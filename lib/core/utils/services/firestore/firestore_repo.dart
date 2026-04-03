import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

abstract interface class FirestoreRepo {
  Future<Result<List<AdModel>>> getAllPosts();
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategories category);
  Future<Result<AdModel>> getPost(int postID);
  Future<Result<void>> addPost(AdModel post);
  Future<Result<AdModel>> searchForPost(String title);
  // Future<Result<List<AdModel>>> ();
  // Future<Result<List<AdModel>>> getData();
}
