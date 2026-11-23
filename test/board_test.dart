import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:minezweeper/src/exception/game_over.dart';
import 'package:minezweeper/src/model/board.dart';
import 'package:minezweeper/src/model/board_data.dart';
import 'package:minezweeper/src/model/cell.dart';
import 'package:minezweeper/src/model/game_event.dart';

Board boardWith({
  int rows = 3,
  int columns = 3,
  List<({int row, int column})> mines = const [],
}) {
  final data = BoardData()
    ..rowsSize = rows
    ..columnsSize = columns
    ..minesCount = mines.length;
  return Board(boardData: data)..setMines(mines.length, mines: mines);
}

int mineCount(Board board) {
  var count = 0;
  for (var row = 0; row < board.rowsSize; row++) {
    for (var column = 0; column < board.columnsSize; column++) {
      if (board.cellAt(rowIndex: row, columnIndex: column)!.mined) {
        count++;
      }
    }
  }
  return count;
}

void expectNeighborCounts(Board board) {
  for (var row = 0; row < board.rowsSize; row++) {
    for (var column = 0; column < board.columnsSize; column++) {
      final cell = board.cellAt(rowIndex: row, columnIndex: column)!;
      var around = 0;
      for (var dr = -1; dr <= 1; dr++) {
        for (var dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) {
            continue;
          }
          final neighbor = board.cellAt(
            rowIndex: row + dr,
            columnIndex: column + dc,
          );
          if (neighbor != null && neighbor.mined) {
            around++;
          }
        }
      }
      expect(cell.minesAround, around, reason: '($row,$column)');
    }
  }
}

void main() {
  test('setMines plants the requested count and neighbor totals', () {
    final data = BoardData()
      ..rowsSize = 9
      ..columnsSize = 9;
    final board = Board(boardData: data)..setMines(10, random: Random(1));

    expect(mineCount(board), 10);
    expect(board.minesLeft, 10);
    expect(board.isActive, isTrue);
    expectNeighborCounts(board);

    final again = Board(boardData: data)..setMines(10, random: Random(1));
    expect(
      board.cellAt(rowIndex: 0, columnIndex: 0)!.mined,
      again.cellAt(rowIndex: 0, columnIndex: 0)!.mined,
    );
  });

  test('setMines rejects a mine on every cell', () {
    final board = Board(
      boardData: BoardData()
        ..rowsSize = 2
        ..columnsSize = 2,
    );
    expect(() => board.setMines(4), throwsArgumentError);
    expect(() => board.setMines(-1), throwsArgumentError);
  });

  test('a corner mine increments only its neighbors', () {
    final board = boardWith(mines: [(row: 0, column: 0)]);

    expect(board.cellAt(rowIndex: 0, columnIndex: 1)!.minesAround, 1);
    expect(board.cellAt(rowIndex: 1, columnIndex: 0)!.minesAround, 1);
    expect(board.cellAt(rowIndex: 1, columnIndex: 1)!.minesAround, 1);
    expect(board.cellAt(rowIndex: 2, columnIndex: 2)!.minesAround, 0);
    expect(board.cellAt(rowIndex: -1, columnIndex: 0), isNull);
  });

  test('flood fill opens the empty region and stops on numbers', () {
    final board = boardWith(mines: [(row: 0, column: 0)]);

    expect(
      () => board.explore(board.cellAt(rowIndex: 2, columnIndex: 2)!),
      throwsA(isA<GameOverEvent>()),
    );

    expect(board.cellAt(rowIndex: 2, columnIndex: 2)!.explored, isTrue);
    expect(board.cellAt(rowIndex: 0, columnIndex: 1)!.explored, isTrue);
    expect(board.cellAt(rowIndex: 0, columnIndex: 0)!.explored, isFalse);
    expect(board.isActive, isFalse);
  });

  test('flood fill does not open a flagged cell', () {
    final board = boardWith(mines: [(row: 0, column: 0)]);
    final flagged = board.cellAt(rowIndex: 2, columnIndex: 2)!;
    board.toggleClear(flagged);

    board.explore(board.cellAt(rowIndex: 0, columnIndex: 2)!);

    expect(flagged.cleared, isTrue);
    expect(flagged.explored, isFalse);
    expect(board.isActive, isTrue);
  });

  test('opening a mine loses and opening every safe cell wins', () {
    final lost = boardWith(mines: [(row: 0, column: 0)]);
    expect(
      () => lost.explore(lost.cellAt(rowIndex: 0, columnIndex: 0)!),
      throwsA(
        isA<GameOverEvent>()
            .having((event) => event.winner, 'winner', isFalse)
            .having((event) => event.event, 'event', GameEvent.mineStepped),
      ),
    );
    expect(lost.isActive, isFalse);

    final won = boardWith(mines: [(row: 0, column: 0)]);
    expect(
      () => won.explore(won.cellAt(rowIndex: 2, columnIndex: 2)!),
      throwsA(
        isA<GameOverEvent>().having((event) => event.winner, 'winner', isTrue),
      ),
    );
  });

  test('flagging every mine wins, a wrong flag does not', () {
    final board = boardWith(mines: [(row: 1, column: 1)]);
    final safe = board.cellAt(rowIndex: 0, columnIndex: 0)!;
    final mine = board.cellAt(rowIndex: 1, columnIndex: 1)!;
    board
      ..toggleClear(safe)
      ..toggleClear(mine);
    expect(board.isActive, isTrue);

    expect(() => board.toggleClear(safe), throwsA(isA<GameOverEvent>()));
    expect(board.minesLeft, 0);
    expect(board.isActive, isFalse);
  });

  test('a direct tap can still open a flagged mine', () {
    final board = boardWith(mines: [(row: 0, column: 0), (row: 0, column: 1)]);
    final mine = board.cellAt(rowIndex: 0, columnIndex: 0)!;
    board.toggleClear(mine);

    expect(() => board.explore(mine), returnsNormally);
    expect(mine.explored, isTrue);
    expect(board.isActive, isTrue);
  });

  test('flagging an opened cell does not change it', () {
    final board = boardWith(mines: [(row: 0, column: 0)]);
    final cell = board.cellAt(rowIndex: 2, columnIndex: 2)!;
    expect(() => board.explore(cell), throwsA(isA<GameOverEvent>()));

    board.toggleClear(cell);

    expect(cell.explored, isTrue);
    expect(cell.cleared, isFalse);
    expect(board.isActive, isFalse);
  });

  test('cell clear resets planted state', () {
    final cell = Cell(rowIndex: 1, columnIndex: 2)
      ..mined = true
      ..cleared = true
      ..explored = true
      ..minesAround = 3
      ..clear();

    expect(cell.mined, isFalse);
    expect(cell.cleared, isFalse);
    expect(cell.explored, isFalse);
    expect(cell.minesAround, 0);
  });
}
