import 'dart:io';

import 'package:skillbridge/core/errors/database_exception.dart';
import 'package:skillbridge/core/errors/storage_exception.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/services/cloudinary/cloudinary_service.dart';
import 'package:skillbridge/core/utils/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

class PostService {
  final CloudinaryService cloudinaryService;
  final FirestoreServiceRepo firestoreService;

  PostService({
    required this.cloudinaryService,
    required this.firestoreService,
  });

  Future<Result<void>> createPost({
    required AdModel post,
    required List<File> images,
  }) async {
    try {
      final List<String> imageUrls = [];

      for (final file in images) {
        final result = await cloudinaryService.uploadImage(file);

        if (result is Success<String>) {
          imageUrls.add(result.data);
        } else if (result is Failure<String>) {
          return Failure(result.exception);
        }
      }

      final updatedPost = post.copyWith(images: imageUrls);

      final saveResult = await firestoreService.addPost(updatedPost);

      if (saveResult is Success<void>) {
        return const Success(null);
      } else if (saveResult is Failure<void>) {
        return Failure(saveResult.exception);
      }

      return Failure(
        UnknownDatabaseException(
          code: 'unknown',
          message: 'Unknown error while saving post',
        ),
      );
    } catch (e) {
      return Failure(
        UnknownStorageException(code: 'unknown', message: e.toString()),
      );
    }
  }
}
