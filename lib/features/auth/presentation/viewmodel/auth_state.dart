part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthUser user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure({required this.errorMessage});
}

class AuthLoading extends AuthState {}

class AuthSendPasswordSuccess extends AuthState {}
