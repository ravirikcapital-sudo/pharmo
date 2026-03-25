import 'package:flutter/material.dart';

class AppThemeColor {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF42A5F5); // blue400
  static const Color primaryIndigo = Color(0xFF5C6BC0);//indigo400
  static const Color primaryBlue600 = Color(0xFF1E88E5);

  // Shades of Blue
  static const Color blue25 = Color(0xFF0000FF); // Lightest blue
  static const Color blue50 = Color(0xFFE3F2FD); // Lightest blue
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue300 = Color(0xFF64B5F6);
  static final Color blue400 = Colors.blue.shade400; // PrimaryBlue
  static final Color blue600 = Colors.blue.shade600;
  static const Color blue700 = Color(0xFF1976D2);
  static final Color blue800 = Colors.blue.shade800;

  // Whites
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;

  // Shades of Black
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;
  static const Color black45 = Colors.black45;
  static const Color black38 = Colors.black38;
  static const Color black26 = Colors.black26;
  static const Color black12 = Colors.black12;

  // Shades of Grey
  static const Color greyl = Color(0xFFE5E8EC);
  static const Color greyd = Color(0xFFD9DDE3);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Common Accent Colors
  static const Color green = Color(0xFF4CAF50);
  static const Color greenAccent = Color(0xFF69F0AE);
  static const Color red = Color(0xFFF44336);
  static const Color red400 = Color(0xFFEF5350);//red 400
  static const Color red600 = Color(0xFFE53935);//red 600
  static const Color redAccent = Color(0xFFFF5252);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color amber = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFF9800);
  static const Color orange100 = Color(0xFFFFE0B2);
  static const Color orange200 = Color(0xFFFFCC80);
  static const Color orange700 = Color(0xFFF57C00);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color teal = Color(0xFF009688);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color indigo700 = Color(0xFF303F9F);
  static const Color transparent = Colors.transparent;

  //Gradient for a;; background color (background color of app)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryIndigo],
  );

  // Animation Durations
  static const Duration splashAnimationDuration = Duration(seconds: 2);
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration slideAnimationDuration = Duration(milliseconds: 800);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 300);

  // Button styling constants (kept for backward compatibility)
  static const double cardElevation = 8.0;
  static const double cardBorderRadius = 15.0;
  static const double inputBorderRadius = 10.0;
  static const double focusedBorderWidth = 2.0;
  static const double buttonHeight = 50.0;
  static const double buttonBorderRadius = 25.0;
  static const double buttonElevation = 5.0;
  static const double defaultSpacing = 20.0;
  static const double smallSpacing = 10.0;
  static const double mediumSpacing = 15.0;
  static const double largeSpacing = 50.0;
  static const double extraLargeSpacing = 30.0;
  static const double logoSize = 50.0;

}