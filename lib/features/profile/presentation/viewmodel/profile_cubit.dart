import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/profile/data/models/ad_post_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/data/repos/profile_repo.dart';

part 'profile_state.dart';

/// Manages all state for the Profile screen.
/// Injected via getIt — register [ProfileRepoImplementation] in service_locator.dart.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  // ─────────────────────────────────────────────
  // Load Profile + Posts
  // ─────────────────────────────────────────────

  /// Fetches profile and posts in parallel.
  /// Uses the same Result<T> switch pattern as AuthCubit.
  Future<void> loadProfile() async {
    emit(ProfileLoading());

    // Run both requests in parallel for faster load
    final results = await Future.wait([
      profileRepo.getUserProfile(),
      profileRepo.getMyPosts(),
      profileRepo.getActivityPosts(),
    ]);

    final profileResult = results[0] as Result<UserProfileModel>;
    final myPostsResult = results[1] as Result<List<AdPostModel>>;
    final activityResult = results[2] as Result<List<AdPostModel>>;

    // If profile fails, emit failure — posts failures are non-critical
    switch (profileResult) {
      case Failure(:final exception):
        emit(ProfileFailure(errorMessage: exception.message));
        return;
      case Success():
        break;
    }

    final profile = (profileResult as Success<UserProfileModel>).data;
    final myPosts = myPostsResult is Success<List<AdPostModel>>
        ? (myPostsResult).data
        : <AdPostModel>[];
    final activity = activityResult is Success<List<AdPostModel>>
        ? (activityResult).data
        : <AdPostModel>[];

    emit(ProfileSuccess(
      userProfile: profile,
      myPosts: myPosts,
      activityPosts: activity,
    ));
  }

  // ─────────────────────────────────────────────
  // Tab Switching
  // ─────────────────────────────────────────────

  /// Switches between "My Posts" (0) and "Activity" (1) tabs.
  /// Only emits if we are already in a [ProfileSuccess] state.
  void selectTab(int index) {
    if (state is ProfileSuccess) {
      emit((state as ProfileSuccess).copyWith(selectedTabIndex: index));
    }
  }
}
