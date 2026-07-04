import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:skillbridge/core/errors/auth_exception.dart';
import 'package:skillbridge/core/services/location/location_service.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';

class AuthServiceHelper {
  final LocationService locationService;
  final Logger logger;

  AuthServiceHelper({required this.locationService, required this.logger});

  AuthUser mapUser(User user) => AuthUser.fromFirebaseUser(user);

  Future<Map<String, dynamic>> locationFields() async {
    final location =
        await locationService.getCachedLocation() ??
        await locationService.getCurrentLocation();

    return {
      'city': location?.city ?? '',
      'governorate': location?.governorate ?? '',
      'country': location?.country ?? '',
      'latitude': location?.latitude,
      'longitude': location?.longitude,
    };
  }

  void validateInputs(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      logger.w(" Validation Failed: Email or Password field is empty");
      throw const InvalidEmailException();
    }
  }

  void logAuthError(String action, FirebaseAuthException e) {
    logger.e(
      "===============  FIREBASE AUTH ERROR ===============\n"
      "ACTION: $action\n"
      "CODE: ${e.code}\n"
      "MESSAGE: ${e.message}",
    );
  }

  AuthException mapException(FirebaseAuthException e) {
    return switch (e.code) {
      'weak-password' => const WeakPasswordException(),
      'email-already-in-use' => const EmailAlreadyInUseException(),
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => const UnknownAuthException(
        code: 'invalid-credential',
        message: 'Email or password is incorrect.',
      ),
      'invalid-email' => const InvalidEmailException(),
      'user-disabled' => const UserDisabledException(),
      'too-many-requests' => const TooManyRequestsException(),
      _ => UnknownAuthException(
        code: e.code,
        message: e.message ?? 'Unexpected authentication error.',
      ),
    };
  }
}
