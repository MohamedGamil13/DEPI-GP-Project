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
