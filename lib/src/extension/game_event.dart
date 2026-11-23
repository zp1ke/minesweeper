import 'package:minezweeper/src/l10n/app_l10n.g.dart';
import 'package:minezweeper/src/model/game_event.dart';

/// Localized text for a terminal [GameEvent], or empty.
String gameEventLabel(GameEvent event, L10n l10n) {
  switch (event) {
    case GameEvent.minesCleared:
      return l10n.eventMinesCleared;
    case GameEvent.mineStepped:
      return l10n.eventMineStepped;
    case GameEvent.boardReload:
    case GameEvent.reloadScores:
    case GameEvent.checkScores:
      return '';
  }
}
