// core/errors/auth_exception.dart

/// Sealed = exhaustive switch in Dart 3, no unknown subclasses
sealed class AuthException implements Exception {
  final String code;
  final String message;

  const AuthException({required this.code, required this.message});

  @override
  String toString() => '[$code] $message';
}

final class WeakPasswordException extends AuthException {
  const WeakPasswordException()
    : super(code: 'weak-password', message: 'Password is too weak.');
}

final class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
    : super(code: 'email-already-in-use', message: 'Email already in use.');
}

final class UserNotFoundException extends AuthException {
  const UserNotFoundException()
    : super(
        code: 'user-not-found',
        message: 'No account found for that email.',
      );
}

final class WrongPasswordException extends AuthException {
  const WrongPasswordException()
    : super(code: 'wrong-password', message: 'Incorrect password.');
}

final class InvalidEmailException extends AuthException {
  const InvalidEmailException()
    : super(code: 'invalid-email', message: 'Invalid email address.');
}

final class UserDisabledException extends AuthException {
  const UserDisabledException()
    : super(code: 'user-disabled', message: 'This account has been disabled.');
}

final class TooManyRequestsException extends AuthException {
  const TooManyRequestsException()
    : super(
        code: 'too-many-requests',
        message: 'Too many attempts. Try again later.',
      );
}

final class UnverifiedEmailException extends AuthException {
  const UnverifiedEmailException()
    : super(
        code: 'email-not-verified',
        message: 'Please verify your email first.',
      );
}

final class UnauthenticatedException extends AuthException {
  const UnauthenticatedException()
    : super(code: 'unauthenticated', message: 'No signed-in user found.');
}

final class UnknownAuthException extends AuthException {
  const UnknownAuthException({required super.code, required super.message});
}
