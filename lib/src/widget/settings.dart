import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/src/event/provider.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/config.dart';

class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(configProvider);
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return ListView(
      children: [
        _themeModeSystemField(configState.config, theme, l10n, ref),
        if (configState.config.themeMode != ThemeMode.system)
          _themeModeField(configState.config, l10n, ref),
      ],
    );
  }

  Widget _themeModeSystemField(
    AppConfig config,
    ThemeData theme,
    L10n l10n,
    WidgetRef ref,
  ) =>
      CheckboxListTile(
        value: config.themeMode == ThemeMode.system,
        title: Text('${l10n.themeMode}: ${l10n.system}'),
        onChanged: (value) {
          final theValue = value ?? false;
          ThemeMode mode;
          if (theValue) {
            mode = ThemeMode.system;
          } else {
            mode = theme.brightness == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light;
          }
          _onThemeMode(mode, ref);
        },
      );

  Widget _themeModeField(AppConfig config, L10n l10n, WidgetRef ref) {
    var icon = Icons.light_mode_sharp;
    var title = l10n.light;
    if (config.themeMode == ThemeMode.dark) {
      icon = Icons.dark_mode_sharp;
      title = l10n.dark;
    }
    return ListTile(
      leading: Icon(icon),
      title: Text('${l10n.themeMode}: $title'),
      trailing: Switch(
        value: config.themeMode == ThemeMode.light,
        onChanged: (value) {
          final mode = config.themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
          _onThemeMode(mode, ref);
        },
      ),
    );
  }

  void _onThemeMode(ThemeMode mode, WidgetRef ref) {
    ref.read(configProvider.notifier).changeThemeMode(mode);
  }
}
