import 'package:flutter/material.dart';
import 'package:minesweeper/src/event/handler.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/game_event.dart';
import 'package:minesweeper/src/widget/board.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BoardScreen();
}

class _BoardScreen extends State<BoardScreen> {
  final _data = BoardData()
    ..rowsSize = 9
    ..columnsSize = 9
    ..minesCount = 10;
  final _eventHandler = EventHandler();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).appTitle),
          actions: [
            _reloadAction(),
          ],
        ),
        body: BoardWidget(
          boardData: _data,
          eventHandler: _eventHandler,
        ),
      );

  Widget _reloadAction() => IconButton(
        onPressed: () {
          _eventHandler.trigger(GameEvent.boardReload, _data);
        },
        icon: const Icon(Icons.refresh_sharp),
      );
}
