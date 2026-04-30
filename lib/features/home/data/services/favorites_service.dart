import 'package:hive_ce/hive.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';

class FavoritesService {
  final box = Hive.box(AppConstants.favoritesAdBox);

  static const _key = AppConstants.favIdsKey;

  List<int> getFavorites() {
    return List<int>.from(box.get(_key, defaultValue: []));
  }

  void toggle(int adId) {
    final favs = getFavorites();

    if (favs.contains(adId)) {
      favs.remove(adId);
    } else {
      favs.add(adId);
    }

    box.put(_key, favs);
  }

  bool isFavorite(int adId) {
    return getFavorites().contains(adId);
  }
}
