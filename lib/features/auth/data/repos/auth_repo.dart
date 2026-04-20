import 'package:skillbridge/core/utils/services/auth/auth_service.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';

abstract class AuthRepo {
  final AuthService authService;

  AuthRepo({required this.authService});
  Future<Result<AuthUser>> signIn(String email, String password);
  Future<Result<AuthUser>> signUp(String email, String password);
  Future<Result<void>> sendPasswordResetEmail(String email);
  Future<Result<AuthUser>> signInWithGoogle();
}
