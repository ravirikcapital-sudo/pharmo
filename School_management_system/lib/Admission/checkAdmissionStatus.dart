import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

import 'package:school/model/admission/admissionStatusModel.dart';

class AdmissionStatusScreen extends StatefulWidget {
  @override
  _AdmissionStatusScreenState createState() => _AdmissionStatusScreenState();
}

class _AdmissionStatusScreenState extends State<AdmissionStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _admissionNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  // Status Data
  bool _isSearching = false;
  bool _showStatus = false;
  AdmissionStatusData? _statusData;

  // Search Method
  String _searchMethod = 'admission'; // 'admission' or 'email'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                title: 'Check Admission Status',
                icon: Icons.check,
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                    vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
                  ),
                  child: Card(
                    elevation: AppThemeResponsiveness.getCardElevation(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppThemeResponsiveness.getCardBorderRadius(context),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        AppThemeResponsiveness.getExtraLargeSpacing(context),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitle(),
                              SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                              _buildSearchMethodSelector(),
                              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                              _buildSearchForm(),
                              SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                              _buildTrackButton(),
                              if (_showStatus) ...[
                                SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                                _buildStatusSection(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track Your Application',
          style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
            color: AppThemeColor.blue800,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Text(
          'Enter your admission number or email with date of birth to check your application status',
          style: AppThemeResponsiveness.getSubHeadingStyle(context),
        ),
      ],
    );
  }

  Widget _buildSearchMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Method',
          style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
            color: AppThemeColor.blue800,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          decoration: BoxDecoration(
            color: AppThemeColor.blue50,
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
            border: Border.all(color: AppThemeColor.blue200),
          ),
          child: AppThemeResponsiveness.isSmallPhone(context)
              ? Column(
            children: [
              _buildMethodOption(
                'admission',
                'Number',
                Icons.confirmation_number,
                isFullWidth: true,
              ),
              Container(
                height: 1,
                color: AppThemeColor.blue200,
              ),
              _buildMethodOption(
                'email',
                'Email',
                Icons.email,
                isFullWidth: true,
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: _buildMethodOption(
                  'admission',
                  'Number',
                  Icons.confirmation_number,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppThemeColor.blue200,
              ),
              Expanded(
                child: _buildMethodOption(
                  'email',
                  'Email',
                  Icons.email,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMethodOption(
      String method,
      String title,
      IconData icon, {
        bool isFullWidth = false,
      }) {
    bool isSelected = _searchMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchMethod = method;
          // Clear controllers when switching methods
          _admissionNumberController.clear();
          _emailController.clear();
          _dobController.clear();
          _showStatus = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppThemeResponsiveness.getDefaultSpacing(context),
          horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppThemeColor.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppThemeColor.blue600,
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            Flexible(
              child: Text(
                title,
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: isSelected ? Colors.white : AppThemeColor.blue800,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: AppThemeResponsiveness.isSmallPhone(context) ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // For desktop, show fields in a row; for mobile, show in column
          AppThemeResponsiveness.isSmallPhone(context) || AppThemeResponsiveness.isTablet(context)
              ? Column(
            children: [
              if (_searchMethod == 'admission') ...[
                AppTextFieldBuilder.build(
                  context: context,
                  controller: _admissionNumberController,
                  label: 'Admission Number',
                  icon: Icons.confirmation_number,
                  validator: _validateAdmissionNumber,
                ),
              ] else ...[
                AppTextFieldBuilder.build(
                  context: context,
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
              ],
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              // Using the new reusable date picker widget
              AppDatePicker.dateOfBirth(
                controller: _dobController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date of birth';
                  }
                  return null;
                },
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                flex: 1,
                child: _searchMethod == 'admission'
                    ? AppTextFieldBuilder.build(
                  context: context,
                  controller: _admissionNumberController,
                  label: 'Admission Number',
                  icon: Icons.confirmation_number,
                  validator: _validateAdmissionNumber,
                )
                    : AppTextFieldBuilder.build(
                  context: context,
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
              Expanded(
                flex: 1,
                child: AppDatePicker.dateOfBirth(
                  controller: _dobController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackButton() {
    return PrimaryButton(
      title: 'Track My Application',
      onPressed: _handleTrackApplication,
      isLoading: _isSearching,
      icon: Icon(
        Icons.search,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application Status',
          style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
            color: AppThemeColor.blue800,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildStatusCard(),
      ],
    );
  }

  Widget _buildStatusCard() {
    if (_statusData == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        border: Border.all(color: AppThemeColor.blue200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatusRow(
            'Admission Number',
            _statusData!.admissionNumber,
            Icons.confirmation_number,
          ),
          _buildDivider(),
          _buildStatusRow(
            'Student Name',
            _statusData!.studentName,
            Icons.person,
          ),
          _buildDivider(),
          _buildStatusRow(
            'Class Applied',
            _statusData!.classApplied,
            Icons.school,
          ),
          _buildDivider(),
          _buildStatusRowWithIcon(
            'Status',
            _statusData!.status,
            _getStatusIcon(_statusData!.status),
            _getStatusColor(_statusData!.status),
          ),
          _buildDivider(),
          _buildStatusRow(
            'Status Updated On',
            _statusData!.statusUpdatedOn,
            Icons.access_time,
          ),
          if (_statusData!.remarks.isNotEmpty) ...[
            _buildDivider(),
            _buildRemarksSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getSmallSpacing(context),
            ),
            decoration: BoxDecoration(
              color: AppThemeColor.blue50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppThemeColor.blue600,
              size: AppThemeResponsiveness.getIconSize(context) * 0.7,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: AppThemeColor.blue800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRowWithIcon(
      String label,
      String value,
      IconData statusIcon,
      Color statusColor,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getSmallSpacing(context),
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: AppThemeResponsiveness.getIconSize(context) * 0.7,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: AppThemeResponsiveness.getIconSize(context) * 0.7,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        value,
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getSmallSpacing(context),
            ),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: AppThemeResponsiveness.getIconSize(context) * 0.7,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remarks',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.all(
                    AppThemeResponsiveness.getSmallSpacing(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _statusData!.remarks,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppThemeColor.blue100,
      height: 1,
      thickness: 1,
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
      case 'declined':
        return Icons.cancel;
      case 'under review':
      case 'pending':
        return Icons.schedule;
      case 'document required':
        return Icons.upload_file;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accepted':
        return Colors.green;
      case 'rejected':
      case 'declined':
        return Colors.red;
      case 'under review':
      case 'pending':
        return Colors.orange;
      case 'document required':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Validation Methods
  String? _validateAdmissionNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter admission number';
    }
    if (value.trim().length < 5) {
      return 'Please enter a valid admission number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _handleTrackApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSearching = true;
      _showStatus = false;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Mock data based on search criteria
    _statusData = AdmissionStatusData(
      admissionNumber: _searchMethod == 'admission'
          ? _admissionNumberController.text
          : 'ADM2025-0001',
      studentName: 'Aman Singh',
      classApplied: 'Class 6 – Section A',
      status: 'Under Review',
      statusUpdatedOn: 'June 4, 2025',
      remarks: 'Waiting for TC document upload',
    );

    setState(() {
      _isSearching = false;
      _showStatus = true;
    });
  }

  @override
  void dispose() {
    _admissionNumberController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}