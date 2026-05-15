import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skillbridge/core/errors/auth_exception.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final StoreService service;

  FirebaseAuthService(this._auth, {required this.service});

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
  Future<AuthUser> register(String email, String password) async {
    String? emailError = AppValidator.validateEmail(email);

    if (emailError != null) {
      throw const InvalidEmailException();
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.sendEmailVerification();
      AuthUser tempUser = _mapUser(credential.user!);
      await service.saveUserData(UserProfileModel.fromAuthUser(tempUser));
      return tempUser;
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<AuthUser> signIn(String email, String password) async {
    _validateInputs(email, password);

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;

      if (!user.emailVerified) {
        await _auth.signOut();
        throw const UnverifiedEmailException();
      }
      return _mapUser(user);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
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
        throw const UnknownAuthException(
          code: 'user-not-found',
          message: 'Failed to retrieve user information from Firebase.',
        );
      }

      return _mapUser(user);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    } catch (e) {
      if (e is AuthException) rethrow;

      throw UnknownAuthException(
        code: 'google-sign-in-error',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      throw const InvalidEmailException();
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  AuthUser _mapUser(User user) => AuthUser.fromFirebaseUser(user);

  void _validateInputs(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const InvalidEmailException();
    }
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
  //reviewed