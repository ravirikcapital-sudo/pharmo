import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/model/quickActionModel.dart'; // Adjust import as needed

class QuickActionsDialog {
  static void show(
      BuildContext context, {
        required List<QuickActionItem> actions,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          title: Row(
            children: [
              Icon(
                Icons.flash_on_rounded,
                color: Colors.amber,
                size: AppThemeResponsiveness.getHeaderIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
              Text(
                'Quick Actions',
                style: AppThemeResponsiveness.getSubtitleTextStyle(context),
              ),
            ],
          ),
          content: Container(
            width: AppThemeResponsiveness.getDialogWidth(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: actions
                  .map((action) => Column(
                children: [
                  _buildQuickActionItem(context, action),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
                ],
              ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
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

  static Widget _buildQuickActionItem(BuildContext context, QuickActionItem action) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
      ),
      leading: Icon(
        action.icon,
        color: action.color,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      title: Text(
        action.title,
        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        action.subtitle,
        style: AppThemeResponsiveness.getCaptionTextStyle(context),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, action.route);
      },
    );
  }
}