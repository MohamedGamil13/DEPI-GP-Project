class LocationData {
  final double latitude;
  final double longitude;
  final String city;
  final String governorate;
  final String country;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.governorate,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'city': city,
    'governorate': governorate,
    'country': country,
  };

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      city: json['city'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }
}
