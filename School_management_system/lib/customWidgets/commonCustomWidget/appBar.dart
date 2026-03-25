import 'package:flutter/material.dart';
import 'package:school/Admission/admissionMainScreen.dart';
import 'package:school/Dashboard/academicOfficerDashboard.dart';
import 'package:school/Dashboard/adminDashboard.dart';
import 'package:school/Dashboard/parentsDashBoard.dart';
import 'package:school/Dashboard/studentDashboard.dart';
import 'package:school/Dashboard/teacherDashboard.dart';
import 'package:school/Screens/loginScreen.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

// 1. First, create a User Role enum
enum UserRole {
  student,
  teacher,
  admin,
  parent,
  academicOfficer,
  guest, // for non-logged in users
}

// 2. Create a User Service to manage authentication state
class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._internal();
  UserService._internal();

  UserRole? _currentUserRole;
  String? _userId;
  Map<String, dynamic>? _userDetails;

  // Getters
  UserRole? get currentUserRole => _currentUserRole;
  String? get userId => _userId;
  Map<String, dynamic>? get userDetails => _userDetails;
  bool get isLoggedIn => _currentUserRole != null && _currentUserRole != UserRole.guest;

  // Set user data after login
  void setUser({
    required UserRole role,
    required String userId,
    Map<String, dynamic>? userDetails,
  }) {
    _currentUserRole = role;
    _userId = userId;
    _userDetails = userDetails;
  }

  // Clear user data on logout
  void clearUser() {
    _currentUserRole = null;
    _userId = null;
    _userDetails = null;
  }

  // Set guest user (not logged in)
  void setGuestUser() {
    _currentUserRole = UserRole.guest;
    _userId = null;
    _userDetails = null;
  }
}

// 3. Create a Navigation Service for role-based routing
class RoleBasedNavigationService {
  static const Map<UserRole, String> _roleRoutes = {
    UserRole.student: '/student-dashboard',
    UserRole.teacher: '/teacher-dashboard',
    UserRole.admin: '/admin-dashboard',
    UserRole.parent: '/parent-dashboard',
    UserRole.academicOfficer: '/academic-officer-dashboard',
    UserRole.guest: '/admission-form',
  };

  static void navigateBasedOnRole(BuildContext context) {
    try {
      final userService = UserService.instance;
      final userRole = userService.currentUserRole ?? UserRole.guest;

      final route = _roleRoutes[userRole];
      if (route != null) {
        Navigator.pushNamed(context, route);
      } else {
        // Fallback to admission form if role is not recognized
        Navigator.pushNamed(context, '/admission-form');
      }
    } catch (e) {
      debugPrint('Role-based navigation error: $e');
      // Fallback navigation
      Navigator.pushNamed(context, '/admission-form');
    }
  }

  // Method to get the appropriate route without navigation
  static String getRouteForRole(UserRole? role) {
    return _roleRoutes[role ?? UserRole.guest] ?? '/admission-form';
  }

  // Method to check if user has permission to access a route
  static bool canAccessRoute(UserRole? userRole, String route) {
    if (userRole == null) return route == '/admission-form' || route == '/login';

    final allowedRoute = _roleRoutes[userRole];
    return allowedRoute == route || _isPublicRoute(route);
  }

  static bool _isPublicRoute(String route) {
    const publicRoutes = [
      '/login',
      '/admission-form',
      '/about',
      '/contact',
      '/school-details',
    ];
    return publicRoutes.contains(route);
  }
}

