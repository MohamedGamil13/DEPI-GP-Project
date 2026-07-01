import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/core/widgets/ad_image_widget.dart';
import 'package:skillbridge/core/widgets/category_tag.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

class ServiceCard extends StatelessWidget {
  final AdModel ad;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ServiceCard({
    super.key,
    required this.ad,
    required this.isFavorite,
    this.onFavoriteToggle,
  });

  static const String _fallbackImage = AppImages.defalutPostImage;

  @override
  Widget build(BuildContext context) {
    final image = ad.photos.isNotEmpty ? ad.photos.first : _fallbackImage;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textLight.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AdHeroImage(
                adId: ad.adID,
                imageUrl: image,
                height: 140,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _FavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteToggle,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryTag(label: ad.category.label),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ad.title,
                        style: AppStyles.font14w600.copyWith(fontSize: 16),
                      ),
                    ),
                    Text(
                      '${ad.price.toStringAsFixed(0)} EGP',
                      style: AppStyles.font14w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ad.description,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 10),
                _ServiceInfoRow(
                  user: ad.city,
                  rating: ad.averageRating,
                  reviews: ad.totalReviews,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceInfoRow extends StatelessWidget {
  const _ServiceInfoRow({
    required this.user,
    required this.rating,
    required this.reviews,
  });

  final String user;
  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            user,
            style: AppStyles.font14Regular.copyWith(fontSize: 13),
          ),
        ),
        const Icon(Icons.star, color: Colors.amber, size: 18),
        Text('$rating', style: AppStyles.font14w600.copyWith(fontSize: 13)),
        Text(
          ' ($reviews)',
          style: AppStyles.font14Regular.copyWith(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _FavoriteButton({required this.isFavorite, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black26,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? AppColors.errorColor : AppColors.white,
        ),
      ),
    );
  }
}
