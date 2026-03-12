//this file for AppStyles(Text styles) don't use any styles isn't exist in this file
import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

abstract class AppStyles {
  static const TextStyle appLogo = TextStyle(
    fontSize: 40,
    color: AppColors.primaryColor,
  );
  static const TextStyle font14w600 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static const TextStyle font14Regular = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );
  static const TextStyle font17Bold = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );
  AppStyles._(); //to prevent any one  to take an instance from this class
}
