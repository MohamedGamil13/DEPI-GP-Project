import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';

class NoPostsWidget extends StatelessWidget {
  const NoPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(AppImages.noPostsFile, height: 320);
  }
}
