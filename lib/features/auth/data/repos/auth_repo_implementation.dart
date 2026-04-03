import 'package:skillbridge/core/errors/auth_exception.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo.dart';

class AuthRepoImplementation extends AuthRepo {
  AuthRepoImplementation({required super.authService});

  @override
  Future<Result<AuthUser>> signIn(String email, String password) async {
    try {
      final user = await authService.signIn(email, password);
      return Success(user);
    } on AuthException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<AuthUser>> signUp(String email, String password) async {
    try {
      final user = await authService.register(email, password);
      return Success(user);
    } on AuthException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await authService.sendPasswordResetEmail(email);
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> sendVerificationEmail() async {
    try {
      await authService.sendVerificationEmail();
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(e);
    }
  }
}
