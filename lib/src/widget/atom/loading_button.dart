import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;
  final String label;

  const LoadingButton(
      {super.key,
      required this.loading,
      required this.onPressed,
      required this.label});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: !loading ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                ),
              ),
            Text(label),
          ],
        ),
      );
}
