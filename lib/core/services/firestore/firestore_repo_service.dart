import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillbridge/core/errors/database_exception.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/data/models/review_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

class FirestoreService implements StoreService {
  final FirebaseFirestore db;

  FirestoreService({required this.db});

  String? get _currentUserId => getIt<FirebaseAuth>().currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _posts =>
      db.collection(AppConstants.adPostsCollection);

  CollectionReference<Map<String, dynamic>> _userFavoritesRef(String userId) =>
      db
          .collection(AppConstants.userMetaDataCollection)
          .doc(userId)
          .collection(AppConstants.favoritesSubCollection);

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _getPostDocByAdId(
    int adId,
  ) async {
    final snapshot = await _posts.where('adID', isEqualTo: adId).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first;
  }

  Future<Set<int>> _loadFavoriteIds() async {
    final userId = _currentUserId;
    if (userId == null) return {};

    // جلب الوثائق من الـ Subcollection للمستخدم الحالي
    final snapshot = await _userFavoritesRef(userId).get();

    // استخدام snapshot.docs للوصول إلى كل وثيقة واستخراج الـ postId
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return (data['postId'] as num?)?.toInt();
        })
        .whereType<int>() // تصفية أي قيم null
        .toSet(); // تحويل النتيجة إلى Set لمنع التكرار
  }

  List<AdModel> _mapPostsWithFavorites(
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

  @override
  Future<Result<List<AdModel>>> getAllPosts() async {
    try {
      final snapshot = await _posts.get();
      final favoriteIds = await _loadFavoriteIds();
      final currentUserId = _currentUserId;

      final posts = _mapPostsWithFavorites(
        snapshot.docs,
        favoriteIds,
      ).where((post) => post.userId != currentUserId).toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategories category) async {
    try {
      Query<Map<String, dynamic>> query = _posts;

      if (category != AdCategories.all) {
        query = query.where('category', isEqualTo: category.name);
      }

      final snapshot = await query.get();
      final favoriteIds = await _loadFavoriteIds();
      final posts = _mapPostsWithFavorites(snapshot.docs, favoriteIds);

      return Success(posts);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<AdModel>> getPost(int postID) async {
    try {
      final doc = await _getPostDocByAdId(postID);
      if (doc == null) throw DocumentNotFoundException();

      final favoriteIds = await _loadFavoriteIds();
      final post = AdModel.fromJson(
        doc.data(),
        isFavorite: favoriteIds.contains(postID),
      );

      return Success(post);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<AdModel>> searchForPost(String title) async {
    try {
      final snapshot = await _posts
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThanOrEqualTo: '$title\uf8ff')
          .get();

      if (snapshot.docs.isEmpty) throw DocumentNotFoundException();

      final favoriteIds = await _loadFavoriteIds();
      final firstDocData = snapshot.docs.first.data();

      final post = AdModel.fromJson(
        firstDocData,
        isFavorite: favoriteIds.contains(firstDocData['adID']),
      );

      return Success(post);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<void>> addPost(AdModel post) async {
    try {
      await _posts.add(post.toJson());
      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<void>> saveUserData(UserProfileModel user) async {
    try {
      await db
          .collection(AppConstants.userMetaDataCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<void>> updateUserToken({
    required String userId,
    required String token,
    required bool add,
  }) async {
    try {
      await db.collection(AppConstants.userMetaDataCollection).doc(userId).set({
        'fcmTokens': add
            ? FieldValue.arrayUnion([token])
            : FieldValue.arrayRemove([token]),
      }, SetOptions(merge: true));

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<UserProfileModel>> getUserById(String id) async {
    try {
      final documentSnapshot = await db
          .collection(AppConstants.userMetaDataCollection)
          .doc(id)
          .get();

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        final Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        final UserProfileModel user = UserProfileModel.fromJson(data);

        return Success(user);
      } else {
        throw DocumentNotFoundException();
      }
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<List<AdModel>>> getCurrentUserPosts() async {
    try {
      final currentUserId = _currentUserId;
      if (currentUserId == null) {
        return const Success([]);
      }
      return getPostsByUserId(currentUserId);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<List<AdModel>>> getPostsByUserId(String userId) async {
    try {
      final snapshot = await _posts.get();
      final favoriteIds = await _loadFavoriteIds();

      final posts = _mapPostsWithFavorites(
        snapshot.docs,
        favoriteIds,
      ).where((post) => post.userId == userId).toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<List<AdModel>>> getFavoritePosts() async {
    try {
      final favoriteIds = await _loadFavoriteIds();
      if (favoriteIds.isEmpty) return const Success([]);

      final snapshot = await _posts.get();
      final posts = _mapPostsWithFavorites(
        snapshot.docs,
        favoriteIds,
      ).where((post) => favoriteIds.contains(post.adID)).toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<Set<int>>> getFavoritePostIds() async {
    try {
      final favoriteIds = await _loadFavoriteIds();
      return Success(favoriteIds);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<void>> addFavorite(int postId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw PermissionDeniedException();

      await _userFavoritesRef(userId).doc(postId.toString()).set({
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<void>> removeFavorite(int postId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw PermissionDeniedException();

      await _userFavoritesRef(userId).doc(postId.toString()).delete();

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<bool>> isFavorite(int postId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) return const Success(false);

      final doc = await _userFavoritesRef(userId).doc(postId.toString()).get();
      return Success(doc.exists);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Future<Result<List<ReviewModel>>> getPostReviews(int postId) async {
    try {
      final postDoc = await _getPostDocByAdId(postId);
      if (postDoc == null) throw DocumentNotFoundException();

      final snapshot = await postDoc.reference
          .collection(AppConstants.reviewsSubCollection)
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data(), id: doc.id))
          .toList();

      return Success(reviews);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  @override
  Stream<List<ReviewModel>> watchPostReviews(int postId) async* {
    final postDoc = await _getPostDocByAdId(postId);
    if (postDoc == null) {
      yield [];
      return;
    }

    yield* postDoc.reference
        .collection(AppConstants.reviewsSubCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data(), id: doc.id))
              .toList(),
        );
  }

  @override
  Future<Result<ReviewModel>> addReview({
    required int postId,
    required String userId,
    required String userName,
    required String userImage,
    required int rating,
    required String comment,
  }) async {
    try {
      final postDoc = await _getPostDocByAdId(postId);
      if (postDoc == null) throw DocumentNotFoundException();

      final reviewsRef = postDoc.reference
          .collection(AppConstants.reviewsSubCollection);
      final existingQuery = await reviewsRef
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      final existingDoc =
          existingQuery.docs.isEmpty ? null : existingQuery.docs.first;

      final postData = postDoc.data();
      final currentTotal = (postData['totalReviews'] as num?)?.toInt() ?? 0;
      final currentAvg = (postData['averageRating'] as num?)?.toDouble() ?? 0.0;
      final normalizedComment = comment.trim();
      final now = DateTime.now();
      final previousRating = (existingDoc?.data()['rating'] as num?)?.toInt();
      final newTotal = currentTotal + (existingDoc == null ? 1 : 0);
      final newAvg = existingDoc == null
          ? ((currentAvg * currentTotal) + rating) / newTotal
          : currentTotal == 0
              ? 0.0
              : (((currentAvg * currentTotal) -
                          (previousRating ?? rating) +
                          rating) /
                      currentTotal);

      final reviewRef = existingDoc?.reference ?? reviewsRef.doc();
      final review = ReviewModel(
        id: reviewRef.id,
        postId: postId,
        userId: userId,
        userName: userName,
        userImage: userImage,
        rating: rating,
        comment: normalizedComment,
        createdAt: existingDoc == null
            ? now
            : ((existingDoc.data()['createdAt'] as Timestamp?)?.toDate() ??
                  now),
      );

      final batch = db.batch();

      final reviewJson = review.toJson();
      reviewJson['createdAt'] = Timestamp.fromDate(review.createdAt);

      batch.set(reviewRef, reviewJson);
      batch.update(postDoc.reference, {
        'averageRating': newAvg,
        'totalReviews': newTotal,
      });
      await batch.commit();

      return Success(review);
    } on FirebaseException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(message: e.toString(), code: 'unknown'),
      );
    }
  }

  DatabaseException _mapException(FirebaseException e) {
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
