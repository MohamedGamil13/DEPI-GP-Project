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
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/core/utils/services/auth/auth_service.dart';
import 'package:skillbridge/core/utils/services/notifications/notification_route_intent.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/home/data/home_mock_ads.dart';
import 'package:skillbridge/features/messages/data/messages_mock_data.dart';
import 'package:skillbridge/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling background message: ${message.messageId}');
}

/// Coordinates FCM setup, token syncing, foreground banners, and tap routing.
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
  }) : _firebaseMessaging = firebaseMessaging,
       _firestore = firestore,
       _authService = authService,
       _localNotificationsPlugin = localNotificationsPlugin;

  final FirebaseMessaging _firebaseMessaging;
  final FirebaseFirestore _firestore;
  final AuthService _authService;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  StreamSubscription<AuthUser?>? _authStateSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  Timer? _tokenRetryTimer;
  bool _initialized = false;
  bool _isSyncingToken = false;
  String? _lastSyncedToken;
  String? _lastSyncedUserId;

  /// Initializes local notifications and FCM listeners for the current app run.
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

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen((
      token,
    ) async {
      log('FCM token refreshed.');
      await _syncTokenToCurrentUser(token: token);
    });

    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      unawaited(_showForegroundNotification(message));
    });

    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      handleNotificationTapData(message.data);
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotificationTapData(initialMessage.data);
      });
    }

    _authStateSubscription = _authService.authStateChanges.listen((user) async {
      if (user == null) {
        _lastSyncedToken = null;
        _lastSyncedUserId = null;
        return;
      }

      await _syncTokenToCurrentUser();
    });
  }

  /// Syncs the current FCM token to the authenticated user's Firestore record.
  Future<void> _syncTokenToCurrentUser({String? token}) async {
    if (_isSyncingToken) return;
    _isSyncingToken = true;

    try {
      final currentUser = _authService.currentUser;
      final resolvedToken = token ?? await _resolveFcmToken();

      if (currentUser == null ||
          resolvedToken == null ||
          resolvedToken.isEmpty) {
        log('Skipping FCM token sync. User or token unavailable.');
        return;
      }

      if (_lastSyncedToken == resolvedToken &&
          _lastSyncedUserId == currentUser.uid) {
        return;
      }

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .set({
            'fcmToken': resolvedToken,
            'notificationsEnabled': true,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      _lastSyncedToken = resolvedToken;
      _lastSyncedUserId = currentUser.uid;

      log('FCM token synced for user ${currentUser.uid}.');
    } finally {
      _isSyncingToken = false;
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

  bool _isApnsTokenUnavailable(FirebaseException error) {
    return Platform.isIOS && error.code == 'apns-token-not-set';
  }

  void _scheduleTokenSyncRetry() {
    _tokenRetryTimer?.cancel();
    _tokenRetryTimer = Timer(const Duration(seconds: 3), () {
      unawaited(_syncTokenToCurrentUser());
    });
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
        handleNotificationTapData(payloadData);
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

    final appleNotification = notification?.apple;

    await _localNotificationsPlugin.show(
      message.messageId.hashCode,
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
          subtitle: appleNotification?.subtitle,
          threadIdentifier:
              message.data['conversationId']?.toString() ?? message.messageId,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Shows the local foreground banner that mirrors a real incoming message.
  Future<void> showMockMessageNotification() async {
    const payload = {
      'type': 'message',
      'conversationId': 'conv-2',
      'title': 'New message',
      'body': 'Omar sent you a message about Math Tutoring.',
    };

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      payload['title'],
      payload['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          _foregroundChannel.id,
          _foregroundChannel.name,
          channelDescription: _foregroundChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'conv-2',
        ),
      ),
      payload: jsonEncode(payload),
    );
  }

  /// Shows a local foreground banner that mirrors a recommended listing push.
  Future<void> showMockListingNotification() async {
    const payload = {
      'type': 'listing',
      'adId': '3',
      'title': 'New listing for you',
      'body': 'Math Tutoring (K-12) matches your interests.',
    };

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      payload['title'],
      payload['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          _foregroundChannel.id,
          _foregroundChannel.name,
          channelDescription: _foregroundChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'listing-3',
        ),
      ),
      payload: jsonEncode(payload),
    );
  }

  /// Routes a decoded notification payload into the correct in-app destination.
  void handleNotificationTapData(Map<String, dynamic> data) {
    final intent = NotificationRouteIntent.fromData(data);

    switch (intent.target) {
      case NotificationRouteTarget.messageConversation:
        final conversation = findSeedConversationById(intent.conversationId);
        if (conversation != null) {
          router.push(AppScreens.chatDetailScreen, extra: conversation);
        } else {
          router.push(AppScreens.messagesScreen);
        }
      case NotificationRouteTarget.messagesInbox:
        router.push(AppScreens.messagesScreen);
      case NotificationRouteTarget.listingDetail:
        final ad = findSeedAdById(intent.adId);
        if (ad != null) {
          router.push(AppScreens.listingDetailScreen, extra: ad);
        } else {
          router.go(AppScreens.homeScreen);
        }
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
        return decoded.map((key, value) => MapEntry(key.toString(), value));
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
