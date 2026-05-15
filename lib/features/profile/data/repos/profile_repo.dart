import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRepo {
  Future<Result<UserProfileModel>> getUserProfile();

  // Future<Result<List<AdModel>>> getMyPosts();

  // Future<Result<List<AdModel>>> getActivityPosts();
}
