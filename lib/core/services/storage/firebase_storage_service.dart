import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:skillbridge/core/errors/storage_exception.dart';
import 'package:skillbridge/core/services/storage/storage_service.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({required FirebaseStorage storage})
    : _storage = storage;

  @override
  Future<Result<List<String>>> uploadImages(
    List<File> images,
    String path,
  ) async {
    List<String> downloadUrls = [];
    try {
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final Reference ref = _storage.ref().child(path).child(fileName);
        final TaskSnapshot snapshot = await ref.putFile(image);
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return Success(downloadUrls);
    } on FirebaseException catch (e) {
      throw _mapException(e);
    } catch (e) {
      throw const UnknownStorageException(
        code: 'unknown-storage',
        message: 'An unexpected error occurred while uploading an image.',
      );
    }
  }

  StorageException _mapException(FirebaseException e) {
    return switch (e.code) {
      'unauthorized' => const StoragePermissionDeniedException(),
      'canceled' => const StorageCanceledException(),
      'quota-exceeded' => const QuotaExceededException(),
      'network-request-failed' ||
      'retry-limit-exceeded' => const ImageUploadNetworkException(),
      _ => UnknownStorageException(
        code: e.code,
        message: e.message ?? 'Unknown storage error occurred.',
      ),
    };
  }
}
