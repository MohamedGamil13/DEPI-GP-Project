import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:skillbridge/core/errors/auth_exception.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/location/location_service.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final StoreService service;
  final LocationService locationService;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );

  FirebaseAuthService(
    this._auth, {
    required this.service,
    required this.locationService,
  });

  @override
  Stream<AuthUser?> get authStateChanges => _auth.authStateChanges().map(
    (user) => user == null ? null : _mapUser(user),
  );

  @override
  AuthUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _mapUser(user);
  }

  @override
  Future<AuthUser> register(String email, String password, {String bio = ''}) async {
    String? emailError = AppValidator.validateEmail(email);

    if (emailError != null) {
      _logger.w("⚠️ Validation Failed: Invalid Email Format ($email)");
      throw const InvalidEmailException();
    }

    _logger.i(
      "===============  AUTH REQUEST ===============\n"
      "ACTION: Register (Email & Password)\n"
      "EMAIL: ${email.trim()}",
    );

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.sendEmailVerification();
      AuthUser tempUser = _mapUser(credential.user!);
      final locationFields = await _locationFields();
      await service.saveUserData(
        UserProfileModel.fromAuthUser(tempUser).copyWith(
          bio: bio.trim(),
          city: locationFields['city'] as String?,
          governorate: locationFields['governorate'] as String?,
          country: locationFields['country'] as String?,
          latitude: locationFields['latitude'] as double?,
          longitude: locationFields['longitude'] as double?,
        ),
      );

      _logger.i(
        "===============  AUTH RESPONSE ===============\n"
        "STATUS: Register Success \n"
        "USER ID: ${tempUser.uid}\n"
        "EMAIL: ${tempUser.email}",
      );

      return tempUser;
    } on FirebaseAuthException catch (e) {
      _logAuthError("Register Failed", e);
      throw _mapException(e);
    }
  }

  @override
  Future<AuthUser> signIn(String email, String password) async {
    _validateInputs(email, password);

    _logger.i(
      "===============  AUTH REQUEST ===============\n"
      "ACTION: Sign In (Email & Password)\n"
      "EMAIL: ${email.trim()}",
    );

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      if (!user.emailVerified) {
        _logger.w(" Sign In Blocked: Email not verified for ${user.email}");
        await _auth.signOut();
        throw const UnverifiedEmailException();
      }

      final authUser = _mapUser(user);

      _logger.i(
        "===============  AUTH RESPONSE ===============\n"
        "STATUS: Sign In Success \n"
        "USER ID: ${authUser.uid}\n"
        "EMAIL: ${authUser.email}",
      );

      return authUser;
    } on FirebaseAuthException catch (e) {
      _logAuthError("Sign In Failed", e);
      throw _mapException(e);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    _logger.i(
      "===============  AUTH REQUEST ===============\n"
      "ACTION: Google Sign In Initiated",
    );

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _logger.w(" Google Sign In Cancelled by user.");
        throw const UnknownAuthException(
          code: 'sign-in-cancelled',
          message: 'Sign in was cancelled by the user.',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        _logger.e(
          " Google Sign In Error: Firebase User is null after credential sign in.",
        );
        throw const UnknownAuthException(
          code: 'user-not-found',
          message: 'Failed to retrieve user information from Firebase.',
        );
      }

      final authUser = _mapUser(user);
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        _logger.i(" New Google User Detected! Saving profile to Firestore...");
        final locationFields = await _locationFields();
        await service.saveUserData(
          UserProfileModel.fromAuthUser(authUser).copyWith(
            city: locationFields['city'] as String?,
            governorate: locationFields['governorate'] as String?,
            country: locationFields['country'] as String?,
            latitude: locationFields['latitude'] as double?,
            longitude: locationFields['longitude'] as double?,
          ),
        );
      }

      _logger.i(
        "===============  AUTH RESPONSE ===============\n"
        "STATUS: Google Sign In Success \n"
        "USER ID: ${authUser.uid}\n"
        "EMAIL: ${authUser.email}\n"
        "IS NEW USER: $isNewUser",
      );

      return authUser;
    } on FirebaseAuthException catch (e) {
      _logAuthError("Google Sign In Failed", e);
      throw _mapException(e);
    } catch (e) {
      if (e is AuthException) rethrow;

      _logger.e(
        "=============== UNKNOWN AUTH ERROR ===============\n"
        "ACTION: Google Sign In Unexpected Crash\n"
        "ERROR: $e",
      );

      throw UnknownAuthException(
        code: 'google-sign-in-error',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    _logger.i(
      "===============  AUTH REQUEST ===============\n"
      "ACTION: Sign Out Called",
    );
    try {
      final user = _auth.currentUser;
      final token = await FirebaseMessaging.instance.getToken();
      if (user != null && token != null) {
        await service.updateUserToken(
          userId: user.uid,
          token: token,
          add: false,
        );
      }
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      _logger.i(" Sign Out Success ");
    } on FirebaseAuthException catch (e) {
      _logAuthError("Sign Out Failed", e);
      throw _mapException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      _logger.w(" Password Reset Failed: Email field is empty");
      throw const InvalidEmailException();
    }

    _logger.i(
      "===============  AUTH REQUEST ===============\n"
      "ACTION: Send Password Reset Email\n"
      "EMAIL: ${email.trim()}",
    );

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _logger.i(" Password Reset Email Sent Successfully ");
    } on FirebaseAuthException catch (e) {
      _logAuthError("Password Reset Failed", e);
      throw _mapException(e);
    }
  }

  AuthUser _mapUser(User user) => AuthUser.fromFirebaseUser(user);

  Future<Map<String, dynamic>> _locationFields() async {
    final location = await locationService.getCachedLocation() ??
        await locationService.getCurrentLocation();

    return {
      'city': location?.city ?? '',
      'governorate': location?.governorate ?? '',
      'country': location?.country ?? '',
      'latitude': location?.latitude,
      'longitude': location?.longitude,
    };
  }

  void _validateInputs(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      _logger.w(" Validation Failed: Email or Password field is empty");
      throw const InvalidEmailException();
    }
  }

  void _logAuthError(String action, FirebaseAuthException e) {
    _logger.e(
      "===============  FIREBASE AUTH ERROR ===============\n"
      "ACTION: $action\n"
      "CODE: ${e.code}\n"
      "MESSAGE: ${e.message}",
    );
  }

  AuthException _mapException(FirebaseAuthException e) {
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
