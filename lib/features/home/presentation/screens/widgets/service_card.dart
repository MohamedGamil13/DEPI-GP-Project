import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/custom_tag.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.ad});
  final AdModel ad;
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
          /// Image + Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: (image.startsWith('http'))
                    ? Image.network(
                        image,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          _fallbackImage,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        _fallbackImage,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const Positioned(top: 12, right: 12, child: _IsFavWidget()),
            ],
          ),

          /// Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Tags
                Row(
                  children: ad.relevantSkills != null
                      ? ad.relevantSkills!
                            .map(
                              (skill) => CustomTag(
                                label: skill.name.toUpperCase(),
                                color: AppColors.primaryColor,
                              ),
                            )
                            .toList()
                      : [],
                ),

                const SizedBox(height: 8),

                /// Title + Price
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

                /// Description
                Text(
                  ad.description,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),

                const SizedBox(height: 10),

                /// Info Row
                _ServiceInfoRow(user: ad.city, rating: 4.5, reviews: 10),
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

class _IsFavWidget extends StatefulWidget {
  const _IsFavWidget();

  @override
  State<_IsFavWidget> createState() => _IsFavWidgetState();
}

class _IsFavWidgetState extends State<_IsFavWidget> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        isFavorite = !isFavorite;
      }),
      child: CircleAvatar(
        backgroundColor: AppColors.surfaceColor,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? AppColors.errorColor : AppColors.textLight,
        ),
      ),
    );
  }
}
