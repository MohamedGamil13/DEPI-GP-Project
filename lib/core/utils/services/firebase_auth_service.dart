import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillbridge/core/errors/auth_errors.dart';
import 'package:skillbridge/core/models/auth_user_model.dart';
import 'package:skillbridge/core/utils/services/firebase_auth_service_repo.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(this._auth);

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

      return _mapUser(credential.user!);
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
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw const UnauthenticatedException();
    }

    try {
      await user.sendEmailVerification();
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

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw const UnauthenticatedException();
    }

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  AuthUser _mapUser(User user) => AuthUser(
    uid: user.uid,
    email: user.email,
    isEmailVerified: user.emailVerified,
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );

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
