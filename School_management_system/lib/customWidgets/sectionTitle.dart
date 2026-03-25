import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

import 'commonCustomWidget/themeColor.dart';
// Update path as per your structure

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context) * 0.4,
      ),
      child: Center(
        child: Text(
          title,
          style: AppThemeResponsiveness.getSectionTitleStyle(context),
        ),
      ),
    );
  }
}

class SectionTitleBlueAdmission extends StatelessWidget {
  final String title;

  const SectionTitleBlueAdmission({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      child: Text(
        title,
        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
          color: AppThemeColor.blue600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}