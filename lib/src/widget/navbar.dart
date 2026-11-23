import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'package:minezweeper/src/model/nav_item.dart';

/// Material 3 bar for the game, scores, and settings destinations.
class NavBar extends StatelessWidget {
  /// Creates a bar that reports selection changes through [onChangeIndex].
  const NavBar({
    required this.selectedIndex,
    required this.navItems,
    required this.onChangeIndex,
    super.key,
  });

  /// Index of the selected destination.
  final int selectedIndex;

  /// Destinations, in display order.
  final List<NavItem> navItems;

  /// Called with the index of the destination the player selected.
  final ValueChanged<int> onChangeIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: onChangeIndex,
      destinations: [
        for (final item in navItems)
          NavigationDestination(icon: FaIcon(item.icon), label: item.title),
      ],
    );
  }
}
