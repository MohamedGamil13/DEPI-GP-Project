import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/features/location/data/location_data.dart';

class LocationService {
  static const _cacheKey = 'cached_location';

  Future<LocationData?> getCurrentLocation({bool allowCached = true}) async {
    try {
      final cached = allowCached ? await _readCachedLocation() : null;
      if (cached != null) return cached;

      final permission = await Geolocator.checkPermission();
      var effectivePermission = permission;

      if (permission == LocationPermission.denied) {
        effectivePermission = await Geolocator.requestPermission();
      }

      if (effectivePermission == LocationPermission.denied ||
          effectivePermission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      final location = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        city: placemark?.locality ?? placemark?.subAdministrativeArea ?? '',
        governorate:
            placemark?.administrativeArea ??
            placemark?.subAdministrativeArea ??
            '',
        country: placemark?.country ?? '',
      );

      await _cacheLocation(location);
      return location;
    } catch (_) {
      return null;
    }
  }

  Future<LocationData?> getCachedLocation() async => _readCachedLocation();

  Future<void> cacheLocation(LocationData location) => _cacheLocation(location);

  double distanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<LocationData?> _readCachedLocation() async {
    final box = Hive.box(AppConstants.appSettingsBox);
    final cached = box.get(_cacheKey);
    if (cached is Map) {
      return LocationData.fromJson(Map<String, dynamic>.from(cached));
    }
    return null;
  }

  Future<void> _cacheLocation(LocationData location) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(_cacheKey, location.toJson());
  }
}
