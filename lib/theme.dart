import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/config.dart';

extension AppColorScheme on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0x2228a745);

  Color get onSuccess =>
      brightness == Brightness.light ? Colors.white : Colors.white54;

  Color get warning => brightness == Brightness.light
      ? const Color(0xffce5b2d)
      : const Color(0x22D3693C);

  Color get onWarning =>
      brightness == Brightness.light ? Colors.white : Colors.white54;
}

ThemeData lightTheme(AppConfig config) =>
    FlexThemeData.light(scheme: config.flexScheme);

ThemeData darkTheme(AppConfig config) =>
    FlexThemeData.dark(scheme: config.flexScheme);
