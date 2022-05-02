import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/game_event.dart';

String gameEventLabel(GameEvent event, L10n l10n) {
  switch (event) {
    case GameEvent.minesCleared:
      return l10n.eventMinesCleared;
    case GameEvent.mineStepped:
      return l10n.eventMineStepped;
    default:
      return '';
  }
}
