import 'package:flutter/material.dart';

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String subtitle;
  final String? badge;

  DashboardItem(
      this.title,
      this.icon,
      this.color,
      this.onTap,
      this.subtitle,
      {
        this.badge,
      });
}
