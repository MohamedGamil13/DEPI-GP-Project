import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

class SavedTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const SavedTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> tabs = const ['All', 'Cleaning', 'Maintenance', 'Beauty'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceColor,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      height: 2,
                      width: 20,
                      color: AppColors.primaryColor,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
