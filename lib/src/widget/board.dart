import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/provider.dart';
import 'package:minesweeper/src/exception/game_over.dart';
import 'package:minesweeper/src/extension/datetime.dart';
import 'package:minesweeper/src/extension/game_event.dart';
import 'package:minesweeper/src/l10n/app_l10n.g.dart';
import 'package:minesweeper/src/model/board.dart';
import 'package:minesweeper/src/model/cell.dart';
import 'package:minesweeper/src/model/config.dart';
import 'package:minesweeper/src/model/event.dart';
import 'package:minesweeper/src/model/game_event.dart';
import 'package:minesweeper/src/widget/atom/cell.dart';
import 'package:minesweeper/theme.dart';

class BoardWidget extends ConsumerStatefulWidget {
  final EventHandler eventHandler;

  const BoardWidget({
    Key? key,
    required this.eventHandler,
  }) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

const _margin = 0.4;
const _padding = 4.0;
const _iconSize = 14.0;

class _BoardWidgetState extends ConsumerState<BoardWidget>
    implements EventListener {
  late Board _board;
  Timer? _timer;

  var _secondsStartedMs = 0;
  var _secondsElapsed = 0;

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
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _header(),
            _messageLabel(),
            ..._rows(context, width: constraints.maxWidth),
          ],
        ),
      );

  Widget _header() {
    final theme = Theme.of(context);
    var timeColor = theme.colorScheme.primary;
    if (_secondsElapsed > 60) {
      timeColor = theme.colorScheme.warning;
      if (_secondsElapsed > 120) {
        timeColor = theme.colorScheme.secondary;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Icon(
            Icons.schedule_sharp,
            size: _iconSize,
            color: timeColor,
          ),
          Text(
            ' ${_secondsElapsed.secondsFormatted()}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: timeColor,
            ),
          ),
          const Spacer(),
          Image.asset(
            minePng,
            color: theme.errorColor,
            width: _iconSize,
            fit: BoxFit.contain,
          ),
          Text(
            ' ${_board.minesLeft}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _messageLabel() {
    final theme = Theme.of(context);
    var backgroundColor = theme.disabledColor;
    var textColor = theme.colorScheme.onBackground;
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
        width / _board.rowsSize - (_margin * _board.rowsSize + _margin);
    for (var columnIndex = 0; columnIndex < _board.columnsSize; columnIndex++) {
      final cell = _board.cellAt(rowIndex: rowIndex, columnIndex: columnIndex);
      cells.add(cell != null ? _cell(context, cell, cellSize) : Container());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _margin * 4),
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
    if (event.winner) {
      _message = l10n.youWin;
    } else {
      _message = gameEventLabel(event.event, l10n);
    }
    setState(() {});
  }

  @override
  void onEvent(GameEvent event) {
    if (event == GameEvent.boardReload) {
      setState(() {
        _board = Board(boardData: _config.boardData)
          ..setMines(_config.boardData.minesCount);
        _winner = null;
        _message = null;
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
}
