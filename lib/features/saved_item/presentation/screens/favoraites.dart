import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/widgets/custom_bottom_navigation_bar.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  static const List<String> _tabs = ['All', 'Cleaning', 'Maintenance', 'Beauty'];

  final List<_SavedService> _savedServices = [
    const _SavedService(
      category: 'CLEANING',
      title: 'Professional Home Cleaning',
      price: 'EGP 350',
      image: 'assets/images/home clean.jpg',
    ),
    const _SavedService(
      category: 'MAINTENANCE',
      title: 'AC Maintenance & Repair',
      price: 'EGP 500',
      image: 'assets/images/laptop.jpg',
      useSecondaryColor: true,
    ),
    const _SavedService(
      category: 'PAINTING',
      title: 'Full Interior Wall Painting',
      price: 'EGP 1,200',
      image: 'assets/images/study11.jpg',
    ),
    const _SavedService(
      category: 'GARDENING',
      title: 'Landscape Design & Care',
      price: 'EGP 850',
      image: 'assets/images/home clean.jpg',
      useSecondaryColor: true,
    ),
  ];

  int _selectedTab = 0;
  late final List<bool> _favoriteStates = List<bool>.filled(
    _savedServices.length,
    true,
  );

  List<_SavedService> get _visibleServices {
    if (_selectedTab == 0) {
      return _savedServices;
    }

    final selectedTabLabel = _tabs[_selectedTab].toUpperCase();
    return _savedServices
        .where((service) => service.category == selectedTabLabel)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Saved Services',
          style: AppStyles.font14w600.copyWith(
            fontSize: 18,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Bar
          Container(
            color: AppColors.surfaceColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTab == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _tabs[index],
                            style: AppStyles.font14w600.copyWith(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.textMedium,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 2,
                            width: isSelected ? 28 : 0,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Service List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _visibleServices.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = _visibleServices[index];
                final serviceIndex = _savedServices.indexOf(service);
                return _SavedServiceCard(
                  category: service.category,
                  categoryColor: service.categoryColor,
                  title: service.title,
                  price: service.price,
                  image: service.image,
                  isFavorite: _favoriteStates[serviceIndex],
                  onFavoriteTap: () {
                    setState(() {
                      _favoriteStates[serviceIndex] =
                          !_favoriteStates[serviceIndex];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const _CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(activeIndex: 1),
    );
  }
}

class _SavedService {
  const _SavedService({
    required this.category,
    required this.title,
    required this.price,
    required this.image,
    this.useSecondaryColor = false,
  });

  final String category;
  final String title;
  final String price;
  final String image;
  final bool useSecondaryColor;

  Color get categoryColor =>
      useSecondaryColor ? AppColors.secondaryColor : AppColors.primaryColor;
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

class _SavedServiceCard extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String title;
  final String price;
  final String image;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _SavedServiceCard({
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.price,
    required this.image,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textLight.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category label
                  Text(
                    category,
                    style: AppStyles.font14w600.copyWith(
                      fontSize: 11,
                      color: categoryColor,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    title,
                    style: AppStyles.font14w600.copyWith(
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Text(
                    price,
                    style: AppStyles.font14Regular.copyWith(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // View Details Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'View Details',
                      style: AppStyles.font14w600.copyWith(
                        fontSize: 13,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right: Image + Favorite
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 110,
                      height: 110,
                      color: AppColors.backgroundColor,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.textLight,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.surfaceColor.withOpacity(0.85),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppColors.errorColor
                            : AppColors.textLight,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
