import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:skillbridge/features/favorites/presentation/screens/widgets/favorites_screen_body.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const FavoritesScreenBody(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
