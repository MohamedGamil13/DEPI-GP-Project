// lib/features/home/presentation/screens/widgets/ad_hero_image.dart
import 'package:flutter/material.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';

class AdHeroImage extends StatelessWidget {
  const AdHeroImage({
    super.key,
    required this.adId,
    required this.imageUrl,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  final int adId;
  final String imageUrl;
  final double height;
  final BorderRadius borderRadius;

  static const String _fallback = AppImages.defalutPostImage;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'ad-image-$adId',
      child: ClipRRect(
        borderRadius: borderRadius,
        child: imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  _fallback,
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                _fallback,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
