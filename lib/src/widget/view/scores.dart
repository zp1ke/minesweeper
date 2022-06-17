import 'package:flutter/material.dart';
import 'package:minesweeper/src/extension/datetime.dart';
import 'package:minesweeper/src/extension/number.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/board_data.dart';
import 'package:minesweeper/src/model/event.dart';
import 'package:minesweeper/src/model/game_event.dart';
import 'package:minesweeper/src/model/user_score.dart';
import 'package:minesweeper/src/service/firestore.dart';
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
  var _scoreID = BoardData().boardStr;
  var _list = <UserScore>[];
  var _loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadList);
    widget.eventHandler.addListener(this);
  }

  void _loadList() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      _list = await FirestoreService().fetchTopTen(_scoreID);
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return RefreshIndicator(
      onRefresh: () {
        _loadList();
        return Future.value();
      },
      child: ListView(
        children: [
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
