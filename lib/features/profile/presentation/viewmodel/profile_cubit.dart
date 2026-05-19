import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/data/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final profileResult = await profileRepo.getUserProfile();
    switch (profileResult) {
      case Failure(:final exception):
        emit(ProfileFailure(errorMessage: exception.message));
        return;
      case Success(:var data):
        emit(
          ProfileSuccess(
            userProfile: data,
            myPosts: const [],
            activityPosts: const [],
          ),
        );
    }
  }

  Future<void> loadCurrentUserPosts() async {
    emit(ProfilePostsLoading());
    final Result<List<AdModel>> result = await profileRepo
        .getCurrentUserPosts();
    switch (result) {
      case Success<List<AdModel>>():
        emit(ProfilePostsLoaded(posts: result.data));
      case Failure<List<AdModel>>():
        emit(ProfileError(message: result.exception.toString()));
    }
  }
}
