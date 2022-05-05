import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minesweeper/src/model/config.dart';

extension AppColorScheme on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0x2F13ec45);

  Color get onSuccess =>
      brightness == Brightness.light ? Colors.white : Colors.white54;

  Color get warning => brightness == Brightness.light
      ? const Color(0xffce5b2d)
      : const Color(0x2FD3693C);

  Color get onWarning =>
      brightness == Brightness.light ? Colors.white : Colors.white54;
}

String? _fontFamily() => GoogleFonts.varelaRound().fontFamily;

ThemeData lightTheme(AppConfig config) => FlexThemeData.light(
      scheme: config.flexScheme,
      fontFamily: _fontFamily(),
      visualDensity: VisualDensity.standard,
    );

ThemeData darkTheme(AppConfig config) => FlexThemeData.dark(
      scheme: config.flexScheme,
      fontFamily: _fontFamily(),
      visualDensity: VisualDensity.standard,
    );
