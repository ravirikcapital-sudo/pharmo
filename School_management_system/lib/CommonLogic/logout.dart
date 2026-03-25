import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/services/api_services.dart';

class LogoutDialog {
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
          title: Text('Logout', style: AppThemeResponsiveness.getSubtitleTextStyle(context)),
          content: Text(
            'Are you sure you want to logout?',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: AppThemeResponsiveness.getButtonTextStyle(context)
                    .copyWith(color: AppThemeColor.primaryBlue),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
              ),
              child: Text(
                'Logout',
                style: AppThemeResponsiveness.getButtonTextStyle(context)
                    .copyWith(color: Colors.white),
              ),
              onPressed: () async {
                // Save the navigator context before closing dialog
                final navigator = Navigator.of(context);
                
                // Close confirmation dialog
                navigator.pop();
                
                // Show loading overlay with root context
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => WillPopScope(
                    onWillPop: () async => false,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                );

                try {
                  // Call logout API to clear tokens and data
                  await ApiService().logout();
                  
                  // Small delay to ensure data is cleared
                  await Future.delayed(Duration(milliseconds: 100));
                  
                  // Close loading indicator
                  navigator.pop();
                  
                  // Navigate to login and clear all routes
                  navigator.pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                } catch (e) {
                  // Close loading indicator
                  navigator.pop();
                  
                  // On error, still navigate to login as local data is cleared
                  navigator.pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
