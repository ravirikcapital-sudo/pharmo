import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/sectionTitle.dart';
import 'package:school/customWidgets/snackBar.dart';


class AddHouseGroupScreen extends StatefulWidget {
  @override
  _AddHouseGroupScreenState createState() => _AddHouseGroupScreenState();
}

class _AddHouseGroupScreenState extends State<AddHouseGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _houseNameController = TextEditingController();
  final _captainController = TextEditingController();
  final _viceCaptainController = TextEditingController();
  final _mottoController = TextEditingController();
  String? _selectedColor;
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
                title: 'Create House Group',
                icon: Icons.home,
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
                  child: _buildHouseGroupForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHouseGroupForm() {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: SectionTitleBlueAdmission(title: 'House Group Details')),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            _buildResponsiveFormFields(),

            SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),

            PrimaryButton(
              title: 'Create House Group',
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
      _buildHouseNameField(),
      _buildHouseColorField(),
      _buildCaptainField(),
      _buildViceCaptainField(),
      _buildMottoField(),
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
              // Row 1: House Name and House Color
              Row(
                children: [
                  Expanded(child: fields[0]),
                  SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                  Expanded(child: fields[1]),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              // Row 2: Captain and Vice Captain
              Row(
                children: [
                  Expanded(child: fields[2]),
                  SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                  Expanded(child: fields[3]),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              // Row 3: Motto (full width)
              fields[4],
            ],
          );
        }
      },
    );
  }

  Widget _buildHouseNameField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _houseNameController,
      label: 'House Name',
      icon: Icons.home,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter house name' : null,
    );
  }

  Widget _buildHouseColorField() {
    return AppDropdown.houseColor(
      value: _selectedColor,
      onChanged: (value) {
        setState(() {
          _selectedColor = value;
        });
      },
      validator: (value) => value == null ? 'Please select house color' : null,
    );
  }

  Widget _buildCaptainField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _captainController,
      label: 'House Captain',
      icon: Icons.person,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter captain name' : null,
    );
  }

  Widget _buildViceCaptainField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _viceCaptainController,
      label: 'Vice Captain',
      icon: Icons.person_outline,
      textCapitalization: TextCapitalization.words,
      validator: (value) => value?.isEmpty == true ? 'Please enter vice captain name' : null,
    );
  }

  Widget _buildMottoField() {
    return AppTextFieldBuilder.build(
      context: context,
      controller: _mottoController,
      label: 'House Motto',
      icon: Icons.format_quote,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) => value?.isEmpty == true ? 'Please enter house motto' : null,
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
      message: 'House group "${_houseNameController.text}" created successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  void dispose() {
    _houseNameController.dispose();
    _captainController.dispose();
    _viceCaptainController.dispose();
    _mottoController.dispose();
    super.dispose();
  }
}