import 'package:flutter/material.dart';
import 'package:skillbridge/features/home/data/home_mock_ads.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/ad_list_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/categories_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/filter_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/home_header.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final _ads = buildSeedAds();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeHeader(),
        const CategoriesSection(),
        const FiltersSection(),
        AdListSection(ads: _ads),
      ],
    );
  }
}
