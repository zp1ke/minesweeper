import 'package:flutter/material.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/src/model/cell.dart';

const _margin = 0.4;

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
  Widget build(BuildContext context) => InkWell(
    child: Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: _margin),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(_margin * 4),
        ),
      ),
      child: Center(
        child: _content(context),
      ),
    ),
    onTap: onTap,
    onLongPress: onLongPress,
  );

  Color get _backgroundColor {
    if (cell.explored) {
      if (cell.mined) {
        return Colors.deepOrange; // todo: apptheme
      }
      return Colors.grey; // todo: apptheme
    }
    if (cell.cleared) {
      return Colors.lightBlue; // todo: apptheme
    }
    return Colors.blueGrey; // todo: apptheme
  }

  Widget? _content(BuildContext context) {
    if (cell.explored) {
      if (cell.mined) {
        return _image(minePng, size);
      }
      if (cell.minesAround > 0) {
        var textColor = Colors.blue; //todo: theme
        if (cell.minesAround == 2) {
          textColor = Colors.yellow; //todo: theme
        } else if (cell.minesAround == 3) {
          textColor = Colors.orange; //todo: theme
        } else if (cell.minesAround == 4) {
          textColor = Colors.deepPurple; //todo: theme
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
