import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/model/config.dart';

const headerIconSize = 14.0;
const loadingIndicatorSize = 14.0;

extension AppColorScheme on ColorScheme {
  Color get success => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0xFF28a745);

  Color get onSuccess =>
      brightness == Brightness.light ? Colors.white54 : Colors.white;

  Color get warning => brightness == Brightness.light
      ? const Color(0x2FD3693C)
      : const Color(0xffce5b2d);

  Color get onWarning =>
      brightness == Brightness.light ? Colors.white54 : Colors.white;
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
