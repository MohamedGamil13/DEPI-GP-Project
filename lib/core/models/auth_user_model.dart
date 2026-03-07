// core/models/auth_user.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String uid;
  final String? email;
  final bool isEmailVerified;
  final String? displayName;
  final String? photoUrl;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.isEmailVerified,
    this.displayName,
    this.photoUrl,
  });

  factory AuthUser.fromFirebaseUser(User user) => AuthUser(
    uid: user.uid,
    email: user.email,
    isEmailVerified: user.emailVerified,
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );

  AuthUser copyWith({
    String? uid,
    String? email,
    bool? isEmailVerified,
    String? displayName,
    String? photoUrl,
  }) => AuthUser(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
  );
}
