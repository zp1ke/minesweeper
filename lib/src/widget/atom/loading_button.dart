import 'package:material_ui/material_ui.dart';
import 'package:minezweeper/theme.dart';

/// Button that shows a spinner while [loading].
class LoadingButton extends StatelessWidget {
  /// Creates a button labeled [label].
  const LoadingButton({
    super.key,
    required this.loading,
    required this.onPressed,
    required this.label,
  });

  /// Whether the action is in flight.
  final bool loading;

  /// Called when the button is enabled.
  final VoidCallback onPressed;

  /// Button text.
  final String label;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: !loading ? onPressed : null,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: loadingIndicatorSize,
              height: loadingIndicatorSize,
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        Text(label),
      ],
    ),
  );
}
