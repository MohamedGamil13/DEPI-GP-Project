// core/models/auth_user.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String uid;
  final String? displayName;
  final String? email;
  final bool isEmailVerified;
  final String? photoUrl;
  final DateTime? lastSignedIn;
  final DateTime? creationTimestamp;
  const AuthUser({
    required this.uid,
    required this.email,
    required this.isEmailVerified,
    this.displayName,
    this.photoUrl,
    this.lastSignedIn,
    this.creationTimestamp,
  });

  factory AuthUser.fromFirebaseUser(User user) => AuthUser(
    uid: user.uid,
    email: user.email,
    isEmailVerified: user.emailVerified,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    lastSignedIn: user.metadata.lastSignInTime,
    creationTimestamp: user.metadata.creationTime,
  );
  //reviewed
}
