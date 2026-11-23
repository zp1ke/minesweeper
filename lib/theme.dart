import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import 'package:minezweeper/src/model/config.dart';

/// Icon size in the board header.
const headerIconSize = 14.0;

/// Spinner size on compact loading indicators.
const loadingIndicatorSize = 14.0;

/// Success and warning colors used by the game UI.
extension AppColorScheme on ColorScheme {
  /// Color for a win, a short time, or a submitted score.
  Color get success => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0xFF28a745);

  /// Text color on [success].
  Color get onSuccess =>
      brightness == Brightness.light ? Colors.white54 : Colors.white;

  /// Color for a time that is getting long.
  Color get warning => brightness == Brightness.light
      ? const Color(0x2FD3693C)
      : const Color(0xffce5b2d);

  /// Text color on [warning].
  Color get onWarning =>
      brightness == Brightness.light ? Colors.white54 : Colors.white;
}

String? _fontFamily() => GoogleFonts.varelaRound().fontFamily;

/// Light theme for [config].
ThemeData lightTheme(AppConfig config) => FlexThemeData.light(
  scheme: config.flexScheme,
  fontFamily: _fontFamily(),
  visualDensity: VisualDensity.standard,
);

/// Dark theme for [config].
ThemeData darkTheme(AppConfig config) => FlexThemeData.dark(
  scheme: config.flexScheme,
  fontFamily: _fontFamily(),
  visualDensity: VisualDensity.standard,
);
