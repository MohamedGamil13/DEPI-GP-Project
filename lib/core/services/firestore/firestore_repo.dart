import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';

abstract interface class StoreService {
  Future<Result<List<AdModel>>> getAllPosts();
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategories category);
  Future<Result<AdModel>> getPost(int postID);
  Future<Result<void>> addPost(AdModel post);
  Future<Result<AdModel>> searchForPost(String title);
}

  // Future<Result<List<AdModel>>> ();
  // Future<Result<List<AdModel>>> getData();