import 'dart:async';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skillbridge/core/utils/helpers/location_service_helper.dart';
import 'package:skillbridge/features/location/data/location_data.dart';

class LocationService {
  static const _cacheKey = 'cached_location';

  final LocationServiceHelper _helper = LocationServiceHelper();

  Future<LocationData?> getCurrentLocation({bool allowCached = true}) async {
    try {
      // تأكد أن خدمة الموقع مفعلة
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log("Location Service Disabled");
        return allowCached ? await _readCachedLocation() : null;
      }

      // الصلاحيات
      var permission = await Geolocator.checkPermission();
      log("Permission Before: $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      log("Permission After: $permission");
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return allowCached ? await _readCachedLocation() : null;
      }

      // احصل على الموقع مع مهلة زمنية — بدون مهلة الطلب ممكن يعلق
      // للأبد على أجهزة حقيقية داخل مبنى أو بإشارة GPS ضعيفة، حتى لو
      // كانت الصلاحيات والخدمة مفعّلة (على عكس المحاكي اللي بيرجع
      // موقع وهمي فوراً).
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw StateError(
          'Could not resolve placemark for '
          '(${position.latitude}, ${position.longitude})',
        );
      }

      final placemark = placemarks.first;

      // للتأكد أثناء التطوير
      log('========== LOCATION ==========');
      log('Latitude : ${position.latitude}');
      log('Longitude: ${position.longitude}');
      log('Country  : ${placemark.country}');
      log('Governor : ${placemark.administrativeArea}');
      log('City     : ${placemark.locality}');
      log('District : ${placemark.subLocality}');
      log('Sub Admin: ${placemark.subAdministrativeArea}');
      log('==============================');

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
    } on TimeoutException catch (e) {
      log('Location Timeout: $e');
      if (allowCached) {
        return await _readCachedLocation();
      }
      return null;
    } catch (e) {
      log('Location Error: $e');

      // لو حصل خطأ استخدم الكاش فقط كحل احتياطي
      if (allowCached) {
        return await _readCachedLocation();
      }

      return null;
    }
  }

  Future<LocationData?> getCachedLocation() async => _readCachedLocation();

  Future<void> cacheLocation(LocationData location) => _cacheLocation(location);

  Future<void> clearCachedLocation() => _helper.deleteCachedLocation(_cacheKey);

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

  Future<LocationData?> _readCachedLocation() =>
      _helper.readCachedLocation(_cacheKey);

  Future<void> _cacheLocation(LocationData location) =>
      _helper.cacheLocation(_cacheKey, location);
}
