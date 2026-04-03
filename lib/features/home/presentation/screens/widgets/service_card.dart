import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class ServiceCard extends StatelessWidget {
  final String image;
  final List<Widget> tags;
  final String title;
  final String price;
  final String description;
  final String user;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  const ServiceCard({
    super.key,
    required this.image,
    required this.tags,
    required this.title,
    required this.price,
    required this.description,
    required this.user,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    required this.onFavoriteTap,
  });
  @override
  Widget build(BuildContext context) {
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
          // Image & Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: CircleAvatar(
                    backgroundColor: AppColors.surfaceColor,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? AppColors.errorColor
                          : AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: tags),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyles.font14w600.copyWith(fontSize: 16),
                      ),
                    ),
                    Text(
                      price,
                      style: AppStyles.font14w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.backgroundColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user,
                        style: AppStyles.font14Regular.copyWith(fontSize: 13),
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      '$rating',
                      style: AppStyles.font14w600.copyWith(fontSize: 13),
                    ),
                    Text(
                      ' ($reviews)',
                      style: AppStyles.font14Regular.copyWith(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
