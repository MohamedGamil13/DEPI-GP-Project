import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillbridge/core/errors/app_exception.dart';
import 'package:skillbridge/core/errors/database_exception.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/core/utils/services/firestore/firestore_repo_service.dart';
import 'package:skillbridge/core/utils/services/storage/storage_service.dart';
import 'package:skillbridge/features/post_ad/data/models/post_ad_model.dart';
import 'package:skillbridge/features/post_ad/data/repos/post_ad_repo.dart';

class PostAdRepoImplementation implements PostAdRepo {
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  PostAdRepoImplementation({
    required FirestoreService firestoreService,
    required StorageService storageService,
  })  : _firestoreService = firestoreService,
        _storageService = storageService;

  @override
  Future<Result<void>> publishAd(PostAdModel ad, List<File> images) async {
    try {
      List<String> uploadedImageUrls = [];

      // 1. Upload images if they exist
      if (images.isNotEmpty) {
        uploadedImageUrls = await _storageService.uploadImages(images, 'ads/images');
      }

      // 2. Attach new image URLs to the model
      final updatedAd = ad.copyWith(imagePaths: uploadedImageUrls);

      // 3. Save directly via db to avoid AdModel mismatch
      await _firestoreService.db
          .collection('AdPosts')
          .add(updatedAd.toJson());

      return const Success(null);
    } on AppException catch (e) {
      // Re-throw our custom exception domain
      return Failure(e);
    } on FirebaseException catch (e) {
      return Failure(_mapDatabaseException(e));
    } catch (e) {
      return Failure(
        UnknownDatabaseException(
          code: 'publish-failed',
          message: 'An unexpected error occurred while publishing the ad.',
        ),
      );
    }
  }

  DatabaseException _mapDatabaseException(FirebaseException e) {
    return switch (e.code) {
      'permission-denied' => PermissionDeniedException(),
      'not-found' => DocumentNotFoundException(),
      'already-exists' => DataAlreadyExistsException(),
      'unavailable' ||
      'network-request-failed' => DatabaseNetworkException(),
      _ => UnknownDatabaseException(
          code: e.code,
          message: e.message ?? 'Unknown database error occurred.',
        ),
    };
  }
}
