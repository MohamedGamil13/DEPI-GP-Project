import 'package:flutter/material.dart';

class AdModel {
  final int adID;
  final String title;
  final String description;
  final String city;
  final List<String> photos;
  final double price;
  final AdCategories category;
  final List<RelevantSkills>? relevantSkills;
  final AdCity adCity;

  AdModel({
    required this.title,
    required this.description,
    required this.city,
    required this.photos,
    required this.price,
    required this.category,
    required this.relevantSkills,
    required this.adCity,
    required this.adID,
  });
  Map<String, dynamic> toJson() {
    return {
      "adID": adID,
      "title": title,
      "description": description,
      "city": city,
      "photos": photos,
      "price": price,
      "category": category.name,
      "relevantSkills": relevantSkills?.map((skill) => skill.name).toList(),
      "adCity": adCity.name,
    };
  }
}

enum AdCategories {
  programming,
  vehicles,
  jobs,
  games,
  interns,
  services,
  events,
  electronics,
  realEstate,
  fashion,
  sports,
  health,
  education,
  travel,
  food,
  books,
  music,
  furniture,
  photography,
  studentSupport;

  String get label => switch (this) {
    AdCategories.programming => 'Programming',
    AdCategories.vehicles => 'Vehicles',
    AdCategories.jobs => 'Jobs',
    AdCategories.games => 'Games',
    AdCategories.interns => 'Interns',
    AdCategories.services => 'Services',
    AdCategories.events => 'Events',
    AdCategories.electronics => 'Electronics',
    AdCategories.realEstate => 'Real Estate',
    AdCategories.fashion => 'Fashion',
    AdCategories.sports => 'Sports',
    AdCategories.health => 'Health',
    AdCategories.education => 'Education',
    AdCategories.travel => 'Travel',
    AdCategories.food => 'Food',
    AdCategories.books => 'Books',
    AdCategories.music => 'Music',
    AdCategories.furniture => 'Furniture',
    AdCategories.photography => 'Photography',
    AdCategories.studentSupport => 'Student Support',
  };

  IconData get icon => switch (this) {
    AdCategories.programming => Icons.code,
    AdCategories.vehicles => Icons.directions_car,
    AdCategories.jobs => Icons.work,
    AdCategories.games => Icons.sports_esports,
    AdCategories.interns => Icons.school,
    AdCategories.services => Icons.miscellaneous_services,
    AdCategories.events => Icons.event,
    AdCategories.electronics => Icons.devices,
    AdCategories.realEstate => Icons.home,
    AdCategories.fashion => Icons.checkroom,
    AdCategories.sports => Icons.sports,
    AdCategories.health => Icons.health_and_safety,
    AdCategories.education => Icons.menu_book,
    AdCategories.travel => Icons.flight,
    AdCategories.food => Icons.restaurant,
    AdCategories.books => Icons.book,
    AdCategories.music => Icons.music_note,
    AdCategories.furniture => Icons.chair,
    AdCategories.photography => Icons.camera_alt,
    AdCategories.studentSupport => Icons.support,
  };
}

enum RelevantSkills {
  mobile,
  web,
  cyberSecurity,
  gameDevelopment,
  devOps,
  ai,
  dataScience,
  uiUxDesign,
  blockchain,
  cloudComputing,
  networking,
  seoMarketing,
  contentWriting,
  digitalMarketing,
  graphicDesign,
  videoEditing,
  projectManagement,
  accounting,
  languages,
  teaching,
}

enum AdCity {
  cairo,
  giza,
  alexandria,
  portSaid,
  suez,
  damietta,
  dakahlia,
  sharkia,
  ghrbia,
  monufia,
  behira,
  fayoum,
  beniSuef,
  minya,
  assiut,
  sohag,
  qena,
  luxor,
  matrouh,
  redSea,
  northSinai,
  southSinai,
  ismailia,
}
