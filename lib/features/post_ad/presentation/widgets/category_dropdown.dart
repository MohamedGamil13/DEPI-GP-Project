import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';

/// Dropdown field for selecting an ad category.
class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final void Function(String?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedCategory,
      onChanged: onChanged,
      validator: (val) => val == null ? 'Please select a category' : null,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textMedium,
        size: 22.sp,
      ),
      style: AppStyles.font14w600,
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        hintText: 'Select a category',
        hintStyle: AppStyles.font14w600.copyWith(color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
      ),
      items: categories
          .map(
            (cat) => DropdownMenuItem(
              value: cat,
              child: Text(cat, style: AppStyles.font14w600),
            ),
          )
          .toList(),
    );
  }
}
