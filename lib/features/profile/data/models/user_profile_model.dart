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
  final List<String> fcmTokens;
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
    this.fcmTokens = const [],
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
      fcmTokens: const [],
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      memberSince: DateTime.parse(json['memberSince']),
      avatarUrl: json['avatarUrl'] ?? '',
      isVerified: json['isVerified'] ?? false,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      lastSignedIn: json['lastSignedIn'] ?? '',
      fcmTokens: json['fcmTokens'] != null
          ? List<String>.from(json['fcmTokens'])
          : const [],
      postsCount: json['postsCount'] ?? 0,
      reviews: json['reviews'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberSince': memberSince.toIso8601String(),
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
      'skills': skills,
      'lastSignedIn': lastSignedIn,
      'fcmTokens': fcmTokens,
      'postsCount': postsCount,
      'reviews': reviews,
      'rating': rating,
    };
  }
}
