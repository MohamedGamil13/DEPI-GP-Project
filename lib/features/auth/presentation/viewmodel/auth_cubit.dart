import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepo.signUp(email, password);

    switch (result) {
      case Success(:final data):
        registerUserAfterLogin();
        emit(AuthSuccess(user: data));
      case Failure(:final exception):
        emit(AuthFailure(errorMessage: exception.message));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepo.signIn(email, password);

    switch (result) {
      case Success(:final data):
        registerUserAfterLogin();
        emit(AuthSuccess(user: data));
      case Failure(:final exception):
        emit(AuthFailure(errorMessage: exception.message));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await authRepo.signInWithGoogle();

    switch (result) {
      case Success(:final data):
        registerUserAfterLogin();
        emit(AuthSuccess(user: data));
      case Failure(:final exception):
        emit(AuthFailure(errorMessage: exception.message));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    final result = await authRepo.sendPasswordResetEmail(email);

    switch (result) {
      case Success():
        emit(AuthSendPasswordSuccess());
      case Failure(:final exception):
        emit(AuthFailure(errorMessage: exception.message));
    }
  }
}
