import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/category_tab.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/custom_tag.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/filter_chip.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/service_card.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  int selectedCategory = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.textLight),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      border: InputBorder.none,
                      hintStyle: AppStyles.font14Regular.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Categories Title
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'CATEGORIES',
              style: AppStyles.font14w600.copyWith(
                color: AppColors.textMedium,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // Categories Tabs (Row - Horizontal, Equal Width)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryTab(
                label: 'Tech',
                icon: Icons.computer,
                selected: selectedCategory == 0,
                onTap: () => setState(() => selectedCategory = 0),
              ),
              CategoryTab(
                label: 'Local',
                icon: Icons.location_on_outlined,
                selected: selectedCategory == 1,
                onTap: () => setState(() => selectedCategory = 1),
              ),
              CategoryTab(
                label: 'Students',
                icon: Icons.school_outlined,
                selected: selectedCategory == 2,
                onTap: () => setState(() => selectedCategory = 2),
              ),
              CategoryTab(
                label: 'General',
                icon: Icons.dashboard_outlined,
                selected: selectedCategory == 3,
                onTap: () => setState(() => selectedCategory = 3),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filters
          const Row(
            children: [
              CustomFilterChip(label: 'All Categories'),
              SizedBox(width: 8),
              CustomFilterChip(label: 'Any City'),
            ],
          ),
          const SizedBox(height: 8),
          const CustomFilterChip(
            label: 'My City Only',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          // Service Cards
          ServiceCard(
            image: 'assets/images/labtop.jpg',
            tags: const [
              CustomTag(label: 'TECH', color: AppColors.primaryColor),
              CustomTag(label: 'NEW YORK', color: AppColors.textMedium),
            ],
            title: 'Laptop Repair & Setup',
            price: 'EGP 50',
            description: 'Expert hardware diagnostics and software...',
            user: 'Alex Chen',
            rating: 4.9,
            reviews: 24,
            isFavorite: true,
            onFavoriteTap: () {},
          ),
          const SizedBox(height: 16),
          ServiceCard(
            image: 'assets/images/labtop.jpg',
            tags: const [
              CustomTag(label: 'LOCAL', color: AppColors.secondaryColor),
              CustomTag(label: 'BROOKLYN', color: AppColors.textMedium),
            ],
            title: 'Deep Home Cleaning',
            price: 'EGP 85',
            description: 'Professional eco-friendly cleaning service for...',
            user: 'Sarah Miller',
            rating: 5.0,
            reviews: 52,
            isFavorite: true,
            onFavoriteTap: () {},
          ),
          const SizedBox(height: 16),
          ServiceCard(
            image: 'assets/images/labtop.jpg',
            tags: const [
              CustomTag(label: 'STUDENTS', color: AppColors.primaryColor),
              CustomTag(label: 'MANHATTAN', color: AppColors.textMedium),
            ],
            title: 'Math Tutoring (K-12)',
            price: 'EGP 35',
            description: 'Personalized algebra and calculus tutoring by...',
            user: 'David Park',
            rating: 4.8,
            reviews: 12,
            isFavorite: true,
            onFavoriteTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
