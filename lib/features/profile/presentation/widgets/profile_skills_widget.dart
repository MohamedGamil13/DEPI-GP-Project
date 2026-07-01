import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';

class ProfileSkillsWidget extends StatelessWidget {
  final List<String> skills;
  final VoidCallback? onAddSkill;
  final ValueChanged<String>? onRemoveSkill;

  const ProfileSkillsWidget({
    super.key,
    required this.skills,
    this.onAddSkill,
    this.onRemoveSkill,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStrings.skills(context),
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const Spacer(),
            if (onAddSkill != null)
              TextButton.icon(
                onPressed: onAddSkill,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Skill'),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: skills
              .map(
                (skill) => InputChip(
                  label: Text(skill),
                  onDeleted: onRemoveSkill == null
                      ? null
                      : () => onRemoveSkill!(skill),
                  deleteIconColor: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: AppColors.primaryColor.withOpacity(0.35),
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
