class BoardData {
  var rowsSize = 9;
  var columnsSize = 9;
  var minesCount = 10;

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
}
