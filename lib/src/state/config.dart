import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:minezweeper/src/model/board_data.dart';
import 'package:minezweeper/src/model/config.dart';

/// Notifies the UI when settings change, and persists them.
class AppConfigState extends ChangeNotifier {
  /// Creates state around an already loaded [config].
  AppConfigState(this.config);

  /// The settings object.
  final AppConfig config;

  /// Sets whether a tap opens a cell.
  void changeExploreOnTap(bool value) {
    config.exploreOnTap = value;
    _save();
  }

  /// Sets the board size and clamps the mine count.
  void changeBoardData(BoardData value) {
    value.fixMinesCount();
    config.boardData = value;
    _save();
  }

  /// Sets the theme mode.
  void changeThemeMode(ThemeMode value) {
    config.themeMode = value;
    _save();
  }

  void _save() {
    if (config.dirty) {
      unawaited(config.save());
      notifyListeners();
    }
  }
}
