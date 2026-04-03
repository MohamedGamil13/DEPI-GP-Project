import 'package:skillbridge/core/errors/app_exception.dart';

sealed class StorageException extends AppException {
  const StorageException({required super.code, required super.message});
}

final class ImageUploadNetworkException extends StorageException {
  const ImageUploadNetworkException()
    : super(
        code: 'storage-network-error',
        message:
            'Network error occurred while uploading images. Please check your connection.',
      );
}

final class StoragePermissionDeniedException extends StorageException {
  const StoragePermissionDeniedException()
    : super(
        code: 'storage-permission-denied',
        message: 'You do not have permission to upload files.',
      );
}

final class QuotaExceededException extends StorageException {
  const QuotaExceededException()
    : super(
        code: 'storage-quota-exceeded',
        message: 'Storage quota exceeded. Please try again later.',
      );
}

final class StorageCanceledException extends StorageException {
  const StorageCanceledException()
    : super(
        code: 'storage-canceled',
        message: 'The upload was canceled by the user.',
      );
}

final class UnknownStorageException extends StorageException {
  const UnknownStorageException({required super.code, required super.message});
}
//reviewed 