import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/custom_bottom_navigation_bar.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ServiMarket',
          style: AppStyles.font14w600.copyWith(
            fontSize: 24,
            color: AppColors.primaryColor,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.notifications_none,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: const HomeScreenBody(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
