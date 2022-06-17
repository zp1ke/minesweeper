import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/service/auth.dart';

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
      user = await AuthService().googleSignIn();
      processing = false;
      notifyListeners();
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
