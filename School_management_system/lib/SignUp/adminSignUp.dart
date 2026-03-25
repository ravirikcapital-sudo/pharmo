import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/loginCustomWidgets/loginSPanText.dart';
import 'package:school/customWidgets/loginCustomWidgets/signUpTitle.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/customWidgets/validation.dart';
import 'package:school/services/api_services.dart';

class AdminSignupPage extends StatefulWidget {
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Date Controllers - Using TextEditingController for AppDatePicker
  final _dateOfJoiningController = TextEditingController();

  // Password Visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Dropdown Values
  String? _selectedRole = 'Admin';
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: AppThemeResponsiveness.getMaxWidth(context),
              ),
              child: _buildResponsiveFormCard(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveFormCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Container(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: !AppThemeResponsiveness.isMobile(context),
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardPadding(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Responsive Title Section using reusable component
                    TitleSection(accountType: 'Admin'),

                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                    // Responsive Form Fields Layout
                    _buildFormLayout(context),

                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                    // Responsive Register Button using reusable CustomButton
                    PrimaryButton(
                      title: 'Create Account',
                      onPressed: _isLoading ? null : _handleAdminSignup,
                      isLoading: _isLoading,
                      icon: _isLoading ? null : Icon(Icons.admin_panel_settings, color: Colors.white),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    LoginRedirectText(context: context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLayout(BuildContext context) {
    final double spacing = AppThemeResponsiveness.getMediumSpacing(context);
    final double largeSpacing = AppThemeResponsiveness.getLargeSpacing(context);

    // Determine the number of columns based on screen size
    int columns;
    if (AppThemeResponsiveness.isMobile(context)) {
      columns = 1;
    }  else { // Desktop
      columns = 2; // For desktop, we can have 3 columns for admin form
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: largeSpacing, // Horizontal spacing between items
          runSpacing: spacing, // Vertical spacing between lines of items
          alignment: WrapAlignment.center, // Center items when they wrap
          children: [
            // Full Name
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _fullNameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: ValidationUtils.validateFullName,
              ),
            ),
            // Email Address
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: ValidationUtils.validateEmail,
              ),
            ),
            // Phone Number
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: ValidationUtils.validatePhone,
              ),
            ),
            // Role Dropdown - Using AppDropdown.role()
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppDropdown.role(
                value: _selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                validator: ValidationUtils.validateRole,
                customRoles: ['Admin', 'Academic Officer'], // Restrict to specific roles for admin signup
              ),
            ),
            // Gender Dropdown - Using AppDropdown.gender()
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppDropdown.gender(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                validator: ValidationUtils.validateGender,
              ),
            ),
            // Date of Joining - Using AppDatePicker
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppDatePicker.genericDate(
                controller: _dateOfJoiningController,
                label: 'Date of Joining',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date of joining';
                  }
                  return ValidationUtils.validateJoiningDate(_parseDateFromString(value));
                },
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365 * 10)), // 10 years ago
                lastDate: DateTime.now(),
                dateFormat: 'dd/MM/yyyy',
              ),
            ),
            // Password
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: Colors.grey[600],
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: ValidationUtils.validatePassword,
              ),
            ),
            // Confirm Password
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: Colors.grey[600],
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getFieldWidth(BuildContext context, BoxConstraints constraints, int columns) {
    if (columns == 1) {
      return double.infinity;
    } else {
      final double largeSpacing = AppThemeResponsiveness.getLargeSpacing(context);
      return (constraints.maxWidth / columns) - (largeSpacing * (columns - 1) / columns);
    }
  }

  // Helper method to parse date from string for validation
  DateTime? _parseDateFromString(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return null;
  }

  void _handleAdminSignup() async {
    if (_formKey.currentState!.validate()) {
      // Additional validation for dropdowns
      if (_selectedGender == null) {
        AppSnackBar.show(
          context,
          message: 'Please select gender',
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Convert date from dd/MM/yyyy to yyyy-MM-dd for API
        final parsedDate = _parseDateFromString(_dateOfJoiningController.text);
        String formattedDate = '';
        if (parsedDate != null) {
          formattedDate = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
        }

        // Call actual API
        final response = await ApiService().registerAdmin(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          gender: _selectedGender!,
          role: _selectedRole ?? 'Admin',
          dateOfJoining: formattedDate,
        );

        if (mounted) {
          if (response.success) {
            AppSnackBar.show(
              context,
              message: response.message ?? 'Admin account created successfully!',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          } else {
            String errorMessage = response.message ?? 'Registration failed';
            if (response.errors != null && response.errors!.isNotEmpty) {
              errorMessage = response.errors!.values.first.toString();
            }
            AppSnackBar.show(
              context,
              message: errorMessage,
              backgroundColor: Colors.red,
              icon: Icons.error,
            );
          }
        }
      } catch (error) {
        if (mounted) {
          AppSnackBar.show(
            context,
            message: 'Network error. Please check your connection and try again.',
            backgroundColor: Colors.red,
            icon: Icons.error,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfJoiningController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}