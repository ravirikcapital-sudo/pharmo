import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';


class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final BuildContext context;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getResponsiveSize(context, 14, 16, 18),
        horizontal: AppThemeResponsiveness.getResponsiveSize(context, 18, 20, 22),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getResponsiveRadius(context, 12),
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppThemeResponsiveness.getResponsiveIconSize(context, 22),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            title,
            style: AppThemeResponsiveness.getTitleTextStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 17),
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
