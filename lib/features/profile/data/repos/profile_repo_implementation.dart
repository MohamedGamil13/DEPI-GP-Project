import 'package:skillbridge/core/errors/app_exception.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/data/repos/profile_repo.dart';

class ProfileRepoImplementation extends ProfileRepo {
  @override
  Future<Result<UserProfileModel>> getUserProfile() async {
    try {
      return Success(getIt<UserProfileModel>());
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<AdModel>>> getCurrentUserPosts() async {
    try {
      return await getIt<StoreService>().getCurrentUserPosts();
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
