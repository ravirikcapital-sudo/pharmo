import 'package:flutter/material.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
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
                    SectionTitle(title: 'Class & Result Management'),
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
        ],
      ),
    );
  }

  Widget _buildDrawer(){
    return ModernDrawer(
      headerIcon: Icons.school_rounded,
      headerTitle: 'Teacher',
      headerSubtitle: 'Mathematics Faculty',
      sections: [
        ModernDrawerSection(title: 'Main', items: [
          ModernDrawerItem(icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              route: '/teacher-dashboard'),
          ModernDrawerItem(icon: Icons.person_rounded,
              title: 'Profile',
              route: '/teacher-profile'),
          ModernDrawerItem(icon: Icons.groups_rounded,
              title: 'Student List',
              route: '/admin-student-management'),
          ModernDrawerItem(icon: Icons.assignment_rounded,
              title: 'Result Entry',
              route: '/teacher-result-entry'),
          ModernDrawerItem(icon: Icons.person_add_alt,
              title: 'Add Applicant',
              route: '/admin-add-student-applicant'),
        ]),
        ModernDrawerSection(title: 'Academic', items: [
          ModernDrawerItem(icon:  Icons.fact_check_rounded,
              title: 'Attendance',
              route: '/teacher-attendance'),
          ModernDrawerItem(icon: Icons.schedule_rounded,
              title: 'Time Table',
              route: '/teacher-timetable'),
          ModernDrawerItem(icon:  Icons.message_rounded,
              title: 'Message',
              route: '/teacher-message'),
        ]),
        ModernDrawerSection(title: 'Settings', items: [
          ModernDrawerItem(icon: Icons.lock_rounded,
              title: 'Change Password',
              route: '/change-password'),
          ModernDrawerItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            onTap: () => LogoutDialog.show(context),
            isDestructive: true,
          ),
        ]),
      ],
    );
  }

  Widget _buildWelcomeSection(){
    return WelcomeSection(
      name: 'Dr. Sarah Johnson',
      classInfo: 'Mathematics',
      isActive: true,
      isVerified: true,
      isSuperUser: false,
      icon: Icons.school_rounded,
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickStatCard(
            title: 'Assigned Classes',
            value: '3',
            icon: Icons.class_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/admin-student-management');
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Total Students',
            value: '125',
            icon: Icons.groups_rounded,
            iconColor: Colors.green,
            iconBackgroundColor: Colors.green.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/admin-student-management');
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Subjects',
            value: '2',
            icon: Icons.subject_rounded,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/teacher-subject-management');
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Attendance',
            value: '92.5%',
            icon: Icons.fact_check_rounded,
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.orange.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/teacher-attendance');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final items = [
      DashboardItem(
        'Student List',
        Icons.groups_rounded,
        Colors.blue,
            () => Navigator.pushNamed(context, '/admin-student-management'),
        'View students in classes',
      ),
      DashboardItem(
        'Attendance',
        Icons.fact_check_rounded,
        Colors.green,
            () => Navigator.pushNamed(context, '/teacher-attendance'),
        'Mark daily attendance',
      ),
      DashboardItem(
        'Take Attendance',
        Icons.check,
        Colors.green,
            () => Navigator.pushNamed(context, '/teacher-mark-attendance'),
        'Mark student Attendance',
      ),
      DashboardItem(
        'Result Entry',
        Icons.assignment_rounded,
        Colors.purple,
            () => Navigator.pushNamed(context, '/teacher-result-entry'),
        'Add exam scores & grades',
      ),
      DashboardItem(
        'Time Table',
        Icons.schedule_rounded,
        Colors.orange,
            () => Navigator.pushNamed(context, '/teacher-timetable'),
        'Teaching schedule',
      ),
      DashboardItem(
        'Add Applicant',
        Icons.person_add_alt,
        Colors.brown,
            () => Navigator.pushNamed(context, '/admin-add-student-applicant'),
        'Add new student',
      ),
      DashboardItem(
        'Add Time Table',
        Icons.add_alarm_outlined,
        Colors.lime,
            () => Navigator.pushNamed(context, '/admin-add-timetable'),
        'Add new timetable',
      ),
      DashboardItem(
        'Academic Options',
        Icons.sports_sharp,
        Colors.indigo,
            () => Navigator.pushNamed(context, '/academic-options'),
        'Academics improvement',
      ),
      DashboardItem(
        'Campaign',
        Icons.account_circle_rounded,
        Colors.pink,
            () => Navigator.pushNamed(context, '/teacher-campaign'),
        'Academics improvement',
      ),
      DashboardItem(
        'Profile',
        Icons.person_rounded,
        Colors.teal,
            () => Navigator.pushNamed(context, '/teacher-profile'),
        'Personal information',
      ),
    ];
    return DashboardGrid(items: items);
  }

  Widget _buildRecentActivity(){
    return RecentActivityCard(
      items: const [
        ActivityItem(
          icon: Icons.assignment_rounded,
          title: 'Math Quiz results entered for Class 10-A',
          time: '1 hour ago',
          color: Colors.purple,
        ),
        ActivityItem(
          icon: Icons.fact_check_rounded,
          title: 'Attendance marked for today\'s classes',
          time: '3 hours ago',
          color: Colors.green,
        ),
        ActivityItem(
          icon: Icons.message_rounded,
          title: 'New message from Academic Officer',
          time: '1 day ago',
          color: Colors.orange,
        ),
      ],
    );
  }
}
