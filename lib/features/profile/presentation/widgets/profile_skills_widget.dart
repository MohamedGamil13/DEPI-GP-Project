import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

/// Skill chips section with "Skills" heading.
/// First chip is highlighted (filled primaryColor), rest are outlined.
class ProfileSkillsWidget extends StatelessWidget {
  final List<String> skills;

  const ProfileSkillsWidget({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            skills.length,
            (index) => _SkillChip(
              label: skills[index],
              isHighlighted: index == 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final bool isHighlighted;

  const _SkillChip({required this.label, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primaryColor
              : AppColors.primaryColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: isHighlighted ? AppColors.white : AppColors.primaryColor,
        ),
      ),
    );
  }
}
