import 'package:flutter/material.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';

class AdImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final BorderRadius? borderRadius;
  final int heroTag;
  final Widget? overlay;

  const AdImageWidget({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.heroTag,
    this.borderRadius,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = imageUrl.startsWith('http');

    return Hero(
      tag: heroTag,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: isNetwork
                ? Image.network(
                    imageUrl,
                    height: height,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppImages.defalutPostImage,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    AppImages.defalutPostImage,
                    height: height,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          if (overlay != null) Positioned.fill(child: overlay!),
        ],
      ),
    );
  }
}
