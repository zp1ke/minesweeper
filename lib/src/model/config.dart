import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/board_data.dart';

class AppConfig {
  var exploreOnTap = true;
  var boardData = BoardData();
  var themeMode = ThemeMode.dark;
  var flexScheme = FlexScheme.rosewood;

  AppConfig._();

  void load() {
    // todo: from local storage
  }

  static final AppConfig _instance = AppConfig._();

  factory AppConfig() => _instance;
}
