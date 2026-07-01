import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/notifications/notification_route_intent.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling background message: ${message.messageId}');
}

class AppPushService {
  static const AndroidNotificationChannel _foregroundChannel =
      AndroidNotificationChannel(
        'foreground_messages',
        'Foreground Messages',
        description: 'Shows notifications while the app is open.',
        importance: Importance.high,
      );

  AppPushService({
    required FirebaseMessaging messaging,
    required StoreService storeService,
    required AuthService authService,
    required GoRouter router,
    required IChatService chatService,
  }) : _messaging = messaging,
       _storeService = storeService,
       _authService = authService,
       _router = router,
       _chatService = chatService;

  final FirebaseMessaging _messaging;
  final StoreService _storeService;
  final AuthService _authService;
  final GoRouter _router;
  final IChatService _chatService;
  final AppLinks _appLinks = AppLinks();
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<AuthUser?>? _authStateSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<Uri>? _uriSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenSubscription;
  Timer? _tokenRetryTimer;
  bool _initialized = false;
  bool _isSyncingToken = false;
  String? _lastSyncedToken;
  String? _lastSyncedUserId;
  Map<String, dynamic>? _pendingTapData;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _configureLocalNotifications();
    await _requestPermission();
    unawaited(_syncToken());

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) => unawaited(_syncToken(token: token)),
    );
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );
    _messageOpenSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessageTap,
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingTapData = initialMessage.data;
      _routePendingTapAfterAuth();
    }

    _authStateSubscription = _authService.authStateChanges.listen((user) async {
      if (user == null) {
        await _clearToken();
        return;
      }
      await _syncToken();
      _routePendingTapAfterAuth();
    });

    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _routeFromUri(initialLink);
    }

    _uriSubscription = _appLinks.uriLinkStream.listen(_routeFromUri);
  }

  Future<void> dispose() async {
    _tokenRetryTimer?.cancel();
    await _authStateSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    await _uriSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _messageOpenSubscription?.cancel();
  }

  Future<void> _requestPermission() async {
    await _messaging.setAutoInitEnabled(true);
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }

  Future<void> _configureLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payloadData = _decodePayload(response.payload);
        if (payloadData != null) {
          unawaited(_navigateFromPayload(payloadData));
        }
      },
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_foregroundChannel);
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _syncToken({String? token}) async {
    if (_isSyncingToken) return;
    _isSyncingToken = true;

    try {
      final user = _authService.currentUser;
      final resolvedToken = token ?? await _resolveFcmToken();
      if (user == null || resolvedToken == null || resolvedToken.isEmpty) {
        return;
      }
      if (_lastSyncedToken == resolvedToken && _lastSyncedUserId == user.uid) {
        return;
      }
      if (_lastSyncedToken != null && _lastSyncedUserId == user.uid) {
        await _storeService.updateUserToken(
          userId: user.uid,
          token: _lastSyncedToken!,
          add: false,
        );
      }
      await _storeService.updateUserToken(
        userId: user.uid,
        token: resolvedToken,
        add: true,
      );
      _lastSyncedToken = resolvedToken;
      _lastSyncedUserId = user.uid;
    } finally {
      _isSyncingToken = false;
    }
  }

  Future<void> _clearToken() async {
    final token = _lastSyncedToken;
    final userId = _lastSyncedUserId;
    _lastSyncedToken = null;
    _lastSyncedUserId = null;
    if (token == null || userId == null) return;
    await _storeService.updateUserToken(
      userId: userId,
      token: token,
      add: false,
    );
  }

  Future<String?> _resolveFcmToken() async {
    try {
      return await _messaging.getToken();
    } on FirebaseException catch (error) {
      if (_isApnsTokenUnavailable(error)) {
        _tokenRetryTimer?.cancel();
        _tokenRetryTimer = Timer(
          const Duration(seconds: 3),
          () => unawaited(_syncToken()),
        );
        return null;
      }
      rethrow;
    }
  }

  bool _isApnsTokenUnavailable(FirebaseException error) =>
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.iOS &&
      error.code == 'apns-token-not-set';

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if (title == null && body == null) return;

    final id =
        (message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString())
            .hashCode
            .abs();

    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _foregroundChannel.id,
          _foregroundChannel.name,
          channelDescription: _foregroundChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          subtitle: notification?.apple?.subtitle,
          threadIdentifier:
              message.data['conversationId']?.toString() ?? message.messageId,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    unawaited(_navigateFromPayload(message.data));
  }

  void _routePendingTapAfterAuth() {
    if (_authService.currentUser == null || _pendingTapData == null) return;
    final pending = _pendingTapData!;
    _pendingTapData = null;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(_navigateFromPayload(pending)),
    );
  }

  void _routeFromUri(Uri uri) {
    if (uri.scheme == 'skillbridge' && uri.host == 'chat') {
      final conversationId = uri.queryParameters['conversationId'];
      if (conversationId != null && conversationId.isNotEmpty) {
        _router.go(
          '${AppScreens.chatDetailScreen}?conversationId=$conversationId',
        );
      }
    }
  }

  Future<void> _navigateFromPayload(Map<String, dynamic> data) async {
    if (_authService.currentUser == null) {
      _pendingTapData = data;
      return;
    }

    final legacyRoute = data['route']?.toString();
    if (legacyRoute == 'chat' && data['conversationId'] != null) {
      _router.go(
        '${AppScreens.chatDetailScreen}?conversationId=${data['conversationId']}',
      );
      return;
    }

    final intent = NotificationRouteIntent.fromData(data);
    switch (intent.target) {
      case NotificationRouteTarget.messageConversation:
        final conversationId = intent.conversationId;
        if (conversationId != null) {
          try {
            final conversation = await _chatService.getConversation(
              conversationId,
            );
            if (conversation != null) {
              _router.push(AppScreens.chatDetailScreen, extra: conversation);
              return;
            }
          } catch (error) {
            log('Failed to fetch conversation $conversationId: $error');
          }
        }
        _router.push(AppScreens.messagesScreen);
      case NotificationRouteTarget.messagesInbox:
        _router.push(AppScreens.messagesScreen);
      case NotificationRouteTarget.listingDetail:
        final adId = intent.adId;
        if (adId != null) {
          try {
            final result = await _storeService.getPost(adId);
            if (result is Success<AdModel>) {
              _router.push(AppScreens.adDetailsScreen, extra: result.data);
              return;
            }
          } catch (error) {
            log('Failed to fetch listing $adId: $error');
          }
        }
        _router.go(AppScreens.homeScreen);
      case NotificationRouteTarget.profile:
        _router.push(AppScreens.profileScreen);
      case NotificationRouteTarget.home:
        _router.go(AppScreens.homeScreen);
    }
  }

  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (error) {
      log('Failed to decode notification payload: $error');
    }
    return null;
  }
}
