extension AppInt on int {
  String secondsFormatted() {
    final seconds = this % 60;
    final minutes = (this / 60) % 60;
    final hours = this / 60 / 60;
    final time =
        '${_twoDigits(minutes.toInt())}:${_twoDigits(seconds.toInt())}';
    if (hours > 0.99) {
      return '${_twoDigits(hours.toInt())}:$time';
    }
    return time;
  }
}

String _twoDigits(int value) {
  if (value < 10) {
    return '0$value';
  }
  return '$value';
}
