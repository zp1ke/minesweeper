import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static AuthService? _instance;

  final GoogleSignIn _googleSignIn;

  AuthService._()
      : _googleSignIn = GoogleSignIn(
          scopes: ['email'],
        );

  factory AuthService() {
    _instance ??= AuthService._();
    return _instance!;
  }

  User? get user => FirebaseAuth.instance.currentUser;

  Future<User?> googleSignIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    }
    return null;
  }

  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    }
  }
}
