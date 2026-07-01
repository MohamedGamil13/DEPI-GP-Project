import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

/// A single toggleable skill chip.
/// Selected  → filled blue background + label + × icon
/// Unselected → white background + border + + prefix + label
class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SkillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Prefix + for unselected
            if (!isSelected)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMedium,
                  ),
                ),
              ),

            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textMedium,
              ),
            ),

            // Suffix × for selected
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Icon(Icons.close, size: 13.sp, color: AppColors.white),
              ),
          ],
        ),
      ),
    );
  }
}
