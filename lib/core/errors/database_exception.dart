import 'package:skillbridge/core/errors/app_exception.dart';

sealed class DatabaseException extends AppException {
  DatabaseException({required super.code, required super.message});
}

final class DocumentNotFoundException extends DatabaseException {
  DocumentNotFoundException()
    : super(
        code: 'document-not-found',
        message: 'The requested document does not exist.',
      );
}

final class PermissionDeniedException extends DatabaseException {
  PermissionDeniedException()
    : super(
        code: 'permission-denied',
        message: 'You do not have permission to access this data.',
      );
}

final class DataAlreadyExistsException extends DatabaseException {
  DataAlreadyExistsException()
    : super(
        code: 'already-exists',
        message: 'The data you are trying to create already exists.',
      );
}

final class DatabaseNetworkException extends DatabaseException {
  DatabaseNetworkException()
    : super(
        code: 'network-error',
        message: 'Network error occurred while accessing the database.',
      );
}

final class UnknownDatabaseException extends DatabaseException {
  UnknownDatabaseException({required super.code, required super.message});
}
//reviewed 