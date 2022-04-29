import 'package:minesweeper/src/model/board_data.dart';

class AppConfig {
  var exploreOnTap = true;
  var boardData = BoardData();

  AppConfig._();

  void load() {
    // todo: from local storage
  }

  static final AppConfig _instance = AppConfig._();

  factory AppConfig() => _instance;
}
