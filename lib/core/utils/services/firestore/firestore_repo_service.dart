import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/core/errors/database_exception.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/core/utils/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

class FirestoreService implements FirestoreRepo {
  final FirebaseFirestore db;
  FirestoreService({required this.db});
  @override
  Future<Result<List<AdModel>>> getAllPosts() async {
    try {
      final QuerySnapshot snapshot = await db
          .collection(AppConstants.adPostsCollection)
          .get();

      final List<AdModel> allPosts = snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Success(allPosts);
    } on FirebaseException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategory category) async {
    try {
      final QuerySnapshot snapshot = await db
          .collection(AppConstants.adPostsCollection)
          .where('category', isEqualTo: category.name)
          .get();

      final List<AdModel> filteredPosts = snapshot.docs
          .map((doc) => AdModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Success(filteredPosts);
    } on FirebaseException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Result<AdModel>> getPost(int postID) async {
    try {
      final QuerySnapshot snapshot = await db
          .collection(AppConstants.adPostsCollection)
          .where('adID', isEqualTo: postID)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) throw DocumentNotFoundException();

      final AdModel post = AdModel.fromJson(
        snapshot.docs.first.data() as Map<String, dynamic>,
      );

      return Success(post);
    } on FirebaseException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Result<AdModel>> searchForPost(String title) async {
    try {
      final QuerySnapshot snapshot = await db
          .collection(AppConstants.adPostsCollection)
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThanOrEqualTo: '$title\uf8ff')
          .get();

      if (snapshot.docs.isEmpty) throw DocumentNotFoundException();

      final AdModel post = AdModel.fromJson(
        snapshot.docs.first.data() as Map<String, dynamic>,
      );

      return Success(post);
    } on FirebaseException catch (e) {
      throw _mapException(e);
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

  @override
  Future<Result<void>> addPost(AdModel post) async {
    try {
      await db.collection(AppConstants.adPostsCollection).add(post.toJson());
      return const Success(null);
    } on FirebaseException catch (e) {
      throw _mapException(e);
    }
  }
}
