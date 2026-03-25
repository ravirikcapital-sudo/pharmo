import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:school/customWidgets/AddCommonWidgets/addNewHeader.dart';
import 'package:school/customWidgets/AddCommonWidgets/addSectionHeader.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/commonImagePicker.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';

class AddNewApplicantScreen extends StatefulWidget {
  @override
  _AddNewApplicantScreenState createState() => _AddNewApplicantScreenState();
}

class _AddNewApplicantScreenState extends State<AddNewApplicantScreen> {
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  // Image related
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Loading state
  bool _isLoading = false;

  // Focus nodes for better UX
  final _fullNameFocus = FocusNode();
  final _fatherNameFocus = FocusNode();
  final _motherNameFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _addressFocus = FocusNode();

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _fullNameFocus.dispose();
    _fatherNameFocus.dispose();
    _motherNameFocus.dispose();
    _cityFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  (AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
            ),
            child: SafeArea(
              child: Padding(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Column(
                  children: [
                    HeaderWidget(titleLabel: 'Applicant'),
                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                    _buildMainCard(),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context) + 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) + 4),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) + 4),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: AppThemeResponsiveness.getCardPadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo Section
                  SectionHeader(
                    context: context,
                    title: 'Photo',
                    icon: Icons.camera_alt_rounded,
                    color: Colors.purple,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  PhotoPickerWidget(
                    onImageChanged: (File? file) {
                      // Do something with the selected file
                      if (file != null) {
                        print('Image selected: ${file.path}');
                      } else {
                        print('Image removed');
                      }
                    },
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Personal Information Section
                  SectionHeader(
                    context: context,
                    title: 'Personal Information',
                    icon: Icons.person_rounded,
                    color: Colors.blue,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _fullNameController,
                    label: 'Full Name *',
                    icon: Icons.person_rounded,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter full name' : null,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _fatherNameController,
                    label: "Father's Name *",
                    icon: Icons.man_rounded,
                    validator: (value) =>
                    value!.isEmpty ? "Please enter father's name" : null,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _motherNameController,
                    label: "Mother's Name *",
                    icon: Icons.woman_rounded,
                    validator: (value) =>
                    value!.isEmpty ? "Please enter mother's name" : null,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppDatePicker.dateOfBirth(
                    controller: _dateOfBirthController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date of birth';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Address Information Section
                  SectionHeader(
                    context: context,
                    title: 'Address Information',
                    icon: Icons.location_on_rounded,
                    color: Colors.green,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _cityController,
                    label: 'City *',
                    icon: Icons.location_city_rounded,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter city' : null,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _addressController,
                    label: 'Current Address *',
                    icon: Icons.home_rounded,
                    maxLines: AppThemeResponsiveness.getTextFieldMaxLines(context),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter current address' : null,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          title: 'Add Applicant',
          icon: Icon(Icons.add_circle_outline_rounded, color: Colors.white),
          isLoading: _isLoading,
          onPressed: _submitApplicant,
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        SecondaryButton(
          title: 'Cancel',
          icon: Icon(Icons.arrow_back_rounded, color: AppThemeColor.blue600),
          color: AppThemeColor.blue600,
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Future<void> _submitApplicant() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Flexible(
                  child: Text(
                    'Applicant added successfully!',
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12)),
          ),
          margin: AppThemeResponsiveness.getHorizontalPadding(context),
          elevation: 8,
        ),
      );
      // Navigate back or to next screen
      Navigator.pop(context);
    }
  }
}