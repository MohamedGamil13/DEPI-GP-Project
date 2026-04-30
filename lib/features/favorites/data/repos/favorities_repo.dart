import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

class FavoritesRepository {
  final box = Hive.box(AppConstants.favoritesAdBox);

  Future<List<AdModel>> getFavoriteAds() async {
    final List<int> ids = List<int>.from(
      box.get(AppConstants.favIdsKey, defaultValue: []),
    );

    List<AdModel> ads = [];

    for (var id in ids) {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.adPostsCollection)
          .doc(id.toString())
          .get();

      if (doc.exists) {
        ads.add(AdModel.fromJson(doc.data()!));
      }
    }

    return ads;
  }
}
