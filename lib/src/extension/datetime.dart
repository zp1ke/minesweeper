import 'package:intl/intl.dart';
import 'package:minezweeper/src/l10n/app_l10n.g.dart';

extension AppDateTime on DateTime {
  String formatted(L10n l10n) {
    final now = DateTime.now();
    if (isSameDay(now)) {
      return l10n.todayAt(hour, DateFormat('HH:mm').format(this));
    }
    if (isSameDay(now.add(const Duration(days: 1)))) {
      return l10n.yesterdayAt(hour, DateFormat('HH:mm').format(this));
    }
    return DateFormat('yyyy-MM-dd – HH:mm').format(this);
  }

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
