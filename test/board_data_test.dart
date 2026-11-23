import 'package:flutter_test/flutter_test.dart';
import 'package:minezweeper/src/model/board_data.dart';

void main() {
  test('copyWith keeps fields that are not overridden', () {
    final original = BoardData()
      ..rowsSize = 12
      ..columnsSize = 8
      ..minesCount = 15;

    final copied = original.copyWith(rowsSize: 10);

    expect(copied.rowsSize, 10);
    expect(copied.columnsSize, 8);
    expect(copied.minesCount, 15);
    expect(copied.sameAs(original), isFalse);
    expect(original.rowsSize, 12);
  });

  test('fromRaw falls back per field and ignores junk', () {
    final parsed = BoardData.fromRaw({'rowsSize': 6, 'columnsSize': 'nope'});

    expect(parsed.rowsSize, 6);
    expect(parsed.columnsSize, 9);
    expect(parsed.minesCount, 10);
    expect(BoardData.fromRaw(null).sameAs(BoardData()), isTrue);
    expect(BoardData.fromRaw('nope').boardStr, '9x9_10');
  });

  test('clampToPlayable keeps a saved board inside the settings range', () {
    final board = BoardData.fromRaw({
      'rowsSize': 1,
      'columnsSize': 99,
      'minesCount': 0,
    })..clampToPlayable();

    expect(board.rowsSize, BoardData.minSide);
    expect(board.columnsSize, BoardData.maxSide);
    expect(
      board.minesCount,
      inInclusiveRange(board.minMinesCount, board.maxMinesCount),
    );
  });

  test('fixMinesCount clamps to the settings range', () {
    final board = BoardData()
      ..rowsSize = 10
      ..columnsSize = 10
      ..minesCount = 1
      ..fixMinesCount();
    expect(board.minesCount, board.minMinesCount);

    board
      ..minesCount = 99
      ..fixMinesCount();
    expect(board.minesCount, board.maxMinesCount);
    expect(board.boardStr, '10x10_${board.maxMinesCount}');
    expect(board.toMap()['minesCount'], board.maxMinesCount);
  });
}
