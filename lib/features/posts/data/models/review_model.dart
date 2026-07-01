import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final int postId;
  final String userId;
  final String userName;
  final String userImage;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, {String? id}) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    }

    return ReviewModel(
      id: id ?? json['reviewId'] as String? ?? '',
      postId: (json['postId'] as num).toInt(),
      userId: json['userId'] as String,
      userName: json['userName'] as String? ?? '',
      userImage: json['userImage'] as String? ?? '',
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String? ?? '',
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
