import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minezweeper/src/extension/number.dart';
import 'package:minezweeper/theme.dart';

class BoardHeader extends StatelessWidget {
  final int secondsElapsed;
  final int minesLeft;

  const BoardHeader({
    Key? key,
    required this.secondsElapsed,
    required this.minesLeft,
  }) : super(key: key);

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
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          FaIcon(
            timeIcon,
            color: timeColor,
            size: headerIconSize,
          ),
          Text(
            ' ${secondsElapsed.secondsFormatted()}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: timeColor,
            ),
          ),
          const Spacer(),
          FaIcon(
            FontAwesomeIcons.bomb,
            color: theme.errorColor,
            size: headerIconSize,
          ),
          Text(
            ' $minesLeft',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
