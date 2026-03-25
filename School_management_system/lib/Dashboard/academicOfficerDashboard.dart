import 'package:flutter/material.dart';
import 'package:school/AdminDashboardPages/employmentManagement.dart';
import 'package:school/AdminEmployeeManagement/editEmployee.dart' hide AddEditEmployeePage;
import 'package:school/academicOfficerDashboardPages/attendanceReport.dart';
import 'package:school/academicOfficerDashboardPages/sendNotificationAcademicOfficer.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/dashboardQuickAction.dart';
import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart' show Employee;
import 'package:school/model/quickActionModel.dart';

class AcademicOfficerDashboard extends StatefulWidget {
  @override
  State<AcademicOfficerDashboard> createState() => _AcademicOfficerDashboardState();
}

class _AcademicOfficerDashboardState extends State<AcademicOfficerDashboard> with TickerProviderStateMixin {

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
                    // Welcome Section
                    _buildWelcomeSection(),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),

                    // Overview Statistics
                    _buildOverviewStatistics(context),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.6),

                    // Quick Access Title
                    SectionTitle(title: 'Quick Access'),

                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

                    // Main Dashboard Grid
                    _buildDashboardGrid(context),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),

                    // Recent Activity Section
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

  Widget _buildDrawer() {
    return ModernDrawer(
      headerIcon: Icons.school_rounded,
      headerTitle: 'Academic Officer',
      headerSubtitle: 'Monitoring & Oversight',
      sections: [
        ModernDrawerSection(
          title: 'Main',
          items: [
            ModernDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              route: '/academic-officer-dashboard',
            ),
            ModernDrawerItem(
              icon: Icons.person_search_rounded,
              title: 'Teacher Performance',
              route: '/academic-officer-teacher-performance',
            ),
            ModernDrawerItem(
              icon: Icons.class_rounded,
              title: 'Classroom Reports',
              route: '/academic-officer-classroom-report',
            ),
            ModernDrawerItem(
              icon: Icons.quiz_rounded,
              title: 'Exam Management',
              route: '/academic-officer-exam-management-screen',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Academic',
          items: [
            ModernDrawerItem(
              icon: Icons.fact_check_rounded,
              title: 'Attendance Reports',
              route: '/academic-officer-attendance-reports',
            ),
            ModernDrawerItem(
              icon: Icons.grade_rounded,
              title: 'Result Entry Status',
              route: '/teacher-result-entry',
            ),
            ModernDrawerItem(
              icon: Icons.add_alarm_outlined,
              title: 'Time Table Management',
              route: '/admin-add-timetable',
            ),
            ModernDrawerItem(
              icon: Icons.sports_sharp,
              title: 'Academic Options',
              route: '/academic-options',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Communication',
          items: [
            ModernDrawerItem(
              icon: Icons.notifications_active_rounded,
              title: 'Send Notifications',
              route: '/academic-officer-notification',
            ),
            ModernDrawerItem(
              icon: Icons.inbox_rounded,
              title: 'Inbox / Chat',
              route: '/main-chat',
            ),
            ModernDrawerItem(
              icon: Icons.announcement_rounded,
              title: 'Announcements',
              route: '/announcements',
              badge: '3',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Settings',
          items: [
            ModernDrawerItem(
              icon: Icons.person_rounded,
              title: 'My Profile',
              route: '/academic-officer-profile',
            ),
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

  Widget _buildWelcomeSection() {
    return WelcomeSection(
      name: 'Academic Officer',
      classInfo: 'Monitoring & Oversight Control',
      isActive: true,
      isVerified: true,
      isSuperUser: true,
      icon: Icons.school_rounded,
    );
  }

  Widget _buildOverviewStatistics(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: [
            QuickStatCard(
              title: 'Classes Supervised',
              value: '12',
              icon: Icons.class_rounded,
              iconColor: Colors.teal,
              iconBackgroundColor: Colors.teal.shade50,
              onTap: () => Navigator.pushNamed(context, '/admin-class-section-management'),
            ),
            QuickStatCard(
              title: 'Attendance Rate',
              value: '95%',
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green,
              iconBackgroundColor: Colors.green.shade50,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendanceReport()),
              ),
            ),
            QuickStatCard(
              title: 'Active Teachers',
              value: '24',
              icon: Icons.person_rounded,
              iconColor: Colors.blue,
              iconBackgroundColor: Colors.blue.shade50,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmploymentManagementPage()),
              ),
            ),
            QuickStatCard(
              title: 'Active Notices',
              value: '3',
              icon: Icons.notifications_active,
              iconColor: Colors.purple,
              iconBackgroundColor: Colors.purple.shade50,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              ),
            ),
            QuickStatCard(
              title: 'System Health',
              value: '99%',
              icon: Icons.health_and_safety_rounded,
              iconColor: Colors.red,
              iconBackgroundColor: Colors.red.shade50,
              onTap: () => Navigator.pushNamed(context, '/admin-system-health'),
            ),
          ],
        ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final items = [
      DashboardItem(
        'Teacher Performance',
        Icons.person_search_rounded,
        Colors.blue,
            () => Navigator.pushNamed(context, '/academic-officer-teacher-performance'),
        'Monitor & evaluate teachers',
      ),
      DashboardItem(
        'Classroom Reports',
        Icons.assessment_rounded,
        Colors.green,
            () => Navigator.pushNamed(context, '/academic-officer-classroom-report'),
        'Detailed classroom analytics',
      ),
      DashboardItem(
        'Exam Management',
        Icons.quiz_rounded,
        Colors.orange,
            () => Navigator.pushNamed(context, '/academic-officer-exam-management-screen'),
        'Schedule & manage exams',
      ),
      DashboardItem(
        'Send Notifications',
        Icons.notifications_active_rounded,
        Colors.purple,
            () => Navigator.pushNamed(context, '/academic-officer-notification'),
        'Broadcast important messages',
      ),
      DashboardItem(
        'Attendance Reports',
        Icons.fact_check_rounded,
        Colors.indigo,
            () => Navigator.pushNamed(context, '/academic-officer-attendance-reports'),
        'Track student attendance',
      ),
      DashboardItem(
        'Result Entry Status',
        Icons.grade_rounded,
        Colors.teal,
            () => Navigator.pushNamed(context, '/teacher-result-entry'),
        'Monitor result submissions',
      ),
      DashboardItem(
        'Time Table Management',
        Icons.add_alarm_outlined,
        Colors.brown,
            () => Navigator.pushNamed(context, '/admin-add-timetable'),
        'Create & modify schedules',
      ),
      DashboardItem(
        'Academic Options',
        Icons.sports_sharp,
        Colors.blueGrey,
            () => Navigator.pushNamed(context, '/academic-options'),
        'Academic year settings',
      ),
      DashboardItem(
        'Performance Analytics',
        Icons.analytics_rounded,
        Colors.cyan,
            () => Navigator.pushNamed(context, '/admin-report-analytics'),
        'Data insights & trends',
      ),
      DashboardItem(
        'My Profile',
        Icons.person_rounded,
        Colors.lightGreen,
            () => Navigator.pushNamed(context, '/academic-officer-profile'),
        'View & edit profile',
      ),
      DashboardItem(
        'Quick Actions',
        Icons.flash_on_rounded,
        Colors.amber.shade700,
            () => _showQuickActionsDialog(context),
        'Shortcuts & quick tasks',
      ),
    ];

    return DashboardGrid(items: items);
  }

  void _showQuickActionsDialog(BuildContext context) {
    return QuickActionsDialog.show(
      context,
      actions: [
        QuickActionItem(
          icon: Icons.assignment_late_rounded,
          color: Colors.orange,
          title: 'Check Pending Entries',
          subtitle: 'Review mark & attendance entries',
          route: '/pending-entries',
        ),
        QuickActionItem(
          icon: Icons.lock_clock_rounded,
          color: Colors.red,
          title: 'Lock/Unlock Results',
          subtitle: 'Manage result submission deadlines',
          route: '/lock-unlock-results',
        ),
        QuickActionItem(
          icon: Icons.announcement_rounded,
          color: Colors.blue,
          title: 'Send Announcement',
          subtitle: 'Notify teachers about deadlines',
          route: '/send-announcement',
        ),
        QuickActionItem(
          icon: Icons.event_rounded,
          color: Colors.green,
          title: 'Schedule Exam',
          subtitle: 'Set test dates and notify',
          route: '/schedule-exam',
        ),
        QuickActionItem(
          icon: Icons.insights_rounded,
          color: Colors.purple,
          title: 'Generate Report',
          subtitle: 'Class performance summary',
          route: '/generate-report',
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return RecentActivityCard(
      items: const [
        ActivityItem(
          icon: Icons.visibility_rounded,
          title: 'Classroom supervision completed for 6A & 8B',
          time: '30 minutes ago',
          color: Colors.blue,
        ),
        ActivityItem(
          icon: Icons.analytics_rounded,
          title: 'Attendance analysis reviewed for June 26',
          time: '2 hours ago',
          color: Colors.teal,
        ),
        ActivityItem(
          icon: Icons.notifications_rounded,
          title: 'Notification sent to all subject teachers',
          time: '5 hours ago',
          color: Colors.deepPurple,
        ),
        ActivityItem(
          icon: Icons.schedule_rounded,
          title: 'Time table updated for Class 9',
          time: '1 day ago',
          color: Colors.indigo,
        ),
        ActivityItem(
          icon: Icons.done_all_rounded,
          title: 'Exam schedule approved for Term 2',
          time: '2 days ago',
          color: Colors.orange,
        ),
        ActivityItem(
          icon: Icons.trending_up_rounded,
          title: 'Performance metrics updated',
          time: '3 days ago',
          color: Colors.green,
        ),
      ],
    );
  }
}