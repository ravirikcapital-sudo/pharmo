import 'package:flutter/material.dart';

class Subject {
  final String name;
  final String grade;
  final double percentage;
  final IconData icon;
  final Color gradeColor;

  Subject(this.name, this.grade, this.percentage, this.icon, this.gradeColor);
}

class ExamResult {
  final String examName;
  final String date;
  final double percentage;
  final String grade;

  ExamResult(this.examName, this.date, this.percentage, this.grade);
}
