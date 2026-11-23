const _rowsSizeKey = 'rowsSize';
const _defaultRowsSize = 9;
const _columnsSizeKey = 'columnsSize';
const _defaultColumnsSize = 9;
const _minesCountKey = 'minesCount';
const _defaultMinesCount = 10;

/// Saved board size and mine count.
class BoardData {
  /// A 9×9 board with 10 mines.
  BoardData();

  /// Reads a board from persisted JSON, or defaults.
  BoardData.fromRaw(Object? raw) {
    if (raw is! Map) {
      return;
    }
    rowsSize = _asInt(raw[_rowsSizeKey], _defaultRowsSize);
    columnsSize = _asInt(raw[_columnsSizeKey], _defaultColumnsSize);
    minesCount = _asInt(raw[_minesCountKey], _defaultMinesCount);
  }

  /// Smallest side the settings screen allows.
  static const int minSide = 6;

  /// Largest side the settings screen allows.
  static const int maxSide = 20;

  static int _asInt(Object? value, int fallback) =>
      value is int ? value : fallback;

  /// Number of rows.
  int rowsSize = _defaultRowsSize;

  /// Number of columns.
  int columnsSize = _defaultColumnsSize;

  /// Mines planted when a game starts.
  int minesCount = _defaultMinesCount;

  /// Returns a copy, keeping every field that is not overridden.
  BoardData copyWith({int? rowsSize, int? columnsSize, int? minesCount}) {
    return BoardData()
      ..rowsSize = rowsSize ?? this.rowsSize
      ..columnsSize = columnsSize ?? this.columnsSize
      ..minesCount = minesCount ?? this.minesCount;
  }

  /// Upper bound used by settings, 60% of the cells.
  int get maxMinesCount => (rowsSize * columnsSize * .6).toInt();

  /// Lower bound used by settings, 10% of the cells.
  int get minMinesCount => (rowsSize * columnsSize * .1).toInt();

  /// Firestore key, `rowsxcolumns_mines`.
  String get boardStr => '${rowsSize}x${columnsSize}_$minesCount';

  /// Clamps size to the settings range, then [fixMinesCount].
  void clampToPlayable() {
    rowsSize = rowsSize.clamp(minSide, maxSide);
    columnsSize = columnsSize.clamp(minSide, maxSide);
    fixMinesCount();
  }

  /// Clamps [minesCount] into the settings range.
  void fixMinesCount() {
    if (minesCount < minMinesCount) {
      minesCount = minMinesCount;
    }
    if (minesCount > maxMinesCount) {
      minesCount = maxMinesCount;
    }
  }

  /// JSON map stored in shared preferences.
  Map<String, Object> toMap() => {
    _rowsSizeKey: rowsSize,
    _columnsSizeKey: columnsSize,
    _minesCountKey: minesCount,
  };

  /// Value equality used when deciding whether settings changed.
  bool sameAs(BoardData other) =>
      rowsSize == other.rowsSize &&
      columnsSize == other.columnsSize &&
      minesCount == other.minesCount;
}
