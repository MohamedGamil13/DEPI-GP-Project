import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/posts/data/models/review_model.dart';

class ReviewItemWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewItemWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final imageUrl = review.userImage.isNotEmpty
        ? review.userImage
        : AppImages.defalutPostImage;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.userName,
                        style: AppStyles.font14w600.copyWith(fontSize: 15),
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy').format(review.createdAt),
                      style: AppStyles.font14Regular.copyWith(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _StarRating(rating: review.rating),
                if (review.comment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    review.comment,
                    style: AppStyles.font14Regular.copyWith(
                      color: AppColors.textMedium,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        );
      }),
    );
  }
}
