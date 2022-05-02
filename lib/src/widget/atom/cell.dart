import 'package:flutter/material.dart';
import 'package:minesweeper/src/model/cell.dart';
import 'package:minesweeper/theme.dart';

const _margin = 0.4;
const flagPng = 'asset/png/flag.png';
const minePng = 'asset/png/mine.png';

class CellWidget extends StatelessWidget {
  final Cell cell;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CellWidget({
    Key? key,
    required this.cell,
    required this.size,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(horizontal: _margin),
        decoration: BoxDecoration(
          color: _backgroundColor(theme),
          borderRadius: const BorderRadius.all(
            Radius.circular(_margin * 4),
          ),
        ),
        child: Center(
          child: _content(theme),
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
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
        return _image(minePng, size);
      }
      if (cell.minesAround > 0) {
        var textColor = theme.colorScheme.onPrimary;
        if (cell.minesAround == 2) {
          textColor = theme.colorScheme.primary;
        } else if (cell.minesAround == 3) {
          textColor = theme.colorScheme.warning;
        } else if (cell.minesAround >= 4) {
          textColor = theme.colorScheme.error;
        }
        return Text(
          '${cell.minesAround}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        );
      }
    }
    if (cell.cleared) {
      return _image(flagPng, size);
    }
    return null;
  }

  Widget _image(String name, double size) => Center(
        child: Image.asset(
          name,
          width: size - (_margin * 8),
          fit: BoxFit.contain,
        ),
      );
}
