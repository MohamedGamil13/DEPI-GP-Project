/// Represents the authenticated user's full profile data.
/// [fromJson] maps directly to your backend API response fields.
class UserProfileModel {
  final String id;
  final String name;
  final String memberSince;
  final String avatarUrl;
  final bool isVerified;
  final double rating;
  final int reviews;
  final int postsCount;
  final List<String> skills;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.memberSince,
    required this.avatarUrl,
    required this.isVerified,
    required this.rating,
    required this.reviews,
    required this.postsCount,
    required this.skills,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      memberSince: json['member_since'] as String,
      avatarUrl: json['avatar_url'] as String,
      isVerified: (json['is_verified'] as bool?) ?? false,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      postsCount: json['posts_count'] as int,
      skills: List<String>.from(json['skills'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'member_since': memberSince,
    'avatar_url': avatarUrl,
    'is_verified': isVerified,
    'rating': rating,
    'reviews': reviews,
    'posts_count': postsCount,
    'skills': skills,
  };
}
