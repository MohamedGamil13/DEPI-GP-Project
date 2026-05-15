import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  PostAdRepo repo;
  UserDataCubit(this.repo) : super(UserDataInitial());
  Future<void> fetchUserData(String userId) async {
    emit(UserDataLoading());
    final result = await repo.getUserDataById(userId);
    switch (result) {
      case Success<UserProfileModel>():
        emit(UserDataSuccess(user: result.data));
      case Failure<UserProfileModel>():
        emit(UserDataFailure(errMessage: result.exception.message));
    }
  }
}
