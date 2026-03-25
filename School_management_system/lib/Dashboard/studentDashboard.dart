import 'package:flutter/material.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';
import 'package:school/customWidgets/helpAndSupport.dart';


class StudentDashboard extends StatefulWidget {
  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppThemeColor.primaryGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),
                  _buildQuickStatsSection(context),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.6),
                  SectionTitle(title: 'Quick Access'),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                  _buildDashboardGrid(context),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),
                  SectionTitle(title: 'Recent Activity'),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                  _buildRecentActivity(),
                ],
              ),
            ),
          ),
        ),
          ExpandableFab(),
        ]
      ),
    );
  }

  Widget _buildDrawer() {
    return ModernDrawer(
      headerIcon: Icons.person_rounded,
      headerTitle: 'Student',
      headerSubtitle: 'Class 10-A • Roll: 15',
      sections: [
        ModernDrawerSection(
          title: 'Main',
          items: [
            ModernDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              route: '/student-dashboard',
            ),
            ModernDrawerItem(
              icon: Icons.person_rounded,
              title: 'Profile',
              route: '/student-profile',
            ),
            ModernDrawerItem(
              icon: Icons.grade_rounded,
              title: 'Subjects & Marks',
              route: '/student-subject-marks',
            ),
            ModernDrawerItem(
              icon: Icons.payment_rounded,
              title: 'Fee Management',
              route: '/student-fee-management',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Academic',
          items: [
            ModernDrawerItem(
              icon: Icons.schedule_rounded,
              title: 'Time Table',
              route: '/student-timetable',
            ),
            ModernDrawerItem(
              icon: Icons.notifications_active_rounded,
              title: 'Notices & Messages',
              route: '/student-notice-message',
              badge: '3',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Support',
          items: [
            ModernDrawerItem(
              icon: Icons.school_rounded,
              title: 'School Help',
              route: '/school-help',
            ),
            ModernDrawerItem(
              icon: Icons.family_restroom_rounded,
              title: 'Parent Help',
              route: '/parent-help',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Settings',
          items: [
            ModernDrawerItem(
              icon: Icons.lock_rounded,
              title: 'Change Password',
              route: '/change-password',
            ),
            ModernDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: () => LogoutDialog.show(context),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(){
    return WelcomeSection(
      name: 'John Doe',
      classInfo: 'Class 10-A • Roll-15',
      isActive: true,
      isVerified: true,
      isSuperUser: false,
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickStatCard(
            title: 'Attendance',
            value: '94.5%',
            icon: Icons.calendar_today_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/student-attendance-report');
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Fee Status',
            value: 'Paid',
            icon: Icons.payment_rounded,
            iconColor: Colors.green,
            iconBackgroundColor: Colors.green.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/student-fee-management');
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Grade',
            value: 'A+',
            icon: Icons.grade_rounded,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/student-progress-report');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final items = [
      DashboardItem(
        'Subjects & Marks',
        Icons.grade_rounded,
        Colors.purple,
            () => Navigator.pushNamed(context, '/student-subject-marks'),
        'View grades & results',
      ),
      DashboardItem(
        'Fee Management',
        Icons.payment_rounded,
        Colors.green,
            () => Navigator.pushNamed(context, '/student-fee-management'),
        'Fee history & payments',
      ),
      DashboardItem(
        'Time Table',
        Icons.schedule_rounded,
        Colors.orange,
            () => Navigator.pushNamed(context, '/student-timetable'),
        'Daily class schedule',
      ),
      DashboardItem(
        'Notices and Message',
        Icons.notifications_active_rounded,
        Colors.red,
            () => Navigator.pushNamed(context, '/student-notice-message'),
        'School announcements',
        badge: '3',
      ),
      DashboardItem(
        'Profile',
        Icons.person_rounded,
        Colors.blue,
            () => Navigator.pushNamed(context, '/student-profile'),
        'Personal information',
      ),
      DashboardItem(
        'Help & Support',
        Icons.support_agent_rounded,
        Colors.teal,
            () => HelpDialog.show(context),
        'Get assistance',
      ),
    ];

    return DashboardGrid(items: items);
  }

  Widget _buildRecentActivity(){
    return RecentActivityCard(
      items: const [
        ActivityItem(
          icon: Icons.grade_rounded,
          title: 'Math Test Results Published',
          time: '2 hours ago',
          color: Colors.purple,
        ),
        ActivityItem(
          icon: Icons.notifications_rounded,
          title: 'New Notice: Parent-Teacher Meeting',
          time: '1 day ago',
          color: Colors.orange,
        ),
        ActivityItem(
          icon: Icons.payment_rounded,
          title: 'Fee Payment Successful',
          time: '3 days ago',
          color: Colors.green,
        ),
      ],
    );
  }
}