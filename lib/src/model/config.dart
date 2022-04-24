import 'package:flutter/material.dart';
import 'package:minesweeper/src/widget/state.dart';

class AppConfig {
  var exploreOnTap = true;

  static AppConfig of(BuildContext context) => AppState.of(context).config;

  void load() {
    // todo
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfig &&
          runtimeType == other.runtimeType &&
          exploreOnTap == other.exploreOnTap;

  @override
  int get hashCode => exploreOnTap.hashCode;
}
