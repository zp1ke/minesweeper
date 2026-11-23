import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

/// One destination in the bottom navigation bar.
class NavItem {
  /// Creates a destination.
  NavItem({
    required this.title,
    required this.body,
    required this.icon,
    this.key,
    this.actions,
  });

  /// Optional key used to find this destination.
  final Key? key;

  /// Title shown in the app bar and navigation bar.
  final String title;

  /// Page built for this destination.
  final Widget body;

  /// Navigation icon.
  final FaIconData icon;

  /// App-bar actions shown while this destination is selected.
  final List<Widget>? actions;
}
