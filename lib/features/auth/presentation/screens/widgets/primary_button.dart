import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  const PrimaryButton({
    super.key,
    required this.label,
    this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, color: AppColors.white, size: 17),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
