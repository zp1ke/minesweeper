import 'package:intl/intl.dart';
import 'package:minezweeper/src/l10n/app_l10n.g.dart';

/// Score-list date formatting.
extension AppDateTime on DateTime {
  /// A short label: today, yesterday, or a full timestamp.
  String formatted(L10n l10n) {
    final now = DateTime.now();
    if (isSameDay(now)) {
      return l10n.todayAt(hour, DateFormat('HH:mm').format(this), hour);
    }
    if (isSameDay(now.subtract(const Duration(days: 1)))) {
      return l10n.yesterdayAt(hour, DateFormat('HH:mm').format(this), hour);
    }
    return DateFormat('yyyy-MM-dd – HH:mm').format(this);
  }

  /// Whether this date falls on the same calendar day as [other].
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
