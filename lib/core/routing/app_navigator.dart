// i created this file to make debuging easier if any navigation bug has met us this is the first file to lookup
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/routing/app_screens.dart';
import 'package:skillbridge/features/messages/data/models/service_conversation.dart';

extension AppNavigator on BuildContext {
  void goHome() => go(AppScreens.homeScreen);
  void gosignIn() => go(AppScreens.signinScreen);
  void gosignUp() => go(AppScreens.signupScreen);
  void goForgetPassword() => go(AppScreens.forgetPasswordScreen);
  void goAddPost() => push(AppScreens.postAdScreen);
  void goProfile() => push(AppScreens.profileScreen);
  void goMessages() => push(AppScreens.messagesScreen);
  void goChatDetail(ServiceConversation conversation) =>
      push(AppScreens.chatDetailScreen, extra: conversation);
  void goListingDetail(AdModel ad) =>
      push(AppScreens.listingDetailScreen, extra: ad);
  void popPage() => pop();
}
