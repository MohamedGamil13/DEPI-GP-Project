import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/widgets/search_bar.dart';

class HomeHeader extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const HomeHeader({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(
              initialValue: searchQuery,
              onChanged: onSearchChanged,
            ),
            const _HomePageSectionTitle(),
          ],
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
