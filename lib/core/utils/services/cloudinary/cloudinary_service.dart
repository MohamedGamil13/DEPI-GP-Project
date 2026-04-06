import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skillbridge/core/errors/app_exception.dart';
import 'package:skillbridge/core/errors/storage_exception.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

class CloudinaryService {
  final Dio dio;

  CloudinaryService({required this.dio});

  Future<Result<String>> uploadImage(File file) async {
    try {
      const url =
          'https://api.cloudinary.com/v1_1/${AppConstants.cloudName}/image/upload';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': AppConstants.uploadPreset,
      });

      final response = await dio.post(url, data: formData);

      final imageUrl = response.data?['secure_url'];
      if (imageUrl is! String) {
        return const Failure(
          ImageUploadNetworkException(),
        ); //UploadFailedException() should be
      }

      return Success(imageUrl);
    } on DioException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return const Failure(
        UnknownStorageException(
          code: 'unknown-error',
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  AppException _mapException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ImageUploadNetworkException();
    }
    return const ImageUploadNetworkException(); //UploadFailedException() should be
  }
}
