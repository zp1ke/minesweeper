import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTileIntPicker extends StatelessWidget {
  final String title;
  final Function(int) onValue;
  final int maxValue;
  final int minValue;
  final int value;

  const ListTileIntPicker({
    Key? key,
    required this.title,
    required this.onValue,
    required this.maxValue,
    required this.minValue,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        leading: InkWell(
          onTap: value > minValue
              ? () {
                  onValue(value - 1);
                }
              : null,
          child: const FaIcon(FontAwesomeIcons.minus),
        ),
        title: Text(
          '$title: $value',
          textAlign: TextAlign.center,
        ),
        trailing: InkWell(
          onTap: value < maxValue
              ? () {
                  onValue(value + 1);
                }
              : null,
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
      );
}
