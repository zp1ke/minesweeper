import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google sign-in backed by Firebase Auth.
class AuthService {
  /// Returns the process-wide auth service.
  factory AuthService() {
    _instance ??= AuthService._();
    return _instance!;
  }
  AuthService._() : _googleSignIn = GoogleSignIn.instance {
    _initialized = _googleSignIn.initialize();
  }

  static AuthService? _instance;

  final GoogleSignIn _googleSignIn;
  late final Future<void> _initialized;

  /// The current Firebase user, if any.
  User? get user => FirebaseAuth.instance.currentUser;

  /// Signs in with Google, or returns the current user.
  Future<User?> googleSignIn() async {
    await _initialized;
    if (!_googleSignIn.supportsAuthenticate()) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }

    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      // accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user;
  }

  /// Signs out of Google and Firebase.
  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    }
  }
}
