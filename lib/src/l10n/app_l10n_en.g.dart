


import 'app_l10n.g.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MineSweeper';

  @override
  String get eventMinesCleared => 'All mines cleared!';

  @override
  String get eventMineStepped => 'You stepped on a mine :(';

  @override
  String get settings => 'Settings';

  @override
  String get youWin => 'You win!';
}
