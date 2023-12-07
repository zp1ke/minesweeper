import 'package:intl/intl.dart' as intl;

import 'app_l10n.g.dart';

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([super.locale = 'es']);

  @override
  String get about => 'Acerca de';

  @override
  String get appTitle => 'Barre esa mina';

  @override
  String get cancel => 'Cancelar';

  @override
  String get check => 'Revisar';

  @override
  String get columnsSize => 'Columnas';

  @override
  String get confirmToSubmitScore => '¿Quieres enviar tu puntuación?';

  @override
  String get dark => 'Oscuro';

  @override
  String get eventMinesCleared => '¡Todas las minas despejadas!';

  @override
  String get eventMineStepped => 'Haz pisado una mina :(';

  @override
  String get exploreOnTap => 'Explorar con tap';

  @override
  String get exploreOnTapDescription => 'Haciendo Tap en una celda la explorará y presionando unos segundos la marcará como despejada.';

  @override
  String get gameSettings => 'Ajustes de juego';

  @override
  String get googleSignIn => 'Ingresar con Google';

  @override
  String get light => 'Claro';

  @override
  String get mines => 'Minas';

  @override
  String get minesCount => 'Cantidad de minas';

  @override
  String get nothingToShow => 'Nada que mostrar :(';

  @override
  String get ok => 'Aceptar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get rowsSize => 'Filas';

  @override
  String get scores => 'Puntajes';

  @override
  String get scoreSubmitted => 'Puntaje enviado';

  @override
  String get settings => 'Ajustes';

  @override
  String get signOut => 'Salir';

  @override
  String get submitScore => 'Enviar puntuación';

  @override
  String get system => 'Sistema';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String todayAt(int hour, String datetime, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hoy a las $datetime',
      one: 'Hoy a la $datetime',
    );
    return '$_temp0';
  }

  @override
  String get toggleOnTapDescription => 'Haciendo Tap en una celda la marcará como despejada y presionando unos segundos la explorará.';

  @override
  String get user => 'Usuario';

  @override
  String get version => 'Versión';

  @override
  String yesterdayAt(int hour, String datetime, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ayer a las $datetime',
      one: 'Ayer a la $datetime',
    );
    return '$_temp0';
  }

  @override
  String get you => 'Tú';

  @override
  String get youWin => '¡Haz ganado!';
}
