import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class ScoresWidget extends ConsumerStatefulWidget {
  final EventHandler eventHandler;

  const ScoresWidget({
    Key? key,
    required this.eventHandler,
  }) : super(key: key);

  @override
  ScoresWidgetState createState() => ScoresWidgetState();
}

class ScoresWidgetState extends ConsumerState<ScoresWidget>
    implements EventListener {
  List<String>? _scoresIDs;
  String? _scoreID;
  var _list = <UserScore>[];
  UserScore? _userScore;
  var _loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadList);
    widget.eventHandler.addListener(this);
  }

  Future<void> _loadScoresIDs() async {
    if (_scoresIDs == null) {
      setState(() {
        _loading = true;
      });
      _scoresIDs = await FirestoreService().fetchScoresIDs();
      if (_scoresIDs!.isNotEmpty && _scoreID == null) {
        final config = ref.read(AppProvider().configProvider).config;
        _scoreID = _scoresIDs!.firstWhere(
            (element) => element == config.boardData.boardStr,
            orElse: () => _scoresIDs!.first);
      }
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _loadList() async {
    await _loadScoresIDs();
    if (!_loading &&
        _scoresIDs != null &&
        _scoresIDs!.isNotEmpty &&
        _scoreID != null) {
      setState(() {
        _loading = true;
      });
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
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_scoresIDs == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final user = AuthService().user;
    return RefreshIndicator(
      onRefresh: () {
        _loadList();
        return Future.value();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
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
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: SizedBox(
                  width: loadingIndicatorSize,
                  height: loadingIndicatorSize,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          if (_list.isEmpty)
            Text(
              l10n.nothingToShow,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
          ..._list
              .map((userScore) => _itemWidget(
                    userScore,
                    (_list.indexOf(userScore) + 1).toString(),
                    l10n,
                    theme,
                    user,
                  ))
              .toList(),
          if (_userScore != null &&
              (_list.isEmpty || _userScore!.score > _list.last.score))
            _itemWidget(
              _userScore!,
              '-',
              l10n,
              theme,
              user,
            )
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
          _loadList();
        },
        itemBuilder: (scoreID) {
          final parts = scoreID.split('_');
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
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
        ),
      ),
      title: Text(
        '${userScore.name}$youStr',
        style: TextStyle(
          fontWeight: isUser ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      subtitle: Text(userScore.datetime.formatted(l10n)),
      trailing: _timeWidget(userScore.score, theme),
      tileColor: theme.colorScheme.secondary.withAlpha(10),
      selectedTileColor: theme.colorScheme.success.withAlpha(15),
    );
  }

  Widget _timeWidget(int secondsElapsed, ThemeData theme) {
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
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: timeColor,
      ),
    );
  }

  @override
  void onEvent(GameEvent event) {
    if (event == GameEvent.reloadScores) {
      _loadList();
    }
  }
}
