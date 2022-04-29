import 'package:flutter/material.dart';
import 'package:minesweeper/src/event/handler.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/game_event.dart';
import 'package:minesweeper/src/widget/board.dart';

class BoardScreen extends StatelessWidget {
  final _eventHandler = EventHandler();

  BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).appTitle),
          actions: [
            _reloadAction(),
          ],
        ),
        body: BoardWidget(
          eventHandler: _eventHandler,
        ),
      );

  Widget _reloadAction() => IconButton(
        onPressed: () {
          _eventHandler.trigger(GameEvent.boardReload);
        },
        icon: const Icon(Icons.refresh_sharp),
      );
}
