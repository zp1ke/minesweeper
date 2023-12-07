import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListTileIntPicker extends StatelessWidget {
  final String title;
  final Function(int) onValue;
  final int maxValue;
  final int minValue;
  final int value;

  const ListTileIntPicker({
    super.key,
    required this.title,
    required this.onValue,
    required this.maxValue,
    required this.minValue,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minusEnabled = value > minValue;
    final plusEnabled = value < maxValue;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: InkWell(
        onTap: minusEnabled
            ? () {
                onValue(value - 1);
              }
            : null,
        child: FaIcon(
          FontAwesomeIcons.minus,
          color: minusEnabled ? theme.primaryColor : theme.disabledColor,
        ),
      ),
      title: Text(
        '$title: $value',
        textAlign: TextAlign.center,
      ),
      trailing: InkWell(
        onTap: plusEnabled
            ? () {
                onValue(value + 1);
              }
            : null,
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: plusEnabled ? theme.primaryColor : theme.disabledColor,
        ),
      ),
    );
  }
}
