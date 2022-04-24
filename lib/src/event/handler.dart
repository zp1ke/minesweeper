import 'package:minesweeper/src/event/listener.dart';
import 'package:minesweeper/src/model/game_event.dart';

class EventHandler {
  final _listeners = <EventListener>{};

  void addListener(EventListener listener) => _listeners.add(listener);

  void removeListener(EventListener listener) => _listeners.remove(listener);

  void trigger(GameEvent event, Object data) {
    for (var listener in _listeners) {
      listener.onEvent(event, data);
    }
  }
}
