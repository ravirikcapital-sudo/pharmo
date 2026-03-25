import 'package:flutter/material.dart';

enum TimeTableType { teacher, student }

class TimeTableOption {
  final IconData icon;
  final String title;
  final Color primaryColor;
  final Color secondaryColor;
  final TimeTableType type;
  final String stats;

  TimeTableOption({
    required this.icon,
    required this.title,
    required this.primaryColor,
    required this.secondaryColor,
    required this.type,
    required this.stats,
  });
}
