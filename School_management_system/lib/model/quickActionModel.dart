import 'package:flutter/material.dart';

class QuickActionItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String route;

  QuickActionItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
