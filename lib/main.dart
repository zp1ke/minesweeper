import 'package:flutter/material.dart';
import 'package:minesweeper/src/screen/board.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MineSweeper', // todo: l10n
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BoardScreen(),
      );
}
