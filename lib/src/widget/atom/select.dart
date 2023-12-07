import 'package:flutter/material.dart';

class SelectButton<T> extends StatelessWidget {
  final String label;
  final T? selected;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final Function(T) onChanged;
  final bool enabled;

  const SelectButton({
    super.key,
    required this.label,
    required this.selected,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) => DropdownButton<T>(
        hint: Text(label),
        value: selected,
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: itemBuilder(item),
              ),
            )
            .toList(),
        onChanged: enabled
            ? (item) {
                if (item != null) {
                  onChanged(item);
                }
              }
            : null,
      );
}
