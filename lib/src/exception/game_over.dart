import '../model/game_event.dart';

final _winnerEvents = <GameEvent>[GameEvent.minesCleared];

class GameOverEvent implements Exception {
  final bool winner;
  final GameEvent event;

  GameOverEvent({required this.event}) : winner = _winnerEvents.contains(event);
}
