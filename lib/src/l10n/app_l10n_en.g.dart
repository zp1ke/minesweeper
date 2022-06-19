


import 'app_l10n.g.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get appTitle => 'Sweep that Mine';

  @override
  String get cancel => 'Cancel';

  @override
  String get check => 'Check';

  @override
  String get columnsSize => 'Columns size';

  @override
  String get confirmToSubmitScore => 'Do you want to submit your score?';

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
  String get gameSettings => 'Game settings';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get light => 'Light';

  @override
  String get mines => 'Mines';

  @override
  String get minesCount => 'Mines count';

  @override
  String get nothingToShow => 'Nothing to show :(';

  @override
  String get ok => 'OK';

  @override
  String get restart => 'Restart';

  @override
  String get rowsSize => 'Rows size';

  @override
  String get scores => 'Scores';

  @override
  String get scoreSubmitted => 'Score submitted';

  @override
  String get settings => 'Settings';

  @override
  String get signOut => 'Sign out';

  @override
  String get submitScore => 'Submit score';

  @override
  String get system => 'System';

  @override
  String get themeMode => 'Theme mode';

  @override
  String todayAt(int hour, String datetime) {
    return 'Today at $datetime';
  }

  @override
  String get toggleOnTapDescription => 'Tapping a cell will mark it as clear and long pressing a cell will explore it.';

  @override
  String get user => 'User';

  @override
  String get version => 'Version';

  @override
  String yesterdayAt(int hour, String datetime) {
    return 'Yesterday at $datetime';
  }

  @override
  String get youWin => 'You win!';
}
