import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class HeaderWidget extends StatelessWidget {
  final String titleLabel;

  const HeaderWidget({
    Key? key,
    required this.titleLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: '${titleLabel.toLowerCase()}_icon',
          child: Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getResponsiveSize(context, 20, 24, 28)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              size: AppThemeResponsiveness.getResponsiveIconSize(context, 45),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        Text(
          'Add New $titleLabel',
          style: AppThemeResponsiveness.getHeadlineTextStyle(context).copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getResponsiveSize(context, 16, 20, 24),
            vertical: AppThemeResponsiveness.getResponsiveSize(context, 8, 10, 12),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            'Please fill in all the required information',
            style: AppThemeResponsiveness.getSubTitleTextStyle(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
