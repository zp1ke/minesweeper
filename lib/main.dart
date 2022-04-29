import 'package:flutter/material.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/screen/board.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        onGenerateTitle: (BuildContext context) => L10n.of(context).appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BoardScreen(),
      );
}
