import 'package:flutter/material.dart';
import 'package:school/model/profileModel.dart';

class ProfileMenuCard extends StatelessWidget {
  final List<MenuItemData> items;
  final void Function(MenuItemData) onTap;

  const ProfileMenuCard({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: items
              .map((item) => _buildMenuItem(context, item))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItemData item) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: item.isLogout ? Colors.red.withOpacity(0.1) : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          item.icon,
          color: item.isLogout ? Colors.red : Colors.blue.shade600,
          size: 20,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: item.isLogout ? Colors.red : Colors.black87,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: item.isLogout ? Colors.red : Colors.grey,
      ),
      onTap: () => onTap(item),
    );
  }
}
