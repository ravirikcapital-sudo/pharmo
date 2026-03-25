import 'dart:math';
import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/mainFooter.dart';
import 'package:school/services/admission_api.dart';

class AdmissionMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/school3.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                0.50,
              ), // Dark overlay for better text readability
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: AppThemeResponsiveness.getMaxWidth(context),
              ),
              margin: EdgeInsets.symmetric(
                horizontal:
                    AppThemeResponsiveness.isMobile(context)
                        ? 0
                        : max(
                            0,
                            (AppThemeResponsiveness.getScreenWidth(context) -
                                    AppThemeResponsiveness.getMaxWidth(context)) /
                                2,
                          ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      AppThemeResponsiveness.getDashboardHorizontalPadding(
                        context,
                      ),
                  vertical: AppThemeResponsiveness.getDashboardVerticalPadding(
                    context,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hero Section with Logo and Welcome
                    _buildHeroSection(context),
                    SizedBox(
                      height: AppThemeResponsiveness.getExtraLargeSpacing(
                        context,
                      ),
                    ),
                    // Quick Actions Card
                    _buildQuickActionsCard(context),
                    SizedBox(
                      height: AppThemeResponsiveness.getExtraLargeSpacing(
                        context,
                      ),
                    ),
                    Text(
                      'Student Admission Portal',
                      style: TextStyle(
                        fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                          context,
                          28.0,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: AppThemeResponsiveness.getExtraLargeSpacing(
                        context,
                      ),
                    ),

                    // Admission Process Section
                    _buildAdmissionProcessSection(context),

                    SizedBox(
                      height: AppThemeResponsiveness.getExtraLargeSpacing(
                        context,
                      ),
                    ),
                    DashboardFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        // Enhanced Logo Container with minimal padding
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(
              0.9,
            ), // Added white background for logo visibility
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: AppThemeResponsiveness.getCardBorderRadius(context),
                offset: Offset(
                  0,
                  AppThemeResponsiveness.isSmallPhone(context)
                      ? 6
                      : AppThemeResponsiveness.isMediumPhone(context)
                      ? 8
                      : 12,
                ),
              ),
            ],
          ),
          child: ClipOval(
            child: Container(
              padding: EdgeInsets.all(
                8,
              ), // Small padding to prevent logo from touching edges
              child: Image.asset(
                'assets/school.png',
                width:
                    AppThemeResponsiveness.getWelcomeAvatarIconSize(context) *
                    2.0, // Reduced from 3.0 to 2.0
                height:
                    AppThemeResponsiveness.getWelcomeAvatarIconSize(context) *
                    2.0, // Reduced from 3.0 to 2.0
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

        // Welcome Text with responsive typography
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: AppThemeResponsiveness.getTabFontSize(context),
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),

        // Main Title with proper responsive sizing
        Text(
          'Royal Public School',
          style: TextStyle(
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(
              context,
              25.0,
            ),
            fontWeight: FontWeight.bold,
            color: Colors.red,
            letterSpacing: -0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Subtitle with responsive sizing
        Text(
          'Empowering minds. Shaping tomorrow.',
          style: TextStyle(
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.95,
        ), // Slight transparency to show background
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: AppThemeResponsiveness.getCardElevation(context) * 3,
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context)),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: _buildResponsiveActionButtons(context),
      ),
    );
  }

  Widget _buildResponsiveActionButtons(BuildContext context) {
    return Column(
      children: [
        SecondaryButton(
          title: 'Check Admission Status',
          color: Colors.green,
          icon: Icon(
            Icons.search_rounded,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            color: Colors.green,
          ),
          onPressed:
              () => Navigator.pushNamed(context, '/check-admission-status'),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        SecondaryButton(
          title: 'Sign In',
          color: AppThemeColor.blue600,
          icon: Icon(
            Icons.login_rounded,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            color: AppThemeColor.blue600,
          ),
          onPressed: () => Navigator.pushNamed(context, '/login'),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        SecondaryButton(
          title: 'Create New Account',
          color: AppThemeColor.orange,
          icon: Icon(
            Icons.person_add_rounded,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            color: AppThemeColor.orange,
          ),
          onPressed: () => Navigator.pushNamed(context, '/main-signup'),
        ),
      ],
    );
  }

  Widget _buildAdmissionProcessSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.95,
        ), // Slight transparency to show background
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: AppThemeResponsiveness.getCardElevation(context) * 3,
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context)),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    AppThemeResponsiveness.getQuickStatsIconPadding(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColor.blue600.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppThemeResponsiveness.getInputBorderRadius(context),
                    ),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: AppThemeColor.blue600,
                    size: AppThemeResponsiveness.getQuickStatsIconSize(context),
                  ),
                ),
                SizedBox(
                  width: AppThemeResponsiveness.getMediumSpacing(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admission Process',
                        style:
                            AppThemeResponsiveness.getDashboardCardTitleStyle(
                              context,
                            ).copyWith(
                              color: AppThemeColor.blue600,
                              letterSpacing: -0.3,
                            ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Complete in 4 simple steps',
                        style:
                            AppThemeResponsiveness.getDashboardCardSubtitleStyle(
                              context,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
              height: AppThemeResponsiveness.getMediumSpacing(context) + 8,
            ),

            // Process Steps with responsive layout
            _buildResponsiveProcessSteps(context),

            SizedBox(
              height: AppThemeResponsiveness.getExtraLargeSpacing(context),
            ),

            // Action Buttons using Custom Buttons
            PrimaryButton(
              title: 'Start Your Application',
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, '/admission-basic'),
            ),

            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

            SecondaryButton(
              title: 'Learn More About School',
              color: AppThemeColor.blue600,
              icon: Icon(
                Icons.info_outline_rounded,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                color: AppThemeColor.blue600,
              ),
              onPressed: () => Navigator.pushNamed(context, '/school-details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveProcessSteps(BuildContext context) {
    final steps = [
      ProcessStepData(
        stepNumber: 1,
        icon: Icons.person_rounded,
        title: 'Basic Information',
        subtitle: 'Student details & academic background',
        onTap: () => Navigator.pushNamed(context, '/admission-basic'),
      ),
      ProcessStepData(
        stepNumber: 2,
        icon: Icons.family_restroom_rounded,
        title: 'Parent/Guardian Details',
        subtitle: 'Family information & emergency contacts',
        onTap: () => Navigator.pushNamed(context, '/admission-parent'),
      ),
      ProcessStepData(
        stepNumber: 3,
        icon: Icons.location_on_rounded,
        title: 'Contact & Address',
        subtitle: 'Residential & correspondence address',
        onTap: () => Navigator.pushNamed(context, '/admission-contact'),
      ),
      ProcessStepData(
        stepNumber: 4,
        icon: Icons.upload_file_rounded,
        title: 'Document Upload',
        subtitle: 'Certificates, photos & required documents',
        onTap: () => Navigator.pushNamed(context, '/admission-documents'),
      ),
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        return Column(
          children: [
            _buildProcessStep(context, steps[index]),
            if (index < steps.length - 1) _buildStepConnector(context),
          ],
        );
      }),
    );
  }

  Widget _buildProcessStep(BuildContext context, ProcessStepData stepData) {
    return GestureDetector(
      onTap: stepData.onTap,
      child: Container(
        padding: EdgeInsets.all(
          AppThemeResponsiveness.getActivityItemPadding(context),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context) + 4,
          ),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            // Step Number Circle with responsive sizing
            Container(
              width: AppThemeResponsiveness.getDashboardCardIconSize(context),
              height: AppThemeResponsiveness.getDashboardCardIconSize(context),
              decoration: BoxDecoration(
                color:
                    stepData.isCompleted ? Colors.green : AppThemeColor.blue600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (stepData.isCompleted
                            ? Colors.green
                            : AppThemeColor.blue600)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child:
                    stepData.isCompleted
                        ? Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size:
                              AppThemeResponsiveness.getDashboardCardIconSize(
                                context,
                              ) *
                              0.6,
                        )
                        : Text(
                          stepData.stepNumber.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                AppThemeResponsiveness.getDashboardCardSubtitleStyle(
                                  context,
                                ).fontSize! +
                                2,
                          ),
                        ),
              ),
            ),

            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

            // Icon Container
            Container(
              padding: EdgeInsets.all(
                AppThemeResponsiveness.getActivityIconPadding(context),
              ),
              decoration: BoxDecoration(
                color: AppThemeColor.blue600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getSmallSpacing(context),
                ),
              ),
              child: Icon(
                stepData.icon,
                color: AppThemeColor.blue600,
                size: AppThemeResponsiveness.getActivityIconSize(context),
              ),
            ),

            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepData.title,
                    style: AppThemeResponsiveness.getDashboardCardTitleStyle(
                      context,
                    ).copyWith(
                      fontSize:
                          AppThemeResponsiveness.getDashboardCardTitleStyle(
                            context,
                          ).fontSize! -
                          2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    stepData.subtitle,
                    style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(
                      context,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Container(
              padding: EdgeInsets.all(
                AppThemeResponsiveness.getSmallSpacing(context) / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size:
                    AppThemeResponsiveness.getDashboardCardSubtitleStyle(
                      context,
                    ).fontSize! +
                    2,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepConnector(BuildContext context) {
    double leftPadding =
        AppThemeResponsiveness.getDashboardCardIconSize(context) / 2 +
        AppThemeResponsiveness.getActivityItemPadding(context) -
        1;

    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        top: AppThemeResponsiveness.getSmallSpacing(context) / 2,
        bottom: AppThemeResponsiveness.getSmallSpacing(context) / 2,
      ),
      child: Container(
        width: 2,
        height: AppThemeResponsiveness.getMediumSpacing(context),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

//Static model no need to make any changes in it
class ProcessStepData {
  final int stepNumber;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap;

  ProcessStepData({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    required this.onTap,
  });
}
