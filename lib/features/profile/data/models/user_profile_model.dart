import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';

class UserProfileModel {
  final String id;
  final String name;
  final DateTime memberSince;
  final String avatarUrl;
  final bool isVerified;
  final List<String>? skills;
  final String lastSignedIn;
  final int? postsCount;
  final int? reviews;
  final double? rating;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.memberSince,
    required this.avatarUrl,
    required this.isVerified,
    required this.lastSignedIn,
    this.skills,
    this.postsCount = 0,
    this.rating = 0,
    this.reviews = 0,
  });

  factory UserProfileModel.fromAuthUser(AuthUser user) {
    return UserProfileModel(
      id: user.uid,
      name: user.displayName ?? "No User Name Provided",
      memberSince: user.creationTimestamp!,
      avatarUrl: user.photoUrl ?? AppImages.defalutPostImage,
      isVerified: user.isEmailVerified,
      lastSignedIn: user.lastSignedIn.toString(),
    );
  }
}
