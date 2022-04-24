import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/config.dart';

class AppState extends InheritedWidget {
  final config = AppConfig();

  AppState({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    config.load();
  }

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppState>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is AppState &&
      runtimeType == oldWidget.runtimeType &&
      config == oldWidget.config;
}
