extension AppInt on int {
  String secondsFormatted() {
    final seconds = this % 60;
    final minutes = (this / 60) % 60;
    final hours = this / 60 / 60;
    final time =
        '${minutes.toInt().twoDigits()}:${seconds.toInt().twoDigits()}';
    if (hours > 0.99) {
      return '${hours.toInt().twoDigits()}:$time';
    }
    return time;
  }

  String twoDigits() {
    if (this < 10) {
      return '0$this';
    }
    return '$this';
  }
}
