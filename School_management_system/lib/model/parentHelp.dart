
// Data Models
import 'package:flutter/material.dart';

class FAQItem {
  final String question;
  final String answer;
  final String category;
  final IconData icon;

  FAQItem(this.question, this.answer, this.category, this.icon);
}

class ContactMethod {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  ContactMethod(this.label, this.value, this.icon, this.onTap);
}

class TutorialItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String difficulty;

  TutorialItem(this.title, this.description, this.icon, this.color, this.difficulty);
}

class IssueItem {
  final String title;
  final String solution;
  final IconData icon;
  final Color color;
  final String category;

  IssueItem(this.title, this.solution, this.icon, this.color, this.category);
}