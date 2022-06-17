import 'package:minesweeper/src/extension/number.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';

extension AppDateTime on DateTime {
  String formatted(L10n l10n) {
    // todo
    return '${day.twoDigits()}-${month.twoDigits()}';
  }
}
