import 'package:minezweeper/src/model/game_event.dart';

final _winnerEvents = <GameEvent>[GameEvent.minesCleared];

/// Thrown when a game ends, either by a mine or a win.
class GameOverEvent implements Exception {
  /// Creates an end-of-game signal for [event].
  GameOverEvent({required this.event}) : winner = _winnerEvents.contains(event);

  /// Whether [event] is a win.
  final bool winner;

  /// Why the game ended.
  final GameEvent event;
}
