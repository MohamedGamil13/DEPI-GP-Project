import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static void initFCM() async {
    await _firebaseMessaging.requestPermission();
    final String? fcmToken = await _firebaseMessaging.getToken();
    log(fcmToken ?? "FCM Token Is NUll");
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  static Future<void> handler(RemoteMessage remoteMessage) async {
    await Firebase.initializeApp();
  }

  //  static void fun() {
  // _firebaseMessaging.
  //   }
}
