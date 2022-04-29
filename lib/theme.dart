import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/config.dart';

ThemeData lightTheme(AppConfig config) =>
    FlexThemeData.light(scheme: config.flexScheme);

ThemeData darkTheme(AppConfig config) =>
    FlexThemeData.dark(scheme: config.flexScheme);
