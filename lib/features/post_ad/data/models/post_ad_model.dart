/// The data model for a posted ad.
/// Pure Dart — no Flutter dependencies.
class PostAdModel {
  final String title;
  final String category;
  final String description;
  final double price;
  final String city;
  final List<String> selectedSkills;
  final List<String> imagePaths;

  const PostAdModel({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.city,
    required this.selectedSkills,
    required this.imagePaths,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category,
        'description': description,
        'price': price,
        'city': city,
        'skills': selectedSkills,
        'images': imagePaths,
      };

  PostAdModel copyWith({
    String? title,
    String? category,
    String? description,
    double? price,
    String? city,
    List<String>? selectedSkills,
    List<String>? imagePaths,
  }) =>
      PostAdModel(
        title: title ?? this.title,
        category: category ?? this.category,
        description: description ?? this.description,
        price: price ?? this.price,
        city: city ?? this.city,
        selectedSkills: selectedSkills ?? this.selectedSkills,
        imagePaths: imagePaths ?? this.imagePaths,
      );

  @override
  String toString() =>
      'PostAdModel(title: $title, category: $category, price: $price, city: $city)';
}
