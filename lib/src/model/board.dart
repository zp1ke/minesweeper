import 'dart:math';

import 'package:minesweeper/src/exception/game_over.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/cell.dart';
import 'package:minesweeper/src/model/game_event.dart';

class Board {
  final int rowsSize;
  final int columnsSize;
  final List<List<Cell>> _cells;

  var _active = false;
  var _minesCount = 0;
  var _minesCleared = 0;
  var _safeCellsCleared = 0;
  var _unexploredCount = 0;

  int get minesLeft => _minesCount - _minesCleared;

  Board({required BoardData boardData})
      : rowsSize = boardData.rowsSize,
        columnsSize = boardData.columnsSize,
        _cells = [] {
    for (var rowIndex = 0; rowIndex < rowsSize; rowIndex++) {
      var row = <Cell>[];
      for (var columnIndex = 0; columnIndex < columnsSize; columnIndex++) {
        row.add(Cell(rowIndex: rowIndex, columnIndex: columnIndex));
      }
      _cells.add(row);
    }
  }

  void setMines(int minesCount) {
    _clear();
    _active = true;
    _minesCount = minesCount;
    final random = Random();
    for (var mineIndex = 0; mineIndex < minesCount; mineIndex++) {
      Cell? cell;
      do {
        final rowIndex = random.nextInt(rowsSize);
        final columnIndex = random.nextInt(columnsSize);
        cell = cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
      } while (cell == null || cell.mined);
      cell.mined = true;
      final cellsAround = _cellsAround(cell);
      for (var cellAround in cellsAround) {
        cellAround.minesAround++;
      }
    }
  }

  bool get isActive => _active;

  Cell? cellAt({required int rowIndex, required int columnIndex}) {
    if (rowIndex >= 0 &&
        rowIndex < rowsSize &&
        columnIndex >= 0 &&
        columnIndex < columnsSize) {
      return _cells[rowIndex][columnIndex];
    }
    return null;
  }

  void _clear() {
    _active = false;
    _minesCount = 0;
    _minesCleared = 0;
    _safeCellsCleared = 0;
    _unexploredCount = rowsSize * columnsSize;
    for (var rowIndex = 0; rowIndex < rowsSize; rowIndex++) {
      for (var columnIndex = 0; columnIndex < columnsSize; columnIndex++) {
        _cells[rowIndex][columnIndex].clear();
      }
    }
  }

  List<Cell> _cellsAround(Cell cell) {
    final cellsAround = <Cell>[];
    for (var rowIndex = cell.rowIndex - 1;
        rowIndex < cell.rowIndex + 2;
        rowIndex++) {
      for (var columnIndex = cell.columnIndex - 1;
          columnIndex < cell.columnIndex + 2;
          columnIndex++) {
        final cellAround = cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
        if (cellAround != null && cellAround != cell) {
          cellsAround.add(cellAround);
        }
      }
    }
    return cellsAround;
  }

  bool get _hasMinesCleared =>
      _minesCount == _minesCleared || _unexploredCount <= _minesCount;

  bool get _hasNotSafeCellsCleared => _safeCellsCleared == 0;

  void toggleClear(Cell cell) {
    final step = cell.cleared ? -1 : 1;
    cell.cleared = !cell.cleared;
    if (cell.mined) {
      _minesCleared += step;
    } else {
      _safeCellsCleared += step;
    }
    _checkWin();
  }

  void explore(Cell cell) => _explore(cell, checkWin: true);

  void _explore(Cell cell, {bool checkWin = false}) {
    if (!cell.explored) {
      cell.explored = true;
      _unexploredCount--;

      if (cell.mined && !cell.cleared) {
        _active = false;
        throw GameOverEvent(event: GameEvent.mineStepped);
      }
      if (cell.minesAround == 0) {
        final cellsAround = _cellsAround(cell);
        for (var cellAround in cellsAround) {
          _explore(cellAround);
        }
      }
      if (checkWin) {
        _checkWin();
      }
    }
  }

  void _checkWin() {
    if (_hasMinesCleared && _hasNotSafeCellsCleared) {
      _active = false;
      throw GameOverEvent(event: GameEvent.minesCleared);
    }
  }
}
