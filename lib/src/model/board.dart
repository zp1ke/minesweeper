import 'dart:math';

import 'package:minezweeper/src/exception/game_over.dart';
import 'package:minezweeper/src/model/board_data.dart';
import 'package:minezweeper/src/model/cell.dart';
import 'package:minezweeper/src/model/game_event.dart';

/// Minefield rules: placement, flood fill, flags, win, and loss.
class Board {
  /// Builds an empty grid from [boardData].
  Board({required BoardData boardData})
    : rowsSize = boardData.rowsSize,
      columnsSize = boardData.columnsSize,
      _cells = [] {
    for (var rowIndex = 0; rowIndex < rowsSize; rowIndex++) {
      final row = <Cell>[];
      for (var columnIndex = 0; columnIndex < columnsSize; columnIndex++) {
        row.add(Cell(rowIndex: rowIndex, columnIndex: columnIndex));
      }
      _cells.add(row);
    }
  }

  /// Number of rows.
  final int rowsSize;

  /// Number of columns.
  final int columnsSize;
  final List<List<Cell>> _cells;

  var _active = false;
  var _minesCount = 0;
  var _minesCleared = 0;
  var _safeCellsCleared = 0;
  var _unexploredCount = 0;

  /// Mines that have not been flagged.
  int get minesLeft => _minesCount - _minesCleared;

  /// Plants [minesCount] mines, or the cells in [mines] when that list is set.
  ///
  /// [random] is injectable so tests can reproduce a layout. [mines] is the
  /// same hook for an exact layout. Requesting more mines than cells throws.
  void setMines(
    int minesCount, {
    Random? random,
    List<({int row, int column})>? mines,
  }) {
    _clear();
    _active = true;
    if (mines != null) {
      _minesCount = mines.length;
      for (final mine in mines) {
        final cell = cellAt(rowIndex: mine.row, columnIndex: mine.column);
        if (cell == null || cell.mined) {
          throw ArgumentError('Invalid mine at ${mine.row},${mine.column}');
        }
        _plant(cell);
      }
      return;
    }
    final cellCount = rowsSize * columnsSize;
    if (minesCount < 0 || minesCount >= cellCount) {
      throw ArgumentError(
        'minesCount must be in 0..${cellCount - 1}, was $minesCount',
      );
    }
    _minesCount = minesCount;
    final rng = random ?? Random();
    for (var mineIndex = 0; mineIndex < minesCount; mineIndex++) {
      Cell? cell;
      do {
        final rowIndex = rng.nextInt(rowsSize);
        final columnIndex = rng.nextInt(columnsSize);
        cell = cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
      } while (cell == null || cell.mined);
      _plant(cell);
    }
  }

  void _plant(Cell cell) {
    cell.mined = true;
    for (final cellAround in _cellsAround(cell)) {
      cellAround.minesAround++;
    }
  }

  /// Whether the player can still open or flag cells.
  bool get isActive => _active;

  /// The cell at the index, or null when it is off the board.
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
    for (
      var rowIndex = cell.rowIndex - 1;
      rowIndex < cell.rowIndex + 2;
      rowIndex++
    ) {
      for (
        var columnIndex = cell.columnIndex - 1;
        columnIndex < cell.columnIndex + 2;
        columnIndex++
      ) {
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

  /// Flags or unflags [cell]. Flagging every mine wins.
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

  /// Opens [cell] and flood-fills empty regions. A mine loses.
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
        for (final cellAround in cellsAround) {
          // A flag blocks flood fill. A direct tap can still open that cell.
          if (!cellAround.cleared) {
            _explore(cellAround);
          }
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
