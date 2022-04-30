import 'package:flutter/material.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.remove_sharp),
          onPressed: value > minValue
              ? () {
                  onValue(value - 1);
                }
              : null,
        ),
        title: Text('$title: $value'),
        trailing: IconButton(
          icon: const Icon(Icons.add_sharp),
          onPressed: value < maxValue
              ? () {
                  onValue(value + 1);
                }
              : null,
        ),
      );
}
