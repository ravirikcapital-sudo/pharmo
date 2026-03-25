import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/loginCustomWidgets/loginSPanText.dart';
import 'package:school/customWidgets/loginCustomWidgets/signUpTitle.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/customWidgets/validation.dart';
import 'package:school/services/api_services.dart';

class StudentSignupPage extends StatefulWidget {
  @override
  _StudentSignupPageState createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends State<StudentSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password Visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

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
                    // Responsive Title Section
                    TitleSection(accountType: 'Student'),

                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                    // Responsive Form Fields Layout
                    _buildFormLayout(context),

                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                    // Responsive Register Button using CustomButton
                    PrimaryButton(
                      title: 'Create Account',
                      onPressed: _isLoading ? null : _handleStudentSignup,
                      isLoading: _isLoading,
                      icon: _isLoading ? null : Icon(Icons.person_add, color: Colors.white),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    LoginRedirectText(context: context)
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

    if (AppThemeResponsiveness.isMobile(context)) {
      // Mobile: Single column layout
      return Column(
        children: [
          // Full Name
          AppTextFieldBuilder.build(
            context: context,
            controller: _fullNameController,
            label: 'Full Name',
            icon: Icons.person,
            validator: ValidationUtils.validateFullName,
          ),
          SizedBox(height: spacing),

          // Email Address
          AppTextFieldBuilder.build(
            context: context,
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: ValidationUtils.validateEmail,
          ),
          SizedBox(height: spacing),

          // Phone Number
          AppTextFieldBuilder.build(
            context: context,
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: ValidationUtils.validatePhone,
          ),
          SizedBox(height: spacing),

          // Password
          AppTextFieldBuilder.build(
            context: context,
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: const Color(0xFF6B7280),
                size: AppThemeResponsiveness.getIconSize(context) * 0.9,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: ValidationUtils.validatePassword,
          ),
          SizedBox(height: spacing),

          // Confirm Password
          AppTextFieldBuilder.build(
            context: context,
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: const Color(0xFF6B7280),
                size: AppThemeResponsiveness.getIconSize(context) * 0.9,
              ),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
          ),
        ],
      );
    } else {
      // Desktop/Tablet: Multi-column layout (2-2-1)
      return Column(
        children: [
          // First Row: Full Name and Email (2 columns)
          Row(
            children: [
              Expanded(
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: ValidationUtils.validateFullName,
                ),
              ),
              SizedBox(width: largeSpacing),
              Expanded(
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationUtils.validateEmail,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),

          // Second Row: Password and Confirm Password (2 columns)
          Row(
            children: [
              Expanded(
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: const Color(0xFF6B7280),
                      size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: ValidationUtils.validatePassword,
                ),
              ),
              SizedBox(width: largeSpacing),
              Expanded(
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: const Color(0xFF6B7280),
                      size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),

          // Third Row: Phone Number (1 column, centered)
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(), // Empty space
              ),
              Expanded(
                flex: 2,
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: ValidationUtils.validatePhone,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(), // Empty space
              ),
            ],
          ),
        ],
      );
    }
  }

  void _handleStudentSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call actual API
        final response = await ApiService().registerStudent(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

        if (mounted) {
          if (response.success) {
            AppSnackBar.show(
              context,
              message: response.message ?? 'Student account created successfully!',
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
    _scrollController.dispose();
    super.dispose();
  }
}