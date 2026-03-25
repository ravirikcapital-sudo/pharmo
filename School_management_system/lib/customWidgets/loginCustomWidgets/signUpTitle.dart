import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class TitleSection extends StatelessWidget {
  final String accountType; // e.g., 'Student', 'Teacher', etc.

  const TitleSection({
    Key? key,
    required this.accountType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create $accountType Account',
          style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.isSmallPhone(context)
                ? 20.0
                : AppThemeResponsiveness.isMediumPhone(context)
                ? 24.0
                : AppThemeResponsiveness.isLargePhone(context)
                ? 26.0
                : AppThemeResponsiveness.isTablet(context)
                ? 28.0
                : 32.0,
            color: AppThemeColor.blue800,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Text(
          'Please fill in your details to register',
          style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.isSmallPhone(context)
                ? 12.0
                : AppThemeResponsiveness.isMediumPhone(context)
                ? 14.0
                : AppThemeResponsiveness.isLargePhone(context)
                ? 15.0
                : AppThemeResponsiveness.isTablet(context)
                ? 16.0
                : 18.0,
          ),
        ),
      ],
    );
  }
}
