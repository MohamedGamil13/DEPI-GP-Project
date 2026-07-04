import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_strings.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/presentation/widgets/post_card_widget.dart';

class ProfilePostsList extends StatelessWidget {
  final List<AdModel> posts;

  const ProfilePostsList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noPostsYet(context),
          style: TextStyle(color: AppColors.secondaryColor, fontSize: 14.sp),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCardWidget(
          post: posts[index],
          onTap: () => context.goAdDetails(posts[index]),
        );
      },
    );
  }
}
