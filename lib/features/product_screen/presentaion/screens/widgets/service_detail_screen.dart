import 'package:flutter/material.dart';
import 'package:skillbridge/core/widgets/custom_bottom_navigation_bar.dart';
import '../widgets/service_header_image.dart';
import '../widgets/service_info_section.dart';
import '../widgets/provider_card.dart';
import '../widgets/service_description_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/action_buttons_bar.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ServiceHeaderImage(
              onBack: () => Navigator.maybePop(context),
              onShare: () {},
              onFavorite: () {},
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  ServiceInfoSection(),
                  SizedBox(height: 16),
                  ProviderCard(),
                  SizedBox(height: 20),
                  ServiceDescriptionSection(),
                  SizedBox(height: 20),
                  ReviewsSection(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ActionButtonsBar()],
            ),
          ),
        ],
      ),
    );
  }
}
