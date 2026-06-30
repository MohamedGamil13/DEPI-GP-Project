part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfileModel userProfile;
  final List<AdModel> myPosts;
  final List<AdModel> activityPosts;
  final int selectedTabIndex;
  final bool isOtherUserProfile;

  ProfileSuccess({
    required this.userProfile,
    required this.myPosts,
    required this.activityPosts,
    this.selectedTabIndex = 0,
    this.isOtherUserProfile = false,
  });

  ProfileSuccess copyWith({
    UserProfileModel? userProfile,
    List<AdModel>? myPosts,
    List<AdModel>? activityPosts,
    int? selectedTabIndex,
    bool? isOtherUserProfile,
  }) {
    return ProfileSuccess(
      userProfile: userProfile ?? this.userProfile,
      myPosts: myPosts ?? this.myPosts,
      activityPosts: activityPosts ?? this.activityPosts,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isOtherUserProfile: isOtherUserProfile ?? this.isOtherUserProfile,
    );
  }
}

class ProfileFailure extends ProfileState {
  final String errorMessage;
  ProfileFailure({required this.errorMessage});
}

class ProfilePostsLoading extends ProfileState {}

class ProfilePostsLoaded extends ProfileState {
  final List<AdModel> posts;
  ProfilePostsLoaded({required this.posts});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
