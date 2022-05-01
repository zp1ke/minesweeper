const _rowsSizeKey = 'rowsSize';
const _defaultRowsSize = 9;
const _columnsSizeKey = 'columnsSize';
const _defaultColumnsSize = 9;
const _minesCountKey = 'minesCount';
const _defaultMinesCount = 10;

class BoardData {
  var rowsSize = _defaultRowsSize;
  var columnsSize = _defaultColumnsSize;
  var minesCount = _defaultMinesCount;

  BoardData();

  BoardData.fromRaw(raw) {
    if (raw is Map) {
      rowsSize = raw[_rowsSizeKey] ?? _defaultRowsSize;
      columnsSize = raw[_columnsSizeKey] ?? _defaultColumnsSize;
      minesCount = raw[_minesCountKey] ?? _defaultMinesCount;
    }
  }

  int get maxMinesCount => (rowsSize * columnsSize * .6).toInt();

  int get minMinesCount => (rowsSize * columnsSize * .1).toInt();

  void fixMinesCount() {
    if (minesCount < minMinesCount) {
      minesCount = minMinesCount;
    }
    if (minesCount > maxMinesCount) {
      minesCount = maxMinesCount;
    }
  }

  Map<String, Object> toMap() => {
    _rowsSizeKey: rowsSize,
    _columnsSizeKey: columnsSize,
    _minesCountKey: minesCount,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardData &&
          runtimeType == other.runtimeType &&
          rowsSize == other.rowsSize &&
          columnsSize == other.columnsSize &&
          minesCount == other.minesCount;

  @override
  int get hashCode =>
      rowsSize.hashCode ^ columnsSize.hashCode ^ minesCount.hashCode;
}
