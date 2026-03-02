import 'package:skillbridge/core/errors/auth_errors.dart';

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AuthException exception;
  const Failure(this.exception);
}
