import 'package:flutter/material.dart';

class NavItem {
  final String title;
  final Widget body;
  final IconData icon;
  final List<Widget>? actions;

  NavItem({
    required this.title,
    required this.body,
    required this.icon,
    this.actions,
  });
}
