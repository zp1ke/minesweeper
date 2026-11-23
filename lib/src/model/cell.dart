/// One square on the board.
class Cell {
  /// Creates a hidden cell at [rowIndex], [columnIndex].
  Cell({required this.rowIndex, required this.columnIndex});

  /// Row, starting at 0.
  final int rowIndex;

  /// Column, starting at 0.
  final int columnIndex;

  /// Whether this cell hides a mine.
  bool mined = false;

  /// Whether the player has flagged this cell.
  bool cleared = false;

  /// Whether the player has opened this cell.
  bool explored = false;

  /// Mines in the eight neighboring cells.
  int minesAround = 0;

  /// Resets the cell for a new game.
  void clear() {
    mined = false;
    cleared = false;
    explored = false;
    minesAround = 0;
  }
}
