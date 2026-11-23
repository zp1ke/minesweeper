import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

/// Settings row that steps an integer up or down.
class ListTileIntPicker extends StatelessWidget {
  /// Creates a picker bounded by [minValue] and [maxValue].
  const ListTileIntPicker({
    super.key,
    required this.title,
    required this.onValue,
    required this.maxValue,
    required this.minValue,
    required this.value,
  });

  /// Label shown next to the value.
  final String title;

  /// Called with the next value.
  final ValueChanged<int> onValue;

  /// Largest allowed value.
  final int maxValue;

  /// Smallest allowed value.
  final int minValue;

  /// Current value.
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minusEnabled = value > minValue;
    final plusEnabled = value < maxValue;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
      title: Text('$title: $value', textAlign: TextAlign.center),
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
