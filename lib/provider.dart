import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/config.dart';

final configProvider = ChangeNotifierProvider((ref) => AppConfigState());

class AppConfigState extends ChangeNotifier {
  final AppConfig config;

  AppConfigState._(this.config);

  factory AppConfigState() {
    final config = AppConfig();
    final state = AppConfigState._(config);
    state._load();
    return state;
  }

  void _load() async {
    await config.load();
    if (config.dirty) {
      notifyListeners();
    }
  }

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
