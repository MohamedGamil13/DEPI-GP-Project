import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _bottomNavIndex;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.initialIndex;
  }

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
      onTap: (index) {
        if (index == 1) {
          context.goFavorites();
          return;
        }
        if (index == 2) {
          context.goMessages();
          return;
        }
        if (index == 3) {
          context.goProfile();
          return;
        }
        if (index == 0) {
          context.goHome();
          return;
        }

        setState(() => _bottomNavIndex = index);
      },
    );
  }
}
