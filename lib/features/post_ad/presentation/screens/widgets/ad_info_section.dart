import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/post_ad/presentation/screens/widgets/category_tag.dart';

class InfoSection extends StatelessWidget {
  final AdModel ad;

  const InfoSection({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CategoryTag(label: ad.category.label),
            const SizedBox(width: 10),
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: AppColors.textLight,
            ),
            Text(
              " ${ad.adCity.label}",
              style: AppStyles.font14Regular.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Text(ad.title, style: AppStyles.font24w600),

        const SizedBox(height: 12),

        _PriceWidget(price: ad.price),
      ],
    );
  }
}

class _PriceWidget extends StatelessWidget {
  final double price;

  const _PriceWidget({required this.price});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "\$${price.toStringAsFixed(2)} ",
            style: AppStyles.font24w600.copyWith(color: AppColors.primaryColor),
          ),
          TextSpan(
            text: "/ hour",
            style: AppStyles.font14Regular.copyWith(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
