part of 'call_cubit.dart';

@immutable
abstract class CallState {}

class CallInitial extends CallState {}

class CallSucess extends CallState {}

class CallFailure extends CallState {
  final String errMessage;
  CallFailure(this.errMessage);
}

class CallLoading extends CallState {}
