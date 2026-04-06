import 'package:flutter/material.dart';

import 'filter_chip.dart';

class FiltersSection extends StatelessWidget {
  const FiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomFilterChip(label: 'All Categories'),
                CustomFilterChip(label: 'Any City'),
              ],
            ),
            SizedBox(height: 8),
            CustomFilterChip(
              label: 'My City Only',
              icon: Icons.location_on_outlined,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
