import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/provider.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/screen/home.dart';
import 'package:minesweeper/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppProvider.create();
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(AppProvider().configProvider);
    return MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      onGenerateTitle: (BuildContext context) => L10n.of(context).appTitle,
      theme: lightTheme(configState.config),
      darkTheme: darkTheme(configState.config),
      themeMode: configState.config.themeMode,
      home: const HomeScreen(),
    );
  }
}
