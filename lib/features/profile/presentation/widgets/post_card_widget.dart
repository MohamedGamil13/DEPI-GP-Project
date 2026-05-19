import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

/// A single ad/post card used in both "My Posts" and "Activity" tabs.
class PostCardWidget extends StatelessWidget {
  final AdModel? post;
  final VoidCallback onTap;

  const PostCardWidget({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Resolve thumbnail: first photo if available, else default asset
    final String thumbnail = (post?.photos.isNotEmpty == true)
        ? post!.photos[0]
        : AppImages.defalutPostImage;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                thumbnail,
                width: 90.w,
                height: 90.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90.w,
                  height: 90.h,
                  color: AppColors.backgroundColor,
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.secondaryColor,
                    size: 28.sp,
                  ),
                ),
              ),
            ),

            SizedBox(width: 14.w),

            // ── Details ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Optional badge ──
                  if (post?.badge != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        post!.badge!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF059669),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                  ],

                  // ── Title ──
                  Text(
                    post?.title ?? 'Untitled',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6.h),

                  // ── Price ──
                  Text(
                    post != null
                        ? 'EGP ${post!.price.toStringAsFixed(0)}'
                        : '—',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // ── City ──
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13.sp,
                        color: AppColors.secondaryColor,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          // adCity.label gives the human-readable city name
                          post?.adCity.label ?? 'Unknown location',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
