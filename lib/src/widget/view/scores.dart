import 'package:flutter/material.dart';
import 'package:minesweeper/src/extension/datetime.dart';
import 'package:minesweeper/src/extension/number.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/event.dart';
import 'package:minesweeper/src/model/game_event.dart';
import 'package:minesweeper/src/model/user_score.dart';
import 'package:minesweeper/src/service/firestore.dart';
import 'package:minesweeper/src/widget/atom/select.dart';
import 'package:minesweeper/theme.dart';

class ScoresWidget extends StatefulWidget {
  final EventHandler eventHandler;

  const ScoresWidget({
    Key? key,
    required this.eventHandler,
  }) : super(key: key);

  @override
  ScoresWidgetState createState() => ScoresWidgetState();
}

class ScoresWidgetState extends State<ScoresWidget> implements EventListener {
  List<String>? _scoresIDs;
  String? _scoreID;
  var _list = <UserScore>[];
  var _loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadScoresIDs);
    widget.eventHandler.addListener(this);
  }

  void _loadScoresIDs() async {
    if (_scoresIDs == null) {
      setState(() {
        _loading = true;
      });
      _scoresIDs = await FirestoreService().fetchScoresIDs();
      if (_scoresIDs!.isNotEmpty) {
        _scoreID = _scoresIDs![0];
      }
      _loading = false;
      if (mounted) {
        setState(() {});
      }
      _loadList();
    }
  }

  void _loadList() async {
    if (!_loading && _scoreID != null) {
      setState(() {
        _loading = true;
      });
      _list = await FirestoreService().fetchScores(_scoreID!);
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
    return RefreshIndicator(
      onRefresh: () {
        _loadList();
        return Future.value();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    _list.indexOf(userScore) + 1,
                    l10n,
                    theme,
                  ))
              .toList(),
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
    int index,
    L10n l10n,
    ThemeData theme,
  ) =>
      ListTile(
        isThreeLine: true,
        leading: Text(
          index.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        title: Text(userScore.name),
        subtitle: Text(userScore.datetime.formatted(l10n)),
        trailing: _timeWidget(userScore.score, theme),
      );

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
