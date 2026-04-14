import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/widgets/app_title.dart';
import 'package:skillbridge/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: const AppTitle(),
        actions: const [_AppBarIcon()],
      ),
      floatingActionButton: const _CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: const HomeScreenBody(),
      bottomNavigationBar: const CustomBottomNavigationBar(activeIndex: 0),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: AppColors.primaryLight,
        child: Icon(Icons.notifications_none, color: AppColors.primaryColor),
      ),
    );
  }
}

class _CustomFloatingActionButton extends StatelessWidget {
  const _CustomFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primaryColor,
      child: const Icon(Icons.add, color: AppColors.white),
    );
  }
}
