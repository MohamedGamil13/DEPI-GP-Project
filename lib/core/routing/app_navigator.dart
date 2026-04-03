// i created this file to make debuging easier if any navigation bug has met us this is the first file to lookup
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';

extension AppNavigator on BuildContext {
  void goHome() => go(AppScreens.homeScreen);
  void gosignIn() => go(AppScreens.signinScreen);
  void gosignUp() => go(AppScreens.signupScreen);
  void goForgetPassword() => go(AppScreens.forgetPasswordScreen);
  void goAddPost() => push(AppScreens.postAdScreen);
  void pop() => pop();
}
