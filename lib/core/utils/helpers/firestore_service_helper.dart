import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/core/errors/database_exception.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

class FirestoreServiceHelper {
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getPostDocByAdId(
    CollectionReference<Map<String, dynamic>> posts,
    int adId,
  ) async {
    final snapshot = await posts.where('adID', isEqualTo: adId).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first;
  }

  Future<Set<int>> loadFavoriteIds(
    CollectionReference<Map<String, dynamic>> Function(String userId)
    userFavoritesRef,
    String? userId,
  ) async {
    if (userId == null) return {};

    // جلب الوثائق من الـ Subcollection للمستخدم الحالي
    final snapshot = await userFavoritesRef(userId).get();

    // استخدام snapshot.docs للوصول إلى كل وثيقة واستخراج الـ postId
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return (data['postId'] as num?)?.toInt();
        })
        .whereType<int>() // تصفية أي قيم null
        .toSet(); // تحويل النتيجة إلى Set لمنع التكرار
  }

  List<AdModel> mapPostsWithFavorites(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    Set<int> favoriteIds,
  ) {
    return docs.map((doc) {
      final data = doc.data();
      return AdModel.fromJson(
        data,
        isFavorite: favoriteIds.contains(data['adID'] as int?),
      );
    }).toList();
  }

  DatabaseException mapException(FirebaseException e) {
    return switch (e.code) {
      'not-found' => DocumentNotFoundException(),
      'permission-denied' => PermissionDeniedException(),
      'already-exists' => DataAlreadyExistsException(),
      'unavailable' || 'network-request-failed' => DatabaseNetworkException(),
      _ => UnknownDatabaseException(
        code: e.code,
        message: e.message ?? 'Unexpected database error.',
      ),
    };
  }
}
