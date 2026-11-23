import 'package:material_ui/material_ui.dart';

/// Dropdown used to pick a score board.
class SelectButton<T> extends StatelessWidget {
  /// Creates a dropdown of [items].
  const SelectButton({
    super.key,
    required this.label,
    required this.selected,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.enabled = true,
  });

  /// Hint shown when nothing is selected.
  final String label;

  /// Currently selected value.
  final T? selected;

  /// Values the player can pick.
  final List<T> items;

  /// Builds the label for one value.
  final Widget Function(T) itemBuilder;

  /// Called with the newly selected value.
  final ValueChanged<T> onChanged;

  /// Whether the dropdown accepts input.
  final bool enabled;

  @override
  Widget build(BuildContext context) => DropdownButton<T>(
    hint: Text(label),
    value: selected,
    items: items
        .map(
          (item) => DropdownMenuItem<T>(value: item, child: itemBuilder(item)),
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
