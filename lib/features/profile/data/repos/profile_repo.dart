import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

/// Abstract profile repository — mirrors the AuthRepo pattern in this project.
/// Inject this via getIt; swap the implementation for testing or backend changes.
abstract class ProfileRepo {
  /// Fetches the current user's profile data.
  Future<Result<UserProfileModel>> getUserProfile();

  /// Fetches all posts created by the current user.
  Future<Result<List<AdModel>>> getMyPosts();

  /// Fetches the activity feed for the current user.
  Future<Result<List<AdModel>>> getActivityPosts();
}
