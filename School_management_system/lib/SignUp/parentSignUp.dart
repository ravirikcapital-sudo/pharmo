import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/loginCustomWidgets/loginSPanText.dart';
import 'package:school/customWidgets/loginCustomWidgets/signUpTitle.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/customWidgets/validation.dart';
import 'package:school/services/api_services.dart';

class ParentSignUpPage extends StatefulWidget {
  @override
  _ParentSignUpPageState createState() => _ParentSignUpPageState();
}

class _ParentSignUpPageState extends State<ParentSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _alternateNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _childAdmissionNoController = TextEditingController();

  // Dropdown Values
  String? _selectedRelationship;

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
                    // Responsive Title Section using reusable widget
                    TitleSection(accountType: 'Parent'),

                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                    // Responsive Form Fields Layout
                    _buildFormLayout(context),

                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                    // Responsive Register Button using reusable CustomButton
                    PrimaryButton(
                      title: 'Create Account',
                      onPressed: _isLoading ? null : _handleParentSignup,
                      isLoading: _isLoading,
                      icon: _isLoading ? null : Icon(Icons.person_add, color: Colors.white),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                    // Responsive Login Link using reusable widget
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

    // Determine the number of columns based on screen size - simplified like teacher signup
    int columns;
    if (AppThemeResponsiveness.isMobile(context)) {
      columns = 1;
    } else { // Desktop and Tablet
      columns = 2; // Use 2 columns for cleaner layout
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
            // Relationship to Child
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppDropdown.relationship(
                value: _selectedRelationship,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRelationship = newValue;
                  });
                },
              ),
            ),
            // Child's Admission Number
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _childAdmissionNoController,
                label: 'Child\'s Admission Number',
                icon: Icons.confirmation_number,
                keyboardType: TextInputType.text,
                validator: _validateChildAdmissionNo,
              ),
            ),
            // Mobile Number
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _mobileNumberController,
                label: 'Mobile Number',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                validator: ValidationUtils.validatePhone,
              ),
            ),
            // Alternate Number (Optional)
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _alternateNumberController,
                label: 'Alternate Number (Optional)',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: null, // Optional field
              ),
            ),
            // Address
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _addressController,
                label: 'Address',
                icon: Icons.home,
                keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
            ),
            // City
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _cityController,
                label: 'City',
                icon: Icons.location_city,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
            ),
            // State
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _stateController,
                label: 'State',
                icon: Icons.map,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
              ),
            ),
            // Zip Code
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _zipCodeController,
                label: 'Zip Code',
                icon: Icons.pin_drop,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter zip code';
                  }
                  if (value.trim().length < 5) {
                    return 'Please enter valid zip code';
                  }
                  return null;
                },
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
                    color: const Color(0xFF6B7280),
                    size: AppThemeResponsiveness.getIconSize(context) * 0.9,
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
                    color: const Color(0xFF6B7280),
                    size: AppThemeResponsiveness.getIconSize(context) * 0.9,
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

  // Updated field width calculation method - simplified like teacher signup
  double _getFieldWidth(BuildContext context, BoxConstraints constraints, int columns) {
    if (columns == 1) {
      return double.infinity;
    } else {
      final double largeSpacing = AppThemeResponsiveness.getLargeSpacing(context);
      return (constraints.maxWidth / columns) - (largeSpacing * (columns - 1) / columns);
    }
  }

  // Validation Methods specific to Parent signup
  String? _validateChildAdmissionNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter child\'s admission number';
    }
    if (value.trim().length < 3) {
      return 'Admission number must be at least 3 characters';
    }
    return null;
  }

  void _handleParentSignup() async {
    if (_formKey.currentState!.validate()) {
      // Additional validation for dropdown
      if (_selectedRelationship == null) {
        AppSnackBar.show(
          context,
          message: 'Please select relationship',
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Call actual API
        final response = await ApiService().registerParent(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          relationship: _selectedRelationship,
          childAdmissionNumber: _childAdmissionNoController.text.trim(),
          mobileNumber: _mobileNumberController.text.trim(),
          alternateNumber: _alternateNumberController.text.trim().isEmpty ? null : _alternateNumberController.text.trim(),
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          zipCode: _zipCodeController.text.trim(),
        );

        if (mounted) {
          if (response.success) {
            AppSnackBar.show(
              context,
              message: response.message ?? 'Parent account created successfully!',
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
    _mobileNumberController.dispose();
    _alternateNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _childAdmissionNoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}