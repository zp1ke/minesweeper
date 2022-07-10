import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minezweeper/provider.dart';
import 'package:minezweeper/src/l10n/app_l10n.g.dart';
import 'package:minezweeper/src/model/board_data.dart';
import 'package:minezweeper/src/model/config.dart';
import 'package:minezweeper/src/widget/atom/loading_button.dart';
import 'package:minezweeper/src/widget/atom/number_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  SettingsWidgetState createState() => SettingsWidgetState();
}

class SettingsWidgetState extends ConsumerState<SettingsWidget> {
  PackageInfo? _packageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          _packageInfo = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(AppProvider().configProvider);
    final userState = ref.watch(AppProvider().userProvider);
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final items = [
      if (userState.user != null) _nameItem(userState.user!),
      if (userState.user == null)
        _googleSignInButton(!userState.processing, theme, l10n, ref),
      _minesCountField(configState.config, l10n, ref),
      _rowsField(configState.config, l10n, ref),
      _columnsField(configState.config, l10n, ref),
      _exploreOnTapField(configState.config, l10n, ref),
      _themeModeSystemField(configState.config, theme, l10n, ref),
      if (configState.config.themeMode != ThemeMode.system)
        _themeModeField(configState.config, theme, l10n, ref),
      _aboutItem(context, theme, l10n),
      if (userState.user != null)
        _signOutButton(!userState.processing, theme, l10n, ref),
    ];
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, index) => items[index],
    );
  }

  Widget _googleSignInButton(
          bool enabled, ThemeData theme, L10n l10n, WidgetRef ref) =>
      Center(
        child: LoadingButton(
          loading: !enabled,
          onPressed: () {
            ref.read(AppProvider().userProvider.notifier).googleSignIn();
          },
          label: l10n.googleSignIn,
        ),
      );

  Widget _nameItem(User user) => ListTile(
        leading: const Icon(FontAwesomeIcons.user),
        title: Text(user.displayName ?? '-'),
        subtitle: Text(user.email ?? '-'),
      );

  Widget _signOutButton(
          bool enabled, ThemeData theme, L10n l10n, WidgetRef ref) =>
      Center(
        child: LoadingButton(
          loading: !enabled,
          onPressed: () {
            ref.read(AppProvider().userProvider.notifier).signOut();
          },
          label: l10n.signOut,
        ),
      );

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
          final boardData = config.boardData.copyWith(minesCount: value);
          _onBoardData(boardData, ref);
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
          final boardData = config.boardData.copyWith(rowsSize: value);
          _onBoardData(boardData, ref);
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
          final boardData = config.boardData.copyWith(columnsSize: value);
          _onBoardData(boardData, ref);
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
          ref
              .read(AppProvider().configProvider.notifier)
              .changeExploreOnTap(value ?? false);
        },
      );

  void _onBoardData(BoardData boardData, WidgetRef ref) {
    ref.read(AppProvider().configProvider.notifier).changeBoardData(boardData);
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

  Widget _themeModeField(
      AppConfig config, ThemeData theme, L10n l10n, WidgetRef ref) {
    var icon = FontAwesomeIcons.sun;
    var title = l10n.light;
    if (config.themeMode == ThemeMode.dark) {
      icon = FontAwesomeIcons.moon;
      title = l10n.dark;
    }
    return ListTile(
      leading: FaIcon(
        icon,
        color: theme.primaryColor,
      ),
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
    ref.read(AppProvider().configProvider.notifier).changeThemeMode(mode);
  }

  Widget _aboutItem(BuildContext context, ThemeData theme, L10n l10n) =>
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.circleInfo,
          color: theme.primaryColor,
        ),
        title: Text(_packageInfo?.version != null
            ? '${l10n.version}: ${_packageInfo!.version}'
            : l10n.about),
        trailing: FaIcon(
          FontAwesomeIcons.arrowRight,
          color: theme.primaryColor,
        ),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              'asset/png/logo.png',
              width: 24,
              fit: BoxFit.contain,
            ),
            applicationName: l10n.appTitle,
            applicationVersion: _packageInfo?.version,
            applicationLegalese: '©${DateTime.now().year} h4j4x',
          );
        },
      );
}
