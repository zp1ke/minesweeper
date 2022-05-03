import 'dart:convert';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _exploreOnTapKey = 'exploreOnTap';
const _boardDataKey = 'boardData';
const _themeModeKey = 'themeMode';
const _flexSchemeKey = 'flexScheme';
const _defaultFlexScheme = FlexScheme.redWine;

class AppConfig {
  SharedPreferences? _prefs;
  var _exploreOnTap = true;
  var _boardData = BoardData();
  var _themeMode = ThemeMode.system;
  var _flexScheme = _defaultFlexScheme;
  var _dirty = false;

  bool get exploreOnTap => _exploreOnTap;

  set exploreOnTap(bool value) {
    _dirty = _dirty || value != _exploreOnTap;
    _exploreOnTap = value;
  }

  BoardData get boardData => _boardData;

  set boardData(BoardData value) {
    _dirty = _dirty || value != _boardData;
    _boardData = value;
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    _dirty = _dirty || value != _themeMode;
    _themeMode = value;
  }

  FlexScheme get flexScheme => _flexScheme;

  set flexScheme(FlexScheme value) {
    _dirty = _dirty || value != _flexScheme;
    _flexScheme = value;
  }

  bool get dirty => _dirty;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return Future.value(_prefs);
  }

  Future<void> load() async {
    final preferences = await _preferences;
    exploreOnTap = preferences.getBool(_exploreOnTapKey) ?? true;
    final boardDataJson = preferences.getString(_boardDataKey) ?? '{}';
    boardData = BoardData.fromRaw(jsonDecode(boardDataJson));
    final themeModeStr =
        preferences.getString(_themeModeKey) ?? ThemeMode.system.name;
    themeMode =
        ThemeMode.values.firstWhere((element) => element.name == themeModeStr);
    final flexSchemeStr =
        preferences.getString(_flexSchemeKey) ?? _defaultFlexScheme.name;
    flexScheme = FlexScheme.values
        .firstWhere((element) => element.name == flexSchemeStr);
  }

  Future<void> save() async {
    final preferences = await _preferences;
    await preferences.setBool(_exploreOnTapKey, _exploreOnTap);
    await preferences.setString(_boardDataKey, jsonEncode(_boardData.toMap()));
    await preferences.setString(_themeModeKey, _themeMode.name);
    await preferences.setString(_flexSchemeKey, _flexScheme.name);
  }
}
