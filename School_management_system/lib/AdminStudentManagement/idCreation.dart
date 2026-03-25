// student_id_creation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:school/AdminStudentManagement/studentModel.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class StudentIdCreationPage extends StatefulWidget {
  final Student student;

  const StudentIdCreationPage({Key? key, required this.student}) : super(key: key);

  @override
  _StudentIdCreationPageState createState() => _StudentIdCreationPageState();
}

class _StudentIdCreationPageState extends State<StudentIdCreationPage> {
  final GlobalKey _idCardKey = GlobalKey();

  // ID Card customization options
  Map<String, bool> selectedFields = {
    'name': true,
    'studentId': true,
    'class': true,
    'dateOfBirth': false,
    'phone': false,
    'email': false,
    'address': false,
    'admissionStatus': false,
  };

  String selectedTemplate = 'template1';
  Color selectedPrimaryColor = AppThemeColor.primaryBlue;
  Color selectedSecondaryColor = Colors.white;
  bool isGenerating = false;

  final List<Map<String, dynamic>> templates = [
    {
      'id': 'template1',
      'name': 'Classic Blue',
      'primaryColor': AppThemeColor.primaryBlue,
      'secondaryColor': Colors.white,
    },
    {
      'id': 'template2',
      'name': 'Green Theme',
      'primaryColor': Colors.green,
      'secondaryColor': Colors.white,
    },
    {
      'id': 'template3',
      'name': 'Purple Theme',
      'primaryColor': Colors.purple,
      'secondaryColor': Colors.white,
    },
    {
      'id': 'template4',
      'name': 'Orange Theme',
      'primaryColor': Colors.orange,
      'secondaryColor': Colors.white,
    },
  ];

  Widget _buildFieldSelector() {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Fields to Include',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: AppThemeColor.primaryBlue,
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            ...selectedFields.entries.map((entry) {
              return CheckboxListTile(
                title: Text(
                  _getFieldDisplayName(entry.key),
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                ),
                value: entry.value,
                activeColor: AppThemeColor.primaryBlue,
                onChanged: (value) {
                  setState(() {
                    selectedFields[entry.key] = value ?? false;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getFieldDisplayName(String fieldKey) {
    switch (fieldKey) {
      case 'name':
        return 'Student Name';
      case 'studentId':
        return 'Student ID';
      case 'class':
        return 'Class';
      case 'dateOfBirth':
        return 'Date of Birth';
      case 'phone':
        return 'Phone Number';
      case 'email':
        return 'Email Address';
      case 'address':
        return 'Address';
      case 'admissionStatus':
        return 'Admission Status';
      default:
        return fieldKey;
    }
  }

  Widget _buildTemplateSelector() {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Template',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: AppThemeColor.primaryBlue,
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppThemeResponsiveness.isMobile(context) ? 2 : 4,
                crossAxisSpacing: AppThemeResponsiveness.getSmallSpacing(context),
                mainAxisSpacing: AppThemeResponsiveness.getSmallSpacing(context),
                childAspectRatio: 1.5,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final isSelected = selectedTemplate == template['id'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTemplate = template['id'];
                      selectedPrimaryColor = template['primaryColor'];
                      selectedSecondaryColor = template['secondaryColor'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: template['primaryColor'],
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        template['name'],
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardPreview() {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Card Preview',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: AppThemeColor.primaryBlue,
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            Center(
              child: RepaintBoundary(
                key: _idCardKey,
                child: _buildIdCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCard() {
    // Make the card responsive to screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = AppThemeResponsiveness.isMobile(context)
        ? screenWidth * 0.8
        : 300.0;
    final cardHeight = cardWidth * 0.67; // Maintain aspect ratio

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [selectedPrimaryColor, selectedPrimaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: cardWidth * 0.08, // Responsive avatar size
                  backgroundColor: selectedSecondaryColor,
                  child: Text(
                    widget.student.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: cardWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: selectedPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STUDENT ID CARD',
                        style: TextStyle(
                          fontSize: cardWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: selectedSecondaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'SCHOOL NAME',
                        style: TextStyle(
                          fontSize: cardWidth * 0.033,
                          color: selectedSecondaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Student Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (selectedFields['name']!)
                    _buildIdCardField('Name', widget.student.name, cardWidth),
                  if (selectedFields['studentId']!)
                    _buildIdCardField('ID', widget.student.id, cardWidth),
                  if (selectedFields['class']!)
                    _buildIdCardField('Class', widget.student.className, cardWidth),
                  if (selectedFields['dateOfBirth']!)
                    _buildIdCardField('DOB',
                        '${widget.student.dateOfBirth.day}/${widget.student.dateOfBirth.month}/${widget.student.dateOfBirth.year}', cardWidth),
                  if (selectedFields['phone']!)
                    _buildIdCardField('Phone', widget.student.phone, cardWidth),
                  if (selectedFields['email']!)
                    _buildIdCardField('Email', widget.student.email, cardWidth),
                  if (selectedFields['admissionStatus']!)
                    _buildIdCardField('Status', widget.student.admissionStatus, cardWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardField(String label, String value, double cardWidth) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontSize: cardWidth * 0.033,
              fontWeight: FontWeight.bold,
              color: selectedSecondaryColor,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: cardWidth * 0.033,
              color: selectedSecondaryColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndPrintId() async {
    setState(() {
      isGenerating = true;
    });

    try {
      // Simulate ID generation process
      await Future.delayed(Duration(seconds: 2));

      // Here you would typically:
      // 1. Generate the ID card as an image
      // 2. Save it to device storage
      // 3. Send to printer or save as PDF

      // For demonstration, we'll show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student ID Card generated successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Print',
            textColor: Colors.white,
            onPressed: () {
              _printId();
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating ID card: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  Future<void> _printId() async {
    try {
      // Convert widget to image
      RenderRepaintBoundary boundary =
      _idCardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Here you would integrate with a printing service
      // For now, we'll just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ID Card sent to printer!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error printing ID card: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                ),
                child: Column(
                  children: [
                    // Header
                    Text(
                      'Create Student ID Card',
                      style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                        fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),

                    // Field Selector
                    _buildFieldSelector(),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // Template Selector
                    _buildTemplateSelector(),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // ID Card Preview
                    _buildIdCardPreview(),
                    SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),

                    // Action Buttons - Changed to Column layout
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            title: 'Generate & Print ID',
                            onPressed: _generateAndPrintId,
                            isLoading: isGenerating,
                            color: Colors.green,
                            icon: Icon(
                              Icons.print,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                        SizedBox(
                          width: double.infinity,
                          child: SecondaryButton(
                            title: 'Back',
                            onPressed: () => Navigator.pop(context),
                            color: AppThemeColor.primaryBlue,
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppThemeColor.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}