import 'package:flutter_riverpod/legacy.dart';
import 'package:minezweeper/src/model/config.dart';
import 'package:minezweeper/src/state/config.dart';
import 'package:minezweeper/src/state/user.dart';

/// Process-wide Riverpod providers, created once at startup.
class AppProvider {
  /// Returns the provider created by [AppProvider.create].
  factory AppProvider() => _instance!;
  AppProvider._(this.configProvider, this.userProvider);

  /// Settings and theme state.
  final ChangeNotifierProvider<AppConfigState> configProvider;

  /// Signed-in user state.
  final ChangeNotifierProvider<UserState> userProvider;

  static AppProvider? _instance;

  /// Loads saved settings and creates the providers.
  static Future<void> create() async {
    if (_instance == null) {
      final config = AppConfig();
      await config.load();
      final configProvider = ChangeNotifierProvider(
        (_) => AppConfigState(config),
      );
      final userProvider = ChangeNotifierProvider((_) => UserState());
      _instance = AppProvider._(configProvider, userProvider);
    }
  }
}
