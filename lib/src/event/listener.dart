import 'package:minesweeper/src/model/game_event.dart';

abstract class EventListener {
  void onEvent(GameEvent event, Object data);
}
