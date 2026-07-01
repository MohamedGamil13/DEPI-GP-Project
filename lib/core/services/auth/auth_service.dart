import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';

abstract class AuthService {
  Stream<AuthUser?> get authStateChanges;
  AuthUser? get currentUser;
  Future<AuthUser> register(String email, String password, {String bio = ''});
  Future<AuthUser> signIn(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<AuthUser> signInWithGoogle();
  Future<void> signOut();
}

//reviewed
