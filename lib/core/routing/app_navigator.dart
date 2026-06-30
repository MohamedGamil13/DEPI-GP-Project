// i created this file to make debuging easier if any navigation bug has met us this is the first file to lookup
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';

extension AppNavigator on BuildContext {
  void goHome() => go(AppScreens.homeScreen);
  void goFavorites() => push(AppScreens.favoritesScreen);
  void gosignIn() => go(AppScreens.signinScreen);
  void gosignUp() => go(AppScreens.signupScreen);
  void goForgetPassword() => go(AppScreens.forgetPasswordScreen);
  void goAddPost() => push(AppScreens.postAdScreen);
  void goProfile({String? userId}) => push(
    userId == null
        ? AppScreens.profileScreen
        : '${AppScreens.profileScreen}?userId=$userId',
  );
  void goMessages() => push(AppScreens.messagesScreen);
  void goChatDetail(ConversationModel conversation) =>
      push(AppScreens.chatDetailScreen, extra: conversation);
  void goAdDetails(AdModel ad) => push(AppScreens.adDetailsScreen, extra: ad);
  void popPage() => pop();
}
