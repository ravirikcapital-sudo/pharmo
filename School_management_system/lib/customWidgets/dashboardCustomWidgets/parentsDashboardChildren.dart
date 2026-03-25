import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class ChildCard extends StatelessWidget {
  final String name;
  final String className;
  final IconData icon;
  final Color color;
  final double attendance;
  final String grade;
  final BuildContext context;

  const ChildCard({
    super.key,
    required this.context,
    required this.name,
    required this.className,
    required this.icon,
    required this.color,
    required this.attendance,
    required this.grade,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: AppThemeResponsiveness.getChildCardWidth(context),
      margin: EdgeInsets.only(right: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
      padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsPadding(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context) * 0.8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                ),
                child: Icon(icon, color: color, size: AppThemeResponsiveness.getIconSize(context) * 0.8),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context) * 0.8,
                    vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                ),
                child: Text(
                  grade,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
          Text(
            name,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            className,
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                  color: Colors.blue.shade600),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
              Text(
                '${attendance.toStringAsFixed(1)}%',
                style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
