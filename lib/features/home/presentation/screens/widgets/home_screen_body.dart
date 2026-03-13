import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/categories_list_view.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/custom_tag.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/filter_chip.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/search_bar.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/service_card.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomSearchBar(),
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
              ],
            ),
          ),
        ),

        // Categories Horizontal ListView
        const SliverToBoxAdapter(
          child: SizedBox(height: 80, child: CategoriesListView()),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Row(
                  children: [
                    CustomFilterChip(label: 'All Categories'),
                    SizedBox(width: 8),
                    CustomFilterChip(label: 'Any City'),
                  ],
                ),
                SizedBox(height: 8),
                CustomFilterChip(
                  label: 'My City Only',
                  icon: Icons.location_on_outlined,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Service Cards Vertical ListView
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
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
                description:
                    'Professional eco-friendly cleaning service for...',
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
            ]),
          ),
        ),
      ],
    );
  }
}
