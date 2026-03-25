import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color; // Added color parameter

  const PrimaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color, // Optional color parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use provided color or default to blue600
    final buttonColor = color ?? AppThemeColor.blue600;

    return Container(
      width: double.infinity,
      height: AppThemeResponsiveness.getButtonHeight(context) + 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
          height: AppThemeResponsiveness.getResponsiveSize(context, 24, 26, 28),
          width: AppThemeResponsiveness.getResponsiveSize(context, 24, 26, 28),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            ],
            Text(
              title,
              style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SecondaryButton extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.color,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppThemeResponsiveness.getButtonHeight(context),
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: color,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
          ),
          backgroundColor: Colors.white,
        ),
        child: isLoading
            ? SizedBox(
          height: AppThemeResponsiveness.getResponsiveSize(context, 22, 24, 26),
          width: AppThemeResponsiveness.getResponsiveSize(context, 22, 24, 26),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 2.5,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            ],
            Text(
              title,
              style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}