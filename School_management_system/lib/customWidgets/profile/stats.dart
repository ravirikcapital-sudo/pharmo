import 'package:flutter/material.dart';

class StatItem {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
}

class StatsCard extends StatelessWidget {
  final List<StatItem> items;

  const StatsCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: _buildStatItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStatItems(BuildContext context) {
    final widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      widgets.add(_buildSingleStat(items[i]));
      if (i != items.length - 1) {
        widgets.add(_buildStatDivider());
      }
    }
    return widgets;
  }

  Widget _buildSingleStat(StatItem item) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
