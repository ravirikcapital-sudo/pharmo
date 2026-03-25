import 'package:flutter/material.dart';
import 'package:school/StudentDashboardPages/noticeAndMessages.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/parentsDashboardChildren.dart';
import 'package:school/parentDashboardPages/feeManagementParent.dart';
import 'package:school/parentDashboardPages/parentCommunity.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';

class ParentDashboard extends StatefulWidget {
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {

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
                    horizontal: AppThemeResponsiveness
                        .getDashboardHorizontalPadding(context),
                    vertical: AppThemeResponsiveness
                        .getDashboardVerticalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(
                          context) * 1.2),
                      _buildChildrenOverview(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(
                          context) * 1.2),
                      _buildQuickStatsSection(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(
                          context) * 1.6),
                      SectionTitle(title: 'Quick Access'),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(
                          context)),
                      _buildDashboardGrid(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(
                          context) * 1.2),
                      SectionTitle(title: 'Recent Updates'),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(
                          context)),
                      _buildRecentActivity(),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(
                          context) * 1.2),
                      _buildUpcomingEventsSection(context),
                      // Pass context here
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
      headerIcon: Icons.family_restroom_rounded,
      headerTitle: 'Parent Portal',
      headerSubtitle: 'Sarah Johnson • 2 Children',
      sections: [
        ModernDrawerSection(
          title: 'Main',
          items: [
            ModernDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              route: '/parent-dashboard',
            ),
            ModernDrawerItem(
              icon: Icons.grade_rounded,
              title: 'Academic Performance',
              route: '/parent-student-performance',
            ),
            ModernDrawerItem(
              icon: Icons.schedule_rounded,
              title: 'Time Tables',
              route: '/student-timetable',
            ),
            ModernDrawerItem(
              icon: Icons.assignment_rounded,
              title: 'Homework & Assignments',
              route: '/parent-homework-tracking',
            ),
            ModernDrawerItem(
              icon: Icons.calendar_today_rounded,
              title: 'Attendance Tracking',
              route: '/parent-attendance',
            ),
            ModernDrawerItem(
              icon: Icons.notifications_active_rounded,
              title: 'School Notices',
              route: '/student-notice-message',
              badge: '5',
            ),
            ModernDrawerItem(
              icon: Icons.payment_rounded,
              title: 'Fee Management',
              route: '/parent-fee-management',
            ),
            ModernDrawerItem(
              icon: Icons.event_rounded,
              title: 'School Events',
              route: '/parent-community',
            ),
            ModernDrawerItem(
              icon: Icons.school_rounded,
              title: 'School Information',
              route: '/school-details',
            ),
            ModernDrawerItem(
              icon: Icons.groups_rounded,
              title: 'Parent Community',
              route: '/parent-community',
            ),
            ModernDrawerItem(
              icon: Icons.support_agent_rounded,
              title: 'Help & Support',
              route: '/parent-help',
            ),
            ModernDrawerItem(
              icon: Icons.feedback_rounded,
              title: 'Feedback',
              route: '/parent-feedback',
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

  Widget _buildWelcomeSection() {
    return WelcomeSection(
      name: 'Sarah Johnson',
      classInfo: '2 Children',
      isActive: true,
      isVerified: true,
      isSuperUser: false,
      icon: Icons.family_restroom_rounded,
    );
  }

  Widget _buildChildrenOverview(BuildContext context) {
    return Container(
      height: AppThemeResponsiveness.getChildCardHeight(context),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChildCard(
            context: context,
            name: 'Emma Johnson',
            className: 'Class 10-A . Roll: 15',
            icon: Icons.girl,
            color: Colors.pink,
            attendance: 94.5,
            grade: 'A+',
          ),
          ChildCard(
            context: context,
            name: 'Jake Johnson',
            className: 'Class 7-B . Roll: 23',
            icon: Icons.boy,
            color: Colors.blue,
            attendance: 91.2,
            grade: 'A',
          ),
        ],
      ),
    );
  }


  Widget _buildQuickStatsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickStatCard(
            title: 'Notices',
            value: '7',
            icon: Icons.message_rounded,
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.orange.shade50,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoticesMessage()),
              );
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Pending Fees',
            value: '₹5,500',
            icon: Icons.payment_rounded,
            iconColor: Colors.red,
            iconBackgroundColor: Colors.red.shade50,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FeePaymentParentPage()),
              );
            },
          ),
          SizedBox(width: AppThemeResponsiveness.getQuickStatsSpacing(context)),

          QuickStatCard(
            title: 'Events',
            value: '3',
            icon: Icons.event_rounded,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.shade50,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ParentCommunity()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final items = [
      DashboardItem('Academic Performance', Icons.grade_rounded, Colors.purple,
              () => Navigator.pushNamed(context, '/parent-student-performance'),
          'View grades & progress', badge: null),
      DashboardItem('Fee Management', Icons.payment_rounded, Colors.green,
              () => Navigator.pushNamed(context, '/parent-fee-management'),
          'Payments & dues'),
      DashboardItem('Attendance', Icons.calendar_today_rounded, Colors.blue,
              () => Navigator.pushNamed(context, '/parent-attendance'),
          'Track daily attendance'),
      DashboardItem('Notices', Icons.message_rounded, Colors.orange,
              () => Navigator.pushNamed(context, '/student-notice-message'),
          'Teacher communications', badge: '2'),
      DashboardItem('School Events', Icons.event_rounded, Colors.indigo,
              () => Navigator.pushNamed(context, '/parent-community'),
          'Upcoming activities'),
      DashboardItem('Homework', Icons.assignment_rounded, Colors.teal,
              () => Navigator.pushNamed(context, '/parent-homework-tracking'),
          'Track assignments'),
      DashboardItem('Time Tables', Icons.schedule_rounded, Colors.cyan,
              () => Navigator.pushNamed(context, '/student-timetable'),
          'Class schedules'),
      DashboardItem('Parent Community', Icons.groups_rounded, Colors.pink,
              () => Navigator.pushNamed(context, '/parent-community'),
          'Connect with parents'),
    ];

    return DashboardGrid(items: items);
  }

  Widget _buildRecentActivity() {
    return RecentActivityCard(
      items: const [
        ActivityItem(
          icon: Icons.grade_rounded,
          title: 'Emma scored 95% in Math Test',
          time: '2 hours ago',
          color: Colors.green,
        ),
        ActivityItem(
          icon: Icons.message_rounded,
          title: 'New message from Jake\'s Class Teacher',
          time: '4 hours ago',
          color: Colors.orange,
        ),
        ActivityItem(
          icon: Icons.event_rounded,
          title: 'Parent-Teacher Meeting scheduled',
          time: '1 day ago',
          color: Colors.purple,
        ),
        ActivityItem(
          icon: Icons.warning_rounded,
          title: 'Emma absent today - Health Issue',
          time: '2 days ago',
          color: Colors.red,

        ),
      ],
    );
  }

  Widget _buildUpcomingEventsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Upcoming Events'),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 1.6),
        Container(
          padding: EdgeInsets.all(
              AppThemeResponsiveness.getActivityItemPadding(context)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getCardBorderRadius(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: AppThemeResponsiveness.getCardElevation(context),
                offset: Offset(
                    0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildEventItem(
                context,
                'Parent-Teacher Meeting',
                'June 15, 2025',
                '10:00 AM - 2:00 PM',
                Colors.blue,
                Icons.people_rounded,
              ),
              Divider(
                  height: AppThemeResponsiveness.getDefaultSpacing(context) *
                      1.2, thickness: 0.8),
              _buildEventItem(
                context,
                'Annual Sports Day',
                'June 20, 2025',
                '9:00 AM - 4:00 PM',
                Colors.orange,
                Icons.sports_rounded,
              ),
              Divider(
                  height: AppThemeResponsiveness.getDefaultSpacing(context) *
                      1.2, thickness: 0.8),
              _buildEventItem(
                context,
                'Science Exhibition',
                'June 25, 2025',
                '11:00 AM - 3:00 PM',
                Colors.purple,
                Icons.science_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem(BuildContext context, String title, String date,
      String time, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
              AppThemeResponsiveness.getActivityIconPadding(context)),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          child: Icon(icon, color: color,
              size: AppThemeResponsiveness.getActivityIconSize(context)),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 1.6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppThemeResponsiveness.getBodyTextStyle(context)
                    .copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) *
                  0.4),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: AppThemeResponsiveness
                          .getCaptionTextStyle(context)
                          .fontSize,
                      color: Colors.grey.shade600),
                  SizedBox(
                      width: AppThemeResponsiveness.getSmallSpacing(context) *
                          0.4),
                  Text(
                    date,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context)
                        .copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(
                      width: AppThemeResponsiveness.getSmallSpacing(context) *
                          1.2),
                  Icon(Icons.access_time,
                      size: AppThemeResponsiveness
                          .getCaptionTextStyle(context)
                          .fontSize,
                      color: Colors.grey.shade600),
                  SizedBox(
                      width: AppThemeResponsiveness.getSmallSpacing(context) *
                          0.4),
                  Text(
                    time,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context)
                        .copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
            size: AppThemeResponsiveness.getIconSize(context)),
      ],
    );
  }

}

