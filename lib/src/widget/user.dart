import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minesweeper/provider.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/widget/atom/loading_button.dart';
import 'package:minesweeper/src/widget/top_ten.dart';

class UserWidget extends ConsumerStatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  UserWidgetState createState() => UserWidgetState();
}

class UserWidgetState extends ConsumerState<UserWidget> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(AppProvider().userProvider);
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final items = [];
    if (userState.user != null) {
      items.add(_nameItem(userState.user!));
    }
    items.add(const Padding(
      padding: EdgeInsets.all(5.0),
      child: TopTenWidget(),
    ));
    if (userState.user != null) {
      items.add(_signOutButton(!userState.processing, theme, l10n, ref));
    } else {
      items.add(_googleSignInButton(!userState.processing, theme, l10n, ref));
    }
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
}
