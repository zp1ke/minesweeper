import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:minezweeper/src/extension/number.dart';
import 'package:minezweeper/theme.dart';

/// Elapsed time and mines left, shown above the grid.
class BoardHeader extends StatelessWidget {
  /// Creates a header for the current game.
  const BoardHeader({
    super.key,
    required this.secondsElapsed,
    required this.minesLeft,
  });

  /// Seconds since the current game started.
  final int secondsElapsed;

  /// Mines that have not been flagged.
  final int minesLeft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var timeColor = theme.colorScheme.success;
    var timeIcon = FontAwesomeIcons.hourglassStart;
    if (secondsElapsed > 60) {
      timeColor = theme.colorScheme.warning;
      timeIcon = FontAwesomeIcons.hourglass;
      if (secondsElapsed > 120) {
        timeColor = theme.colorScheme.error;
        timeIcon = FontAwesomeIcons.hourglassEnd;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          FaIcon(timeIcon, color: timeColor, size: headerIconSize),
          Text(
            ' ${secondsElapsed.secondsFormatted()}',
            style: TextStyle(fontWeight: FontWeight.w700, color: timeColor),
          ),
          const Spacer(),
          FaIcon(
            FontAwesomeIcons.bomb,
            color: theme.colorScheme.error,
            size: headerIconSize,
          ),
          Text(
            ' $minesLeft',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
