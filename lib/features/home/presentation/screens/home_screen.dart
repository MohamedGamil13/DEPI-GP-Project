import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0; // 0: Tech, 1: Local, 2: Students, 3: General
  List<bool> favorites = [false, true, false];

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
      body: SingleChildScrollView(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CategoryTab(
                  label: 'Tech',
                  icon: Icons.computer,
                  selected: selectedCategory == 0,
                  onTap: () => setState(() => selectedCategory = 0),
                ),
                _CategoryTab(
                  label: 'Local',
                  icon: Icons.location_on_outlined,
                  selected: selectedCategory == 1,
                  onTap: () => setState(() => selectedCategory = 1),
                ),
                _CategoryTab(
                  label: 'Students',
                  icon: Icons.school_outlined,
                  selected: selectedCategory == 2,
                  onTap: () => setState(() => selectedCategory = 2),
                ),
                _CategoryTab(
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
                _FilterChip(label: 'All Categories'),
                SizedBox(width: 8),
                _FilterChip(label: 'Any City'),
              ],
            ),
            const SizedBox(height: 8),
            const _FilterChip(
              label: 'My City Only',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),
            // Service Cards
            _ServiceCard(
              image: 'assets/images/labtop.jpg',
              tags: const [
                _Tag(label: 'TECH', color: AppColors.primaryColor),
                _Tag(label: 'NEW YORK', color: AppColors.textMedium),
              ],
              title: 'Laptop Repair & Setup',
              price: 'EGP 50',
              description: 'Expert hardware diagnostics and software...',
              user: 'Alex Chen',
              rating: 4.9,
              reviews: 24,
              isFavorite: favorites[0],
              onFavoriteTap: () {
                setState(() {
                  favorites[0] = !favorites[0];
                });
              },
            ),
            const SizedBox(height: 16),
            _ServiceCard(
              image: 'assets/images/labtop.jpg',
              tags: const [
                _Tag(label: 'LOCAL', color: AppColors.secondaryColor),
                _Tag(label: 'BROOKLYN', color: AppColors.textMedium),
              ],
              title: 'Deep Home Cleaning',
              price: 'EGP 85',
              description: 'Professional eco-friendly cleaning service for...',
              user: 'Sarah Miller',
              rating: 5.0,
              reviews: 52,
              isFavorite: favorites[1],
              onFavoriteTap: () {
                setState(() {
                  favorites[1] = !favorites[1];
                });
              },
            ),
            const SizedBox(height: 16),
            _ServiceCard(
              image: 'assets/images/labtop.jpg',
              tags: const [
                _Tag(label: 'STUDENTS', color: AppColors.primaryColor),
                _Tag(label: 'MANHATTAN', color: AppColors.textMedium),
              ],
              title: 'Math Tutoring (K-12)',
              price: 'EGP 35',
              description: 'Personalized algebra and calculus tutoring by...',
              user: 'David Park',
              rating: 4.8,
              reviews: 12,
              isFavorite: favorites[2],
              onFavoriteTap: () {
                setState(() {
                  favorites[2] = !favorites[2];
                });
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}

// Category Tab Widget (fixed width for each tab)
class _CategoryTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryColor : AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? AppColors.primaryColor : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.white : AppColors.secondaryColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppStyles.font14w600.copyWith(
                    color: selected
                        ? AppColors.white
                        : AppColors.secondaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _FilterChip({required this.label, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primaryColor, size: 18),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppStyles.font14Regular.copyWith(
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Tag Widget
class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppStyles.font14w600.copyWith(fontSize: 11, color: color),
      ),
    );
  }
}

// Service Card Widget
class _ServiceCard extends StatelessWidget {
  final String image;
  final List<Widget> tags;
  final String title;
  final String price;
  final String description;
  final String user;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  const _ServiceCard({
    required this.image,
    required this.tags,
    required this.title,
    required this.price,
    required this.description,
    required this.user,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    required this.onFavoriteTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textLight.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image & Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: CircleAvatar(
                    backgroundColor: AppColors.surfaceColor,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? AppColors.errorColor
                          : AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: tags),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyles.font14w600.copyWith(fontSize: 16),
                      ),
                    ),
                    Text(
                      price,
                      style: AppStyles.font14w600.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.backgroundColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user,
                        style: AppStyles.font14Regular.copyWith(fontSize: 13),
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      '$rating',
                      style: AppStyles.font14w600.copyWith(fontSize: 13),
                    ),
                    Text(
                      ' ($reviews)',
                      style: AppStyles.font14Regular.copyWith(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
