/// Elapsed-time formatting for the board header and scores.
extension AppInt on int {
  /// This many seconds as `mm:ss` or `hh:mm:ss`.
  String secondsFormatted() {
    final seconds = this % 60;
    final minutes = (this / 60) % 60;
    final hours = this / 60 / 60;
    final time = '${minutes.toInt().twoDigits()}:${seconds.twoDigits()}';
    if (hours > 0.99) {
      return '${hours.toInt().twoDigits()}:$time';
    }
    return time;
  }

  /// This integer padded to two digits.
  String twoDigits() {
    if (this < 10) {
      return '0$this';
    }
    return '$this';
  }
}
