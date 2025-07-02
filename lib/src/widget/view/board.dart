import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider.dart';
import '../../exception/game_over.dart';
import '../../extension/game_event.dart';
import '../../l10n/app_l10n.g.dart';
import '../../model/board.dart';
import '../../model/cell.dart';
import '../../model/config.dart';
import '../../model/event.dart';
import '../../model/game_event.dart';
import '../../service/gaming.dart';
import '../atom/cell.dart';
import '../molecule/board_header.dart';
import '../../../theme.dart';

class BoardWidget extends ConsumerStatefulWidget {
  final EventHandler eventHandler;

  const BoardWidget({
    super.key,
    required this.eventHandler,
  });

  @override
  BoardWidgetState createState() => BoardWidgetState();
}

const _margin = 0.4;
const _padding = 4.0;

class BoardWidgetState extends ConsumerState<BoardWidget>
    implements EventListener {
  late Board _board;
  Timer? _timer;

  var _secondsStartedMs = 0;
  var _secondsElapsed = 0;
  var _loading = false;
  var _scoreSubmitted = false;

  bool? _winner;
  String? _message;

  AppConfig get _config => ref.read(AppProvider().configProvider).config;

  @override
  void initState() {
    super.initState();
    _board = Board(boardData: _config.boardData)
      ..setMines(_config.boardData.minesCount);
    widget.eventHandler.addListener(this);
    Future.delayed(Duration.zero, _clearTimer);
  }

  void _clearTimer() {
    _timer?.cancel();
    _secondsStartedMs = DateTime.now().millisecondsSinceEpoch;
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed =
          (DateTime.now().millisecondsSinceEpoch - _secondsStartedMs) / 1000;
      setState(() {
        _secondsElapsed = elapsed.toInt();
      });
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          BoardHeader(
            secondsElapsed: _secondsElapsed,
            minesLeft: _board.minesLeft,
          ),
          _messageLabel(),
          ..._rows(context, width: constraints.maxWidth - _margin),
          if (_timer == null) _toolbar(theme),
        ],
      ),
    );
    if (_loading) {
      return Stack(
        children: [
          content,
          Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.canvasColor.withValues(alpha: .8),
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      );
    }
    return content;
  }

  Widget _messageLabel() {
    final theme = Theme.of(context);
    var backgroundColor = Colors.transparent;
    var textColor = Colors.transparent;
    if (_winner != null) {
      backgroundColor =
          _winner! ? theme.colorScheme.success : theme.colorScheme.error;
      textColor =
          _winner! ? theme.colorScheme.onSuccess : theme.colorScheme.onError;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: _padding,
        horizontal: _padding * 2,
      ),
      margin: const EdgeInsets.only(bottom: _padding),
      color: backgroundColor,
      child: Center(
        child: Text(
          _message ?? ' ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  List<Widget> _rows(BuildContext context, {required double width}) {
    final rows = <Widget>[];
    for (var rowIndex = 0; rowIndex < _board.rowsSize; rowIndex++) {
      rows.add(_row(context, rowIndex, width));
    }
    return rows;
  }

  Widget _row(BuildContext context, int rowIndex, double width) {
    final cells = <Widget>[];
    final cellSize =
        width / _board.columnsSize - (_margin * _board.columnsSize + _margin);
    for (var columnIndex = 0; columnIndex < _board.columnsSize; columnIndex++) {
      final cell = _board.cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
      cells.add(cell != null ? _cell(context, cell, cellSize) : Container());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: _margin * 4,
        horizontal: .0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: cells,
      ),
    );
  }

  Widget _cell(BuildContext context, Cell cell, double size) => CellWidget(
        cell: cell,
        size: size,
        onTap: _board.isActive
            ? () => _onCellTap(cell, !_config.exploreOnTap)
            : null,
        onLongPress: _board.isActive
            ? () => _onCellTap(cell, _config.exploreOnTap)
            : null,
      );

  Widget _toolbar(ThemeData theme) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          _reloadButton(l10n),
          _submitScoreButton(l10n, theme),
        ],
      ),
    );
  }

  Widget _reloadButton(L10n l10n) => ElevatedButton(
        onPressed: () {
          onEvent(GameEvent.boardReload);
        },
        child: Text(l10n.restart),
      );

  Widget _submitScoreButton(L10n l10n, ThemeData theme) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSuccess,
          backgroundColor: theme.colorScheme.success,
        ),
        onPressed: (_winner ?? false) && !_scoreSubmitted ? _submitScore : null,
        child: Text(l10n.submitScore),
      );

  void _onCellTap(Cell cell, bool toggle) {
    if (toggle) {
      _toggleClear(cell);
    } else {
      _explore(cell);
    }
  }

  void _explore(Cell cell) {
    try {
      _board.explore(cell);
    } on GameOverEvent catch (e) {
      _onEvent(e);
    }
    setState(() {});
  }

  void _toggleClear(Cell cell) {
    try {
      _board.toggleClear(cell);
    } on GameOverEvent catch (e) {
      _onEvent(e);
    }
    setState(() {});
  }

  void _onEvent(GameOverEvent event) {
    _timer?.cancel();
    _timer = null;
    _winner = event.winner;
    final l10n = L10n.of(context);
    _message = event.winner ? l10n.youWin : gameEventLabel(event.event, l10n);
    setState(() {});
    if (event.winner) {
      _showScoreDialog();
    }
  }

  @override
  void onEvent(GameEvent event) {
    if (event == GameEvent.boardReload) {
      setState(() {
        _board = Board(boardData: _config.boardData)
          ..setMines(_config.boardData.minesCount);
        _winner = null;
        _message = null;
        _scoreSubmitted = false;
        _clearTimer();
      });
    }
  }

  @override
  void dispose() {
    widget.eventHandler.removeListener(this);
    _timer?.cancel();
    super.dispose();
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final l10n = L10n.of(context);
        return AlertDialog(
          title: Text(l10n.submitScore),
          content: Text(l10n.confirmToSubmitScore),
          actions: [
            TextButton(
              onPressed: () {
                _submitScore();
                Navigator.of(context).pop();
              },
              child: Text(l10n.ok),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            )
          ],
        );
      },
    );
  }

  void _submitScore() async {
    setState(() {
      _loading = true;
    });
    _scoreSubmitted = await GamingService()
        .saveScore(ref, _secondsElapsed, _config.boardData);
    _loading = false;
    if (mounted) {
      setState(() {});
      if (_scoreSubmitted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final l10n = L10n.of(context);
        final theme = Theme.of(context);
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(
            l10n.scoreSubmitted,
            style: TextStyle(
              color: theme.colorScheme.success,
              fontWeight: FontWeight.w700,
            ),
          ),
          action: SnackBarAction(
            label: l10n.check,
            onPressed: () {
              widget.eventHandler.trigger(GameEvent.checkScores);
            },
          ),
        ));
      }
    }
  }
}
