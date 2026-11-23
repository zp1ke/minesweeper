import 'dart:convert';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:minezweeper/src/model/board_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _exploreOnTapKey = 'exploreOnTap';
const _boardDataKey = 'boardData';
const _themeModeKey = 'themeMode';
const _flexSchemeKey = 'flexScheme';
const FlexScheme _defaultFlexScheme = FlexScheme.redWine;

/// Settings persisted in shared preferences.
class AppConfig {
  SharedPreferences? _prefs;
  var _exploreOnTap = true;
  var _boardData = BoardData();
  ThemeMode _themeMode = ThemeMode.system;
  FlexScheme _flexScheme = _defaultFlexScheme;
  var _dirty = false;

  /// Whether a tap opens a cell instead of flagging it.
  bool get exploreOnTap => _exploreOnTap;

  /// Whether a tap opens a cell instead of flagging it.
  set exploreOnTap(bool value) {
    _dirty = _dirty || value != _exploreOnTap;
    _exploreOnTap = value;
  }

  /// Current board size and mine count.
  BoardData get boardData => _boardData;

  /// Current board size and mine count.
  set boardData(BoardData value) {
    _dirty = _dirty || !value.sameAs(_boardData);
    _boardData = value;
  }

  /// Light, dark, or system theme.
  ThemeMode get themeMode => _themeMode;

  /// Light, dark, or system theme.
  set themeMode(ThemeMode value) {
    _dirty = _dirty || value != _themeMode;
    _themeMode = value;
  }

  /// FlexColorScheme palette.
  FlexScheme get flexScheme => _flexScheme;

  /// FlexColorScheme palette.
  set flexScheme(FlexScheme value) {
    _dirty = _dirty || value != _flexScheme;
    _flexScheme = value;
  }

  /// Whether a setter changed a value since the last save.
  bool get dirty => _dirty;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Reads saved settings, or keeps the defaults.
  Future<void> load() async {
    final preferences = await _preferences;
    exploreOnTap = preferences.getBool(_exploreOnTapKey) ?? true;
    final boardDataJson = preferences.getString(_boardDataKey) ?? '{}';
    final loaded = BoardData.fromRaw(jsonDecode(boardDataJson))
      ..clampToPlayable();
    boardData = loaded;
    final themeModeStr =
        preferences.getString(_themeModeKey) ?? ThemeMode.system.name;
    themeMode = ThemeMode.values.firstWhere(
      (element) => element.name == themeModeStr,
      orElse: () => ThemeMode.system,
    );
    final flexSchemeStr =
        preferences.getString(_flexSchemeKey) ?? _defaultFlexScheme.name;
    flexScheme = FlexScheme.values.firstWhere(
      (element) => element.name == flexSchemeStr,
      orElse: () => _defaultFlexScheme,
    );
    _dirty = false;
  }

  /// Writes the current settings.
  Future<void> save() async {
    final preferences = await _preferences;
    await preferences.setBool(_exploreOnTapKey, _exploreOnTap);
    await preferences.setString(_boardDataKey, jsonEncode(_boardData.toMap()));
    await preferences.setString(_themeModeKey, _themeMode.name);
    await preferences.setString(_flexSchemeKey, _flexScheme.name);
  }
}
