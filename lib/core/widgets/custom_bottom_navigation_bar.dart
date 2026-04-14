import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.activeIndex,
    this.onTap,
  });

  final int activeIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      activeColor: AppColors.primaryColor,
      inactiveColor: AppColors.textLight,
      icons: const [
        Icons.home,
        Icons.favorite,
        Icons.chat_bubble_outline,
        Icons.person_outline,
      ],
      activeIndex: activeIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: onTap ?? (_) {},
    );
  }
}
