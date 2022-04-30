import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/config.dart';

final configProvider =
    ChangeNotifierProvider.autoDispose((ref) => AppConfigState());

class AppConfigState extends ChangeNotifier {
  final config = AppConfig()..load();

  void changeThemeMode(ThemeMode value) {
    config.themeMode = value;
    _save();
  }

  void changeBoardData(BoardData value) {
    value.fixMinesCount();
    config.boardData = value;
    _save();
  }

  void changeExploreOnTap(bool value) {
    config.exploreOnTap = value;
    _save();
  }

  void _save() {
    config.save();
    notifyListeners();
  }
}
