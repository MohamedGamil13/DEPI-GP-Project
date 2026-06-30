import 'package:flutter/material.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/service_card.dart';

class AdListSection extends StatelessWidget {
  final List<AdModel> ads;
  final ValueChanged<int> onFavoriteToggle;

  const AdListSection({
    super.key,
    required this.ads,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final ad = ads[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => context.goAdDetails(ad),
              child: ServiceCard(
                ad: ad,
                isFavorite: ad.isFavorite,
                onFavoriteToggle: () => onFavoriteToggle(ad.adID),
              ),
            ),
          );
        }, childCount: ads.length),
      ),
    );
  }
}
