import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

/// Displays the circular avatar with verified badge, user name, and member-since text.
/// Matches the design: light blue ring around avatar, blue verified checkmark badge.
class ProfileHeaderWidget extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileHeaderWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Avatar + verified badge ──
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 52.r,
                backgroundColor: AppColors.backgroundColor,
                backgroundImage: NetworkImage(profile.avatarUrl),
              ),
            ),
            if (profile.isVerified)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified,
                    color: AppColors.white,
                    size: 15.sp,
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 14.h),

        // ── Name ──
        Text(
          profile.name,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        SizedBox(height: 4.h),
        Text(
          'Member since ${DateFormat.yMMMM().format(profile.memberSince)}',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
