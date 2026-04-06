import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/category_tab.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(height: 48, child: _CategoriesListView()),
    );
  }
}

class _CategoriesListView extends StatefulWidget {
  const _CategoriesListView();

  @override
  State<_CategoriesListView> createState() => __CategoriesListViewState();
}

class __CategoriesListViewState extends State<_CategoriesListView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const List<AdCategories> categories = AdCategories.values;
    return ListView.builder(
      scrollDirection: .horizontal,
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CategoryTab(
            label: category.label,
            icon: category.icon,
            selected: index == _currentIndex,
            onTap: () => setState(() => _currentIndex = index),
          ),
        );
      },
    );
  }
}
