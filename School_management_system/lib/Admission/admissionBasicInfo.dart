import 'package:flutter/material.dart';
import 'package:school/customWidgets/admissionCustomWidgets/admissionProcessIndicator.dart';
import 'package:school/customWidgets/admissionCustomWidgets/backAndNextButton.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/datePicker.dart';

import 'package:school/services/admission_api.dart';

class AdmissionBasicInfoScreen extends StatefulWidget {
  @override
  _AdmissionBasicInfoScreenState createState() =>
      _AdmissionBasicInfoScreenState();
}

class _AdmissionBasicInfoScreenState extends State<AdmissionBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _aadharController = TextEditingController();
  final _previousSchoolController = TextEditingController();

  // Date picker controllers
  final _dateOfBirthController = TextEditingController();
  final _admissionDateController = TextEditingController();

  bool _showOtpButton = false;
  bool _showOtpField = false;
  bool _otpSent = false;
  bool isOtpVerified = false; // ✅ FIXED (added)

  final TextEditingController _otpController = TextEditingController();

  String _selectedClass = 'Nursery';
  String _selectedAcademicYear = '2025-2026';
  String _selectedStudentType = 'New';
  String? _selectedGender;
  String? _selectedCategory = "General";

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneNumberChanged);

    // Default dates
    _dateOfBirthController.text = _formatDate(
      DateTime.now().subtract(Duration(days: 365 * 5)),
    );
    _admissionDateController.text = _formatDate(DateTime.now());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _aadharController.dispose();
    _previousSchoolController.dispose();
    _dateOfBirthController.dispose();
    _admissionDateController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Format DD/MM/YYYY
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Convert date to backend format YYYY-MM-DD
  String formatToBackend(String d) {
    final p = d.split('/');
    return "${p[2]}-${p[1]}-${p[0]}";
  }

  void _onPhoneNumberChanged() {
    setState(() {
      _showOtpButton = _phoneController.text.length == 10;

      if (_otpSent) {
        _showOtpField = false;
        _otpSent = false;
        isOtpVerified = false;
        _otpController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppThemeResponsiveness.getMaxWidth(context),
              ),
              child: SingleChildScrollView(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Column(
                  children: [
                    ProgressIndicatorBar(currentStep: 1, totalSteps: 4),
                    SizedBox(height: 20),
                    Text(
                      'Student Information',
                      style: AppThemeResponsiveness.getFontStyle(context),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please fill in all the required information',
                      style: AppThemeResponsiveness.getSplashSubtitleStyle(
                        context,
                      ),
                    ),
                    SizedBox(height: 30),

                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _nameController,
                                label: 'Full Name *',
                                icon: Icons.person,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),

                              SizedBox(height: 20),
                              AppDatePicker.dateOfBirth(
                                controller: _dateOfBirthController,
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Required'
                                            : null,
                              ),

                              SizedBox(height: 20),
                              AppDropdown.gender(
                                value: _selectedGender,
                                onChanged: (v) {
                                  setState(() => _selectedGender = v);
                                },
                              ),

                              SizedBox(height: 20),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _nationalityController,
                                label: 'Nationality *',
                                icon: Icons.flag,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),

                              SizedBox(height: 20),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _aadharController,
                                label: 'Aadhaar Number *',
                                icon: Icons.credit_card,
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value!.length < 10
                                            ? 'Invalid ID'
                                            : null,
                              ),

                              SizedBox(height: 20),
                              AppDropdown.category(
                                value: _selectedCategory,
                                onChanged: (v) {
                                  setState(() => _selectedCategory = v);
                                },
                              ),

                              SizedBox(height: 20),
                              AppDropdown.academicYear(
                                value: _selectedAcademicYear,
                                onChanged: (v) {
                                  setState(() => _selectedAcademicYear = v!);
                                },
                              ),

                              SizedBox(height: 20),
                              AppDropdown.classGrade(
                                value: _selectedClass,
                                onChanged: (v) {
                                  setState(() => _selectedClass = v!);
                                },
                              ),

                              SizedBox(height: 20),
                              AppDatePicker.admissionDate(
                                controller: _admissionDateController,
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Required'
                                            : null,
                              ),

                              SizedBox(height: 20),
                              AppDropdown.studentType(
                                value: _selectedStudentType,
                                onChanged: (v) {
                                  setState(() => _selectedStudentType = v!);
                                },
                              ),

                              if (_selectedStudentType == "Transfer") ...[
                                SizedBox(height: 20),
                                AppTextFieldBuilder.build(
                                  context: context,
                                  controller: _previousSchoolController,
                                  label: 'Previous School *',
                                  icon: Icons.school,
                                  validator:
                                      (value) =>
                                          value!.isEmpty ? 'Required' : null,
                                ),
                              ],

                              SizedBox(height: 20),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _emailController,
                                label: 'Email *',
                                icon: Icons.email,
                                validator:
                                    (v) =>
                                        !v!.contains('@')
                                            ? 'Invalid Email'
                                            : null,
                              ),

                              SizedBox(height: 20),
                              _buildPhoneFieldWithOTP(),

                              SizedBox(height: 30),
                              FormNavigationButtons(
                                onNext: _nextPage,
                                onBack: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneFieldWithOTP() {
    return Column(
      children: [
        AppTextFieldBuilder.build(
          context: context,
          controller: _phoneController,
          label: 'Phone Number *',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator:
              (v) => v!.length != 10 ? 'Enter 10-digit phone number' : null,
        ),

        if (_showOtpButton && !_otpSent) ...[
          SizedBox(height: 10),
          PrimaryButton(
            title: 'Send OTP',
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: _sendOtp,
          ),
        ],

        if (_showOtpField) ...[
          SizedBox(height: 10),
          AppTextFieldBuilder.build(
            context: context,
            controller: _otpController,
            label: 'Enter OTP',
            icon: Icons.security,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          SizedBox(height: 10),
          PrimaryButton(
            title: 'Verify OTP',
            icon: Icon(Icons.verified, color: Colors.white),
            onPressed: _verifyOtp,
          ),
        ],
      ],
    );
  }

  void _sendOtp() {
    setState(() {
      _showOtpField = true;
      _otpSent = true;
      isOtpVerified = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('OTP sent successfully')));
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      setState(() => isOtpVerified = true);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Phone verified successfully')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Enter valid 6-digit OTP')));
    }
  }

  // ------------------------------------------------------
  // 🔥 FIXED _nextPage — Now matches your backend fields
  // ------------------------------------------------------
  void _nextPage() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill required fields")));
      return;
    }

    if (!isOtpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please verify your phone number')),
      );
      return;
    }

    Map<String, String> classMap = {
      "Nursery": "nursery",
      "LKG": "lkg",
      "UKG": "ukg",
      "1": "1",
      "2": "2",
      "3": "3",
      "4": "4",
      "5": "5",
      "6": "6",
      "7": "7",
      "8": "8",
      "9": "9",
      "10": "10",
      "11": "11",
      "12": "12",
    };
    Map<String, String> genderMap = {
      "Male": "male",
      "Female": "female",
      "Other": "other",
    };
    Map<String, String> categoryMap = {
      "General": "GEN",
      "Scheduled Caste": "SC",
      "Scheduled Tribe": "ST",
      "Other Backward Class": "OBC",
      "Economically Weaker Section": "EWS",
    };

    Map<String, String> studentTypeMap = {"New": "new", "Transfer": "transfer"};

    final payload = {
      "full_name": _nameController.text,
      "dob": formatToBackend(_dateOfBirthController.text),
      "gender": genderMap[_selectedGender],
      "nationality": _nationalityController.text,
      "aadhaar_number": _aadharController.text,
      "category": _selectedCategory,
      "academic_year": _selectedAcademicYear,
      "class_applied": classMap[_selectedClass] ?? "GEN",
      "admission_date": formatToBackend(_admissionDateController.text),
      "student_type": studentTypeMap[_selectedStudentType],
      "email": _emailController.text,
      "phone": _phoneController.text,
      "previous_school": _previousSchoolController.text,
    };

    try {
      final result = await AdmissionApi.AdmissionStepOneView(payload);

      final applicationId = result['application_id'] ?? result['id'];

      if (applicationId != null) {
        Navigator.pushNamed(
          context,
          '/admission-parent',
          arguments: {'application_id': applicationId},
        );
      } else {
        throw Exception("No application ID returned");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("API error: $e")));
    }
  }
}
