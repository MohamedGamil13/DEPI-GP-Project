part of 'user_data_cubit.dart';

@immutable
abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataSuccess extends UserDataState {
  final UserProfileModel user;

  UserDataSuccess({required this.user});
}

class UserDataFailure extends UserDataState {
  final String errMessage;

  UserDataFailure({required this.errMessage});
}

class UserDataLoading extends UserDataState {}
