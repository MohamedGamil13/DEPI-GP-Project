import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/category_tab.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
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
