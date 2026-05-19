import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

abstract interface class StoreService {
  Future<Result<List<AdModel>>> getAllPosts();
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategories category);
  Future<Result<AdModel>> getPost(int postID);
  Future<Result<void>> addPost(AdModel post);
  Future<Result<AdModel>> searchForPost(String title);
  Future<Result<void>> saveUserData(UserProfileModel user);
  Future<Result<UserProfileModel>> getUserById(String id);
  Future<Result<List<AdModel>>> getCurrentUserPosts();
}
