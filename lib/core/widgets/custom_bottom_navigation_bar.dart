import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _bottomNavIndex = 0;
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
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) => setState(() => _bottomNavIndex = index),
    );
  }
}
