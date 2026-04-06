import 'package:flutter/material.dart';
import 'package:skillbridge/core/models/ad_model.dart';
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
  final List<AdModel> _ads = [
    AdModel(
      adID: 1,
      title: 'Laptop Repair & Setup',
      description: 'Expert hardware diagnostics and software installation',
      city: 'Cairo',
      photos: ['assets/images/labtop.jpg'],
      price: 50,
      category: AdCategories.services,
      relevantSkills: [RelevantSkills.mobile, RelevantSkills.ai],
      adCity: AdCity.cairo,
    ),
    AdModel(
      adID: 2,
      title: 'Deep Home Cleaning',
      description: 'Professional eco-friendly cleaning service',
      city: 'Giza',
      photos: ['assets/images/labtop.jpg'],
      price: 85,
      category: AdCategories.services,
      relevantSkills: [RelevantSkills.projectManagement],
      adCity: AdCity.giza,
    ),
    AdModel(
      adID: 3,
      title: 'Math Tutoring (K-12)',
      description: 'Personalized algebra and calculus tutoring',
      city: 'Alexandria',
      photos: ['assets/images/labtop.jpg'],
      price: 35,
      category: AdCategories.education,
      relevantSkills: [RelevantSkills.teaching],
      adCity: AdCity.alexandria,
    ),
  ];

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
