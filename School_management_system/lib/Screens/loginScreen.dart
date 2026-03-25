import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/loginCustomWidgets/userTypeSelection.dart';
import 'package:school/customWidgets/snackBar.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _userType;
  bool _showUserTypeError = false;

  @override
  void initState() {
    super.initState();
    _checkExistingLogin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check if user is already logged in
  Future<void> _checkExistingLogin() async {
    try {
      bool isLoggedIn = await _apiService.isLoggedIn();
      if (isLoggedIn) {
        // Try to get current user to validate token
        final response = await _apiService.getCurrentUserFromAPI();
        if (response.success && response.data != null) {
          _navigateToDashboard();
        } else {
          // Token might be expired, try to refresh
          // If refresh fails, user will need to login again
          print('Token validation failed, user needs to login again');
        }
      }
    } catch (e) {
      print('Error checking existing login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      backgroundColor: AppThemeColor.blue50,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
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
    return Row(
      children: [
        // Left side - Welcome section
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getLargeSpacing(context)),
            constraints: BoxConstraints(
              maxWidth: AppThemeResponsiveness.getMaxWidth(context) * 0.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                Text(
                  'Streamline your educational experience with our comprehensive school management system.',
                  style: AppThemeResponsiveness.getSplashSubtitleStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.isDesktop(context) ? 18 : 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right side - Login form
        Expanded(
          flex: 1,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: AppThemeResponsiveness.getScreenHeight(context) * 0.9,
            ),
            padding: AppThemeResponsiveness.getScreenPadding(context),
            child: Center(
              child: SingleChildScrollView(
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        // Header section with reduced height
        _buildHeader(),
        // Login form section - takes remaining space
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: _buildLoginForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.isDesktop(context)
            ? AppThemeResponsiveness.getDashboardCardPadding(context)
            : AppThemeResponsiveness.getSmallSpacing(context),
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: AppThemeResponsiveness.isDesktop(context)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'login_logo',
            child: Container(
              width: AppThemeResponsiveness.isDesktop(context)
                  ? AppThemeResponsiveness.getLogoSize(context) * 1.5
                  : AppThemeResponsiveness.getLogoSize(context) * 1.2,
              height: AppThemeResponsiveness.isDesktop(context)
                  ? AppThemeResponsiveness.getLogoSize(context) * 1.5
                  : AppThemeResponsiveness.getLogoSize(context) * 1.2,
              decoration: BoxDecoration(
                color: AppThemeColor.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.school_rounded,
                size: AppThemeResponsiveness.isDesktop(context)
                    ? AppThemeResponsiveness.getLogoSize(context) * 0.75
                    : AppThemeResponsiveness.getLogoSize(context) * 0.6,
                color: AppThemeColor.primaryBlue600,
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Welcome Back!',
            style: AppThemeResponsiveness.getFontStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.isSmallPhone(context)
                  ? 22
                  : AppThemeResponsiveness.isMobile(context)
                  ? 26
                  : 32,
              letterSpacing: -0.5,
            ),
            textAlign: AppThemeResponsiveness.isDesktop(context)
                ? TextAlign.left
                : TextAlign.center,
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          Text(
            'Sign in to continue your learning journey',
            style: AppThemeResponsiveness.getSplashSubtitleStyle(context).copyWith(
              height: 1.3,
              fontSize: AppThemeResponsiveness.isSmallPhone(context) ? 13 : 14,
            ),
            textAlign: AppThemeResponsiveness.isDesktop(context)
                ? TextAlign.left
                : TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      margin: AppThemeResponsiveness.getHorizontalPadding(context),
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.isDesktop(context) ? 500 : double.infinity,
      ),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Login as',
                style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! + 2,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              // User Type Selection Widget
              UserTypeSelection(
                selectedUserType: _userType,
                onUserTypeSelected: (userType) {
                  setState(() {
                    _userType = userType;
                    _showUserTypeError = false;
                  });
                },
                showError: _showUserTypeError,
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Email Field
              AppTextFieldBuilder.build(
                context: context,
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

              // Password Field
              AppTextFieldBuilder.build(
                context: context,
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: const Color(0xFF6B7280),
                    size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your password' : null,
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Remember Me Row
              _buildRememberMeRow(),
              SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

              // Login Button
              _buildLoginButton(),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Divider
              _buildDivider(),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Quick Actions
              _buildQuickActions(),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _rememberMe = !_rememberMe;
            });
            HapticFeedback.lightImpact();
          },
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _rememberMe ? AppThemeColor.primaryBlue : Colors.transparent,
                  border: Border.all(
                    color: _rememberMe ? AppThemeColor.primaryBlue : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Remember me',
                style: AppThemeResponsiveness.getCaptionTextStyle(context),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forget-password');
          },
          child: Text(
            'Forgot Password?',
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: AppThemeColor.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return PrimaryButton(
      title: 'Sign In',
      onPressed: _login,
      isLoading: _isLoading,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getMediumSpacing(context),
          ),
          child: Text(
            'or',
            style: AppThemeResponsiveness.getCaptionTextStyle(context),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            'Change Password',
            Icons.lock_reset_rounded,
                () => Navigator.pushNamed(context, '/change-password'),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(
          child: _buildQuickActionButton(
            'New Admission',
            Icons.person_add_rounded,
                () => Navigator.pushNamed(context, '/admission-main'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
      String title, IconData icon, VoidCallback onTap) {
    return Container(
      height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppThemeResponsiveness.getIconSize(context) * 0.7,
                color: const Color(0xFF6B7280),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                title,
                style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated login function using ApiService
  void _login() async {
    bool isFormValid = _formKey.currentState!.validate();

    if (_userType == null) {
      setState(() {
        _showUserTypeError = true;
      });
    }

    if (!isFormValid || _userType == null) {
      if (_userType == null) {
        _showError('Please select a user type');
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use ApiService for login
      final response = await _apiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (response.success && response.data != null) {
        // Check if user role matches selected type
        final user = response.data!;
        if (_isRoleMatching(user.role, _userType!)) {
          // Save remember me preference
          if (_rememberMe) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('remember_me', true);
          }

          setState(() => _isLoading = false);
          _showSuccess('Login successful!');
          _navigateToDashboard();
        } else {
          setState(() => _isLoading = false);
          await _apiService.logout(); // Clear stored data
          _showError('Selected user type does not match your account role');
        }
      } else {
        setState(() => _isLoading = false);
        _showError(response.message ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Network error. Please check your connection.');
      print('Login error: $e');
    }
  }

  // Check if selected user type matches the user's role
  bool _isRoleMatching(String userRole, String selectedType) {
    Map<String, String> roleMapping = {
      'Student': 'Student',
      'Teacher': 'Teacher',
      'Parent': 'Parent',
      'Admin': 'Admin',
      'Academic Officer': 'Academic Officer',
    };

    return roleMapping[userRole] == selectedType;
  }

  // Navigate to appropriate dashboard based on user role
  void _navigateToDashboard() async {
    final user = await _apiService.getCurrentUser();
    if (user == null) {
      _showError('Failed to get user information');
      return;
    }

    switch (user.role) {
      case 'Student':
        Navigator.pushReplacementNamed(context, '/student-dashboard');
        break;
      case 'Teacher':
        Navigator.pushReplacementNamed(context, '/teacher-dashboard');
        break;
      case 'Parent':
        Navigator.pushReplacementNamed(context, '/parent-dashboard');
        break;
      case 'Admin':
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
        break;
      case 'Academic Officer':
        Navigator.pushReplacementNamed(context, '/academic-officer-dashboard');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _showError(String message) {
    AppSnackBar.show(
      context,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  void _showSuccess(String message) {
    AppSnackBar.show(
      context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }
}