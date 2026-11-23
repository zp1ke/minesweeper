import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'package:minezweeper/src/model/cell.dart';

const _margin = 0.4;

/// One painted board cell.
class CellWidget extends StatelessWidget {
  /// Creates a cell of [size] that reports tap and long-press.
  const CellWidget({
    super.key,
    required this.cell,
    required this.size,
    required this.onTap,
    required this.onLongPress,
  });

  /// Cell state to paint.
  final Cell cell;

  /// Width and height, in logical pixels.
  final double size;

  /// Called on tap while the game is active.
  final VoidCallback? onTap;

  /// Called on long-press while the game is active.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(horizontal: _margin),
        decoration: BoxDecoration(
          color: _backgroundColor(theme),
          borderRadius: const BorderRadius.all(Radius.circular(_margin * 4)),
        ),
        child: Center(child: _content(theme)),
      ),
    );
  }

  Color _backgroundColor(ThemeData theme) {
    if (cell.explored) {
      if (cell.mined) {
        return theme.colorScheme.error;
      }
      return theme.disabledColor;
    }
    if (cell.cleared) {
      return theme.colorScheme.primary;
    }
    return theme.brightness == Brightness.dark
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.secondaryContainer;
  }

  Widget? _content(ThemeData theme) {
    if (cell.explored) {
      if (cell.mined) {
        return _image(FontAwesomeIcons.bomb, theme.colorScheme.onError);
      }
      if (cell.minesAround > 0) {
        var textColor = theme.colorScheme.onPrimary;
        if (cell.minesAround == 2) {
          textColor = theme.colorScheme.primary;
        } else if (cell.minesAround >= 3) {
          textColor = theme.colorScheme.error;
        }
        return Text(
          '${cell.minesAround}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textColor,
          ),
        );
      }
    }
    if (cell.cleared) {
      return _image(FontAwesomeIcons.solidFlag, theme.colorScheme.onPrimary);
    }
    return null;
  }

  Widget _image(FaIconData icon, Color color) =>
      Center(child: FaIcon(icon, color: color));
}
