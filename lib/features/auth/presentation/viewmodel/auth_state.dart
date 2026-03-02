part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSucess extends AuthState {
  final AuthUser user;

  AuthSucess({required this.user});
}

class AuthFaliure extends AuthState {
  final String errorMassege;

  AuthFaliure({required this.errorMassege});
}

class AuthLoading extends AuthState {}

class AuthSendPasswordSucees extends AuthState {}
