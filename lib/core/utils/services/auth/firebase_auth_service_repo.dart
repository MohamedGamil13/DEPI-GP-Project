import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';

abstract interface class AuthService {
  Stream<AuthUser?> get authStateChanges;
  AuthUser? get currentUser;
  Future<AuthUser> register(String email, String password);
  Future<AuthUser> signIn(String email, String password);
  Future<void> signOut();
  Future<void> sendVerificationEmail();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();
}
