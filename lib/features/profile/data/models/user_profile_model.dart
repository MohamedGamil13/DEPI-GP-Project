import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String bio;
  final String city;
  final String governorate;
  final String country;
  final double? latitude;
  final double? longitude;
  final DateTime memberSince;
  final String avatarUrl;
  final bool isVerified;
  final List<String> skills;
  final String lastSignedIn;
  final List<String> fcmTokens;
  final int? postsCount;
  final int? reviews;
  final double? rating;

  const UserProfileModel({
    required this.id,
    required this.name,
    this.bio = '',
    this.city = '',
    this.governorate = '',
    this.country = '',
    this.latitude,
    this.longitude,
    required this.memberSince,
    required this.avatarUrl,
    required this.isVerified,
    required this.lastSignedIn,
    this.skills = const [],
    this.fcmTokens = const [],
    this.postsCount = 0,
    this.rating = 0,
    this.reviews = 0,
  });

  factory UserProfileModel.fromAuthUser(AuthUser user) {
    return UserProfileModel(
      id: user.uid,
      name: user.displayName ?? "No User Name Provided",
      bio: '',
      city: '',
      governorate: '',
      country: '',
      memberSince: user.creationTimestamp!,
      avatarUrl: user.photoUrl ?? AppImages.defalutPostImage,
      isVerified: user.isEmailVerified,
      lastSignedIn: user.lastSignedIn.toString(),
      skills: const [],
      fcmTokens: const [],
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      city: json['city'] ?? '',
      governorate: json['governorate'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      memberSince: DateTime.parse(json['memberSince']),
      avatarUrl: json['avatarUrl'] ?? '',
      isVerified: json['isVerified'] ?? false,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : const [],
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
      'bio': bio,
      'city': city,
      'governorate': governorate,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
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

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? city,
    String? governorate,
    String? country,
    double? latitude,
    double? longitude,
    DateTime? memberSince,
    String? avatarUrl,
    bool? isVerified,
    List<String>? skills,
    String? lastSignedIn,
    List<String>? fcmTokens,
    int? postsCount,
    int? reviews,
    double? rating,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      memberSince: memberSince ?? this.memberSince,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      skills: skills ?? this.skills,
      lastSignedIn: lastSignedIn ?? this.lastSignedIn,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      postsCount: postsCount ?? this.postsCount,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
    );
  }
}
