import 'package:flutter/material.dart';

class MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String path;
  final bool isLogout;

  MenuItemData(this.icon, this.title, this.subtitle, this.path, {this.isLogout = false});
}