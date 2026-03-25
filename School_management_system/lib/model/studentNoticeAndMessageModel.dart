import 'package:flutter/material.dart';

class NoticeItem {
  final IconData icon;
  final String title;
  final String time;
  final Color color;
  final NoticePriority priority;
  final String description;

  NoticeItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
    required this.priority,
    required this.description,
  });
}

enum NoticePriority { high, medium, low }