import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_content_section.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_details_widget.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_header_section.dart';

class AdDetailsScreen extends StatelessWidget {
  final AdModel ad;

  const AdDetailsScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(ad: ad),
                  ContentSection(ad: ad),
                ],
              ),
            ),
          ),
          const ContactButtons(),
        ],
      ),
    );
  }
}
