import 'package:flutter/material.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_details_widget.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.ad,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final AdModel ad;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return AdImageHeader(
      adId: ad.adID,
      imageUrl: ad.photos.isNotEmpty
          ? ad.photos[0]
          : AppImages.defalutPostImage,
      isFavorite: isFavorite,
      onFavoriteToggle: onFavoriteToggle,
    );
  }
}
