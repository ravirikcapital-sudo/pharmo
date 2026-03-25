import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'dart:io';
import 'package:school/customWidgets/snackBar.dart';

class StudentTimeTableForm extends StatefulWidget {
  @override
  _StudentTimeTableFormState createState() => _StudentTimeTableFormState();
}

class _StudentTimeTableFormState extends State<StudentTimeTableForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _semesterController = TextEditingController();

  String? _selectedClass;
  String? _selectedSection;
  String? _selectedDepartment;
  String? _selectedTimeSlot;
  String? _selectedSubject;

  List<PlatformFile> _attachedFiles = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _academicYearController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                title: 'Student Time Table',
                icon: Icons.schedule,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        AppThemeResponsiveness.getCardBorderRadius(context),
                      ),
                      topRight: Radius.circular(
                        AppThemeResponsiveness.getCardBorderRadius(context),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: AppThemeResponsiveness.getCardElevation(
                          context,
                        ),
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: _buildForm(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getDashboardHorizontalPadding(context),
            ),
            physics: BouncingScrollPhysics(),
            children: [
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // Timetable Title
    AppTextFieldBuilder.build(
    context: context,
    controller: _titleController,
    label: 'Timetable Title',
    icon: Icons.title,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter timetable title';
    }
    return null;
    },
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),


    //Class Selection using AppDropdown
    AppDropdown.classGrade(
    value: _selectedClass,
    onChanged: (String? newValue) {
    setState(() {
    _selectedClass = newValue;
    });
    },
    validator: (value) {
    if (value == null) {
    return 'Please select a class';
    }
    return null;
    },
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // Section Selection using AppDropdown
    AppDropdown.section(
    value: _selectedSection,
    onChanged: (String? newValue) {
    setState(() {
    _selectedSection = newValue;
    });
    },
    validator: (value) {
    if (value == null) {
    return 'Please select a section';
    }
    return null;
    },
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // Academic Year using AppDropdown
    AppDropdown.academicYear(
    value: _academicYearController.text.isEmpty ? null : _academicYearController.text,
    onChanged: (String? newValue) {
    setState(() {
    _academicYearController.text = newValue ?? '';
    });
    },
    validator: (value) {
    if (value == null) {
    return 'Please select an academic year';
    }
    return null;
    },
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // Semester - kept as text field since it's not in common dropdowns
    AppTextFieldBuilder.build(
    context: context,
    controller: _semesterController,
    label: 'Semester (e.g., Fall 2024)',
    icon: Icons.school,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter semester';
    }
    return null;
    },
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // Description
    AppTextFieldBuilder.build(
    context: context,
    controller: _descriptionController,
    label: 'Additional Notes (Optional)',
    icon: Icons.description,
    maxLines: 3,
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // File Attachments
    _buildAttachmentSection(),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

    // Action Buttons
    _buildActionButtons(context),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
    ],
    ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      padding: EdgeInsets.all(
        AppThemeResponsiveness.getDefaultSpacing(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file_outlined,
                color: Color(0xFF667EEA),
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Attach Supporting Documents',
                style: AppThemeResponsiveness.getCaptionTextStyle(context)
                    .copyWith(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667EEA),
                ),
              ),
            ],
          ),

          if (_attachedFiles.isNotEmpty) ...[
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            ...(_attachedFiles
                .map((file) => _buildAttachedFileItem(file))
                .toList()),
          ],

          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          InkWell(
            onTap: _pickFiles,
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: AppThemeResponsiveness.getDefaultSpacing(context),
                horizontal: AppThemeResponsiveness.getSmallSpacing(context),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF667EEA).withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getInputBorderRadius(context),
                ),
                color: Color(0xFF667EEA).withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: Color(0xFF667EEA),
                    size: AppThemeResponsiveness.getHeaderIconSize(context),
                  ),
                  SizedBox(
                    height: AppThemeResponsiveness.getSmallSpacing(context),
                  ),
                  Text(
                    'Tap to upload files',
                    style: AppThemeResponsiveness.getCaptionTextStyle(context)
                        .copyWith(
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height:
                    AppThemeResponsiveness.getSmallSpacing(context) * 0.5,
                  ),
                  Text(
                    'Supported: PDF, PNG, JPG, JPEG (Max 5MB each)',
                    style: AppThemeResponsiveness.getCaptionTextStyle(context)
                        .copyWith(
                      color: Color(0xFF718096),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedFileItem(PlatformFile file) {
    String fileName = file.name;
    String fileExtension = fileName.split('.').last.toLowerCase();

    IconData fileIcon;
    Color fileColor;

    switch (fileExtension) {
      case 'pdf':
        fileIcon = Icons.picture_as_pdf_outlined;
        fileColor = Color(0xFFDC2626);
        break;
      case 'png':
      case 'jpg':
      case 'jpeg':
        fileIcon = Icons.image_outlined;
        fileColor = Color(0xFF059669);
        break;
      default:
        fileIcon = Icons.insert_drive_file_outlined;
        fileColor = Color(0xFF6B7280);
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context) * 0.8,
        ),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getSmallSpacing(context) * 0.8,
            ),
            decoration: BoxDecoration(
              color: fileColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getInputBorderRadius(context) * 0.6,
              ),
            ),
            child: Icon(
              fileIcon,
              color: fileColor,
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppThemeResponsiveness.getCaptionTextStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: AppThemeResponsiveness.getSmallSpacing(context) * 0.3,
                ),
                Text(
                  '${(file.size / 1024).toStringAsFixed(1)} KB',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context)
                      .copyWith(
                    color: Color(0xFF718096),
                    fontSize:
                    AppThemeResponsiveness
                        .getCaptionTextStyle(
                      context,
                    )
                        .fontSize! *
                        0.9,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _removeFile(file),
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context) * 0.6,
            ),
            child: Container(
              padding: EdgeInsets.all(
                AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
              ),
              child: Icon(
                Icons.close,
                color: Color(0xFF718096),
                size: AppThemeResponsiveness.getIconSize(context) * 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            title: 'Cancel',
            color: AppThemeColor.blue600,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
        Expanded(
          child: PrimaryButton(
            title: 'Save',
            onPressed: _saveTimeTable,
            isLoading: _isLoading,
            icon: Icon(Icons.save_outlined, size: 18),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Check file size for each file (5MB limit)
        List<PlatformFile> validFiles = [];
        for (PlatformFile file in result.files) {
          if (file.size > 5 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File ${file.name} exceeds 5MB limit. Skipping this file.'),
                backgroundColor: Color(0xFFDC2626),
              ),
            );
            continue;
          }
          validFiles.add(file);
        }

        setState(() {
          _attachedFiles.addAll(validFiles);
        });

        if (validFiles.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${validFiles.length} file(s) selected successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: $e'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _attachedFiles.remove(file);
    });
  }

  void _saveTimeTable() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically save the timetable data to your backend
      // For now, we'll just show a success message
      AppSnackBar.show(
        context,
        message: 'Student timetable saved successfully!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }
}
