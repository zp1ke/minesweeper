import 'game_event.dart';

abstract class EventListener {
  void onEvent(GameEvent event);
}

class EventHandler {
  final _listeners = <EventListener>{};

  void addListener(EventListener listener) => _listeners.add(listener);

  void removeListener(EventListener listener) => _listeners.remove(listener);

  void trigger(GameEvent event) {
    for (var listener in _listeners) {
      listener.onEvent(event);
    }
  }
}
