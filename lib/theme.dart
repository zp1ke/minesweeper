import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/config.dart';

ThemeData lightTheme() => FlexThemeData.light(scheme: AppConfig().flexScheme);

ThemeData darkTheme() => FlexThemeData.dark(scheme: AppConfig().flexScheme);
