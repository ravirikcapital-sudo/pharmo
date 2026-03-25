import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/sectionTitle.dart';
import 'package:school/customWidgets/snackBar.dart';

class AddSubjectScreen extends StatefulWidget {
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectNameController = TextEditingController();
  final _subjectCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> _selectedClasses = [];
  List<String> _availableClasses = ['Class 1', 'Class 2', 'Class 3', 'Class 4'];
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
          child: Column(
            children: [
              HeaderSection(
                title: 'Add New Subject',
                icon: Icons.book,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                  decoration: BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemeColor.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _buildSubjectForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectForm() {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: SectionTitleBlueAdmission(title: 'Add Subject Details')),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Responsive input fields
            _buildResponsiveFields(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Class Selection Section
            _buildClassSelection(),
            SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),

            PrimaryButton(
              title: 'Create Subject',
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              isLoading: _isLoading,
              onPressed: _submitForm,
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveFields() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800; // Desktop breakpoint

    if (isDesktop) {
      return Column(
        children: [
          // First row: Subject Name and Subject Code
          Row(
            children: [
              Expanded(
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _subjectNameController,
                  label: 'Subject Name',
                  icon: Icons.book,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => value?.isEmpty == true ? 'Please enter subject name' : null,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
              Expanded(
                child: AppTextFieldBuilder.build(
                  context: context,
                  controller: _subjectCodeController,
                  label: 'Subject Code',
                  icon: Icons.code,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) => value?.isEmpty == true ? 'Please enter subject code' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          // Second row: Description (full width)
          AppTextFieldBuilder.build(
            context: context,
            controller: _descriptionController,
            label: 'Description',
            icon: Icons.description,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => null, // Optional field
          ),
        ],
      );
    } else {
      // Mobile layout: stacked fields
      return Column(
        children: [
          // Subject Name Field
          AppTextFieldBuilder.build(
            context: context,
            controller: _subjectNameController,
            label: 'Subject Name',
            icon: Icons.book,
            textCapitalization: TextCapitalization.words,
            validator: (value) => value?.isEmpty == true ? 'Please enter subject name' : null,
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          // Subject Code Field
          AppTextFieldBuilder.build(
            context: context,
            controller: _subjectCodeController,
            label: 'Subject Code',
            icon: Icons.code,
            textCapitalization: TextCapitalization.characters,
            validator: (value) => value?.isEmpty == true ? 'Please enter subject code' : null,
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          // Description Field
          AppTextFieldBuilder.build(
            context: context,
            controller: _descriptionController,
            label: 'Description',
            icon: Icons.description,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => null, // Optional field
          ),
        ],
      );
    }
  }

  Widget _buildClassSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assign to Classes',
          style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            color: AppThemeColor.primaryBlue,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Main container with input field styling
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppThemeColor.greyl,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
            color: AppThemeColor.white,
          ),
          child: Column(
            children: [
              // Header with icon (similar to input field style)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                decoration: BoxDecoration(
                  color: AppThemeColor.blue50.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      AppThemeResponsiveness.getInputBorderRadius(context),
                    ),
                    topRight: Radius.circular(
                      AppThemeResponsiveness.getInputBorderRadius(context),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: AppThemeColor.primaryBlue,
                      size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                    ),
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                    Spacer(),
                    Text(
                      '${_selectedClasses.length}/${_availableClasses.length}',
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: AppThemeColor.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Class list with custom styling
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _availableClasses.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppThemeColor.greyl.withOpacity(0.3),
                  indent: AppThemeResponsiveness.getDefaultSpacing(context),
                  endIndent: AppThemeResponsiveness.getDefaultSpacing(context),
                ),
                itemBuilder: (context, index) {
                  final className = _availableClasses[index];
                  final isSelected = _selectedClasses.contains(className);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedClasses.remove(className);
                        } else {
                          _selectedClasses.add(className);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                        vertical: AppThemeResponsiveness.getSmallSpacing(context) * 1.2,
                      ),
                      child: Row(
                        children: [
                          // Custom checkbox
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected
                                    ? AppThemeColor.primaryBlue
                                    : AppThemeColor.greyl,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppThemeColor.primaryBlue
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                                : null,
                          ),
                          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),

                          // Class name
                          Expanded(
                            child: Text(
                              className,
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                fontWeight: isSelected ? FontWeight.w400 : FontWeight.w400,
                                color: isSelected
                                    ? AppThemeColor.black87
                                    : AppThemeColor.grey600,
                              ),
                            ),
                          ),

                          // Selection indicator
                          if (isSelected)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppThemeColor.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Selected',
                                style: TextStyle(
                                  color: AppThemeColor.primaryBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Helper text
        if (_selectedClasses.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getSmallSpacing(context),
              left: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Text(
              'Selected: ${_selectedClasses.join(", ")}',
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                fontSize: 12,
                color: AppThemeColor.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedClasses.isEmpty) {
        AppSnackBar.show(
          context,
          message: 'Please select at least one class',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      // Here you would typically save to database
      _showSuccessMessage();

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  void _showSuccessMessage() {
    AppSnackBar.show(
      context,
      message: 'Subject "${_subjectNameController.text}" created successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _subjectCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}