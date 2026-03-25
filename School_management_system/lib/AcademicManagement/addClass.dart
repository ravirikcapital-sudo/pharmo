import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/sectionTitle.dart';
import 'package:school/customWidgets/snackBar.dart';


class AddClassScreen extends StatefulWidget {
  @override
  _AddClassScreenState createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _teacherController = TextEditingController();
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
                title: 'Add New CLass',
                icon: Icons.class_,
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
                  child: _buildClassForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassForm() {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: SectionTitleBlueAdmission(title: 'Add Class Details')),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            _buildResponsiveFormFields(),

            SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
            PrimaryButton(
              title: 'Create Class',
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

  Widget _buildResponsiveFormFields() {
    final fields = [
      _buildClassNameField(),
      _buildSectionField(),
      _buildCapacityField(),
      _buildTeacherField(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            children: fields
                .map((field) => [
              field,
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            ])
                .expand((x) => x)
                .toList()
              ..removeLast(), // Remove last spacing
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: fields[0]),
                  SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                  Expanded(child: fields[1]),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              Row(
                children: [
                  Expanded(child: fields[2]),
                  SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                  Expanded(child: fields[3]),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildClassNameField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _classNameController,
      label: 'Class Name',
      icon: Icons.class_,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter class name' : null,
    );
  }

  Widget _buildSectionField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _sectionController,
      label: 'Section',
      icon: Icons.category,
      textCapitalization: TextCapitalization.characters,
      maxLength: 3,
      validator: (value) => value?.isEmpty == true ? 'Please enter section' : null,
    );
  }

  Widget _buildCapacityField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _capacityController,
      label: 'Class Capacity',
      icon: Icons.people,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'Please enter capacity';
        }
        final capacity = int.tryParse(value!);
        if (capacity == null || capacity <= 0) {
          return 'Please enter a valid capacity';
        }
        if (capacity > 100) {
          return 'Capacity cannot exceed 100 students';
        }
        return null;
      },
    );
  }

  Widget _buildTeacherField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _teacherController,
      label: 'Class Teacher',
      icon: Icons.person,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter teacher name' : null,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
      message: 'Class "${_classNameController.text} - ${_sectionController.text}" created successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _sectionController.dispose();
    _capacityController.dispose();
    _teacherController.dispose();
    super.dispose();
  }
}