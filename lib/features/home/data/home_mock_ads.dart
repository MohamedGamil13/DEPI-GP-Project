import 'package:skillbridge/core/models/ad_model.dart';

/// Builds the seed ads used by the home feed and listing notification tests.
List<AdModel> buildSeedAds() {
  return [
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
}

/// Finds a seeded ad by id for notification routing and local testing.
AdModel? findSeedAdById(int? adId) {
  if (adId == null) return null;

  for (final ad in buildSeedAds()) {
    if (ad.adID == adId) {
      return ad;
    }
  }

  return null;
}
