import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../service/auth.dart';

class UserState extends ChangeNotifier {
  User? user;
  bool processing = false;

  UserState() {
    user = AuthService().user;
  }

  Future<User?> googleSignIn() async {
    if (!processing) {
      processing = true;
      notifyListeners();
      try {
        user = await AuthService().googleSignIn();
      } catch (error, stack) {
        FirebaseCrashlytics.instance.recordError(
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
