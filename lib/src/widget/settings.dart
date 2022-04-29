import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/src/event/provider.dart';
import 'package:minesweeper/src/model/config.dart';

class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(configProvider);
    return ListView(
      children: [
        _themeModeField(configState.config, ref),
      ],
    );
  }

  Widget _themeModeField(AppConfig config, WidgetRef ref) {
    var icon = Icons.settings_system_daydream_sharp;
    if (config.themeMode == ThemeMode.dark) {
      icon = Icons.dark_mode_sharp;
    } else if (config.themeMode == ThemeMode.light) {
      icon = Icons.light_mode_sharp;
    }
    return ListTile(
      leading: Icon(icon),
      title: Text('TODO'),
      trailing: Switch(
        value: config.themeMode == ThemeMode.light,
        onChanged: (value) {
          final mode = config.themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
          ref.read(configProvider.notifier).changeThemeMode(mode);
        },
      ),
    );
  }
}
