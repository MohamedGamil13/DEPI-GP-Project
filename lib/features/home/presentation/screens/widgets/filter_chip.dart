import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const CustomFilterChip({super.key, required this.label, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primaryColor, size: 18),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppStyles.font14Regular.copyWith(
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
