import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/src/model/config.dart';

final configProvider = ChangeNotifierProvider.autoDispose((ref) => AppConfigState());

class AppConfigState extends ChangeNotifier {
  final config = AppConfig()..load();

  void changeThemeMode(ThemeMode mode) {
    config.themeMode = mode;
    config.save();
    notifyListeners();
  }
}
