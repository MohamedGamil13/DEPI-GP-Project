import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

/// Three stat cards in a row: Rating / Reviews / Posts.
/// Each card has a white surface with a subtle shadow matching the app's card style.
class ProfileStatsWidget extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileStatsWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(value: profile.rating.toString(), label: AppStrings.rating(context)),
        SizedBox(width: 12.w),
        _StatCard(value: profile.reviews.toString(), label: AppStrings.reviews(context)),
        SizedBox(width: 12.w),
        _StatCard(value: profile.postsCount.toString(), label: AppStrings.posts(context)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
