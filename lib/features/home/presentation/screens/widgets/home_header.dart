import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/widgets/search_bar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [CustomSearchBar(), _HomePageSectionTitle()],
        ),
      ),
    );
  }
}

class _HomePageSectionTitle extends StatelessWidget {
  const _HomePageSectionTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'CATEGORIES',
        style: AppStyles.font14w600.copyWith(
          color: AppColors.textMedium,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
