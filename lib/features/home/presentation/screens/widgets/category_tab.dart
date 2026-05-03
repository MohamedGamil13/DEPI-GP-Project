import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

class CategoryTab extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final AdCategories adCategories;
  const CategoryTab({
    super.key,
    required this.selected,
    required this.onTap,
    required this.adCategories,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? AppColors.primaryColor : AppColors.border,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              adCategories.icon,
              color: selected ? AppColors.white : AppColors.secondaryColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              adCategories.label,
              style: AppStyles.font13w500.copyWith(
                color: selected ? AppColors.white : AppColors.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
