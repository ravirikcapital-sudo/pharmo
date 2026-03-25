import 'package:flutter/material.dart';

class SchoolInfo {
  final String name;
  final String established;
  final String motto;
  final String vision;
  final String mission;
  final String principalName;
  final String principalMessage;
  final String totalStudents;
  final String totalTeachers;
  final String campusSize;
  final String establishmentYear;

  SchoolInfo({
    required this.name,
    required this.established,
    required this.motto,
    required this.vision,
    required this.mission,
    required this.principalName,
    required this.principalMessage,
    required this.totalStudents,
    required this.totalTeachers,
    required this.campusSize,
    required this.establishmentYear,
  });
}

class StatItem {
  final IconData icon;
  final String label;
  final String value;

  StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
