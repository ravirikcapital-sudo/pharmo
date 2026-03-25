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

class TeacherSignupPage extends StatefulWidget {
  @override
  _TeacherSignupPageState createState() => _TeacherSignupPageState();
}

class _TeacherSignupPageState extends State<TeacherSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceYearsController = TextEditingController();
  final _experienceDetailsController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Date Controllers - Using TextEditingController for AppDatePicker
  final _dateOfBirthController = TextEditingController();
  final _joiningDateController = TextEditingController();

  // Password Visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Dropdown values
  String? _selectedGender;
  String? _selectedSubject;
  String? _selectedDesignation;

  // Store subject and designation data with IDs
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _designations = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      // Load subjects - if endpoint doesn't exist, use fallback
      try {
        final subjectsResponse = await ApiService().getSubjects();
        setState(() {
          _subjects = subjectsResponse;
        });
      } catch (e) {
        debugPrint('Subjects endpoint not available: $e');
        // Use fallback - set empty so form shows text input
        setState(() {
          _subjects = [];
        });
      }

      // Load designations - if endpoint doesn't exist, use fallback
      try {
        final designationsResponse = await ApiService().getDesignations();
        if (designationsResponse.success && designationsResponse.data != null) {
          setState(() {
            _designations = designationsResponse.data!;
          });
        }
      } catch (e) {
        debugPrint('Designations endpoint not available: $e');
        // Use fallback - set empty, designation is optional anyway
        setState(() {
          _designations = [];
        });
      }
    } catch (e) {
      debugPrint('Error loading dropdown data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
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
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(
          context,
        ),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
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
                padding: EdgeInsets.all(
                  AppThemeResponsiveness.getDashboardCardPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Responsive Title Section
                    TitleSection(accountType: 'Teacher'),

                    SizedBox(
                      height: AppThemeResponsiveness.getExtraLargeSpacing(
                        context,
                      ),
                    ),

                    // Responsive Form Fields Layout
                    _buildFormLayout(context),

                    SizedBox(
                      height: AppThemeResponsiveness.getExtraLargeSpacing(
                        context,
                      ),
                    ),

                    // Responsive Register Button using CustomButton
                    PrimaryButton(
                      title: 'Create Account',
                      onPressed: _isLoading ? null : _handleTeacherSignup,
                      isLoading: _isLoading,
                      icon:
                          _isLoading
                              ? null
                              : Icon(
                                Icons.person_add_alt_1,
                                color: Colors.white,
                              ),
                    ),

                    SizedBox(
                      height: AppThemeResponsiveness.getMediumSpacing(context),
                    ),
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
    } else {
      // Desktop
      columns = 2; // For desktop, we can have 3 columns for teacher form
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
            // Gender Dropdown - Using AppDropdown
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
            // Date of Birth - Using AppDatePicker
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppDatePicker.dateOfBirth(
                controller: _dateOfBirthController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date of birth';
                  }
                  // Additional validation can be added here if needed
                  return ValidationUtils.validateDateOfBirth(
                    _parseDateFromString(value),
                  );
                },
              ),
            ),
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child:
                  _subjects.isEmpty
                      ? AppDropdown.subject(
                        value: _selectedSubject,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSubject = newValue;
                          });
                        },
                        validator: ValidationUtils.validateSubject,
                      )
                      : AppDropdown.custom<String>(
                        value: _selectedSubject,
                        items:
                            _subjects.map((s) => s['id'].toString()).toList(),
                        label: 'Subject *',
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSubject = newValue;
                          });
                        },
                        itemLabelBuilder: (id) {
                          final subject = _subjects.firstWhere(
                            (s) => s['id'].toString() == id,
                            orElse: () => {'name': 'Unknown'},
                          );
                          return subject['name'] ?? 'Unknown';
                        },
                        validator: ValidationUtils.validateSubject,
                        prefixIcon: Icons.book,
                      ),
            ),
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppDatePicker.genericDate(
                controller: _joiningDateController,
                label: 'Joining Date',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select joining date';
                  }
                  // Additional validation can be added here if needed
                  return ValidationUtils.validateJoiningDate(
                    _parseDateFromString(value),
                  );
                },
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)),
                dateFormat: 'dd/MM/yyyy',
              ),
            ),
            // Qualification (Optional)
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _qualificationController,
                label: 'Qualification (Optional)',
                icon: Icons.school,
                validator: null,
              ),
            ),
            // Experience Years (Optional)
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _experienceYearsController,
                label: 'Experience (Years)',
                icon: Icons.work,
                keyboardType: TextInputType.number,
                validator: null,
              ),
            ),
            // Experience Details (Optional)
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child: AppTextFieldBuilder.build(
                context: context,
                controller: _experienceDetailsController,
                label: 'Experience Details (Optional)',
                icon: Icons.description,
                maxLines: 3,
                validator: null,
              ),
            ),
            // Designation Dropdown (Optional)
            SizedBox(
              width: _getFieldWidth(context, constraints, columns),
              child:
                  _designations.isEmpty
                      ? AppDropdown.teacherDesignation(
                        value: _selectedDesignation,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDesignation = newValue;
                          });
                        },
                        validator: null,
                      )
                      : AppDropdown.custom<String>(
                        value: _selectedDesignation,
                        items:
                            _designations
                                .map((d) => d['id'].toString())
                                .toList(),
                        label: 'Designation (Optional)',
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDesignation = newValue;
                          });
                        },
                        itemLabelBuilder: (id) {
                          final designation = _designations.firstWhere(
                            (d) => d['id'].toString() == id,
                            orElse: () => {'title': 'Unknown'},
                          );
                          return designation['title'] ?? 'Unknown';
                        },
                        validator: null,
                        prefixIcon: Icons.badge,
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
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey[600],
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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
                    _obscureConfirmPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey[600],
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                  onPressed:
                      () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                ),
                validator:
                    (value) => ValidationUtils.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getFieldWidth(
    BuildContext context,
    BoxConstraints constraints,
    int columns,
  ) {
    if (columns == 1) {
      return double.infinity;
    } else {
      final double largeSpacing = AppThemeResponsiveness.getLargeSpacing(
        context,
      );
      return (constraints.maxWidth / columns) -
          (largeSpacing * (columns - 1) / columns);
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

  void _handleTeacherSignup() async {
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

      if (_selectedSubject == null) {
        AppSnackBar.show(
          context,
          message: 'Please select subject',
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Convert dates from dd/MM/yyyy to yyyy-MM-dd for API
        final parsedDob = _parseDateFromString(_dateOfBirthController.text);
        String formattedDob = '';
        if (parsedDob != null) {
          formattedDob =
              '${parsedDob.year}-${parsedDob.month.toString().padLeft(2, '0')}-${parsedDob.day.toString().padLeft(2, '0')}';
        }

        final parsedJoiningDate = _parseDateFromString(
          _joiningDateController.text,
        );
        String formattedJoiningDate = '';
        if (parsedJoiningDate != null) {
          formattedJoiningDate =
              '${parsedJoiningDate.year}-${parsedJoiningDate.month.toString().padLeft(2, '0')}-${parsedJoiningDate.day.toString().padLeft(2, '0')}';
        }

        // Call actual API
        print("===== TEACHER SIGNUP DATA =====");
        print("Full Name: ${_fullNameController.text}");
        print("Email: ${_emailController.text}");
        print("Phone: ${_phoneController.text}");
        print("Gender: $_selectedGender");
        print("DOB: $formattedDob");
        print("Joining Date: $formattedJoiningDate");
        print("Subject ID: ${_subjects.isEmpty ? 1 : _selectedSubject}");
        print("Qualification: ${_qualificationController.text}");
        print("Experience Years: ${_experienceYearsController.text}");
        print("Experience Details: ${_experienceDetailsController.text}");
        print("Designation ID: ${_selectedDesignation}");
        print("================================");
        final response = await ApiService().registerTeacher(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          gender: _selectedGender!.trim(),
          dateOfBirth: formattedDob,
          joiningDate: formattedJoiningDate,
          subjectId:
              _subjects.isEmpty
                  ? 1
                  : int.parse(
                    _selectedSubject!,
                  ), // If no backend data, send default ID 1
          qualification:
              _qualificationController.text.trim().isEmpty
                  ? null
                  : _qualificationController.text.trim(),
          experienceYears:
              _experienceYearsController.text.trim().isEmpty
                  ? null
                  : int.tryParse(_experienceYearsController.text.trim()),
          experienceDetails:
              _experienceDetailsController.text.trim().isEmpty
                  ? null
                  : _experienceDetailsController.text.trim(),
          designationId:
              _selectedDesignation != null
                  ? (_designations.isEmpty
                      ? 1
                      : int.parse(_selectedDesignation!))
                  : null, // If no backend data and selected, send default ID 1
        );

        if (mounted) {
          if (response.success) {
            AppSnackBar.show(
              context,
              message:
                  response.message ?? 'Teacher account created successfully!',
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
            message:
                'Network error. Please check your connection and try again.',
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
    _qualificationController.dispose();
    _experienceYearsController.dispose();
    _experienceDetailsController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    _joiningDateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
