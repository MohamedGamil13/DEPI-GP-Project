// /// Represents a single ad post displayed in the profile screen tabs.
// class AdPostModel {
//   final String id;
//   final String title;
//   final String priceRange;
//   final String location;
//   final String imageUrl;
//   final String? badge; // e.g. "GREAT MATCH" — null means no badge shown

//   const AdPostModel({
//     required this.id,
//     required this.title,
//     required this.priceRange,
//     required this.location,
//     required this.imageUrl,
//     this.badge,
//   });

//   factory AdPostModel.fromJson(Map<String, dynamic> json) {
//     return AdPostModel(
//       id: json['id'] as String,
//       title: json['title'] as String,
//       priceRange: json['price_range'] as String,
//       location: json['location'] as String,
//       imageUrl: json['image_url'] as String,
//       badge: json['badge'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'price_range': priceRange,
//     'location': location,
//     'image_url': imageUrl,
//     'badge': badge,
//   };
// }
