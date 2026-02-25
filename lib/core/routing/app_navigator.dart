import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';

// i created this file to make debuging easier if any navigation bug has met us this is the first file to lookup
extension AppNavigator on BuildContext {
  void goHome() => go(AppScreens.homeScreen);
}
