import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skillbridge/core/errors/storage_exception.dart';
import 'package:skillbridge/core/services/cloudinary/storage_service.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

class CloudinaryStorageService implements StorageService {
  final String cloudName;
  final String uploadPreset;
  final Dio _dio;

  CloudinaryStorageService({
    required this.cloudName,
    required this.uploadPreset,
  }) : _dio = Dio();

  @override
  Future<Result<List<String>>> uploadImages(
    List<File> images,
    String path,
  ) async {
    final List<String> downloadUrls = [];

    try {
      for (int i = 0; i < images.length; i++) {
        final String url = await _uploadSingle(images[i], path);
        downloadUrls.add(url);
      }
      return Success(downloadUrls);
    } on StorageException catch (e) {
      return Failure(e);
    } catch (e) {
      return const Failure(
        UnknownStorageException(
          code: 'unknown-storage',
          message: 'An unexpected error occurred while uploading an image.',
        ),
      );
    }
  }

  Future<String> _uploadSingle(File image, String folder) async {
    final formData = FormData.fromMap({
      'upload_preset': uploadPreset,
      'folder': folder, // 'services/images'
      'file': await MultipartFile.fromFile(
        image.path,
        filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    });

    try {
      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return response.data['secure_url'] as String;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  StorageException _mapDioError(DioException e) {
    final errorMessage =
        (e.response?.data?['error'] as Map<String, dynamic>?)?['message']
            as String? ??
        'Cloudinary upload failed';

    return switch (e.response?.statusCode) {
      401 => const StoragePermissionDeniedException(),
      429 => const QuotaExceededException(),
      null => const ImageUploadNetworkException(), // network error / timeout
      _ => UnknownStorageException(
        code: 'cloudinary-${e.response?.statusCode}',
        message: errorMessage,
      ),
    };
  }
}
