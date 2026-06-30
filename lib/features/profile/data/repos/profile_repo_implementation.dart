import 'package:skillbridge/core/errors/app_exception.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';
import 'package:skillbridge/features/profile/data/repos/profile_repo.dart';

class ProfileRepoImplementation extends ProfileRepo {
  @override
  Future<Result<UserProfileModel>> getUserProfile() async {
    try {
      final authUser = getIt<AuthService>().currentUser;
      if (authUser == null) {
        return const Failure(
          AppException(
            code: 'unauthenticated',
            message: 'No signed-in user found.',
          ),
        );
      }

      final profileResult = await getIt<StoreService>().getUserById(
        authUser.uid,
      );
      switch (profileResult) {
        case Success(:final data):
          return Success(data);
        case Failure():
          return Success(UserProfileModel.fromAuthUser(authUser));
      }
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

  @override
  Future<Result<UserProfileModel>> updateUserProfile(
    UserProfileModel profile,
  ) async {
    try {
      final result = await getIt<StoreService>().saveUserData(profile);
      switch (result) {
        case Success():
          return Success(profile);
        case Failure(:final exception):
          return Failure(exception);
      }
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await getIt<AuthService>().signOut();
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
