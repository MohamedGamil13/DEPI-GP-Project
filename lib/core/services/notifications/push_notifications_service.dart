import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skillbridge/core/routing/app_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/notifications/notification_route_intent.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling background message: ${message.messageId}');
}

class PushNotificationsService {
  static const AndroidNotificationChannel _foregroundChannel =
      AndroidNotificationChannel(
        'foreground_messages',
        'Foreground Messages',
        description: 'Shows notifications while the app is open.',
        importance: Importance.high,
      );

  PushNotificationsService({
    required FirebaseMessaging firebaseMessaging,
    required FirebaseFirestore firestore,
    required AuthService authService,
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required IChatService chatService,
    required StoreService storeService,
  })  : _firebaseMessaging = firebaseMessaging,
        _firestore = firestore,
        _authService = authService,
        _localNotificationsPlugin = localNotificationsPlugin,
        _chatService = chatService,
        _storeService = storeService;

  final FirebaseMessaging _firebaseMessaging;
  final FirebaseFirestore _firestore;
  final AuthService _authService;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final IChatService _chatService;
  final StoreService _storeService;

  StreamSubscription<AuthUser?>? _authStateSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  Timer? _tokenRetryTimer;
  bool _initialized = false;
  bool _isSyncingToken = false;
  String? _lastSyncedToken;
  String? _lastSyncedUserId;
  // ponytail: stored here so routing fires after auth confirms the user is logged in
  Map<String, dynamic>? _pendingTapData;

  Future<void> initFCM() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _initLocalNotifications();

    await _firebaseMessaging.setAutoInitEnabled(true);
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    unawaited(_syncTokenToCurrentUser());

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
      (token) async {
        log('FCM token refreshed.');
        await _syncTokenToCurrentUser(token: token);
      },
    );

    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      unawaited(_showForegroundNotification(message));
    });

    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => unawaited(handleNotificationTapData(message.data)),
    );

    // Store cold-start tap data — routed after auth confirms login (fix #2)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingTapData = initialMessage.data;
    }

    _authStateSubscription = _authService.authStateChanges.listen(
      (user) async {
        if (user == null) {
          await _clearTokenFromFirestore(); // fix #3
          return;
        }
        await _syncTokenToCurrentUser();
        // Safe to route now — auth is confirmed, router redirect has settled
        final pending = _pendingTapData;
        if (pending != null) {
          _pendingTapData = null;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => unawaited(handleNotificationTapData(pending)),
          );
        }
      },
    );
  }

  Future<void> _syncTokenToCurrentUser({String? token}) async {
    if (_isSyncingToken) return;
    _isSyncingToken = true;

    try {
      final currentUser = _authService.currentUser;
      final resolvedToken = token ?? await _resolveFcmToken();

      if (currentUser == null || resolvedToken == null || resolvedToken.isEmpty) {
        log('Skipping FCM token sync. User or token unavailable.');
        return;
      }

      if (_lastSyncedToken == resolvedToken &&
          _lastSyncedUserId == currentUser.uid) {
        return;
      }

      await _firestore
          .collection(AppConstants.userMetaDataCollection)
          .doc(currentUser.uid)
          .set(
            {
              'fcmToken': resolvedToken,
              'notificationsEnabled': true,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );

      _lastSyncedToken = resolvedToken;
      _lastSyncedUserId = currentUser.uid;
      log('FCM token synced for user ${currentUser.uid}.');
    } finally {
      _isSyncingToken = false;
    }
  }

  // fix #3: removes token from Firestore on logout so Cloud Function stops delivering
  Future<void> _clearTokenFromFirestore() async {
    final uid = _lastSyncedUserId;
    _lastSyncedToken = null;
    _lastSyncedUserId = null;
    if (uid == null) return;
    try {
      await _firestore
          .collection(AppConstants.userMetaDataCollection)
          .doc(uid)
          .set(
            {
              'fcmToken': FieldValue.delete(),
              'notificationsEnabled': false,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
    } catch (e) {
      log('Failed to clear FCM token on logout: $e');
    }
  }

  Future<String?> _resolveFcmToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } on FirebaseException catch (error) {
      if (_isApnsTokenUnavailable(error)) {
        log('APNs token not ready yet. Will retry FCM token sync.');
        _scheduleTokenSyncRetry();
        return null;
      }
      rethrow;
    }
  }

  bool _isApnsTokenUnavailable(FirebaseException error) =>
      Platform.isIOS && error.code == 'apns-token-not-set';

  void _scheduleTokenSyncRetry() {
    _tokenRetryTimer?.cancel();
    _tokenRetryTimer = Timer(
      const Duration(seconds: 3),
      () => unawaited(_syncTokenToCurrentUser()),
    );
  }

  Future<void> _initLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payloadData = _decodePayload(response.payload);
        if (payloadData == null) return;
        unawaited(handleNotificationTapData(payloadData));
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

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) {
      log('Foreground data message received: ${message.data}');
      return;
    }

    // fix #1: messageId can be null; hashCode can be negative
    final notificationId =
        (message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString())
            .hashCode
            .abs();

    await _localNotificationsPlugin.show(
      notificationId,
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

  Future<void> handleNotificationTapData(Map<String, dynamic> data) async {
    // fix #7: don't attempt protected navigation if user is not logged in
    if (_authService.currentUser == null) return;

    final intent = NotificationRouteIntent.fromData(data);

    switch (intent.target) {
      case NotificationRouteTarget.messageConversation:
        final conversationId = intent.conversationId;
        if (conversationId != null) {
          try {
            final conversation = await _chatService.getConversation(conversationId);
            if (conversation != null) {
              router.push(AppScreens.chatDetailScreen, extra: conversation);
              return;
            }
          } catch (e) {
            log('Failed to fetch conversation $conversationId: $e');
          }
        }
        router.push(AppScreens.messagesScreen);
      case NotificationRouteTarget.messagesInbox:
        router.push(AppScreens.messagesScreen);
      case NotificationRouteTarget.listingDetail:
        final adId = intent.adId;
        if (adId != null) {
          try {
            final result = await _storeService.getPost(adId);
            if (result is Success<AdModel>) {
              router.push(AppScreens.adDetailsScreen, extra: result.data);
              return;
            }
          } catch (e) {
            log('Failed to fetch listing $adId: $e');
          }
        }
        router.go(AppScreens.homeScreen);
      case NotificationRouteTarget.profile:
        router.push(AppScreens.profileScreen);
      case NotificationRouteTarget.home:
        router.go(AppScreens.homeScreen);
    }
  }

  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (error) {
      log('Failed to decode notification payload: $error');
    }
    return null;
  }

  void dispose() {
    _tokenRetryTimer?.cancel();
    _authStateSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    _foregroundSubscription?.cancel();
    _openedAppSubscription?.cancel();
  }
}
