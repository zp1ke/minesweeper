import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:material_ui/material_ui.dart';
import 'package:minezweeper/src/service/auth.dart';

/// Signed-in user, and whether a sign-in call is in flight.
class UserState extends ChangeNotifier {
  /// Reads the current Firebase user, if Firebase is ready.
  UserState() {
    user = AuthService().user;
  }

  /// Signed-in Firebase user, if any.
  User? user;

  /// Whether sign-in or sign-out is running.
  bool processing = false;

  /// Starts Google sign-in and records failures in Crashlytics.
  Future<User?> googleSignIn() async {
    if (!processing) {
      processing = true;
      notifyListeners();
      try {
        user = await AuthService().googleSignIn();
      } on Object catch (error, stack) {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          reason: 'googleSignIn',
          printDetails: true,
        );
      } finally {
        processing = false;
        notifyListeners();
      }
    }
    return user;
  }

  /// Signs out and clears [user].
  Future<void> signOut() async {
    if (!processing) {
      processing = true;
      notifyListeners();
      await AuthService().signOut();
      user = null;
      processing = false;
      notifyListeners();
    }
  }
}
