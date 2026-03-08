import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

class FirestoreService implements FirestoreRepo {
  final FirebaseFirestore db;
  FirestoreService({required this.db});
  @override
  Future<Result<void>> addPost(AdModel post) async {
    // try {
    //   db
    //       .collection('AdPosts')
    //       .add(post.toJson())
    //       .then(
    //         (DocumentReference doc) =>
    //             print('DocumentSnapshot added with ID: ${doc.id}'),
    //       );
    //   return const Success(null);
    // } on Exception catch (e) {
    //   return Failure(e);
    // }
    // TODO: implement getAllPosts
    throw UnimplementedError();
  }

  @override
  Future<Result<List<AdModel>>> getAllPosts() {
    // TODO: implement getAllPosts
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
}
