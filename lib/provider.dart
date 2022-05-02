import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/src/model/config.dart';
import 'package:minesweeper/state.dart';

class AppProvider {
  final ChangeNotifierProvider<AppConfigState> configProvider;

  AppProvider._(this.configProvider);

  factory AppProvider() => _instance!;

  static AppProvider? _instance;

  static Future<void> create() async {
    if (_instance == null) {
      final config = AppConfig();
      await config.load();
      final configProvider =
          ChangeNotifierProvider((_) => AppConfigState(config));
      _instance = AppProvider._(configProvider);
    }
  }
}
