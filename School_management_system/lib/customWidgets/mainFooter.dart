import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final captionStyle = AppThemeResponsiveness.getCaptionTextStyle(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school_rounded,
            color: Colors.white.withOpacity(0.6),
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            '© 2024 School Management System',
            style: captionStyle.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: captionStyle.fontSize! - 1,
            ),
          ),
          Text(
            'Empowering Education Through Technology',
            style: captionStyle.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: captionStyle.fontSize! - 2,
            ),
          ),
        ],
      ),
    );
  }
}
