import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/category_tab.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeSuccess || current is HomeLoading,
      builder: (context, state) {
        final selectedCategory = state is HomeSuccess
            ? state.selectedCategory
            : AdCategories.all;

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 48,
              child: _CategoriesListView(selectedCategory: selectedCategory),
            ),
          ),
        );
      },
    );
  }
}

class _CategoriesListView extends StatelessWidget {
  final AdCategories selectedCategory;

  const _CategoriesListView({required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    const categories = AdCategories.values;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CategoryTab(
            adCategories: category,
            selected: category == selectedCategory,
            onTap: () {
              context.read<HomeCubit>().getFilteredPosts(category);
            },
          ),
        );
      },
    );
  }
}
