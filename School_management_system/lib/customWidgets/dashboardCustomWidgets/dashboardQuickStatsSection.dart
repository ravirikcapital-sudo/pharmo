import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const QuickStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive width based on screen size and orientation
    double getResponsiveWidth() {
      if (AppThemeResponsiveness.isSmallPhone(context)) {
        // For small phones, use more screen width
        return screenWidth * 0.42; // ~42% of screen width
      } else if (AppThemeResponsiveness.isMediumPhone(context)) {
        return screenWidth * 0.4; // ~40% of screen width
      } else if (AppThemeResponsiveness.isTablet(context)) {
        // For tablets, use fixed width but responsive to orientation
        return screenWidth > screenHeight ? 200 : 180; // Landscape vs Portrait
      } else {
        // Desktop - use fixed width with minimum constraints
        return 220.0;
      }
    }

    // Calculate responsive height to maintain aspect ratio
    double getResponsiveHeight() {
      final width = getResponsiveWidth();
      if (AppThemeResponsiveness.isSmallPhone(context)) {
        return width * 0.8; // Slightly shorter for small phones
      } else if (AppThemeResponsiveness.isMediumPhone(context)) {
        return width * 0.85;
      } else {
        return width * 0.9; // More square-like for larger screens
      }
    }

    // Get responsive margin
    double getResponsiveMargin() {
      if (AppThemeResponsiveness.isSmallPhone(context)) {
        return AppThemeResponsiveness.getSmallSpacing(context) * 0.5;
      } else if (AppThemeResponsiveness.isMediumPhone(context)) {
        return AppThemeResponsiveness.getSmallSpacing(context) * 0.75;
      } else {
        return AppThemeResponsiveness.getSmallSpacing(context);
      }
    }

    // Get responsive padding
    double getResponsivePadding() {
      if (AppThemeResponsiveness.isSmallPhone(context)) {
        return AppThemeResponsiveness.getQuickStatsPadding(context) * 0.8;
      } else {
        return AppThemeResponsiveness.getQuickStatsPadding(context);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: getResponsiveWidth(),
        height: getResponsiveHeight(),
        margin: EdgeInsets.only(
          right: getResponsiveMargin(),
        ),
        padding: EdgeInsets.all(getResponsivePadding()),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: AppThemeResponsiveness.getCardElevation(context),
              offset: Offset(
                0,
                AppThemeResponsiveness.getCardElevation(context) * 0.5,
              ),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container with responsive sizing
            Container(
              padding: EdgeInsets.all(
                AppThemeResponsiveness.getQuickStatsIconPadding(context),
              ),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getInputBorderRadius(context),
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: AppThemeResponsiveness.getQuickStatsIconSize(context),
              ),
            ),

            // Responsive spacing
            SizedBox(
              height: AppThemeResponsiveness.getSmallSpacing(context) *
                  (AppThemeResponsiveness.isSmallPhone(context) ? 1.0 : 1.2),
            ),

            // Value text with responsive styling
            Flexible(
              child: Text(
                value,
                style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
                  color: iconColor,
                  fontSize: AppThemeResponsiveness.isSmallPhone(context)
                      ? AppThemeResponsiveness.getStatValueStyle(context).fontSize! * 0.9
                      : AppThemeResponsiveness.getStatValueStyle(context).fontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Responsive spacing
            SizedBox(
              height: AppThemeResponsiveness.getSmallSpacing(context) *
                  (AppThemeResponsiveness.isSmallPhone(context) ? 0.3 : 0.4),
            ),

            // Title text with responsive styling
            Flexible(
              child: Text(
                title,
                style: AppThemeResponsiveness.getStatTitleStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.isSmallPhone(context)
                      ? AppThemeResponsiveness.getStatTitleStyle(context).fontSize! * 0.85
                      : AppThemeResponsiveness.getStatTitleStyle(context).fontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension for better responsiveness calculations
extension QuickStatCardResponsiveness on QuickStatCard {
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  static double getOptimalCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (AppThemeResponsiveness.isSmallPhone(context)) {
      return screenWidth * 0.42;
    } else if (AppThemeResponsiveness.isMediumPhone(context)) {
      return screenWidth * 0.4;
    } else if (AppThemeResponsiveness.isTablet(context)) {
      return isLandscape(context) ? 200 : 180;
    } else {
      return 220.0;
    }
  }
}