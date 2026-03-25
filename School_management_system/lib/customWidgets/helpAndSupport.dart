import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class HelpDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.help_rounded,
                color: Colors.teal,
                size: AppThemeResponsiveness.getHeaderIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
              Text(
                'Help & Support',
                style: AppThemeResponsiveness.getSubtitleTextStyle(context),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpOption(
                context,
                Icons.school_rounded,
                'School Related Help',
                'Academic queries & support',
                Colors.orange,
                '/school-help',
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
              _buildHelpOption(
                context,
                Icons.family_restroom_rounded,
                'Parent/Guardian Help',
                'Family communication & updates',
                Colors.green,
                '/parent-help',
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
              _buildHelpOption(
                context,
                Icons.support_agent_rounded,
                'Technical Support',
                'App & system issues',
                Colors.blue,
                '/tech-support',
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
              ),
              child: Text(
                'Close',
                style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                  color: AppThemeColor.primaryBlue,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildHelpOption(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Color color,
      String route,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(
            AppThemeResponsiveness.getSmallSpacing(context) * 0.8,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ),
        title: Text(
          title,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppThemeResponsiveness.getCaptionTextStyle(context),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
