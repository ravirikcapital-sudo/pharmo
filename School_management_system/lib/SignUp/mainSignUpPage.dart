import 'package:flutter/material.dart';
import 'package:school/SignUp/academicOfficerSignUp.dart';
import 'package:school/SignUp/adminSignUp.dart';
import 'package:school/SignUp/parentSignUp.dart';
import 'package:school/SignUp/studentSignUp.dart';
import 'package:school/SignUp/teacherSignUp.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/loginCustomWidgets/userTypeSelection.dart';
import 'package:school/customWidgets/loginCustomWidgets/loginSpanText.dart';

class MainSignUpPage extends StatefulWidget {
  @override
  _MainSignUpPageState createState() => _MainSignUpPageState();
}

class _MainSignUpPageState extends State<MainSignUpPage> {
  String? selectedRole;
  String? _userType;
  bool _showUserTypeError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        // Ensure full height coverage
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          // Set minimum to false to allow background to extend
          minimum: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (AppThemeResponsiveness.isDesktop(context)) {
                return _buildDesktopLayout();
              } else {
                return _buildMobileLayout();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getLargeSpacing(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(isDesktop: true),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(maxWidth: AppThemeResponsiveness.getMaxWidth(context) * 0.4),
              padding: AppThemeResponsiveness.getCardPadding(context),
              child: Center(
                child: _buildSignUpCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      width: double.infinity,
      // Use the full available height
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            AppThemeResponsiveness.getAppBarHeight(context),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                AppThemeResponsiveness.getAppBarHeight(context),
          ),
          child: Column(
            children: [
              _buildWelcomeSection(isDesktop: false),
              _buildSignUpCard(),
              // Add flexible space to push content up and fill remaining space
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection({required bool isDesktop}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getExtraLargeSpacing(context),
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: AppThemeResponsiveness.isDesktop(context)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'signup_logo',
            child: Container(
              width: AppThemeResponsiveness.getLogoSize(context) * 1.5,
              height: AppThemeResponsiveness.getLogoSize(context) * 1.5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_add_rounded,
                size: AppThemeResponsiveness.getLogoSize(context) * 0.75,
                color: AppThemeColor.blue600,
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
          Text(
            'Join Us Today!',
            style: AppThemeResponsiveness.getFontStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getFontStyle(context).fontSize! + 4,
              letterSpacing: -0.5,
            ),
            textAlign: AppThemeResponsiveness.isDesktop(context) ? TextAlign.left : TextAlign.center,
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Create your account and start your educational journey',
            style: AppThemeResponsiveness.getSplashSubtitleStyle(context).copyWith(
              height: 1.5,
            ),
            textAlign: AppThemeResponsiveness.isDesktop(context) ? TextAlign.left : TextAlign.center,
          ),
          if (AppThemeResponsiveness.isDesktop(context)) ...[
            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
            Text(
              'Join our comprehensive school management system and streamline your educational experience.',
              style: AppThemeResponsiveness.getSplashSubtitleStyle(context).copyWith(
                color: Colors.white.withOpacity(0.7),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSignUpCard() {
    return Container(
      margin: AppThemeResponsiveness.getHorizontalPadding(context),
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getDialogWidth(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Role',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! + 2,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            // Using the imported UserTypeSelection widget instead of custom implementation
            UserTypeSelection(
              selectedUserType: _userType,
              onUserTypeSelected: (userType) {
                setState(() {
                  _userType = userType;
                  selectedRole = userType;
                  _showUserTypeError = false;
                });
              },
              showError: _showUserTypeError,
            ),
            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
            // Replaced custom continue button with PrimaryButton
            PrimaryButton(
              title: 'Continue to Sign Up',
              onPressed: selectedRole != null ? _navigateToSelectedRole : null,
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
            _buildDivider(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            LoginRedirectText(context: context)
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
          child: Text(
            'or',
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }

  void _navigateToSelectedRole() {
    if (selectedRole == null) return;

    Widget destinationPage;

    switch (selectedRole) {
      case 'Student':
        destinationPage = StudentSignupPage();
        break;
      case 'Teacher':
        destinationPage = TeacherSignupPage();
        break;
      case 'Academic Officer':
        destinationPage = AcademicOfficerSignupPage();
        break;
      case 'Admin':
        destinationPage = AdminSignupPage();
        break;
      case 'Parent':
        destinationPage = ParentSignUpPage();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }
}