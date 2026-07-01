import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/features/location/data/location_data.dart';

class LocationService {
  static const _cacheKey = 'cached_location';

  Future<LocationData?> getCurrentLocation({bool allowCached = true}) async {
    try {
      // تأكد أن خدمة الموقع مفعلة
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return allowCached ? await _readCachedLocation() : null;
      }
      print(
        "Location Service Enabled: ${await Geolocator.isLocationServiceEnabled()}",
      );
      // الصلاحيات
      var permission = await Geolocator.checkPermission();
      print("Permission Before: $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      print("Permission After: $permission");
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return allowCached ? await _readCachedLocation() : null;
      }

      // احصل دائماً على أحدث Location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final placemark = placemarks.first;

      // للتأكد أثناء التطوير
      print('========== LOCATION ==========');
      print('Latitude : ${position.latitude}');
      print('Longitude: ${position.longitude}');
      print('Country  : ${placemark.country}');
      print('Governor : ${placemark.administrativeArea}');
      print('City     : ${placemark.locality}');
      print('District : ${placemark.subLocality}');
      print('Sub Admin: ${placemark.subAdministrativeArea}');
      print('==============================');

      final location = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,

        // في مصر locality أحياناً تكون فارغة
        city: (placemark.locality?.isNotEmpty ?? false)
            ? placemark.locality!
            : (placemark.subLocality?.isNotEmpty ?? false)
            ? placemark.subLocality!
            : placemark.subAdministrativeArea ?? '',

        governorate:
            placemark.administrativeArea ??
            placemark.subAdministrativeArea ??
            '',

        country: placemark.country ?? '',
      );

      // حدث الكاش دائماً
      await _cacheLocation(location);

      return location;
    } catch (e) {
      print('Location Error: $e');

      // لو حصل خطأ استخدم الكاش فقط كحل احتياطي
      if (allowCached) {
        return await _readCachedLocation();
      }

      return null;
    }
  }

  Future<LocationData?> getCachedLocation() async => _readCachedLocation();

  Future<void> cacheLocation(LocationData location) => _cacheLocation(location);

  Future<void> clearCachedLocation() async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.delete(_cacheKey);
  }

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
