import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/board_data.dart';

class AppConfig {
  var exploreOnTap = true;
  var boardData = BoardData();
  var themeMode = ThemeMode.system;
  var flexScheme = FlexScheme.hippieBlue;

  void load() {
    // todo: from local storage
  }

  void save() {
    // todo: to local storage
  }
}
