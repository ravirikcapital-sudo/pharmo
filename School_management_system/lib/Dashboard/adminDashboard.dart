import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/dashboardQuickAction.dart';
import 'package:school/model/quickActionModel.dart';
import 'package:school/model/adminProfileModel.dart';
import 'package:school/services/api_services.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  // Add admin profile data
  AdminProfile? adminData;
  PlatformFile? _profileImage;
  bool _isLoading = true;

  int totalStudents = 0;
  int activeStudents = 0;
  int totalClasses = 0;
  int totalEmployees = 0;
  int unreadNotifications = 0;
  int totalTeachers = 0;//
  int userRequestCount = 0;//
  List userRequests = [];//
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    // _loadUserRequests();//
    _loadTeachersCount();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdminDashboard();
    _loadEmployeeCount();
    _loadUnreadNotifications();
    // _loadUserRequests();//
  }

  Future<void> _loadAdminData() async {
    final api = ApiService();

    final name = await api.getUserName();
    final email = await api.getUserEmail();

    setState(() {
      adminData = AdminProfile(
        name: name ?? 'Administrator',
        email: email ?? '',
        phone: '',
        adminId: '',
        role: 'System Administrator',
        designation: 'Principal Administrator',
        experience: '',
        qualification: '',
        address: '',
        joinDate: '',
        permissions: [],
        managedSections: [],
        totalUsers: 0,
        activeStudents: totalStudents,
        totalFaculty: totalEmployees,
        totalStaff: 0,
        systemUptime: '99.8%',
        profileImageUrl: '',
      );
      _isLoading = false;
    });
  }

  Future<void> _loadAdminDashboard() async {
    setState(() => isLoading = true);

    final response = await ApiService().getAdminDashboard();

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;

      setState(() {
        totalStudents = data['total_students'] ?? 0;
        activeStudents = data['active_students'] ?? 0;
        totalClasses = data['total_classes'] ?? 0;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }
//   Future<void> _loadTeachersCount() async {
//   try {
//     final data = await ApiService().getTeachers();

//     setState(() {
//       totalTeachers = data.length;
//     });
//   } catch (e) {
//     print("Error loading teachers: $e");
//   }
// }
  Future<void> _loadTeachersCount() async {
    try {
      final response = await ApiService().getTeachers();

      setState(() {
        if (response.success && response.data != null) {
          totalTeachers = response.data!.length;
        } else {
          totalTeachers = 0;
        }
      });
    } catch (e) {
      print("Error loading teachers count: $e");
      setState(() {
        totalTeachers = 0;
      });
    }
  }


  Future<void> _loadEmployeeCount() async {
    final response = await ApiService().getEmployeeCount();

    if (response.success) {
      setState(() {
        totalEmployees = response.data ?? 0;
      });
    }
  }


  Future<void> _loadUnreadNotifications() async {
    final response = await ApiService().getUnreadNotificationsCount();

    if (response.success) {
      setState(() {
        unreadNotifications = response.data ?? 0;
      });
    }
  }

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
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            AppThemeResponsiveness.getDashboardHorizontalPadding(
                              context,
                            ),
                        vertical:
                            AppThemeResponsiveness.getDashboardVerticalPadding(
                              context,
                            ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          SizedBox(
                            height:
                                AppThemeResponsiveness.getDefaultSpacing(
                                  context,
                                ) *
                                1.2,
                          ),
                          _buildQuickStatsSection(context),
                          SizedBox(
                            height:
                                AppThemeResponsiveness.getDefaultSpacing(
                                  context,
                                ) *
                                1.6,
                          ),
                          SectionTitle(title: 'Quick Access'),
                          SizedBox(
                            height: AppThemeResponsiveness.getSmallSpacing(
                              context,
                            ),
                          ),
                          _buildDashboardGrid(context),
                          SizedBox(
                            height:
                                AppThemeResponsiveness.getDefaultSpacing(
                                  context,
                                ) *
                                1.2,
                          ),
                          SectionTitle(title: 'System Overview'),
                          SizedBox(
                            height: AppThemeResponsiveness.getSmallSpacing(
                              context,
                            ),
                          ),
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
      headerIcon: Icons.admin_panel_settings_rounded,
      headerTitle: adminData?.name ?? 'Administrator',
      headerSubtitle: adminData?.designation ?? 'Full System Control',
      sections: [
        ModernDrawerSection(
          title: 'Main',
          items: [
            ModernDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              route: '/admin-dashboard',
            ),
            ModernDrawerItem(
              icon: Icons.people_rounded,
              title: 'Student Management',
              route: '/admin-student-management',
            ),
            ModernDrawerItem(
              icon: Icons.work_rounded,
              title: 'Employee Management',
              route: '/admin-employee-management',
            ),
            ModernDrawerItem(
              icon: Icons.class_rounded,
              title: 'Class Management',
              route: '/admin-class-section-management',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Academic',
          items: [
            ModernDrawerItem(
              icon: Icons.grade_rounded,
              title: 'Academic Results',
              route: '/admin-academic-result-screen',
            ),
            ModernDrawerItem(
              icon: Icons.payment_rounded,
              title: 'Fee Management',
              route: '/admin-fee-management',
            ),
            ModernDrawerItem(
              icon: Icons.analytics_rounded,
              title: 'Reports & Analytics',
              route: '/admin-report-analytics',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Administration',
          items: [
            ModernDrawerItem(
              icon: Icons.person_add_alt_rounded,
              title: 'Add Applicant',
              route: '/admin-add-student-applicant',
            ),
            ModernDrawerItem(
              icon: Icons.add_rounded,
              title: 'Add Teacher',
              route: '/admin-add-teacher',
            ),
            ModernDrawerItem(
              icon: Icons.add_task,
              title: 'Add Designation',
              route: '/admin-add-designation',
            ),
            ModernDrawerItem(
              icon: Icons.notification_add_rounded,
              title: 'User Requests',
              route: '/admin-user-request',
              badge: '5',
            ),
            ModernDrawerItem(
              icon: Icons.settings_rounded,
              title: 'System Controls',
              route: '/admin-system-control',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Settings',
          items: [
            ModernDrawerItem(
              icon: Icons.person_rounded,
              title: 'My Profile',
              route: '/admin-profile',
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
    if (adminData == null) {
      return Container(); 
    }

    return WelcomeSection(
      name: adminData!.name,
      classInfo: adminData!.designation,
      isActive: true,
      isVerified: true,
      isSuperUser: true,
      icon: Icons.admin_panel_settings_rounded,
      // profileImageUrl: adminData!.profileImageUrl,
      // profileImageFile: _profileImage,
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickStatCard(
            title: 'Total Teachers',
            value: isLoading ? '...' : totalTeachers.toString(),
            icon: Icons.people_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.shade50,
            onTap: () =>
                Navigator.pushNamed(context, '/admin-teacher-management'),
          ),
          QuickStatCard(
            title: 'Total Students',
            value: isLoading ? '...' : totalStudents.toString(),
            icon: Icons.people_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.shade50,
            onTap: () =>
                Navigator.pushNamed(context, '/admin-student-management'),
          ),
          QuickStatCard(
            title: 'Total Employee',
            value: isLoading ? '...' : totalEmployees.toString(),
            icon: Icons.school_rounded,
            iconColor: Colors.green,
            iconBackgroundColor: Colors.green.shade50,
            onTap: () =>
                Navigator.pushNamed(context, '/admin-employee-management'),
          ),
          QuickStatCard(
            title: 'Pending Admissions',
            value: '23',
            icon: Icons.pending_rounded,
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.orange.shade50,
            onTap: () =>
                Navigator.pushNamed(context, '/admin-pending-admission'),
          ),
          QuickStatCard(
            title: 'Attendance Report',
            value: 'All',
            icon: Icons.bar_chart_outlined,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.shade50,
            onTap: () => Navigator.pushNamed(
              context,
              '/academic-officer-attendance-reports',
            ),
          ),
          QuickStatCard(
            title: 'Active Notices',
            value: isLoading ? '...' : unreadNotifications.toString(),
            icon: Icons.notifications_active_rounded,
            iconColor: Colors.red,
            iconBackgroundColor: Colors.red.shade50,
            onTap: () {
              Navigator.pushNamed(context, '/notifications').then((_) {
                
                _loadUnreadNotifications();
              });
            },
          ),
          QuickStatCard(
            title: 'System Health',
            value: adminData?.systemUptime ?? '98%',
            icon: Icons.health_and_safety_rounded,
            iconColor: Colors.teal,
            iconBackgroundColor: Colors.teal.shade50,
            onTap: () => Navigator.pushNamed(context, '/admin-system-health'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final items = [
      DashboardItem(
        'Student Management',
        Icons.people_rounded,
        Colors.blue,
        () => Navigator.pushNamed(context, '/admin-student-management'),
        'Manage student records & data',
      ),
      DashboardItem(
        'Employee Management',
        Icons.work_rounded,
        Colors.green,
        () => Navigator.pushNamed(context, '/admin-employee-management'),
        'Staff records & management',
      ),
      DashboardItem(
        'Class Management',
        Icons.class_rounded,
        Colors.orange,
        () => Navigator.pushNamed(context, '/admin-class-section-management'),
        'Classes & sections setup',
      ),
      DashboardItem(
        'Fee Management',
        Icons.payment_rounded,
        Colors.purple,
        () => Navigator.pushNamed(context, '/admin-fee-management'),
        'Fee collection & tracking',
      ),
      DashboardItem(
        'Fee Structure Management',
        Icons.payment_rounded,
        Colors.blueGrey,
        () => Navigator.pushNamed(context, '/admin-fee-structure'),
        'Adding fess',
      ),
      DashboardItem(
        'Salary Management',
        Icons.payment_rounded,
        Colors.yellow,
        () => Navigator.pushNamed(context, '/admin-salary-management'),
        'Fee collection & tracking',
      ),
      DashboardItem(
        'Reports & Analytics',
        Icons.analytics_rounded,
        Colors.teal,
        () => Navigator.pushNamed(context, '/admin-report-analytics'),
        'Data insights & reports',
      ),
      DashboardItem(
        'Add New Applicant',
        Icons.person_add_alt_rounded,
        Colors.brown,
        () => Navigator.pushNamed(context, '/admin-add-student-applicant'),
        'New student applications',
      ),
      DashboardItem(
        'Add Teacher',
        Icons.add_rounded,
        Colors.green,
        () => Navigator.pushNamed(context, '/admin-add-teacher'),
        'Register new teaching staff',
      ),
      DashboardItem(
        'Add Designation',
        Icons.add_task,
        Colors.deepOrangeAccent,
        () => Navigator.pushNamed(context, '/admin-add-designation'),
        'Register new teaching staff',
      ),
      DashboardItem(
        'User Requests',
        Icons.notification_add_rounded,
        Colors.deepPurple,
        () => Navigator.pushNamed(context, '/admin-user-request'),
        'Handle user requests',
        badge: userRequestCount > 0 ? userRequestCount.toString() : null,
      ),

      DashboardItem(
        'System Controls',
        Icons.settings_rounded,
        Colors.red.shade700,
        () => Navigator.pushNamed(context, '/admin-system-control'),
        'System configuration',
      ),
      DashboardItem(
        'Academic Options',
        Icons.sports_rounded,
        Colors.black45,
        () => Navigator.pushNamed(context, '/academic-options'),
        'Academic year & settings',
      ),
      DashboardItem(
        'Add Time Table',
        Icons.add_alarm_outlined,
        Colors.indigo,
        () => Navigator.pushNamed(context, '/admin-add-timetable'),
        'Academic year & settings',
      ),
      DashboardItem(
        'View Document',
        Icons.document_scanner,
        Colors.pink,
        () => Navigator.pushNamed(context, '/admin-document-submitted'),
        'Documents submitted',
      ),
      DashboardItem(
        'Profile',
        Icons.person,
        Colors.teal,
        () => Navigator.pushNamed(context, '/admin-profile'),
        'About Me',
      ),
      DashboardItem(
        'Quick Actions',
        Icons.flash_on_rounded,
        Colors.amber.shade700,
        () => _showQuickActionsDialog(context),
        'Shortcuts & quick tasks',
      ),
    ];

    // return DashboardGrid(items: items);
    return LayoutBuilder(
    builder: (context, constraints) {
      int crossAxisCount = 2;

      if (constraints.maxWidth > 1200) {
        crossAxisCount = 5; // desktop
      } else if (constraints.maxWidth > 900) {
        crossAxisCount = 4; // tablet landscape
      } else if (constraints.maxWidth > 600) {
        crossAxisCount = 3; // tablet
      } else {
        crossAxisCount = 2; // mobile
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8, // 🔥 THIS FIXES OVERFLOW
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 30, color: item.color),
                  SizedBox(height: 10),

                  /// 🔥 TITLE FIX
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 6),

                  /// 🔥 SUBTITLE FIX
                  Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  }
  

  void _showQuickActionsDialog(BuildContext context) {
    return QuickActionsDialog.show(
      context,
      actions: [
        QuickActionItem(
          icon: Icons.person_add_rounded,
          color: Colors.blue,
          title: 'Add New Student',
          subtitle: 'Enroll new students quickly',
          route: '/admin-add-student-applicant',
        ),
        QuickActionItem(
          icon: Icons.work_outline_rounded,
          color: Colors.green,
          title: 'Add New Employee',
          subtitle: 'Register new staff members',
          route: '/admin-add-teacher',
        ),
        QuickActionItem(
          icon: Icons.announcement_rounded,
          color: Colors.orange,
          title: 'Add New Designation',
          subtitle: 'Register new position',
          route: '/admin-add-designation',
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return RecentActivityCard(
      items: const [
        ActivityItem(
          icon: Icons.trending_up_rounded,
          title: 'System Performance: Excellent',
          time: '99.8% uptime',
          color: Colors.green,
        ),
        ActivityItem(
          icon: Icons.storage_rounded,
          title: 'Database Status: Healthy',
          time: 'Last backup: 2 hours ago',
          color: Colors.blue,
        ),
        ActivityItem(
          icon: Icons.security_rounded,
          title: 'Security: All systems secure',
          time: 'No threats detected',
          color: Colors.purple,
        ),
      ],
    );
  }
}
