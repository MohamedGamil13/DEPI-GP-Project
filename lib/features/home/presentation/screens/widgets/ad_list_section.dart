import 'package:flutter/material.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/service_card.dart';

class AdListSection extends StatelessWidget {
  final List<AdModel> ads;
  const AdListSection({super.key, required this.ads});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final AdModel ad = ads[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ServiceCard(ad: ad),
          );
        }, childCount: ads.length),
      ),
    );
  }
}
