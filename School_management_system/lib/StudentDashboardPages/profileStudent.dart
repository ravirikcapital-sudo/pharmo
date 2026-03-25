import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/profile/infoCard.dart';
import 'package:school/customWidgets/profile/mainProfileCard.dart';
import 'package:school/customWidgets/profile/menuCard.dart';
import 'package:school/customWidgets/profile/stats.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'dart:io';
import 'package:school/model/profileModel.dart';
import 'package:school/CommonLogic/logout.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/studentProfileModel.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  // Changed from File? to PlatformFile? to match ProfileCard expectations
  PlatformFile? _profileImage;

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  // Editing state
  bool _isEditing = false;

  // Sample student data
  StudentProfile studentData = StudentProfile(
    name: 'Arjun Sharma',
    email: 'arjun.sharma@student.royalpublic.edu',
    phone: '+91 98765 43211',
    studentId: 'STU2024001',
    rollNumber: '10A-25',
    className: 'Class 10A',
    section: 'A',
    academicYear: '2024-25',
    dateOfBirth: 'June 15, 2009',
    address: '456 Student Colony, Mumbai, Maharashtra',
    admissionDate: 'April 10, 2019',
    parentName: 'Mr. Rajesh Sharma',
    parentPhone: '+91 98765 43200',
    emergencyContact: '+91 98765 43199',
    bloodGroup: 'B+',
    religion: 'Hindu',
    category: 'General',
    subjects: ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Hindi'],
    currentGrade: 'A',
    overallPercentage: 87.5,
    attendance: 94.2,
    totalSubjects: 6,
    completedAssignments: 45,
    pendingAssignments: 3,
    profileImageUrl: '', // Empty for default avatar
  );

  final menuItems = [
    MenuItemData(
      Icons.edit,
      'Edit Profile',
      'Update personal information',
      '/edit-profile',
    ),
    MenuItemData(
      Icons.assignment,
      'Assignments',
      'View assignments and homework',
      '/assignments',
    ),
    MenuItemData(
      Icons.grade,
      'Grades & Results',
      'Check your academic performance',
      '/student-subject-marks',
    ),
    MenuItemData(
      Icons.calendar_today,
      'Attendance',
      'View attendance record',
      '/student-attendance-report',
    ),
    MenuItemData(
      Icons.schedule,
      'Timetable',
      'View class schedule',
      '/student-timetable',
    ),
    MenuItemData(
      Icons.notifications,
      'Notifications',
      'Manage notification settings',
      '/student-notice-message',
    ),
    MenuItemData(
      Icons.language,
      'Language',
      'Change app language',
      '/language',
    ),
    MenuItemData(Icons.help, 'Help & Support', 'Get help and support', '/school-help'),
    MenuItemData(
      Icons.logout,
      'Logout',
      'Sign out of your account',
      '/',
      isLogout: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = studentData.name;
    _emailController.text = studentData.email;
    _phoneController.text = studentData.phone;
    _addressController.text = studentData.address;
    _parentNameController.text = studentData.parentName;
    _parentPhoneController.text = studentData.parentPhone;
    _emergencyContactController.text = studentData.emergencyContact;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers if canceling edit
        _initializeControllers();
      }
    });
  }

  void _saveProfile() {
    setState(() {
      studentData = StudentProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        parentName: _parentNameController.text,
        parentPhone: _parentPhoneController.text,
        emergencyContact: _emergencyContactController.text,
        studentId: studentData.studentId,
        rollNumber: studentData.rollNumber,
        className: studentData.className,
        section: studentData.section,
        academicYear: studentData.academicYear,
        dateOfBirth: studentData.dateOfBirth,
        admissionDate: studentData.admissionDate,
        bloodGroup: studentData.bloodGroup,
        religion: studentData.religion,
        category: studentData.category,
        subjects: studentData.subjects,
        currentGrade: studentData.currentGrade,
        overallPercentage: studentData.overallPercentage,
        attendance: studentData.attendance,
        totalSubjects: studentData.totalSubjects,
        completedAssignments: studentData.completedAssignments,
        pendingAssignments: studentData.pendingAssignments,
        profileImageUrl: studentData.profileImageUrl,
      );
      _isEditing = false;
    });

    AppSnackBar.show(
      context,
      message: 'Profile updated successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  // Updated image selection handler to work with PlatformFile
  void _handleImageSelection(PlatformFile? selectedImage) {
    setState(() {
      _profileImage = selectedImage;
    });

    if (selectedImage != null) {
      AppSnackBar.show(
        context,
        message: 'Profile picture updated!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppThemeColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleEditMode,
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
              tooltip: 'Save',
            ),
          ],
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileCard(context),
                _buildStatsCard(context),
                _buildInfoSection(context),
                _buildMenuSection(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return ProfileCard(
      name: studentData.name,
      designation: 'Student',
      department: '${studentData.className} - ${studentData.section}',
      profileImageUrl: studentData.profileImageUrl,
      profileImageFile: _profileImage, // Now correctly typed as PlatformFile?
      isEditing: _isEditing,
      nameController: _nameController,
      onImageSelected: _handleImageSelection, // Updated callback
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return StatsCard(
      items: [
        StatItem(
          icon: Icons.grade,
          value: studentData.currentGrade,
          label: 'Current Grade',
          color: Colors.green.shade600,
        ),
        StatItem(
          icon: Icons.percent,
          value: '${studentData.overallPercentage}%',
          label: 'Overall %',
          color: Colors.blue.shade600,
        ),
        StatItem(
          icon: Icons.trending_up,
          value: '${studentData.attendance}%',
          label: 'Attendance',
          color: Colors.orange.shade600,
        ),
        StatItem(
          icon: Icons.assignment,
          value: '${studentData.completedAssignments}',
          label: 'Completed',
          color: Colors.purple.shade600,
        ),
      ],
    );
  }

  Widget _buildSubjectsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.book, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text(
              'Subjects',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: studentData.subjects
              .map(
                (subject) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subject,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAcademicInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.school, size: 20, color: Colors.green.shade600),
            const SizedBox(width: 8),
            const Text(
              'Academic Information',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoTile(
                'Class',
                studentData.className,
                Icons.class_,
                Colors.blue.shade100,
                Colors.blue.shade800,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoTile(
                'Roll No.',
                studentData.rollNumber,
                Icons.numbers,
                Colors.green.shade100,
                Colors.green.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoTile(
                'Academic Year',
                studentData.academicYear,
                Icons.calendar_today,
                Colors.orange.shade100,
                Colors.orange.shade800,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoTile(
                'Blood Group',
                studentData.bloodGroup,
                Icons.water_drop,
                Colors.red.shade100,
                Colors.red.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return ProfileInfoCard(
      title: 'Personal Information',
      isEditing: _isEditing,
      onToggleEditMode: _toggleEditMode,
      onSaveChanges: _saveProfile,
      editableFields: [
        EditableField(
          icon: Icons.email,
          label: 'Email',
          controller: _emailController,
          value: studentData.email,
        ),
        EditableField(
          icon: Icons.phone,
          label: 'Phone',
          controller: _phoneController,
          value: studentData.phone,
        ),
        EditableField(
          icon: Icons.location_on,
          label: 'Address',
          controller: _addressController,
          value: studentData.address,
          maxLines: 2,
        ),
        EditableField(
          icon: Icons.person,
          label: 'Parent Name',
          controller: _parentNameController,
          value: studentData.parentName,
        ),
        EditableField(
          icon: Icons.phone,
          label: 'Parent Phone',
          controller: _parentPhoneController,
          value: studentData.parentPhone,
        ),
        EditableField(
          icon: Icons.emergency,
          label: 'Emergency Contact',
          controller: _emergencyContactController,
          value: studentData.emergencyContact,
        ),
      ],
      readOnlyFields: [
        ReadOnlyField(
          icon: Icons.badge,
          label: 'Student ID',
          value: studentData.studentId,
        ),
        ReadOnlyField(
          icon: Icons.cake,
          label: 'Date of Birth',
          value: studentData.dateOfBirth,
        ),
        ReadOnlyField(
          icon: Icons.calendar_today,
          label: 'Admission Date',
          value: studentData.admissionDate,
        ),
        ReadOnlyField(
          icon: Icons.category,
          label: 'Category',
          value: studentData.category,
        ),
        ReadOnlyField(
          icon: Icons.church,
          label: 'Religion',
          value: studentData.religion,
        ),
      ],
      subjectsSection: _buildSubjectsSection(context),
      classesSection: _buildAcademicInfoSection(context),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return ProfileMenuCard(
      items: menuItems,
      onTap: (item) {
        if (item.isLogout) {
          LogoutDialog.show(context);
        } else if (item.title == 'Edit Profile') {
          _toggleEditMode();
        } else {
          try {
            Navigator.pushNamed(context, item.path);
          } catch (e) {
            AppSnackBar.show(
              context,
              message: '${item.title} - Coming Soon!',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline,
            );
          }
        }
      },
    );
  }
}