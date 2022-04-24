import 'package:flutter/material.dart';
import 'package:minesweeper/src/screen/board.dart';
import 'package:minesweeper/src/widget/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppState(
        child: MaterialApp(
          title: 'MineSweeper',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const BoardScreen(),
        ),
      );
}
