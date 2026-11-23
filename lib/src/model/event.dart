import 'package:minezweeper/src/model/game_event.dart';

/// Receives in-app [GameEvent]s such as reload and win navigation.
abstract class EventListener {
  /// Handles [event].
  void onEvent(GameEvent event);
}

/// Small multicast bus between the board, scores, and home screen.
class EventHandler {
  final _listeners = <EventListener>{};

  /// Subscribes [listener].
  void addListener(EventListener listener) => _listeners.add(listener);

  /// Unsubscribes [listener].
  void removeListener(EventListener listener) => _listeners.remove(listener);

  /// Delivers [event] to every listener.
  void trigger(GameEvent event) {
    for (final listener in _listeners) {
      listener.onEvent(event);
    }
  }
}
