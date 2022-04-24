import 'package:flutter/material.dart';
import 'package:minesweeper/src/exception/game_over.dart';
import 'package:minesweeper/src/model/board.dart';
import 'package:minesweeper/src/model/cell.dart';

class BoardWidget extends StatefulWidget {
  final int boardSize;
  final int minesCount;

  const BoardWidget({
    Key? key,
    required this.boardSize,
    required this.minesCount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final _cellMargin = 0.4;

  late Board _board;

  @override
  void initState() {
    super.initState();
    _board = Board(size: widget.boardSize)..setMines(widget.minesCount);
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
        children: [
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

  Widget _cell(BuildContext context, Cell cell, double size) {
    final color = cell.explored ? Colors.blueGrey : Colors.grey; // todo: theme
    Widget? content;
    if (cell.explored) {
      if (cell.mined) {
        content = Text('X');
      } else if (cell.minesAround > 0) {
        var textColor = Colors.blue; //todo: theme
        if (cell.minesAround == 2) {
          textColor = Colors.yellow; //todo: theme
        } else if (cell.minesAround == 3) {
          textColor = Colors.orange; //todo: theme
        } else if (cell.minesAround == 4) {
          textColor = Colors.deepPurple; //todo: theme
        }
        content = Text(
          '${cell.minesAround}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        );
      }
    } else if (cell.cleared) {
      content = Text('*');
    }
    return InkWell(
      child: Container(
        width: size,
        height: size,
        margin: EdgeInsets.symmetric(horizontal: _cellMargin),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(_cellMargin * 4),
          ),
        ),
        child: Center(
          child: content,
        ),
      ),
      onTap: () {
        try {
          _board.explore(cell);
        } on GameOverEvent catch (e) {
          print('GameOverEvent = ${e.event.name}');
        }
        setState(() {});
      },
    );
  }
}
