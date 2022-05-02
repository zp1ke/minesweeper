import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/config.dart';

class AppConfigState extends ChangeNotifier {
  final AppConfig config;

  AppConfigState(this.config);

  void changeExploreOnTap(bool value) {
    config.exploreOnTap = value;
    _save();
  }

  void changeBoardData(BoardData value) {
    value.fixMinesCount();
    config.boardData = value;
    _save();
  }

  void changeThemeMode(ThemeMode value) {
    config.themeMode = value;
    _save();
  }

  void _save() {
    if (config.dirty) {
      notifyListeners();
    }
    config.save();
  }
}
