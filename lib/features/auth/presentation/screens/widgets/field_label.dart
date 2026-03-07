import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: AppStyles.font14w600),
    );
  }
}
