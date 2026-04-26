import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void initFCM() async {
    _firebaseMessaging.requestPermission();
    final fcmToken = _firebaseMessaging.getToken();
  }
}
