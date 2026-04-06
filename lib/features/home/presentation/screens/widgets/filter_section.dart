import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';

import 'filter_chip.dart';

class FiltersSection extends StatelessWidget {
  const FiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Categories
                CustomFilterChip<AdCategories>(
                  key: const ValueKey('categories'),
                  label: 'All Categories',
                  items: AdCategories.values,
                  getLabel: (category) => category.label,
                  getIcon: (category) => category.icon,
                  onChanged: (value) {
                    // TODO: handle category filter
                  },
                ),

                /// Cities
                CustomFilterChip<AdCity>(
                  key: const ValueKey('cities'),
                  label: 'Any City',
                  items: AdCity.values,
                  getLabel: (city) => city.label,
                  leadingIcon: Icons.location_on_outlined,
                  onChanged: (value) {
                    // TODO: handle city filter
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// My City Only (optional logic)
            Center(
              child: CustomFilterChip<AdCity>(
                key: const ValueKey('my_city'),
                label: 'My City Only',
                items: AdCity.values,
                getLabel: (city) => city.label,
                leadingIcon: Icons.my_location,
                onChanged: (value) {
                  // ممكن هنا تجيب current location وتفلتر
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
