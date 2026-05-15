import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/services/call/call_service.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallService callService = CallService();
  CallCubit() : super(CallInitial());
  Future<void> call(String path) async {
    emit(CallLoading());
    final res = await callService.openCall(path);
    switch (res) {
      case Success<void>():
        emit(CallSucess());
      case Failure<void>(:var exception):
        emit(CallFailure(exception.toString()));
    }
  }
}
