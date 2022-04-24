import 'package:flutter/material.dart';
import 'package:minesweeper/src/event/handler.dart';
import 'package:minesweeper/src/event/listener.dart';
import 'package:minesweeper/src/exception/game_over.dart';
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
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> implements EventListener {
  final _cellMargin = 0.4;

  late Board _board;

  @override
  void initState() {
    super.initState();
    _board = Board(size: widget.boardData.boardSize)
      ..setMines(widget.boardData.minesCount);
    widget.eventHandler.addListener(this);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, contraints) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _header(),
            ..._rows(context, width: contraints.maxWidth),
          ],
        ),
      );

  Widget _header() => Row(
        children: const [
          Text('HEADER'),
        ],
      );

  List<Widget> _rows(BuildContext context, {required double width}) {
    final rows = <Widget>[];
    for (var rowIndex = 0; rowIndex < _board.size; rowIndex++) {
      rows.add(_row(context, rowIndex, width));
    }
    return rows;
  }

  Widget _row(BuildContext context, int rowIndex, double width) {
    final cells = <Widget>[];
    final cellSize =
        width / _board.size - (_cellMargin * _board.size + _cellMargin);
    for (var columnIndex = 0; columnIndex < _board.size; columnIndex++) {
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
            ? () {
                final config = AppConfig.of(context);
                if (config.exploreOnTap) {
                  _explore(cell);
                } else {
                  _toggleClear(cell);
                }
              }
            : null,
        onLongPress: _board.isActive
            ? () {
                final config = AppConfig.of(context);
                if (config.exploreOnTap) {
                  _toggleClear(cell);
                } else {
                  _explore(cell);
                }
              }
            : null,
      );

  Color _cellColor(Cell cell) {
    if (cell.explored) {
      if (cell.mined) {
        return Colors.deepOrange; // todo: apptheme
      }
      return Colors.blueGrey; // todo: apptheme
    }
    if (cell.cleared) {
      return Colors.lightBlue; // todo: apptheme
    }
    return Colors.grey; // todo: apptheme
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
    print('GameOverEvent = ${event.event.name}');
  }

  @override
  void onEvent(GameEvent event, Object data) {
    if (event == GameEvent.boardReload && data is BoardData) {
      setState(() {
        _board.setMines(data.minesCount);
      });
    }
  }

  @override
  void dispose() {
    widget.eventHandler.removeListener(this);
    super.dispose();
  }
}
