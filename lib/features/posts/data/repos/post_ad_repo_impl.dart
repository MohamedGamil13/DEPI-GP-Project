import 'dart:io';

import 'package:skillbridge/core/errors/app_exception.dart';
import 'package:skillbridge/core/errors/database_exception.dart';
import 'package:skillbridge/core/errors/storage_exception.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/storage/storage_service.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

class PostAdRepoImplementation implements PostAdRepo {
  final StoreService _firestoreRepo;
  final StorageService _storageService;

  PostAdRepoImplementation({
    required StoreService firestoreRepo,
    required StorageService storageService,
  }) : _firestoreRepo = firestoreRepo,
       _storageService = storageService;

  @override
  Future<Result<void>> publishAd(AdModel ad, List<File> images) async {
    try {
      List<String> uploadedImageUrls = [];

      if (images.isNotEmpty) {
        final Result<List<String>> uploadResult = await _storageService
            .uploadImages(images, 'ads/images');

        if (uploadResult is Failure<List<String>>) {
          return Failure((uploadResult).exception);
        }

        uploadedImageUrls = (uploadResult as Success<List<String>>).data;
      }

      final updatedAd = ad.copyWith(photos: uploadedImageUrls);
      return await _firestoreRepo.addPost(updatedAd);
    } on StorageException catch (e) {
      return Failure(e);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        UnknownDatabaseException(
          code: 'publish-failed',
          message: 'An unexpected error occurred while publishing the ad.',
        ),
      );
    }
  }

  Future<Result<UserProfileModel>> getUserDataById(String id) async {
    return await _firestoreRepo.getUserById(id);
  }
}
