


import 'app_l10n.g.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get appTitle => 'MineSweeper';

  @override
  String get columnsSize => 'Columns size';

  @override
  String get dark => 'Dark';

  @override
  String get eventMinesCleared => 'All mines cleared!';

  @override
  String get eventMineStepped => 'You stepped on a mine :(';

  @override
  String get exploreOnTap => 'Explore on tap';

  @override
  String get exploreOnTapDescription => 'Tapping a cell will explore it and long pressing a cell will mark it as clear.';

  @override
  String get light => 'Light';

  @override
  String get minesCount => 'Mines count';

  @override
  String get rowsSize => 'Rows size';

  @override
  String get settings => 'Settings';

  @override
  String get system => 'System';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get toggleOnTapDescription => 'Tapping a cell will mark it as clear and long pressing a cell will explore it.';

  @override
  String get version => 'Version';

  @override
  String get youWin => 'You win!';
}
