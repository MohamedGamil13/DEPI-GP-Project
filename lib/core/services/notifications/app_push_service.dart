import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
}

class AppPushService {
  AppPushService({
    required FirebaseMessaging messaging,
    required StoreService storeService,
    required AuthService authService,
    required GoRouter router,
  }) : _messaging = messaging,
       _storeService = storeService,
       _authService = authService,
       _router = router;

  final FirebaseMessaging _messaging;
  final StoreService _storeService;
  final AuthService _authService;
  final GoRouter _router;
  final AppLinks _appLinks = AppLinks();
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<Uri>? _uriSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenSubscription;

  Future<void> initialize() async {
    await _configureLocalNotifications();
    await _requestPermission();
    await _syncToken();

    _messaging.onTokenRefresh.listen(_handleTokenRefresh);
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );
    _messageOpenSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessageTap,
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _routeFromUri(initialLink);
    }

    _uriSubscription = _appLinks.uriLinkStream.listen(_routeFromUri);
  }

  Future<void> dispose() async {
    await _uriSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _messageOpenSubscription?.cancel();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _configureLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotificationsPlugin.initialize(settings);
  }

  Future<void> _syncToken() async {
    final user = _authService.currentUser;
    if (user == null) return;

    final token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await _storeService.updateUserToken(
        userId: user.uid,
        token: token,
        add: true,
      );
    }
  }

  Future<void> _handleTokenRefresh(String token) async {
    final user = _authService.currentUser;
    if (user == null) return;
    await _storeService.updateUserToken(
      userId: user.uid,
      token: token,
      add: true,
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'skillbridge_messages',
          'Messages',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    _navigateFromPayload(message.data);
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

  void _navigateFromPayload(Map<String, dynamic> data) {
    final route = data['route'] as String?;
    final conversationId = data['conversationId'] as String?;

    if (route == 'chat' && conversationId != null) {
      _router.go(
        '${AppScreens.chatDetailScreen}?conversationId=$conversationId',
      );
    }
  }
}
