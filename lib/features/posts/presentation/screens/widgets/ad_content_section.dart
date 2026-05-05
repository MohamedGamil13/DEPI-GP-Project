import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_details_widget.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_info_section.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({super.key, required this.ad});
  final AdModel ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoSection(ad: ad),
          const SizedBox(height: 20),
          const SellerCard(),
          const SizedBox(height: 24),
          _DescriptionSection(description: ad.description),
          const SizedBox(height: 24),
          const _FeaturesSection(),
          const SizedBox(height: 24),
          const _ReviewsSection(),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Service Description", style: AppStyles.font17Bold),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppStyles.font14Regular.copyWith(
            color: AppColors.textMedium,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Reviews", style: AppStyles.font17Bold),
        TextButton(
          onPressed: () {},
          child: Text(
            "See All",
            style: AppStyles.font14Regular.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _FeatureItem(text: "All equipment provided"),
        _FeatureItem(text: "Insured and bonded professionals"),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(text, style: AppStyles.font14Regular),
        ],
      ),
    );
  }
}
