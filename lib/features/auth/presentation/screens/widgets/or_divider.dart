import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  final String label;

  const OrDivider({super.key, this.label = 'Or continue with'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
