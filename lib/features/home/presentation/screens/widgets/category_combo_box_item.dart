import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class CategoryComboBoxItem extends StatelessWidget {
  const CategoryComboBoxItem({super.key, required this.adCategories});
  final AdCategories adCategories;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          adCategories.label,
          style: AppStyles.font14Regular.copyWith(color: AppColors.textMedium),
        ),
        Icon(adCategories.icon, color: AppColors.primaryColor),
      ],
    );
  }
}
