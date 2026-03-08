import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ad_posting_state.dart';

class AdPostingCubit extends Cubit<AdPostingState> {
  AdPostingCubit() : super(AdPostingInitial());
}
