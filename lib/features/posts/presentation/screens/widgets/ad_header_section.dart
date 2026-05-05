import 'package:flutter/material.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_details_widget.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required this.ad});
  final AdModel ad;

  @override
  Widget build(BuildContext context) {
    return AdImageHeader(
      adId: ad.adID,
      imageUrl: ad.photos.isNotEmpty
          ? ad.photos[0]
          : AppImages.defalutPostImage,
    );
  }
}
