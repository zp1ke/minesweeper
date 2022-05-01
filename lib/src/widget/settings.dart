import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/provider.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/config.dart';
import 'package:minesweeper/src/widget/atom/number_picker.dart';

class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(configProvider);
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final items = [
      _minesCountField(configState.config, l10n, ref),
      _rowsField(configState.config, l10n, ref),
      _columnsField(configState.config, l10n, ref),
      _exploreOnTapField(configState.config, l10n, ref),
      _themeModeSystemField(configState.config, theme, l10n, ref),
      if (configState.config.themeMode != ThemeMode.system)
        _themeModeField(configState.config, l10n, ref),
    ];
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, index) => items[index],
    );
  }

  Widget _minesCountField(
    AppConfig config,
    L10n l10n,
    WidgetRef ref,
  ) =>
      ListTileIntPicker(
        title: l10n.minesCount,
        value: config.boardData.minesCount,
        maxValue: config.boardData.maxMinesCount,
        minValue: config.boardData.minMinesCount,
        onValue: (value) {
          config.boardData.minesCount = value;
          _onBoardData(config.boardData, ref);
        },
      );

  Widget _rowsField(
    AppConfig config,
    L10n l10n,
    WidgetRef ref,
  ) =>
      ListTileIntPicker(
        title: l10n.rowsSize,
        value: config.boardData.rowsSize,
        maxValue: 20,
        minValue: 6,
        onValue: (value) {
          config.boardData.rowsSize = value;
          _onBoardData(config.boardData, ref);
        },
      );

  Widget _columnsField(
    AppConfig config,
    L10n l10n,
    WidgetRef ref,
  ) =>
      ListTileIntPicker(
        title: l10n.columnsSize,
        value: config.boardData.columnsSize,
        maxValue: 20,
        minValue: 6,
        onValue: (value) {
          config.boardData.columnsSize = value;
          _onBoardData(config.boardData, ref);
        },
      );

  Widget _exploreOnTapField(
    AppConfig config,
    L10n l10n,
    WidgetRef ref,
  ) =>
      CheckboxListTile(
        isThreeLine: true,
        value: config.exploreOnTap,
        title: Text(l10n.exploreOnTap),
        subtitle: Text(
            config.exploreOnTap
                ? l10n.exploreOnTapDescription
                : l10n.toggleOnTapDescription,
            textAlign: TextAlign.justify),
        onChanged: (value) {
          ref.read(configProvider.notifier).changeExploreOnTap(value ?? false);
        },
      );

  void _onBoardData(BoardData boardData, WidgetRef ref) {
    ref.read(configProvider.notifier).changeBoardData(boardData);
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
