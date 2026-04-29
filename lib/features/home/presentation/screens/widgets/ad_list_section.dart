import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/custom_tag.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/service_card.dart';

class AdListSection extends StatelessWidget {
  final List<AdModel> ads;
  const AdListSection({super.key, required this.ads});

  static const String _fallbackImage = AppImages.defalutPostImage;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final ad = ads[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ServiceCard(
              image: ad.photos.isNotEmpty ? ad.photos.first : _fallbackImage,
              tags: ad.relevantSkills != null
                  ? ad.relevantSkills!
                        .map(
                          (skill) => CustomTag(
                            label: skill.name.toUpperCase(),
                            color: AppColors.primaryColor,
                          ),
                        )
                        .toList()
                  : [],
              title: ad.title,
              price: 'EGP ${ad.price.toStringAsFixed(0)}',
              description: ad.description,
              user: ad.city,
              rating: 4.5,
              reviews: 10,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          );
        }, childCount: ads.length),
      ),
    );
  }
}
