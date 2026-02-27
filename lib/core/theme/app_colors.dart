import 'package:flutter/material.dart';

//this file for AppColors don't use any Color isn't exist in this file
abstract class AppColors {
  static const Color primaryColor = Color(0xFF2F6FED);
  static const Color secondaryColor = Color(0xFF6B7280);
  static const Color backgroundColor = Color(0xFFF3F4F6);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color white = Colors.white;
  static const Color border = Color(0xFFDDDDDD);
  static const Color textDark = Color(0xFF111111);
  static const Color textLight = Color(0xFF999999);
  static const Color textMedium = Color(0xFF555555);
  static const Color primaryLight = Color(0xFFE8F0FF);
  static const Color watermark = Color(0xFFCCDDFF);

  AppColors._(); //to prevent any one  to take an instance from this class
}
