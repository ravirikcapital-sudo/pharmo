import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/appBar.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/model/schoolInfo.dart';

class AboutSchool extends StatefulWidget {
  const AboutSchool({super.key});

  @override
  State<AboutSchool> createState() => _AboutSchoolState();
}

class _AboutSchoolState extends State<AboutSchool> {
  final ScrollController _scrollController = ScrollController();

  // School data - replace with your actual school information
  final SchoolInfo schoolInfo = SchoolInfo(
    name: "Royal Public School",
    established: "1985",
    motto: "Excellence in Education, Character in Life",
    vision: "To nurture young minds and develop future leaders who contribute positively to society through innovative education and strong moral values.",
    mission: "We are committed to providing a comprehensive, student-centered education that promotes academic excellence, critical thinking, creativity, and character development in a safe and supportive environment.",
    principalName: "Dr. Sarah Johnson",
    principalMessage: "Welcome to Sunrise Academy, where every student's potential is recognized and nurtured. We believe in creating an environment where academic excellence meets character development.",
    totalStudents: "1,200+",
    totalTeachers: "85",
    campusSize: "15 acres",
    establishmentYear: "1985",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            // Content Section
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: AppThemeResponsiveness.getScreenPadding(context),
                  child: Column(
                    children: [
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildSchoolOverviewCard(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildVisionMissionCard(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildPrincipalMessageCard(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildStatsCard(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildFacilitiesCard(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildAchievementsCard(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      _buildContactCard(context),
                      SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: Icon(
              Icons.school,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Our School',
                  style: AppThemeResponsiveness.getFontStyle(context),
                ),
                Text(
                  'Discover our story and values',
                  style: AppThemeResponsiveness.getSplashSubtitleStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolOverviewCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Container(
        padding: AppThemeResponsiveness.getCardPadding(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          gradient: LinearGradient(
            colors: [AppThemeColor.blue50, AppThemeColor.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  color: AppThemeColor.blue800,
                  size: AppThemeResponsiveness.getIconSize(context),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                Expanded(
                  child: Text(
                    schoolInfo.name,
                    style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                      fontSize: AppThemeResponsiveness.isMobile(context) ? 20.0 : (AppThemeResponsiveness.isTablet(context) ? 22.0 : 24.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            Container(
              padding: AppThemeResponsiveness.getStatusBadgePadding(context),
              decoration: BoxDecoration(
                color: AppThemeColor.blue100,
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              ),
              child: Text(
                'Established ${schoolInfo.established}',
                style: TextStyle(
                  color: AppThemeColor.blue800,
                  fontWeight: FontWeight.w600,
                  fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                ),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            Text(
              schoolInfo.motto,
              style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisionMissionCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, Icons.visibility, 'Vision & Mission'),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Vision Section
            Container(
              padding: AppThemeResponsiveness.getCardPadding(context),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.green.shade700,
                        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                      ),
                      SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                      Text(
                        'Our Vision',
                        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                  Text(
                    schoolInfo.vision,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            // Mission Section
            Container(
              padding: AppThemeResponsiveness.getCardPadding(context),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: Colors.orange.shade700,
                        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                      ),
                      SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                      Text(
                        'Our Mission',
                        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                  Text(
                    schoolInfo.mission,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipalMessageCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, Icons.person, 'Principal\'s Message'),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: AppThemeResponsiveness.isMobile(context) ? 25 : (AppThemeResponsiveness.isTablet(context) ? 30 : 35),
                  backgroundColor: AppThemeColor.blue100,
                  child: Icon(
                    Icons.person,
                    size: AppThemeResponsiveness.getHeaderIconSize(context),
                    color: AppThemeColor.blue800,
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schoolInfo.principalName,
                        style: AppThemeResponsiveness.getHeadingStyle(context),
                      ),
                      Text(
                        'Principal',
                        style: AppThemeResponsiveness.getSubHeadingStyle(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            Container(
              padding: AppThemeResponsiveness.getCardPadding(context),
              decoration: BoxDecoration(
                color: AppThemeColor.grey300,
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                border: Border.all(color: AppThemeColor.grey800),
              ),
              child: Text(
                '"${schoolInfo.principalMessage}"',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final stats = [
      StatItem(icon: Icons.groups, label: 'Students', value: schoolInfo.totalStudents),
      StatItem(icon: Icons.person_outline, label: 'Teachers', value: schoolInfo.totalTeachers),
      StatItem(icon: Icons.landscape, label: 'Campus', value: schoolInfo.campusSize),
      StatItem(icon: Icons.calendar_today, label: 'Since', value: schoolInfo.establishmentYear),
    ];

    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, Icons.bar_chart, 'School Statistics'),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Improved responsive grid layout
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate optimal number of columns based on available width
                final double availableWidth = constraints.maxWidth;
                final double minItemWidth = 120.0; // Minimum width for each stat item
                final int crossAxisCount = (availableWidth / minItemWidth).floor().clamp(2, 4);

                // Calculate dynamic aspect ratio based on screen size and content
                final double aspectRatio = _calculateAspectRatio(context, crossAxisCount);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
                    mainAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    final stat = stats[index];
                    return _buildStatItem(context, stat);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to calculate optimal aspect ratio
  double _calculateAspectRatio(BuildContext context, int crossAxisCount) {
    if (AppThemeResponsiveness.isMobile(context)) {
      return crossAxisCount == 2 ? 1.1 : 0.9;
    } else if (AppThemeResponsiveness.isTablet(context)) {
      return crossAxisCount <= 3 ? 1.2 : 1.0;
    } else {
      return crossAxisCount <= 4 ? 1.3 : 1.1;
    }
  }

  // Improved stat item widget with better text handling
  Widget _buildStatItem(BuildContext context, StatItem stat) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        vertical: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: AppThemeColor.blue100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stat.icon,
            color: AppThemeColor.blue800,
            size: _getStatIconSize(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat.value,
                style: _getStatValueStyle(context),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.3),
          Flexible(
            child: Text(
              stat.label,
              style: _getStatLabelStyle(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for responsive stat item styling
  double _getStatIconSize(BuildContext context) {
    if (AppThemeResponsiveness.isMobile(context)) {
      return 24.0;
    } else if (AppThemeResponsiveness.isTablet(context)) {
      return 28.0;
    } else {
      return 32.0;
    }
  }

  TextStyle _getStatValueStyle(BuildContext context) {
    final baseStyle = AppThemeResponsiveness.getStatValueStyle(context);
    return baseStyle.copyWith(
      fontSize: AppThemeResponsiveness.isMobile(context) ? 16.0 :
      AppThemeResponsiveness.isTablet(context) ? 18.0 : 20.0,
      fontWeight: FontWeight.bold,
      color: AppThemeColor.blue800,
    );
  }

  TextStyle _getStatLabelStyle(BuildContext context) {
    final baseStyle = AppThemeResponsiveness.getCaptionTextStyle(context);
    return baseStyle.copyWith(
      fontSize: AppThemeResponsiveness.isMobile(context) ? 12.0 :
      AppThemeResponsiveness.isTablet(context) ? 13.0 : 14.0,
      color: AppThemeColor.blue600,
    );
  }

  Widget _buildFacilitiesCard(BuildContext context) {
    final facilities = [
      'Modern Classrooms with Smart Boards',
      'Science & Computer Laboratories',
      'Library with 10,000+ Books',
      'Sports Complex & Playground',
      'Auditorium & Music Room',
      'Cafeteria & Medical Room',
    ];

    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, Icons.domain, 'School Facilities'),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            ...facilities.map((facility) => Padding(
              padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  ),
                  SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                  Expanded(
                    child: Text(
                      facility,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context) {
    final achievements = [
      'CBSE Board Excellence Award 2023',
      'State Level Science Fair Winner',
      'Best School Infrastructure Award',
      'Environmental Sustainability Certificate',
    ];

    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, Icons.emoji_events, 'Recent Achievements'),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            ...achievements.map((achievement) => Padding(
              padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber.shade600,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  ),
                  SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                  Expanded(
                    child: Text(
                      achievement,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, Icons.contact_mail, 'Contact Information'),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            _buildContactItem(context, Icons.location_on, 'Address', '123 Education Street, Knowledge City, State 12345'),
            _buildContactItem(context, Icons.phone, 'Phone', '+1 (555) 123-4567'),
            _buildContactItem(context, Icons.email, 'Email', 'info@sunriseacademy.edu'),
            _buildContactItem(context, Icons.web, 'Website', 'www.sunriseacademy.edu'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppThemeColor.blue800,
          size: AppThemeResponsiveness.getIconSize(context),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: Text(
            title,
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppThemeColor.blue600,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  value,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
