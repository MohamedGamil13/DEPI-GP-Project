import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRepo {
  Future<Result<UserProfileModel>> getUserProfile();
  Future<Result<List<AdModel>>> getCurrentUserPosts();
  Future<Result<UserProfileModel>> updateUserProfile(UserProfileModel profile);
  Future<Result<void>> signOut();
}
