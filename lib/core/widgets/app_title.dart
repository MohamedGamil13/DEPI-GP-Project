import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'ServiMarket',
      style: AppStyles.font24w600.copyWith(color: AppColors.primaryColor),
    );
  }
}
