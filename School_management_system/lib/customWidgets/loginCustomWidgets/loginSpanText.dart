import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class LoginRedirectText extends StatelessWidget {
  final BuildContext context;

  const LoginRedirectText({super.key, required this.context});

  @override
  Widget build(BuildContext _) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
              color: const Color(0xFF6B7280),
            ),
            children: [
              TextSpan(
                text: 'Login here',
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  color: AppThemeColor.blue600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
