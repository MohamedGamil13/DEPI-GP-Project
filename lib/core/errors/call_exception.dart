import 'package:skillbridge/core/errors/app_exception.dart';

sealed class CallException extends AppException {
  const CallException({required super.code, required super.message});
}

final class CouldNotLaunchException extends CallException {
  const CouldNotLaunchException()
    : super(
        code: 'could-not-launch',
        message:
            'Could not launch the dialer. Please check your phone settings.',
      );
}

final class InvalidPhoneNumberException extends CallException {
  const InvalidPhoneNumberException()
    : super(
        code: 'invalid-phone-number',
        message: 'The phone number provided is invalid.',
      );
}

final class PermissionDeniedException extends CallException {
  const PermissionDeniedException()
    : super(code: 'permission-denied', message: 'Call permission was denied.');
}

final class UnknownCallException extends CallException {
  const UnknownCallException({required super.code, required super.message});
}
