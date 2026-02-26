import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillbridge/core/errors/auth_errors.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  // inject via constructor — don't hardcode instance
  FirebaseAuthService(this._auth);

  User? get currentUser => _auth.currentUser;
  Future<UserCredential> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  AuthException _mapException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AuthException(code: e.code, message: 'Password is too weak.');
      case 'email-already-in-use':
        return AuthException(code: e.code, message: 'Email already in use.');
      case 'user-not-found':
        return AuthException(
          code: e.code,
          message: 'No user found for that email.',
        );
      case 'wrong-password':
        return AuthException(code: e.code, message: 'Incorrect password.');
      case 'invalid-email':
        return AuthException(code: e.code, message: 'Invalid email address.');
      case 'user-disabled':
        return AuthException(
          code: e.code,
          message: 'This account has been disabled.',
        );
      case 'too-many-requests':
        return AuthException(
          code: e.code,
          message: 'Too many attempts. Try again later.',
        );
      default:
        return AuthException(
          code: e.code,
          message: 'An unexpected error occurred.',
        );
    }
  }
}
