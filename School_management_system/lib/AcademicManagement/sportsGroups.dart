import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/sectionTitle.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/customWidgets/dropDownCommon.dart';

class AddSportGroupScreen extends StatefulWidget {
  @override
  _AddSportGroupScreenState createState() => _AddSportGroupScreenState();
}

class _AddSportGroupScreenState extends State<AddSportGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _coachController = TextEditingController();
  final _maxMembersController = TextEditingController();
  String? _selectedSportType;
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
                title: 'Add Sport Group',
                icon: Icons.sports_soccer,
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
                  child: _buildSportGroupForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportGroupForm() {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: SectionTitleBlueAdmission(title: 'Add Sport Group Details')),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            _buildResponsiveFormFields(),

            SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
            PrimaryButton(
              title: 'Create Sport Group',
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
      _buildGroupNameField(),
      _buildSportTypeField(),
      _buildCoachField(),
      _buildMaxMembersField(),
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

  Widget _buildGroupNameField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _groupNameController,
      label: 'Group Name',
      icon: Icons.group,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter group name' : null,
    );
  }

  Widget _buildSportTypeField() {
    return AppDropdown.sportType(
      value: _selectedSportType,
      onChanged: (String? newValue) {
        setState(() {
          _selectedSportType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select sport type' : null,
    );
  }

  Widget _buildCoachField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _coachController,
      label: 'Coach Name',
      icon: Icons.person,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter coach name' : null,
    );
  }

  Widget _buildMaxMembersField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _maxMembersController,
      label: 'Maximum Members',
      icon: Icons.people,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'Please enter maximum members';
        }
        final maxMembers = int.tryParse(value!);
        if (maxMembers == null || maxMembers <= 0) {
          return 'Please enter a valid number';
        }
        if (maxMembers > 50) {
          return 'Maximum members cannot exceed 50';
        }
        return null;
      },
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
      message: 'Sport group "${_groupNameController.text}" created successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _coachController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }
}