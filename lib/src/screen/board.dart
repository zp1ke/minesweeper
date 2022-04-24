import 'package:flutter/material.dart';
import 'package:minesweeper/src/widget/board.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BoardScreen();
}

class _BoardScreen extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('MineSweeper'), //todo: l10n
        ),
        body: BoardWidget(
          boardSize: 9,
          minesCount: 10,
        ),
      );
}
