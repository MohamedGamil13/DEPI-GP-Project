import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/errors/auth_errors.dart';
import 'package:skillbridge/core/models/auth_user_model.dart';
import 'package:skillbridge/core/utils/services/firebase_auth_service_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit(this.authService) : super(AuthInitial());
  //   Future<Result<AuthUser>> signIn(String email, String password);
  // Future<Result<AuthUser>> signUp(String email, String password);
  // Future<Result<void>> sendPasswordResetEmail(String email);
  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final AuthUser user = await authService.register(email, password);
      emit(AuthSucess(user: user));
    } on AuthException catch (e) {
      emit(AuthFaliure(errorMassege: e.message));
    } catch (e) {
      emit(AuthFaliure(errorMassege: e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final AuthUser user = await authService.signIn(email, password);
      emit(AuthSucess(user: user));
    } on AuthException catch (e) {
      emit(AuthFaliure(errorMassege: e.message));
    } catch (e) {
      emit(AuthFaliure(errorMassege: e.toString()));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    try {
      await authService.sendPasswordResetEmail(email);
      emit(AuthSendPasswordSucees());
    } on AuthException catch (e) {
      emit(AuthFaliure(errorMassege: e.message));
    } catch (e) {
      emit(AuthFaliure(errorMassege: e.toString()));
    }
  }
}
