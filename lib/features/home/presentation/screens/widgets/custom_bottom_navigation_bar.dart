import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.surfaceColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textLight,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: 'SAVED',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 36),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'CHAT',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'PROFILE',
        ),
      ],
      currentIndex: 0,
      onTap: (index) {},
      type: BottomNavigationBarType.fixed,
    );
  }
}
