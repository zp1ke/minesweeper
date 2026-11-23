/// Signals between screens and the end of a game.
enum GameEvent {
  /// Start a new board with the current settings.
  boardReload,

  /// The player won.
  minesCleared,

  /// The player opened a mine.
  mineStepped,

  /// Refresh the scores list.
  reloadScores,

  /// Switch to the scores screen.
  checkScores,
}
