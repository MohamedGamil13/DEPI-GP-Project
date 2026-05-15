part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

/// Initial state before any data is loaded.
class ProfileInitial extends ProfileState {}

/// Emitted while profile data is being fetched.
class ProfileLoading extends ProfileState {}

/// Emitted when profile and posts are successfully loaded.
class ProfileSuccess extends ProfileState {
  final UserProfileModel userProfile;
  final List<AdModel> myPosts;
  final List<AdModel> activityPosts;
  final int selectedTabIndex;

  ProfileSuccess({
    required this.userProfile,
    required this.myPosts,
    required this.activityPosts,
    this.selectedTabIndex = 0,
  });

  /// Returns a copy with only the changed fields updated.
  /// Used when switching tabs without reloading profile data.
  ProfileSuccess copyWith({
    UserProfileModel? userProfile,
    List<AdModel>? myPosts,
    List<AdModel>? activityPosts,
    int? selectedTabIndex,
  }) {
    return ProfileSuccess(
      userProfile: userProfile ?? this.userProfile,
      myPosts: myPosts ?? this.myPosts,
      activityPosts: activityPosts ?? this.activityPosts,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

/// Emitted when any profile operation fails.
class ProfileFailure extends ProfileState {
  final String errorMessage;
  ProfileFailure({required this.errorMessage});
}
