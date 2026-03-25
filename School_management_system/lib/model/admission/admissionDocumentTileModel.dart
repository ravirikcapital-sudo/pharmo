import 'package:flutter/material.dart';

class DocumentConfig {
  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> allowedTypes;

  DocumentConfig({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.allowedTypes,
  });
}