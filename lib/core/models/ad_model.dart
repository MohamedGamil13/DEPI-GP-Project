class AdModel {
  final int adID;
  final String title;
  final String description;
  final String city;
  final List<String> photos;
  final double price;
  final AdCategory category;
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

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      title: json['title'],
      description: json['description'],
      city: json['city'],
      photos: List<String>.from(json['photos']),
      price: (json['price'] as num).toDouble(),
      adID: json['adID'],
      category: AdCategory.values.byName(json['category']),
      relevantSkills: (json['relevantSkills'] as List?)
          ?.map((s) => RelevantSkills.values.byName(s))
          .toList(),
      adCity: AdCity.values.byName(json['adCity']),
    );
  }

  AdModel copyWith({
    int? adID,
    String? title,
    String? description,
    String? city,
    List<String>? photos,
    double? price,
    AdCategory? category,
    List<RelevantSkills>? relevantSkills,
    AdCity? adCity,
  }) {
    return AdModel(
      adID: adID ?? this.adID,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      photos: photos ?? this.photos,
      price: price ?? this.price,
      category: category ?? this.category,
      relevantSkills: relevantSkills ?? this.relevantSkills,
      adCity: adCity ?? this.adCity,
    );
  }
}

enum AdCategory {
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
  studentSupport,
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
