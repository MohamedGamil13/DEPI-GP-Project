import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/features/location/data/location_data.dart';

class LocationServiceHelper {
  Future<LocationData?> readCachedLocation(String cacheKey) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    final cached = box.get(cacheKey);

    if (cached is Map) {
      return LocationData.fromJson(Map<String, dynamic>.from(cached));
    }

    return null;
  }

  Future<void> cacheLocation(String cacheKey, LocationData location) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(cacheKey, location.toJson());
  }

  Future<void> deleteCachedLocation(String cacheKey) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.delete(cacheKey);
  }
}
