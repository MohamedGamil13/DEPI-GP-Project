import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class CustomTag extends StatelessWidget {
  final String label;
  final Color color;
  const CustomTag({super.key, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppStyles.font14w600.copyWith(fontSize: 11, color: color),
      ),
    );
  }
}
