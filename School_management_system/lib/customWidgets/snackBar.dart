import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class AppSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        required Color backgroundColor,
        required IconData icon,
        SnackBarAction? action, // Accept full SnackBarAction directly
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                message,
                style: AppThemeResponsiveness.getBodyTextStyle(context)
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        action: action,
      ),
    );
  }
}
