class Cell {
  final int rowIndex;
  final int columnIndex;

  var mined = false;
  var cleared = false;
  var explored = false;
  var minesAround = 0;

  Cell({required this.rowIndex, required this.columnIndex});

  void clear() {
    mined = false;
    cleared = false;
    explored = false;
    minesAround = 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          runtimeType == other.runtimeType &&
          rowIndex == other.rowIndex &&
          columnIndex == other.columnIndex;

  @override
  int get hashCode => rowIndex.hashCode ^ columnIndex.hashCode;
}
