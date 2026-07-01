import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';

/// The photo upload card at the top of Post an Ad.
/// Empty state  → camera icon + title + subtitle + "Select Images" button
/// Filled state → thumbnail row + remove buttons + photo count
class PhotoUploadSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onSelectImages;
  final void Function(int index) onRemoveImage;

  const PhotoUploadSection({
    super.key,
    required this.images,
    required this.onSelectImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: images.isEmpty
          ? _EmptyState(onSelectImages: onSelectImages)
          : _FilledState(
              images: images,
              onSelectImages: onSelectImages,
              onRemoveImage: onRemoveImage,
            ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onSelectImages;
  const _EmptyState({required this.onSelectImages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 24.w),
      child: Column(
        children: [
          // Camera icon with + badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.camera_alt_rounded,
                size: 42.sp,
                color: AppColors.primaryColor,
              ),
              Positioned(
                right: -6.w,
                top: -6.h,
                child: Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 12.sp, color: AppColors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          Text(
            'Add Photos (1-3)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 6.h),

          Text(
            'Upload high-quality images of your service to attract more clients',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textMedium,
              height: 1.5,
            ),
          ),
          SizedBox(height: 18.h),

          GestureDetector(
            onTap: onSelectImages,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_rounded,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Select Images',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filled state ──────────────────────────────────────────────────────────────
class _FilledState extends StatelessWidget {
  final List<File> images;
  final VoidCallback onSelectImages;
  final void Function(int) onRemoveImage;

  const _FilledState({
    required this.images,
    required this.onSelectImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 90.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + (images.length < 3 ? 1 : 0),
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                // Add more slot
                if (index == images.length) {
                  return GestureDetector(
                    onTap: onSelectImages,
                    child: Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.primaryColor,
                        size: 26.sp,
                      ),
                    ),
                  );
                }

                // Image thumbnail with remove button
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.file(
                        images[index],
                        width: 90.w,
                        height: 90.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(index),
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: const BoxDecoration(
                            color: AppColors.errorColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 12.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${images.length}/3 photos added',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}
