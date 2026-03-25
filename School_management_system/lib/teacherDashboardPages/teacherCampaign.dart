import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/appBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';

class StudentDetailsCollectionPage extends StatefulWidget {
  @override
  _StudentDetailsCollectionPageState createState() => _StudentDetailsCollectionPageState();
}

class _StudentDetailsCollectionPageState extends State<StudentDetailsCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarksController = TextEditingController();
  final _followUpDateController = TextEditingController();

  String? _selectedClass;
  String? _selectedGender;
  String? _selectedInterestLevel;
  bool _isLoading = false;

  // Class options for students
  final List<String> _classOptions = [
    'Nursery',
    'LKG',
    'UKG',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12'
  ];

  // Interest level options
  final List<String> _interestLevelOptions = [
    'Very Interested',
    'Interested',
    'Moderately Interested',
    'Not Sure',
    'Not Interested'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _parentNameController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    _followUpDateController.dispose();
    super.dispose();
  }

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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildHeaderSection(),
                    SizedBox(height: 20),
                    _buildFormCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.school,
            size: 60,
            color: AppThemeColor.white,
          ),
          SizedBox(height: 10),
          Text(
            'Student Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppThemeColor.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Collect potential student details for follow-up',
            style: TextStyle(
              fontSize: 16,
              color: AppThemeColor.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStudentSection(),
              SizedBox(height: 20),
              _buildParentSection(),
              SizedBox(height: 20),
              _buildFollowUpSection(),
              SizedBox(height: 30),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 15),
        AppTextFieldBuilder.build(
          context: context,
          controller: _nameController,
          label: 'Student Name *',
          icon: Icons.person,
          textCapitalization: TextCapitalization.words,
          validator: (value) => value!.isEmpty ? 'Please enter student name' : null,
        ),
        SizedBox(height: 15),
        AppDropdown.custom<String>(
          value: _selectedClass,
          items: _classOptions,
          label: 'Class *',
          onChanged: (value) => setState(() => _selectedClass = value),
          validator: (value) => value == null ? 'Please select a class' : null,
          prefixIcon: Icons.school,
        ),
        SizedBox(height: 15),
        AppDropdown.gender(
          value: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
          validator: null, // Gender is optional in this form
        ),
      ],
    );
  }

  Widget _buildParentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Parent/Guardian Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 15),
        AppTextFieldBuilder.build(
          context: context,
          controller: _parentNameController,
          label: 'Parent/Guardian Name *',
          icon: Icons.person_outline,
          textCapitalization: TextCapitalization.words,
          validator: (value) => value!.isEmpty ? 'Please enter parent name' : null,
        ),
        SizedBox(height: 15),
        AppTextFieldBuilder.build(
          context: context,
          controller: _phoneController,
          label: 'Phone Number *',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value!.isEmpty) return 'Please enter phone number';
            if (value.length < 10) return 'Please enter valid phone number';
            return null;
          },
        ),
        SizedBox(height: 15),
        AppTextFieldBuilder.build(
          context: context,
          controller: _emailController,
          label: 'Email (Optional)',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isNotEmpty && !value.contains('@')) {
              return 'Please enter valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 15),
        AppTextFieldBuilder.build(
          context: context,
          controller: _addressController,
          label: 'Address',
          icon: Icons.location_on,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildFollowUpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow-up Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 15),
        AppDropdown.custom<String>(
          value: _selectedInterestLevel,
          items: _interestLevelOptions,
          label: 'Interest Level *',
          onChanged: (value) => setState(() => _selectedInterestLevel = value),
          validator: (value) => value == null ? 'Please select interest level' : null,
          prefixIcon: Icons.star,
        ),
        SizedBox(height: 15),
        AppDatePicker.genericDate(
          controller: _followUpDateController,
          label: 'Follow-up Date',
          validator: null, // Optional field
          initialDate: DateTime.now().add(Duration(days: 7)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          dateFormat: 'dd/MM/yyyy',
        ),
        SizedBox(height: 15),
        AppTextFieldBuilder.build(
          context: context,
          controller: _remarksController,
          label: 'Remarks/Notes',
          icon: Icons.note,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            title: 'Clear',
            onPressed: _clearForm,
            color: Colors.grey[600]!,
            icon: Icon(Icons.clear, color: Colors.grey[600]),
            isLoading: false,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: PrimaryButton(
            title: 'Save Details',
            onPressed: _saveStudentDetails,
            icon: Icon(Icons.save, color: Colors.white),
            isLoading: _isLoading,
            color: AppThemeColor.blue600,
          ),
        ),
      ],
    );
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _parentNameController.clear();
      _addressController.clear();
      _remarksController.clear();
      _followUpDateController.clear();
      _selectedClass = null;
      _selectedGender = null;
      _selectedInterestLevel = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form cleared successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _saveStudentDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Simulate API call delay
        await Future.delayed(Duration(seconds: 2));

        // Parse follow-up date if provided
        DateTime? followUpDate;
        if (_followUpDateController.text.isNotEmpty) {
          try {
            final parts = _followUpDateController.text.split('/');
            followUpDate = DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
          } catch (e) {
            // Handle date parsing error
            debugPrint('Error parsing follow-up date: $e');
          }
        }

        // Collect all form data
        Map<String, dynamic> studentData = {
          'studentName': _nameController.text,
          'class': _selectedClass,
          'gender': _selectedGender,
          'parentName': _parentNameController.text,
          'phoneNumber': _phoneController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'interestLevel': _selectedInterestLevel,
          'followUpDate': followUpDate?.toIso8601String(),
          'remarks': _remarksController.text,
          'collectedAt': DateTime.now().toIso8601String(),
        };

        // Here you would typically save to database or send to API
        print('Student Data Collected: $studentData');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Student details saved successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Clear form after successful save
        _clearForm();

        // Optional: Navigate back or to next student
        // Navigator.pop(context);
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Error saving student details. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Please fill in all required fields'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}