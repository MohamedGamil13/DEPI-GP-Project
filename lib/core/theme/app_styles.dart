//this file for AppStyles(Text styles) don't use any styles isn't exist in this file
import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

abstract class AppStyles {
  static const TextStyle appLogo = TextStyle(
    fontSize: 40,
    color: AppColors.primaryColor,
  );
  AppStyles._(); //to prevent any one  to take an instance from this class
}
