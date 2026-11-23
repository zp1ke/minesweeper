import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:minezweeper/provider.dart';
import 'package:minezweeper/src/extension/datetime.dart';
import 'package:minezweeper/src/extension/number.dart';
import 'package:minezweeper/src/l10n/app_l10n.g.dart';
import 'package:minezweeper/src/model/event.dart';
import 'package:minezweeper/src/model/game_event.dart';
import 'package:minezweeper/src/model/user_score.dart';
import 'package:minezweeper/src/service/auth.dart';
import 'package:minezweeper/src/service/firestore.dart';
import 'package:minezweeper/src/widget/atom/select.dart';
import 'package:minezweeper/theme.dart';

/// Top times loaded from Firestore.
class ScoresWidget extends ConsumerStatefulWidget {
  /// Creates the scores page.
  const ScoresWidget({super.key, required this.eventHandler});

  /// Bus used to reload the list.
  final EventHandler eventHandler;

  @override
  ScoresWidgetState createState() => ScoresWidgetState();
}

/// State for [ScoresWidget].
class ScoresWidgetState extends ConsumerState<ScoresWidget>
    implements EventListener {
  List<String>? _scoresIDs;
  String? _scoreID;
  var _list = <UserScore>[];
  UserScore? _userScore;
  var _loading = false;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadList);
    widget.eventHandler.addListener(this);
  }

  Future<void> _loadScoresIDs() async {
    if (_scoresIDs != null) {
      return;
    }
    _scoresIDs = await FirestoreService().fetchScoresIDs();
    if (_scoresIDs!.isNotEmpty && _scoreID == null) {
      final config = ref.read(AppProvider().configProvider).config;
      _scoreID = _scoresIDs!.firstWhere(
        (element) => element == config.boardData.boardStr,
        orElse: () => _scoresIDs!.first,
      );
    }
  }

  Future<void> _loadList() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      await _loadScoresIDs();
      if (_scoresIDs != null && _scoresIDs!.isNotEmpty && _scoreID != null) {
        _list = await FirestoreService().fetchScores(_scoreID!);
        final user = AuthService().user;
        if (user != null) {
          _userScore = await FirestoreService().fetchUserScore(
            userID: user.uid,
            scoreID: _scoreID!,
          );
        } else {
          _userScore = null;
        }
      }
    } on FirebaseException {
      _failed = true;
      _scoresIDs = null;
    } on Object catch (error, stack) {
      _failed = true;
      _scoresIDs = null;
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: 'loadScores',
      );
    } finally {
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_scoresIDs == null && !_failed) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final user = AuthService().user;
    return RefreshIndicator(
      onRefresh: () async {
        await _loadList();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_scoresIDs != null && _scoresIDs!.isNotEmpty)
                  _scoreIDSelector(l10n),
              ],
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: SizedBox(
                  width: loadingIndicatorSize,
                  height: loadingIndicatorSize,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          if (_failed)
            Text(
              l10n.scoresUnavailable,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            )
          else if (_list.isEmpty)
            Text(
              l10n.nothingToShow,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ..._list.map(
            (userScore) => _itemWidget(
              userScore,
              (_list.indexOf(userScore) + 1).toString(),
              l10n,
              theme,
              user,
            ),
          ),
          if (_userScore != null &&
              (_list.isEmpty || _userScore!.score > _list.last.score))
            _itemWidget(_userScore!, '-', l10n, theme, user),
        ],
      ),
    );
  }

  Widget _scoreIDSelector(L10n l10n) => SelectButton<String>(
    enabled: !_loading,
    label: l10n.gameSettings,
    selected: _scoreID,
    items: _scoresIDs!,
    onChanged: (scoreID) {
      _scoreID = scoreID;
      unawaited(_loadList());
    },
    itemBuilder: (scoreID) {
      final parts = scoreID.split('_');
      if (parts.length < 2) {
        return Text(scoreID);
      }
      return Text('${parts[0]} (${parts[1]} ${l10n.mines})');
    },
  );

  Widget _itemWidget(
    UserScore userScore,
    String index,
    L10n l10n,
    ThemeData theme,
    User? user,
  ) {
    final isUser = user?.uid == userScore.uid;
    final youStr = isUser ? ' (${l10n.you})' : '';
    return ListTile(
      selected: isUser,
      dense: true,
      leading: Text(
        index,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      title: Text(
        '${userScore.name}$youStr',
        style: TextStyle(
          fontWeight: isUser ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      subtitle: Text(userScore.datetime.formatted(l10n)),
      trailing: _timeWidget(userScore.score),
      tileColor: theme.colorScheme.secondary.withAlpha(10),
      selectedTileColor: theme.colorScheme.success.withAlpha(15),
    );
  }

  Widget _timeWidget(int secondsElapsed) {
    final theme = Theme.of(context);
    var timeColor = theme.colorScheme.success;
    if (secondsElapsed > 60) {
      timeColor = theme.colorScheme.warning;
      if (secondsElapsed > 120) {
        timeColor = theme.colorScheme.error;
      }
    }
    return Text(
      ' ${secondsElapsed.secondsFormatted()}',
      style: TextStyle(fontWeight: FontWeight.w700, color: timeColor),
    );
  }

  @override
  void dispose() {
    widget.eventHandler.removeListener(this);
    super.dispose();
  }

  @override
  void onEvent(GameEvent event) {
    if (event == GameEvent.reloadScores) {
      unawaited(_loadList());
    }
  }
}
