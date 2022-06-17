import 'package:flutter/material.dart';

class NavItem {
  final Key? key;
  final String title;
  final Widget body;
  final IconData icon;
  final List<Widget>? actions;

  NavItem({
    this.key,
    required this.title,
    required this.body,
    required this.icon,
    this.actions,
  });
}
