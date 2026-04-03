import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/category_combo_box_item.dart';

class CustomFilterChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final List<AdCategories> categories = AdCategories.values;

  const CustomFilterChip({super.key, required this.label, this.icon});

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCategory,
            hint: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: AppColors.primaryColor, size: 18),
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.label,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            iconEnabledColor: AppColors.primaryColor,
            isExpanded: true,
            dropdownColor: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            items: widget.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.label,
                child: CategoryComboBoxItem(adCategories: category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            // Styling the button itself
            selectedItemBuilder: (context) {
              return widget.categories.map((category) {
                return Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      category.label,
                      style: AppStyles.font14Regular.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
