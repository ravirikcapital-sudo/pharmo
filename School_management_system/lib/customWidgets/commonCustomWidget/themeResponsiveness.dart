import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart'; // Assuming this file exists and provides your color palette

class AppThemeResponsiveness {
  // DEVICE TYPE DETECTION
  static bool isSmallPhone(BuildContext context) => MediaQuery.of(context).size.width < 360;
  static bool isMediumPhone(BuildContext context) => MediaQuery.of(context).size.width >= 360 && MediaQuery.of(context).size.width < 400;
  static bool isLargePhone(BuildContext context) => MediaQuery.of(context).size.width >= 400 && MediaQuery.of(context).size.width < 600;
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  // SCREEN DIMENSIONS
  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static double _getResponsiveValue({
    required BuildContext context,
    required double smallPhone,
    required double mediumPhone,
    required double largePhone,
    required double tablet,
    required double desktop,
  }) {
    if (isSmallPhone(context)) return smallPhone;
    if (isMediumPhone(context)) return mediumPhone;
    if (isLargePhone(context)) return largePhone;
    if (isTablet(context)) return tablet;
    return desktop; // Default to desktop if none match (or you can set a specific fallback)
  }

  // RESPONSIVE SPACING
  //Small spacing
  static double getSmallSpacing(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 4.0,
      mediumPhone: 5.0,
      largePhone: 6.0,
      tablet: 12.0,
      desktop: 14.0,
    );
  }

  // medium spacing
  static double getMediumSpacing(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 12.0,
      largePhone: 15.0,
      tablet: 18.0,
      desktop: 22.0,
    );
  }

  //Default spacing
  static double getDefaultSpacing(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 16.0,
      largePhone: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  // Gets extra large spacing for maximum separation
  static double getExtraLargeSpacing(BuildContext context) {
    // This is the example you provided, now using the helper
    return _getResponsiveValue(
      context: context,
      smallPhone: 20.0,
      mediumPhone: 24.0,
      largePhone: 28.0,
      tablet: 32.0,
      desktop: 40.0,
    );
  }

  // large spacing
  static double getLargeSpacing(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 32.0,
      mediumPhone: 40.0,
      largePhone: 48.0,
      tablet: 56.0,
      desktop: 64.0,
    );
  }

  // MARK: - RESPONSIVE PADDING
  // Gets screen padding for main content areas
  static EdgeInsets getScreenPadding(BuildContext context) {
    double padding = getDefaultSpacing(context);
    return EdgeInsets.all(padding);
  }

  // Gets horizontal padding for content
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    double padding = getDefaultSpacing(context);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  // Gets vertical padding for content
  static EdgeInsets getVerticalPadding(BuildContext context) {
    double padding = getDefaultSpacing(context);
    return EdgeInsets.symmetric(vertical: padding);
  }

  // Gets responsive padding based on base value
  static EdgeInsets getResponsivePadding(BuildContext context, double basePadding) {
    double scaleFactor = _getResponsiveValue(
      context: context,
      smallPhone: 0.8,
      mediumPhone: 0.9,
      largePhone: 1.0,
      tablet: 1.2,
      desktop: 1.4,
    );
    return EdgeInsets.all(basePadding * scaleFactor);
  }

  // Gets padding for cards
  static EdgeInsets getCardPadding(BuildContext context) {
    return EdgeInsets.all(_getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 16.0,
      largePhone: 20.0,
      tablet: 24.0,
      desktop: 16.0, // Original had 16.0 for desktop, maintaining it
    ));
  }

  // MARK: - Responsive Icon Size
  // Gets default icon size
  static double getIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 20.0,
      mediumPhone: 22.0,
      largePhone: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  // Gets header icon size
  static double getHeaderIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 22.0,
      mediumPhone: 24.0,
      largePhone: 26.0,
      tablet: 30.0,
      desktop: 34.0,
    );
  }

  // Gets logo size
  static double getLogoSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 32.0,
      mediumPhone: 36.0,
      largePhone: 40.0,
      tablet: 50.0,
      desktop: 50.0,
    );
  }

  // Gets responsive icon size based on base value
  static double getResponsiveIconSize(BuildContext context, double baseIconSize) {
    double scaleFactor = _getResponsiveValue(
      context: context,
      smallPhone: 0.8,
      mediumPhone: 0.9,
      largePhone: 1.0,
      tablet: 1.2,
      desktop: 1.4,
    );
    return baseIconSize * scaleFactor;
  }

  // Gets empty state icon size
  static double getEmptyStateIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 48.0,
      mediumPhone: 56.0,
      largePhone: 64.0,
      tablet: 72.0,
      desktop: 80.0,
    );
  }

  // MARK: - Responsive Font Size
  // Gets responsive font size based on base value
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double scaleFactor = _getResponsiveValue(
      context: context,
      smallPhone: 0.8,
      mediumPhone: 0.9,
      largePhone: 1.0,
      tablet: 1.2,
      desktop: 1.3,
    );
    return baseFontSize * scaleFactor;
  }

  // Gets status badge font size
  static double getStatusBadgeFontSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 9.0,
      mediumPhone: 10.0,
      largePhone: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );
  }

  // Gets history time font size
  static double getHistoryTimeFontSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 11.0,
      largePhone: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );
  }

  // Gets tab font size
  static double getTabFontSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 13.0,
      largePhone: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
  }

  // MARK: - TEXT STYLES - CONSTANTS (These can remain as const if they don't need responsiveness)
  static const TextStyle FontStyle = TextStyle(
    fontSize: 28,
    color: AppThemeColor.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static const TextStyle splashSubtitleStyle = TextStyle(
    fontSize: 16,
    color: AppThemeColor.white70,
    fontFamily: 'Roboto',
  );

  // MARK: - TEXT STYLES - MAIN TYPOGRAPHY (Now using _getResponsiveValue)
  // Gets headline text style for main headings
  static TextStyle getHeadlineTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 24.0,
      mediumPhone: 28.0,
      largePhone: 32.0,
      tablet: 36.0,
      desktop: 44.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.white,
      fontFamily: 'Roboto',
    );
  }

  // Gets title text style for section titles
  static TextStyle getTitleTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 20.0,
      mediumPhone: 22.0,
      largePhone: 24.0,
      tablet: 28.0,
      desktop: 34.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppThemeColor.primaryBlue600,
    );
  }

  // Gets subtitle text style
  static TextStyle getSubTitleTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 16.0,
      largePhone: 18.0,
      tablet: 20.0,
      desktop: 24.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: AppThemeColor.white,
    );
  }

  // Gets body text style for regular content
  static TextStyle getBodyTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.black87,
    );
  }

  // Gets heading text style for sections
  static TextStyle getHeadingTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 20.0,
      mediumPhone: 22.0,
      largePhone: 24.0,
      tablet: 28.0,
      desktop: 36.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.black,
      fontFamily: 'Roboto',
    );
  }

  // Gets subtitle text style for descriptions
  static TextStyle getSubtitleTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 16.0,
      largePhone: 17.0,
      tablet: 18.0,
      desktop: 22.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppThemeColor.black87,
      fontFamily: 'Roboto',
    );
  }

  // Gets caption text style for small text
  static TextStyle getCaptionTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 11.0,
      largePhone: 12.0,
      tablet: 13.0,
      desktop: 15.0,
    );
    return TextStyle(
      fontSize: fontSize,
    );
  }

  // Gets small caption text style
  static TextStyle getSmallCaptionTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 8.0,
      mediumPhone: 9.0,
      largePhone: 10.0,
      tablet: 11.0,
      desktop: 13.0,
    );
    return TextStyle(
      fontSize: fontSize,
    );
  }

  // MARK: - TEXT STYLES - Specialized
  // Section title style based on screen size
  static TextStyle getSectionTitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 18.0,
      mediumPhone: 20.0,
      largePhone: 22.0,
      tablet: 24.0,
      desktop: 26.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.white,
    );
  }

  // General heading style
  static TextStyle getHeadingStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 17.0,
      largePhone: 17.0, // Original had same for medium/large
      tablet: 18.0,
      desktop: 20.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.grey800,
    );
  }

  // Sub-heading style
  static TextStyle getSubHeadingStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 13.0,
      mediumPhone: 14.0,
      largePhone: 14.0, // Original had same for medium/large
      tablet: 15.0,
      desktop: 16.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey600,
    );
  }

  // Performance trend text style
  static TextStyle getPerformanceTrendTextStyle(BuildContext context) {
    double baseFontSize = getBodyTextStyle(context).fontSize ?? 14.0;
    return TextStyle(
      fontSize: baseFontSize + 2,
      fontWeight: FontWeight.w600,
      color: AppThemeColor.black87,
    );
  }

  // MARK: - TEXT STYLES - Input fields
  // Input label style
  static TextStyle getInputLabelStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 15.0,
      largePhone: 15.0, // Original had same for medium/large
      tablet: 16.0,
      desktop: 17.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: AppThemeColor.black87,
      letterSpacing: 0.5,
    );
  }

  // Input hint style
  static TextStyle getInputHintStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 13.0,
      largePhone: 13.0, // Original had same for medium/large
      tablet: 14.0,
      desktop: 15.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: AppThemeColor.black45,
      letterSpacing: 0.3,
    );
  }

  // MARK: - TEXT STYLES - Buttons
  // Button text style (responsive)
  static TextStyle getButtonTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 16.0,
      largePhone: 16.0, // Original had same for medium/large
      tablet: 18.0,
      desktop: 20.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.white,
      fontFamily: 'Roboto',
    );
  }

  // Special font style (responsive)
  static TextStyle getFontStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 20.0,
      mediumPhone: 24.0,
      largePhone: 24.0, // Original had same for medium/large
      tablet: 28.0,
      desktop: 32.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    );
  }

  // MARK: - DIALOG TEXT STYLES
  // Gets dialog title style
  static TextStyle getDialogTitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 18.0,
      largePhone: 20.0,
      tablet: 22.0,
      desktop: 24.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.primaryBlue,
    );
  }

  // Gets dialog content style
  static TextStyle getDialogContentStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 15.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey700,
      height: 1.4,
    );
  }

  // MARK: - DASHBOARD STYLING
  // Gets dashboard horizontal padding
  static double getDashboardHorizontalPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 16.0,
      largePhone: 20.0,
      tablet: 24.0,
      desktop: 32.0,
    );
  }

  // Gets dashboard vertical padding
  static double getDashboardVerticalPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 8.0,
      mediumPhone: 12.0,
      largePhone: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  // Gets dashboard icon size
  static double getDashboardIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 36.0,
      mediumPhone: 40.0,
      largePhone: 48.0,
      tablet: 56.0,
      desktop: 64.0,
    );
  }

  // Gets dashboard item width
  static double getDashboardItemWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // This one has a slightly different calculation, so keep its specific logic
    if (isSmallPhone(context)) return width * 0.42;
    if (isMediumPhone(context)) return width * 0.45;
    if (isLargePhone(context)) return width * 0.42;
    if (isTablet(context)) return width * 0.28;
    if (isDesktop(context)) return width * 0.22;
    return width * 0.4; // fallback
  }

  // Gets dashboard item height
  static double getDashboardItemHeight(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 120.0,
      mediumPhone: 130.0,
      largePhone: 140.0,
      tablet: 160.0,
      desktop: 180.0,
    );
  }

  // MARK: - DASHBOARD GRID CONFIGURATION
  // Gets dashboard grid cross axis count
  static int getDashboardGridCrossAxisCount(BuildContext context) {
    if (isSmallPhone(context)) return 1;
    if (isMediumPhone(context)) return 2;
    if (isLargePhone(context)) return 2;
    if (isTablet(context)) return 4;
    if (isDesktop(context)) return 6;
    return 2; // fallback
  }

  // Gets dashboard grid cross axis spacing
  static double getDashboardGridCrossAxisSpacing(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  // Gets dashboard grid main axis spacing
  static double getDashboardGridMainAxisSpacing(BuildContext context) {
    return getDashboardGridCrossAxisSpacing(context); // reuses same logic
  }

  // Gets dashboard grid child aspect ratio
  static double getDashboardGridChildAspectRatio(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 1.2,
      mediumPhone: 0.9,
      largePhone: 0.85,
      tablet: 0.8,
      desktop: 0.75,
    );
  }

  // Gets grid cross axis count (general-purpose grid)
  static int getGridCrossAxisCount(BuildContext context) {
    if (isSmallPhone(context)) return 2;
    if (isMediumPhone(context)) return 2;
    if (isLargePhone(context)) return 3;
    if (isTablet(context)) return 4;
    if (isDesktop(context)) return 5;
    return 3; // fallback
  }

  // Gets grid child aspect ratio (general-purpose grid)
  static double getGridChildAspectRatio(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 0.9,
      mediumPhone: 1.0,
      largePhone: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
  }

  // Dashboard Grid Styling
  static double getGridItemPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }

  static double getGridItemIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 36.0,
      mediumPhone: 40.0,
      largePhone: 45.0,
      tablet: 50.0,
      desktop: 55.0,
    );
  }

  // MARK: - GRID ITEM STYLING
  static TextStyle getGridItemTitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 16.0,
      largePhone: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppThemeColor.grey800,
    );
  }

  static TextStyle getGridItemSubtitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 11.0,
      largePhone: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey600,
    );
  }

  // MARK: - DASHBOARD CARD STYLING
  // Gets dashboard card padding
  static double getDashboardCardPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 18.0,
      largePhone: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  // Gets dashboard card icon padding
  static double getDashboardCardIconPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }

  // Gets dashboard card icon size
  static double getDashboardCardIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 28.0,
      mediumPhone: 30.0,
      largePhone: 32.0,
      tablet: 36.0,
      desktop: 40.0,
    );
  }

  //Gets dashboard card title style
  static TextStyle getDashboardCardTitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 15.0,
      largePhone: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.grey800,
    );
  }

  // Gets dashboard card subtitle style
  static TextStyle getDashboardCardSubtitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 11.0,
      largePhone: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey600,
    );
  }

  // MARK: - WELCOME SECTION STYLING
  // Gets welcome section padding

  //Gets welcome avatar radius
  static double getWelcomeAvatarRadius(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 28.0,
      mediumPhone: 32.0,
      largePhone: 35.0,
      tablet: 40.0,
      desktop: 48.0,
    );
  }

  // Gets welcome avatar icon size
  static double getWelcomeAvatarIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 32.0,
      mediumPhone: 36.0,
      largePhone: 40.0,
      tablet: 45.0,
      desktop: 52.0,
    );
  }

  //Gets welcome back text style
  static TextStyle getWelcomeBackTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 14.0,
      mediumPhone: 15.0,
      largePhone: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey600,
      fontWeight: FontWeight.w500,
    );
  }

  // Gets welcome name text style
  static TextStyle getWelcomeNameTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 20.0,
      mediumPhone: 22.0,
      largePhone: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.grey800,
    );
  }

  // Gets welcome class text style
  static TextStyle getWelcomeClassTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 11.0,
      largePhone: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    return TextStyle(
      color: AppThemeColor.indigo700,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  // MARK: - ACTIVITY SECTION STYLING
  // Gets activity item padding
  static double getActivityItemPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 18.0,
      largePhone: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  /// Gets activity icon padding
  static double getActivityIconPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 8.0,
      mediumPhone: 9.0,
      largePhone: 10.0,
      tablet: 12.0,
      desktop: 14.0,
    );
  }

  /// Gets activity icon size
  static double getActivityIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 18.0,
      mediumPhone: 19.0,
      largePhone: 20.0,
      tablet: 22.0,
      desktop: 24.0,
    );
  }

  // MARK: - QUICK STATS STYLING
  // Gets quick stats spacing
  static double getQuickStatsSpacing(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 8.0,
      mediumPhone: 10.0,
      largePhone: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  // Gets quick stats padding
  static double getQuickStatsPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 16.0,
      largePhone: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  // Gets quick stats icon padding
  static double getQuickStatsIconPadding(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 8.0,
      mediumPhone: 10.0,
      largePhone: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
  }

  // Gets quick stats icon size
  static double getQuickStatsIconSize(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 24.0,
      mediumPhone: 28.0,
      largePhone: 32.0,
      tablet: 36.0,
      desktop: 40.0,
    );
  }

  // This `getResponsiveSize` function is a more generalized helper,
  // but it's not currently used by the other methods.
  // You could consider integrating it or removing it if unused.
  static double getResponsiveSize(
      BuildContext context,
      double mobileSize,
      double tabletSize,
      double desktopSize,
      ) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return mobileSize * 0.85;
    } else if (width < 480) {
      return mobileSize * 0.95;
    } else if (width < 600) {
      return mobileSize;
    } else if (width < 768) {
      return tabletSize * 0.95;
    } else if (width < 1024) {
      return tabletSize;
    } else if (width < 1440) {
      return desktopSize;
    } else if (width < 1920) {
      return desktopSize * 1.05;
    } else {
      return desktopSize * 1.1;
    }
  }

  static double getStatusBadgeBorderRadius(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 15.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }

  static double getDialogBorderRadius(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 14.0,
      largePhone: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  static double getChildCardHeight(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 130.0,
      mediumPhone: 140.0,
      largePhone: 150.0,
      tablet: 165.0,
      desktop: 220.0,
    );
  }

  static TextStyle getStatusBadgeTextStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 12.0,
      largePhone: 13.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppThemeColor.white,
    );
  }

  static double getResponsiveRadius(BuildContext context, double baseRadius) {
    double scaleFactor = _getResponsiveValue(
      context: context,
      smallPhone: 0.8,
      mediumPhone: 0.9,
      largePhone: 1.0,
      tablet: 1.2,
      desktop: 1.3,
    );
    return baseRadius * scaleFactor;
  }

  // MARK: - RESPONSIVE RADIUS & SIZE
  // Responsive Sizing Helpers
  static double getResponsiveWidth(BuildContext context, double percentage) {
    final width = MediaQuery.of(context).size.width;
    return (percentage >= 0 && percentage <= 1) ? width * percentage : width;
  }

  static double getResponsiveHeight(BuildContext context, double percentage) {
    final height = MediaQuery.of(context).size.height;
    return (percentage >= 0 && percentage <= 1) ? height * percentage : height;
  }

  static double getChildCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (isDesktop(context)) {
      return width * 0.22; // e.g., 22% of screen width
    }

    // Else use fixed logic
    return _getResponsiveValue(
      context: context,
      smallPhone: 160.0,
      mediumPhone: 180.0,
      largePhone: 200.0,
      tablet: 220.0,
      desktop: 200.0, // This value is overridden by the desktop specific logic above, but included for completeness.
    );
  }

  static TextStyle getQuickStatsNumberStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 24.0,
      mediumPhone: 28.0,
      largePhone: 32.0,
      tablet: 36.0,
      desktop: 40.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.white,
    );
  }

  static TextStyle getQuickStatsLabelStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 13.0,
      largePhone: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.white70,
    );
  }

  static TextStyle getRecentTitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 17.0,
      largePhone: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppThemeColor.grey800,
    );
  }

  static TextStyle getRecentSubtitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 12.0,
      mediumPhone: 13.0,
      largePhone: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey600,
    );
  }

  static const TextStyle splashSubtitleTextStyle = TextStyle(
    fontSize: 16,
    color: AppThemeColor.white70,
    fontFamily: 'Roboto',
  );

  static int getTextFieldMaxLines(BuildContext context) {
    if (isSmallPhone(context)) return 2;
    if (isMediumPhone(context)) return 2;
    if (isLargePhone(context)) return 3;
    if (isTablet(context)) return 4;
    if (isDesktop(context)) return 5;
    return 3; // fallback
  }

  // MARK: - HISTORY CARD STYLING
  // History card styling
  static EdgeInsets getHistoryCardMargin(BuildContext context) {
    return EdgeInsets.only(bottom: getMediumSpacing(context));
  }

  // Dialog dimensions
  static double getDialogWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (isSmallPhone(context)) return screenWidth * 0.95;
    if (isMediumPhone(context)) return screenWidth * 0.9;
    if (isLargePhone(context)) return screenWidth * 0.85;
    if (isTablet(context)) return screenWidth * 0.6;
    if (isDesktop(context)) return screenWidth * 0.4;
    return screenWidth * 0.8; // fallback
  }

  // Time chip padding
  static EdgeInsets getTimeChipPadding(BuildContext context) {
    double horizontal = _getResponsiveValue(
      context: context,
      smallPhone: 6.0,
      mediumPhone: 8.0,
      largePhone: 9.0,
      tablet: 10.0,
      desktop: 12.0,
    );
    double vertical = _getResponsiveValue(
      context: context,
      smallPhone: 3.0,
      mediumPhone: 4.0,
      largePhone: 4.5,
      tablet: 5.0,
      desktop: 6.0,
    );
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  // Time chip icon size
  static double getTimeChipIconSize(BuildContext context) {
    return getIconSize(context) * 0.7;
  }

  // Status badge padding
  static EdgeInsets getStatusBadgePadding(BuildContext context) {
    double horizontal = _getResponsiveValue(
      context: context,
      smallPhone: 8.0,
      mediumPhone: 10.0,
      largePhone: 11.0,
      tablet: 12.0,
      desktop: 14.0,
    );
    double vertical = _getResponsiveValue(
      context: context,
      smallPhone: 3.0,
      mediumPhone: 4.0,
      largePhone: 5.0,
      tablet: 6.0,
      desktop: 8.0,
    );
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  // Max layout width constraint
  static double getMaxWidth(BuildContext context) {
    // This function has a different logic (double.infinity for phones), so it's not ideal for _getResponsiveValue directly.
    if (isSmallPhone(context)) return double.infinity;
    if (isMediumPhone(context)) return double.infinity;
    if (isLargePhone(context)) return double.infinity;
    if (isTablet(context)) return 800.0;
    if (isDesktop(context)) return 1200.0;
    return 1000.0; // fallback
  }

  // TabBar height
  static double getTabBarHeight(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 38.0,
      mediumPhone: 40.0,
      largePhone: 42.0,
      tablet: 45.0,
      desktop: 50.0,
    );
  }

  // AppBar height
  static double getAppBarHeight(BuildContext context) {
    // This uses kToolbarHeight as a base, so keep its specific logic.
    if (isSmallPhone(context)) return kToolbarHeight;
    if (isMediumPhone(context)) return kToolbarHeight + 5;
    if (isLargePhone(context)) return kToolbarHeight + 10;
    if (isTablet(context)) return kToolbarHeight + 10;
    if (isDesktop(context)) return kToolbarHeight + 40;
    return kToolbarHeight;
  }

  // Stat title style
  static TextStyle getStatTitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 10.0,
      mediumPhone: 11.0,
      largePhone: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.grey600,
      fontWeight: FontWeight.w500,
    );
  }

  // Splash subtitle style
  static TextStyle getSplashSubtitleStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 13.0,
      mediumPhone: 14.0,
      largePhone: 15.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    return TextStyle(
      fontSize: fontSize,
      color: AppThemeColor.white70,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle getStatValueStyle(BuildContext context) {
    double fontSize = _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 17.0,
      largePhone: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.grey800,
    );
  }

  // MARK: - BUTTON STYLING
  // Responsive Button Styling
  static double getButtonHeight(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 42.0,
      mediumPhone: 45.0,
      largePhone: 48.0,
      tablet: 50.0,
      desktop: 55.0,
    );
  }

  static double getButtonBorderRadius(BuildContext context) {
    return getButtonHeight(context) / 2;
  }

  static double getButtonElevation(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 3.0,
      mediumPhone: 4.0,
      largePhone: 4.5,
      tablet: 5.0,
      desktop: 6.0,
    );
  }

  // MARK: - CARD & INPUT FIELD STYLING
  // Responsive Card Styling
  static double getCardElevation(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 5.0,
      mediumPhone: 6.0,
      largePhone: 7.0,
      tablet: 8.0,
      desktop: 10.0,
    );
  }

  static double getCardBorderRadius(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 16.0,
      mediumPhone: 20.0,
      largePhone: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  // Responsive Input Field Styling
  static double getInputBorderRadius(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 6.0,
      mediumPhone: 8.0,
      largePhone: 9.0,
      tablet: 10.0,
      desktop: 12.0,
    );
  }

  static double getFocusedBorderWidth(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 1.2,
      mediumPhone: 1.5,
      largePhone: 1.8,
      tablet: 2.0,
      desktop: 2.5,
    );
  }

  // MARK: - DRAWER STYLING
  // Drawer Styling
  static double getDrawerHeaderHeight(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 180.0,
      mediumPhone: 190.0,
      largePhone: 200.0,
      tablet: 220.0,
      desktop: 240.0,
    );
  }

  static double getDrawerAvatarRadius(BuildContext context) {
    return _getResponsiveValue(
      context: context,
      smallPhone: 35.0,
      mediumPhone: 38.0,
      largePhone: 40.0,
      tablet: 45.0,
      desktop: 50.0,
    );
  }
}