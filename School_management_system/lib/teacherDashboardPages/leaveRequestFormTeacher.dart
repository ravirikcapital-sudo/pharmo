import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/services/api_services.dart';

class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({Key? key}) : super(key: key);

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _reasonController = TextEditingController();
  final _substituteController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  String _leaveType = 'sick';
  bool _needsSubstitute = false;
  bool _isSubmitting = false;

  // Sample substitute teachers list - replace with actual data
  final List<Map<String, String>> _availableSubstitutes = [
    {'id': '1', 'name': 'John Smith', 'subject': 'Mathematics'},
    {'id': '2', 'name': 'Sarah Johnson', 'subject': 'English'},
    {'id': '3', 'name': 'Mike Wilson', 'subject': 'Science'},
    {'id': '4', 'name': 'Emily Davis', 'subject': 'History'},
    {'id': '5', 'name': 'Robert Brown', 'subject': 'Physical Education'},
  ];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    _substituteController.dispose();
    _emergencyContactController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeaveRequestCard(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            _buildSubstituteSection(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRequestCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave Request Details',
              style: AppThemeResponsiveness.getHeadingStyle(context),
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Leave Type Selection
            _buildLeaveTypeSelection(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Date Selection
            _buildDateSelection(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Reason for Leave
            AppTextFieldBuilder.build(
              context: context,
              controller: _reasonController,
              label: 'Reason for Leave',
              icon: Icons.description,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide a reason for leave';
                }
                if (value.trim().length < 10) {
                  return 'Please provide a more detailed reason (min 10 characters)';
                }
                return null;
              },
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Emergency Contact
            AppTextFieldBuilder.build(
              context: context,
              controller: _emergencyContactController,
              label: 'Emergency Contact Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide an emergency contact number';
                }
                if (value.trim().length < 10) {
                  return 'Please provide a valid contact number';
                }
                return null;
              },
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Additional Notes
            AppTextFieldBuilder.build(
              context: context,
              controller: _additionalNotesController,
              label: 'Additional Notes (Optional)',
              icon: Icons.note_add,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leave Type',
          style: AppThemeResponsiveness.getSubHeadingStyle(context),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: _leaveType,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category,
                color: Colors.grey[600],
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
                vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'sick', child: Text('Sick Leave')),
              DropdownMenuItem(value: 'personal', child: Text('Personal Leave')),
              DropdownMenuItem(value: 'emergency', child: Text('Emergency Leave')),
              DropdownMenuItem(value: 'vacation', child: Text('Vacation Leave')),
              DropdownMenuItem(value: 'maternity', child: Text('Maternity Leave')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (value) {
              setState(() {
                _leaveType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      children: [
                AppDatePicker.genericDate(
                controller: _startDateController,
                label: 'Start Date',
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select start date';
                  }
                  return null;
                },
              ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            AppDatePicker.genericDate(
                controller: _endDateController,
                label: 'End Date',
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select end date';
                  }

                  // Validate that end date is not before start date
                  if (_startDateController.text.isNotEmpty) {
                    try {
                      DateTime startDate = _parseDate(_startDateController.text);
                      DateTime endDate = _parseDate(value);
                      if (endDate.isBefore(startDate)) {
                        return 'End date cannot be before start date';
                      }
                    } catch (e) {
                      return 'Invalid date format';
                    }
                  }
                  return null;
                },
              ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        _buildLeaveDurationInfo(),
      ],
    );
  }

  Widget _buildLeaveDurationInfo() {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      return Container();
    }

    try {
      DateTime startDate = _parseDate(_startDateController.text);
      DateTime endDate = _parseDate(_endDateController.text);
      int duration = endDate.difference(startDate).inDays + 1;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
        decoration: BoxDecoration(
          color: AppThemeColor.blue50,
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          border: Border.all(color: AppThemeColor.primaryBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              'Leave Duration: $duration day${duration > 1 ? 's' : ''}',
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: AppThemeColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  Widget _buildSubstituteSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Substitute Teacher',
              style: AppThemeResponsiveness.getHeadingStyle(context),
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Substitute Toggle
            Container(
              decoration: BoxDecoration(
                color: AppThemeColor.blue50,
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getInputBorderRadius(context),
                ),
                border: Border.all(color: AppThemeColor.primaryBlue.withOpacity(0.3)),
              ),
              child: CheckboxListTile(
                title: Text(
                  'I need a substitute teacher',
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                ),
                subtitle: Text(
                  'Check this if you want to assign a substitute teacher for your classes',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey[600],
                    fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! - 2,
                  ),
                ),
                value: _needsSubstitute,
                onChanged: (value) {
                  setState(() {
                    _needsSubstitute = value!;
                    if (!_needsSubstitute) {
                      _substituteController.clear();
                    }
                  });
                },
                activeColor: AppThemeColor.primaryBlue,
              ),
            ),

            if (_needsSubstitute) ...[
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              _buildSubstituteSelection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubstituteSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Substitute Teacher',
          style: AppThemeResponsiveness.getSubHeadingStyle(context),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: _substituteController.text.isEmpty ? null : _substituteController.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              hintText: 'Select a substitute teacher',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
                vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
              ),
            ),
            items: _availableSubstitutes.map((substitute) {
              return DropdownMenuItem<String>(
                value: substitute['id'],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      substitute['name']!,
                      style: AppThemeResponsiveness.getBodyTextStyle(context),
                    ),
                    Text(
                      substitute['subject']!,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey[600],
                        fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! - 2,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _substituteController.text = value!;
              });
            },
            validator: _needsSubstitute ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a substitute teacher';
              }
              return null;
            } : null,
          ),
        ),

        if (_substituteController.text.isNotEmpty) ...[
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          _buildSelectedSubstituteInfo(),
        ],
      ],
    );
  }

  Widget _buildSelectedSubstituteInfo() {
    final substitute = _availableSubstitutes.firstWhere(
          (sub) => sub['id'] == _substituteController.text,
      orElse: () => {'name': '', 'subject': ''},
    );

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected: ${substitute['name']}',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Subject: ${substitute['subject']}',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.green[700],
                    fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! - 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: PrimaryButton(
        title: _isSubmitting ? 'Submitting...' : 'Submit Leave Request',
        onPressed: _isSubmitting ? null : _submitLeaveRequest,
        icon: _isSubmitting
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Icon(
          Icons.send,
          color: Colors.white,
          size: AppThemeResponsiveness.getIconSize(context) * 0.8,
        ),
      ),
    );
  }

  void _submitLeaveRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get teacher ID from user session
      final apiService = ApiService();
      final userId = await apiService.getUserId();
      
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Parse dates
      final startDate = _parseDate(_startDateController.text);
      final endDate = _parseDate(_endDateController.text);

      // Call API to submit leave request
      final response = await apiService.applyTeacherLeave(
        leaveType: _leaveType,
        fromDate: ApiService.formatDate(startDate),
        toDate: ApiService.formatDate(endDate),
        reason: _reasonController.text.trim(),
        teacherId: userId,
      );

      if (response.success) {
        // Show success message
        AppSnackBar.show(
          context,
          message: 'Leave request submitted successfully!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );

        // Reset form
        _resetForm();
      } else {
        throw Exception(response.message ?? 'Failed to submit leave request');
      }
    } catch (e) {
      AppSnackBar.show(
        context,
        message: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _startDateController.clear();
    _endDateController.clear();
    _reasonController.clear();
    _substituteController.clear();
    _emergencyContactController.clear();
    _additionalNotesController.clear();
    setState(() {
      _leaveType = 'sick';
      _needsSubstitute = false;
    });
  }

  DateTime _parseDate(String dateString) {
    // Assuming dd/MM/yyyy format as per your date picker
    final parts = dateString.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }
}