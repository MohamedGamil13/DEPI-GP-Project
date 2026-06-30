import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/data/models/review_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

abstract interface class StoreService {
  Future<Result<List<AdModel>>> getAllPosts();
  Future<Result<List<AdModel>>> getFilteredPosts(AdCategories category);
  Future<Result<AdModel>> getPost(int postID);
  Future<Result<void>> addPost(AdModel post);
  Future<Result<AdModel>> searchForPost(String title);
  Future<Result<void>> saveUserData(UserProfileModel user);
  Future<Result<void>> updateUserToken({
    required String userId,
    required String token,
    required bool add,
  });
  Future<Result<UserProfileModel>> getUserById(String id);
  Future<Result<List<AdModel>>> getCurrentUserPosts();
  Future<Result<List<AdModel>>> getPostsByUserId(String userId);
  Future<Result<List<AdModel>>> getFavoritePosts();
  Future<Result<Set<int>>> getFavoritePostIds();
  Future<Result<void>> addFavorite(int postId);
  Future<Result<void>> removeFavorite(int postId);
  Future<Result<bool>> isFavorite(int postId);
  Future<Result<List<ReviewModel>>> getPostReviews(int postId);
  Stream<List<ReviewModel>> watchPostReviews(int postId);
  Future<Result<ReviewModel>> addReview({
    required int postId,
    required String userId,
    required String userName,
    required String userImage,
    required int rating,
    required String comment,
  });
}
