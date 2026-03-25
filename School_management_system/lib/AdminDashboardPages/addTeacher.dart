import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school/customWidgets/AddCommonWidgets/addNewHeader.dart';
import 'package:school/customWidgets/AddCommonWidgets/addSectionHeader.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/commonImagePicker.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/services/api_services.dart';

class AddTeacherScreen extends StatefulWidget {
  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _dobController = TextEditingController();
  final _designationController = TextEditingController();
  final _tagsController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _joiningDateController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceYearsController = TextEditingController();
  final _experienceDetailsController = TextEditingController();

  // Focus nodes for better UX
  final _nameFocus = FocusNode();
  final _teacherIdFocus = FocusNode();
  final _designationFocus = FocusNode();
  final _tagsFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _emailFocus = FocusNode();

  // Image related
  Uint8List? _imageBytes;
  String? _imageName;
  final ImagePicker _picker = ImagePicker();

  // Loading state
  bool _isLoading = false;

  // Dropdown selections
  String? _selectedGender;
  int? _selectedDesignationId;

  // Predefined options
  final List<String> _genders = ['Male', 'Female', 'Other'];
  
  final List<Map<String, dynamic>> _designations = [
    {"id": 1, "name": "Principal"},
    {"id": 2, "name": "Vice Principal"},
    {"id": 3, "name": "Head Teacher"},
    {"id": 4, "name": "Senior Teacher"},
    {"id": 5, "name": "Teacher"},
    {"id": 6, "name": "Assistant Teacher"},
    {"id": 7, "name": "Subject Coordinator"},
    {"id": 8, "name": "Department Head"},
    {"id": 9, "name": "Lab Assistant"},
    {"id": 10, "name": "Physical Education Teacher"},
    {"id": 11, "name": "Librarian"},
    {"id": 12, "name": "Counselor"},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _teacherIdController.dispose();
    _dobController.dispose();
    _designationController.dispose();
    _tagsController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _joiningDateController.dispose();
    _qualificationController.dispose();
    _experienceYearsController.dispose();
    _experienceDetailsController.dispose();
    _nameFocus.dispose();
    _teacherIdFocus.dispose();
    _designationFocus.dispose();
    _tagsFocus.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must contain only digits';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: AppThemeResponsiveness.getScreenPadding(context),
              child: Column(
                children: [
                  HeaderWidget(titleLabel: 'Teacher'),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                  _buildMainCard(),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
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
                  _buildImagePicker(),
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
                    controller: _nameController,
                    label: 'Full Name *',
                    icon: Icons.person_rounded,
                    validator: (value) => _validateRequired(value, 'Name'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _teacherIdController,
                    label: 'Teacher ID *',
                    icon: Icons.badge_rounded,
                    validator: (value) => _validateRequired(value, 'Teacher ID'),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppDatePicker.dateOfBirth(
                    controller: _dobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date of birth';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  _buildGenderDropdown(),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Professional Information Section
                  SectionHeader(
                    context: context,
                    title: 'Professional Information',
                    icon: Icons.work_outline_rounded,
                    color: Colors.orange,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _subjectController,
                    label: 'Subject *',
                    icon: Icons.book_rounded,
                    validator: (value) => _validateRequired(value, 'Subject'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppDatePicker.genericDate(
                    controller: _joiningDateController,
                    label: 'Joining Date *',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select joining date';
                      }
                      return null;
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  _buildDesignationDropdown(),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _qualificationController,
                    label: 'Qualification *',
                    icon: Icons.school_rounded,
                    validator: (value) => _validateRequired(value, 'Qualification'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _experienceYearsController,
                    label: 'Experience Years *',
                    icon: Icons.history_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) => _validateRequired(value, 'Experience Years'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _experienceDetailsController,
                    label: 'Experience Details *',
                    icon: Icons.description_rounded,
                    validator: (value) => _validateRequired(value, 'Experience Details'),
                    maxLines: 3,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Contact Information Section
                  SectionHeader(
                    context: context,
                    title: 'Contact Information',
                    icon: Icons.contact_phone_rounded,
                    color: Colors.green,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _mobileController,
                    label: 'Mobile Number *',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    validator: _validateMobile,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _emailController,
                    label: 'Email Address *',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
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

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            final bytes = await image.readAsBytes();
            setState(() {
              _imageBytes = bytes;
              _imageName = image.name;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppThemeColor.blue600,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[100],
            backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
            child: _imageBytes == null
                ? Icon(
                    Icons.camera_alt_rounded,
                    size: 40,
                    color: AppThemeColor.blue600,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender *',
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          size: AppThemeResponsiveness.getIconSize(context),
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: AppThemeColor.blue600,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _genders.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(
            gender,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select gender';
        }
        return null;
      },
      dropdownColor: Colors.white,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey[600],
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      style: AppThemeResponsiveness.getBodyTextStyle(context),
    );
  }

  Widget _buildDesignationDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedDesignationId,
      decoration: InputDecoration(
        labelText: 'Designation *',
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        prefixIcon: Icon(
          Icons.work_rounded,
          size: AppThemeResponsiveness.getIconSize(context),
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: AppThemeColor.blue600,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _designations.map((Map<String, dynamic> designation) {
        return DropdownMenuItem<int>(
          value: designation['id'] as int,
          child: Text(
            designation['name'].toString(),
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _selectedDesignationId = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a designation';
        }
        return null;
      },
      dropdownColor: Colors.white,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey[600],
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      style: AppThemeResponsiveness.getBodyTextStyle(context),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          title: 'Add Teacher',
          icon: Icon(Icons.save_rounded, color: Colors.white),
          isLoading: _isLoading,
          onPressed: _saveTeacher,
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        SecondaryButton(
          title: 'Cancel',
          icon: Icon(Icons.cancel_rounded, color: AppThemeColor.blue600),
          color: AppThemeColor.blue600,
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Future<void> _saveTeacher() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageBytes == null) {
      _showErrorDialog('Please select a photo for the teacher');
      return;
    }

    if (_selectedGender == null) {
      _showErrorDialog('Please select gender');
      return;
    }

    if (_selectedDesignationId == null) {
      _showErrorDialog('Please select a designation');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call real API
      final success = await ApiService.quickCreateTeacher(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _mobileController.text,
        gender: _selectedGender!,
        dob: _dobController.text,
        subject: _subjectController.text,
        joiningDate: _joiningDateController.text,
        designationId: _selectedDesignationId!,
        qualification: _qualificationController.text,
        experienceYears: _experienceYearsController.text,
        experienceDetails: _experienceDetailsController.text,
        profileImageBytes: _imageBytes!,
        profileImageName: _imageName!,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
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
                      'Teacher added successfully!',
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
        // Navigate back
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _showErrorDialog('Failed to add teacher. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error saving teacher: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 15)),
          ),
          title: Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.red, size: AppThemeResponsiveness.getResponsiveIconSize(context, 30)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Error',
                style: AppThemeResponsiveness.getTitleTextStyle(context),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ===============================
// add_teacher_screen.dart
// ===============================
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:school/services/api_services.dart';

// class AddTeacherScreen extends StatefulWidget {
//   const AddTeacherScreen({super.key});

//   @override
//   State<AddTeacherScreen> createState() => _AddTeacherScreenState();
// }

// class _AddTeacherScreenState extends State<AddTeacherScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _dobController = TextEditingController();
//   final _subjectController = TextEditingController();
//   final _joiningDateController = TextEditingController();
//   final _qualificationController = TextEditingController();
//   final _experienceYearsController = TextEditingController();
//   final _experienceDetailsController = TextEditingController();

//   final ImagePicker _picker = ImagePicker();

//   Uint8List? _imageBytes;
//   String? _imageName;

//   bool _isLoading = false;

//   String? _selectedGender;
//   int? _selectedDesignationId;

//   final genders = ['Male', 'Female', 'Other'];

//   final designations = [
//     {"id": 1, "name": "Principal"},
//     {"id": 2, "name": "Vice Principal"},
//     {"id": 3, "name": "Teacher"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Teacher")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _imagePicker(),
//               _field(_nameController, "Full Name"),
//               _field(
//                 _emailController,
//                 "Email",
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               _field(
//                 _mobileController,
//                 "Mobile",
//                 keyboardType: TextInputType.phone,
//                 formatters: [FilteringTextInputFormatter.digitsOnly],
//               ),
//               _dateField(_dobController, "Date of Birth"),
//               _genderDropdown(),
//               _field(_subjectController, "Subject"),
//               _dateField(_joiningDateController, "Joining Date"),
//               _designationDropdown(),
//               _field(_qualificationController, "Qualification"),
//               _field(
//                 _experienceYearsController,
//                 "Experience Years",
//                 keyboardType: TextInputType.number,
//               ),
//               _field(
//                 _experienceDetailsController,
//                 "Experience Details",
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 20),
//               _submitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- IMAGE PICKER ----------------

//   Widget _imagePicker() {
//     return GestureDetector(
//       onTap: () async {
//         final image = await _picker.pickImage(source: ImageSource.gallery);
//         if (image != null) {
//           final bytes = await image.readAsBytes();
//           setState(() {
//             _imageBytes = bytes;
//             _imageName = image.name;
//           });
//         }
//       },
//       child: CircleAvatar(
//         radius: 50,
//         backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
//         child: _imageBytes == null
//             ? const Icon(Icons.camera_alt, size: 30)
//             : null,
//       ),
//     );
//   }

//   // ---------------- FORM FIELD ----------------

//   Widget _field(
//     TextEditingController controller,
//     String label, {
//     TextInputType keyboardType = TextInputType.text,
//     List<TextInputFormatter>? formatters,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         inputFormatters: formatters,
//         maxLines: maxLines,
//         validator: (v) => v == null || v.isEmpty ? "$label required" : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   // ---------------- DATE FIELD ----------------

//   Widget _dateField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         readOnly: true,
//         validator: (v) => v == null || v.isEmpty ? "$label required" : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           suffixIcon: const Icon(Icons.calendar_today),
//         ),
//         onTap: () async {
//           final date = await showDatePicker(
//             context: context,
//             firstDate: DateTime(1950),
//             lastDate: DateTime.now(),
//             initialDate: DateTime.now(),
//           );
//           if (date != null) {
//             controller.text = date.toIso8601String().split('T').first;
//           }
//         },
//       ),
//     );
//   }

//   // ---------------- DROPDOWNS ----------------

//   Widget _genderDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _selectedGender,
//       decoration: const InputDecoration(
//         labelText: "Gender",
//         border: OutlineInputBorder(),
//       ),
//       items: genders
//           .map((g) => DropdownMenuItem(value: g, child: Text(g)))
//           .toList(),
//       onChanged: (v) => setState(() => _selectedGender = v),
//       validator: (v) => v == null ? "Gender required" : null,
//     );
//   }

//   Widget _designationDropdown() {
//     return DropdownButtonFormField<int>(
//       value: _selectedDesignationId,
//       decoration: const InputDecoration(
//         labelText: "Designation",
//         border: OutlineInputBorder(),
//       ),
//       items: designations
//           .map(
//             (d) => DropdownMenuItem<int>(
//               value: d['id'] as int,
//               child: Text(d['name'].toString()),
//             ),
//           )
//           .toList(),
//       onChanged: (v) => setState(() => _selectedDesignationId = v),
//       validator: (v) => v == null ? "Designation required" : null,
//     );
//   }

//   // ---------------- SUBMIT ----------------

//   Widget _submitButton() {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _submit,
//       child: _isLoading
//           ? const CircularProgressIndicator(color: Colors.white)
//           : const Text("Add Teacher"),
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate() || _imageBytes == null) return;

//     setState(() => _isLoading = true);

//     final success = await ApiService.quickCreateTeacher(
//       fullName: _nameController.text,
//       email: _emailController.text,
//       phone: _mobileController.text,
//       gender: _selectedGender!,
//       dob: _dobController.text,
//       subject: _subjectController.text,
//       joiningDate: _joiningDateController.text,
//       designationId: _selectedDesignationId!,
//       qualification: _qualificationController.text,
//       experienceYears: _experienceYearsController.text,
//       experienceDetails: _experienceDetailsController.text,
//       profileImageBytes: _imageBytes!,
//       profileImageName: _imageName!,
//     );

//     setState(() => _isLoading = false);

//     if (success && mounted) {
//       Navigator.pop(context);
//     }
//   }
// }
