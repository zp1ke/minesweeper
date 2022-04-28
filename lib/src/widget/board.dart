import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/src/event/handler.dart';
import 'package:minesweeper/src/event/listener.dart';
import 'package:minesweeper/src/exception/game_over.dart';
import 'package:minesweeper/src/extension/datetime.dart';
import 'package:minesweeper/src/model/board.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/cell.dart';
import 'package:minesweeper/src/model/config.dart';
import 'package:minesweeper/src/model/game_event.dart';

class BoardWidget extends StatefulWidget {
  final BoardData boardData;
  final EventHandler eventHandler;

  const BoardWidget({
    Key? key,
    required this.boardData,
    required this.eventHandler,
  }) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> implements EventListener {
  final _cellMargin = 0.4;

  late Board _board;
  Timer? _timer;

  var _secondsStartedMs = 0;
  var _secondsElapsed = 0;

  bool? _winner;
  String? _message;

  @override
  void initState() {
    super.initState();
    _board = Board(boardData: widget.boardData)
      ..setMines(widget.boardData.minesCount);
    widget.eventHandler.addListener(this);
    Future.delayed(Duration.zero, _clearTimer);
  }

  void _clearTimer() {
    _timer?.cancel();
    _secondsStartedMs = DateTime.now().millisecondsSinceEpoch;
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed =
          (DateTime.now().millisecondsSinceEpoch - _secondsStartedMs) / 1000;
      setState(() {
        _secondsElapsed = elapsed.toInt();
      });
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _header(),
            if (_message != null) _messageLabel(),
            ..._rows(context, width: constraints.maxWidth),
          ],
        ),
      );

  Widget _header() => Padding(
        padding: const EdgeInsets.all(10.0), //todo: apptheme
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            const Icon(
              Icons.schedule_sharp,
              size: 14.0,
            ), //todo: apptheme
            Text(' ${_secondsElapsed.secondsFormatted()}'),
            const Spacer(),
            const Icon(
              Icons.ac_unit_sharp,
              size: 14.0,
            ), //todo: apptheme
            Text(' ${_board.minesLeft}'),
            const Spacer(),
          ],
        ),
      );

  Widget _messageLabel() => Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        color: (_winner ?? false) ? Colors.green : Colors.red, //todo: apptheme
        child: Center(
          child: Text(
            _message!,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

  List<Widget> _rows(BuildContext context, {required double width}) {
    final rows = <Widget>[];
    for (var rowIndex = 0; rowIndex < _board.rowsSize; rowIndex++) {
      rows.add(_row(context, rowIndex, width));
    }
    return rows;
  }

  Widget _row(BuildContext context, int rowIndex, double width) {
    final cells = <Widget>[];
    final cellSize =
        width / _board.rowsSize - (_cellMargin * _board.rowsSize + _cellMargin);
    for (var columnIndex = 0; columnIndex < _board.columnsSize; columnIndex++) {
      final cell = _board.cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
      cells.add(cell != null ? _cell(context, cell, cellSize) : Container());
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _cellMargin * 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: cells,
      ),
    );
  }

  Widget _cell(BuildContext context, Cell cell, double size) => InkWell(
        child: Container(
          width: size,
          height: size,
          margin: EdgeInsets.symmetric(horizontal: _cellMargin),
          decoration: BoxDecoration(
            color: _cellColor(cell),
            borderRadius: BorderRadius.all(
              Radius.circular(_cellMargin * 4),
            ),
          ),
          child: Center(
            child: _cellContent(context, cell),
          ),
        ),
        onTap: _board.isActive
            ? () => _onCellTap(cell, !AppConfig().exploreOnTap)
            : null,
        onLongPress: _board.isActive
            ? () => _onCellTap(cell, AppConfig().exploreOnTap)
            : null,
      );

  void _onCellTap(Cell cell, bool toggle) {
    if (toggle) {
      _toggleClear(cell);
    } else {
      _explore(cell);
    }
  }

  Color _cellColor(Cell cell) {
    if (cell.explored) {
      if (cell.mined) {
        return Colors.deepOrange; // todo: apptheme
      }
      return Colors.grey; // todo: apptheme
    }
    if (cell.cleared) {
      return Colors.lightBlue; // todo: apptheme
    }
    return Colors.blueGrey; // todo: apptheme
  }

  Widget? _cellContent(BuildContext context, Cell cell) {
    if (cell.explored) {
      if (cell.mined) {
        return const Text('X');
      }
      if (cell.minesAround > 0) {
        var textColor = Colors.blue; //todo: theme
        if (cell.minesAround == 2) {
          textColor = Colors.yellow; //todo: theme
        } else if (cell.minesAround == 3) {
          textColor = Colors.orange; //todo: theme
        } else if (cell.minesAround == 4) {
          textColor = Colors.deepPurple; //todo: theme
        }
        return Text(
          '${cell.minesAround}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        );
      }
    }
    if (cell.cleared) {
      return const Text('*');
    }
    return null;
  }

  void _explore(Cell cell) {
    try {
      _board.explore(cell);
    } on GameOverEvent catch (e) {
      _onEvent(e);
    }
    setState(() {});
  }

  void _toggleClear(Cell cell) {
    try {
      _board.toggleClear(cell);
    } on GameOverEvent catch (e) {
      _onEvent(e);
    }
    setState(() {});
  }

  void _onEvent(GameOverEvent event) {
    _timer?.cancel();
    _timer = null;
    _winner = event.winner;
    if (event.winner) {
      _message = 'You win!'; // todo: l10n
    } else {
      _message = event.event.name; // todo: l10n
    }
    setState(() {});
  }

  @override
  void onEvent(GameEvent event, Object data) {
    if (event == GameEvent.boardReload && data is BoardData) {
      setState(() {
        _board.setMines(data.minesCount);
        _winner = null;
        _message = null;
        _clearTimer();
      });
    }
  }

  @override
  void dispose() {
    widget.eventHandler.removeListener(this);
    _timer?.cancel();
    super.dispose();
  }
}
