import 'package:skillbridge/core/models/auth_user_model.dart';
import 'package:skillbridge/core/utils/services/firebase_auth_service_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

abstract class AuthRepo {
  final AuthService authService;

  AuthRepo({required this.authService});
  Future<Result<AuthUser>> signIn(String email, String password);
  Future<Result<AuthUser>> signUp(String email, String password);
  Future<Result<void>> sendPasswordResetEmail(String email);
}