// 4. Updated AppBarCustom with improved responsiveness
class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppThemeColor.white,
      iconTheme: const IconThemeData(
        color: Colors.black87,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      title: _buildResponsiveTitle(context),
      centerTitle: false,
      titleSpacing: AppThemeResponsiveness.getDefaultSpacing(context),
      toolbarHeight: AppThemeResponsiveness.getAppBarHeight(context),
    );
  }

  Widget _buildResponsiveTitle(BuildContext context) {
    return Row(
      children: [
        _buildSchoolLogo(context),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: _buildSchoolTitle(context),
        ),
      ],
    );
  }

  Widget _buildSchoolLogo(BuildContext context) {
    final logoSize = AppThemeResponsiveness.getLogoSize(context);

    return GestureDetector(
      onTap: () => _navigateToSchoolDetails(context),
      child: Container(
        width: logoSize,
        height: logoSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getResponsiveRadius(context, 8.0)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: AppThemeResponsiveness.getSmallSpacing(context) / 2,
              offset: Offset(0, AppThemeResponsiveness.getSmallSpacing(context) / 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getResponsiveRadius(context, 8.0)
          ),
          child: Image.asset(
            'assets/school.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackLogo(context, logoSize);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade100,
            Colors.orange.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getResponsiveRadius(context, 8.0)
        ),
      ),
      child: Icon(
        Icons.school_rounded,
        color: Colors.orange.shade700,
        size: AppThemeResponsiveness.getResponsiveIconSize(context, size * 0.6),
      ),
    );
  }

  Widget _buildSchoolTitle(BuildContext context) {
    const schoolName = 'Royal Public School';
    final fontSize = AppThemeResponsiveness.getResponsiveFontSize(context, 18.0);

    return GestureDetector(
      onTap: () => _navigateToRoleDashboard(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: schoolName,
              style: _getTextStyle(context, fontSize),
            ),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(maxWidth: constraints.maxWidth);

          final willOverflow = textPainter.didExceedMaxLines;

          return AnimatedContainer(
            duration: AppThemeColor.buttonAnimationDuration,
            child: Text(
              schoolName,
              style: _getTextStyle(context, fontSize),
              overflow: willOverflow ? TextOverflow.ellipsis : TextOverflow.visible,
              maxLines: 1,
            ),
          );
        },
      ),
    );
  }

  // Role-based dashboard navigation
  void _navigateToRoleDashboard(BuildContext context) {
    final userService = UserService.instance;

    // If user is not logged in, navigate to login
    if (!userService.isLoggedIn || userService.currentUserRole == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    // Navigate based on current user role
    RoleBasedNavigationService.navigateBasedOnRole(context);
  }

  TextStyle _getTextStyle(BuildContext context, double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      color: Colors.black87,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      shadows: [
        Shadow(
          offset: const Offset(0.5, 0.5),
          blurRadius: 2.0,
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }

  void _navigateToSchoolDetails(BuildContext context) {
    try {
      Navigator.pushNamed(context, '/school-details');
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }

  @override Size get preferredSize => const Size.fromHeight(56.0);
}

// 5. Route Guard Middleware
class RouteGuard {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final userRole = UserService.instance.currentUserRole;

    // Check if user can access the requested route
    if (!RoleBasedNavigationService.canAccessRoute(userRole, settings.name!)) {
      // Redirect to appropriate route based on role
      final appropriateRoute = RoleBasedNavigationService.getRouteForRole(userRole);
      return MaterialPageRoute(
        builder: (context) => _getPageForRoute(appropriateRoute),
        settings: RouteSettings(name: appropriateRoute),
      );
    }

    // Return the requested route if user has permission
    return MaterialPageRoute(
      builder: (context) => _getPageForRoute(settings.name!),
      settings: settings,
    );
  }

  static Widget _getPageForRoute(String route) {
    switch (route) {
      case '/student-dashboard':
        return StudentDashboard();
      case '/teacher-dashboard':
        return TeacherDashboard();
      case '/admin-dashboard':
        return AdminDashboard();
      case '/parent-dashboard':
        return ParentDashboard();
      case '/academic-officer-dashboard':
        return AcademicOfficerDashboard();
      case '/admission-form':
        return AdmissionMainScreen();
      default:
        return LoginPage();
    }
  }
}

// Extension for additional responsive utilities
extension ResponsiveExtension on BuildContext {
  bool get isMobile => AppThemeResponsiveness.isMobile(this);
  bool get isTablet => AppThemeResponsiveness.isTablet(this);
  bool get isDesktop => AppThemeResponsiveness.isDesktop(this);
  bool get isSmallPhone => AppThemeResponsiveness.isSmallPhone(this);
  bool get isMediumPhone => AppThemeResponsiveness.isMediumPhone(this);
  bool get isLargePhone => AppThemeResponsiveness.isLargePhone(this);

  double get screenWidth => AppThemeResponsiveness.getScreenWidth(this);
  double get screenHeight => AppThemeResponsiveness.getScreenHeight(this);
}