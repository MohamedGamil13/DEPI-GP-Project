import 'package:flutter/material.dart';

import 'categories_list_view.dart'; // your existing categories widget

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(height: 48, child: CategoriesListView()),
    );
  }
}
