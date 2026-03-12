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
  Future<Result<void>> addPost(AdModel post) async {
    try {
      db.collection(AppConstants.adPostsCollection).add(post.toJson());

      return const Success(null);
    } on FirebaseException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Result<List<AdModel>>> getAllPosts() async {
    // List<AdModel> allPosts = [];
    // await db.collection(AppConstants.adPostsCollection).get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //     allPosts = doc.data();
    //   }
    // });
    // TODO: implement getFilteredPosts
    throw UnimplementedError();
  }

  @override
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategory category) {
    // TODO: implement getFilteredPosts
    throw UnimplementedError();
  }

  @override
  Future<Result<AdModel>> getPost(int postID) {
    // TODO: implement getPost
    throw UnimplementedError();
  }

  @override
  Future<Result<AdModel>> searchForPost(String title) {
    // TODO: implement searchForPost
    throw UnimplementedError();
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
