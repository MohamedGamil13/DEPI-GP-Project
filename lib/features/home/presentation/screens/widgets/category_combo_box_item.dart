import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class CategoryComboBoxItem extends StatelessWidget {
  const CategoryComboBoxItem({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor,
  });

  final String label;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.font14Regular.copyWith(color: AppColors.textMedium),
        ),
        Icon(icon, color: iconColor ?? AppColors.primaryColor),
      ],
    );
  }
}
