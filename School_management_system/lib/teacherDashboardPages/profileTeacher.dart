import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/profile/infoCard.dart';
import 'package:school/customWidgets/profile/mainProfileCard.dart';
import 'package:school/customWidgets/profile/menuCard.dart';
import 'package:school/customWidgets/profile/stats.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'dart:io';
import 'package:school/model/profileModel.dart';
import 'package:school/CommonLogic/logout.dart';
import 'package:school/model/dashboard/teacherDashboardModel/teacherProfile.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({Key? key}) : super(key: key);

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  // Changed from File? to PlatformFile? to match ProfileCard
  PlatformFile? _profileImageFile;

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _qualificationController =
  TextEditingController();

  // Editing state
  bool _isEditing = false;

  // Sample teacher data
  TeacherProfile teacherData = TeacherProfile(
    name: 'Dr. Sarah Johnson',
    email: 'sarah.johnson@royalpublic.edu',
    phone: '+91 98765 43210',
    employeeId: 'EMP001',
    department: 'Mathematics & Science',
    designation: 'Senior Teacher',
    experience: '8 years',
    qualification: 'M.Sc Mathematics, B.Ed',
    address: '123 Education Lane, Mumbai, Maharashtra',
    joinDate: 'August 15, 2016',
    subjects: ['Mathematics', 'Physics', 'Computer Science'],
    classes: ['Class 10A', 'Class 11B', 'Class 12C'],
    totalStudents: 125,
    completedLessons: 245,
    attendanceRate: 96.5,
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
      Icons.lock,
      'Change Password',
      'Update your password',
      '/change-password',
    ),
    MenuItemData(
      Icons.notifications,
      'Notifications',
      'Manage notification settings',
      '/notifications',
    ),
    MenuItemData(
      Icons.language,
      'Language',
      'Change app language',
      '/language',
    ),
    MenuItemData(
      Icons.language,
      'Salary',
      'Check your salary',
      '/teacher-salary',
    ),
    MenuItemData(Icons.help, 'Help & Support', 'Get help and support', '/help'),
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
    _nameController.text = teacherData.name;
    _emailController.text = teacherData.email;
    _phoneController.text = teacherData.phone;
    _addressController.text = teacherData.address;
    _qualificationController.text = teacherData.qualification;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
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
      teacherData = TeacherProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        qualification: _qualificationController.text,
        employeeId: teacherData.employeeId,
        department: teacherData.department,
        designation: teacherData.designation,
        experience: teacherData.experience,
        joinDate: teacherData.joinDate,
        subjects: teacherData.subjects,
        classes: teacherData.classes,
        totalStudents: teacherData.totalStudents,
        completedLessons: teacherData.completedLessons,
        attendanceRate: teacherData.attendanceRate,
        profileImageUrl: teacherData.profileImageUrl,
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

  // Updated image selection handler to match ProfileCard's onImageSelected callback
  void _handleImageSelected(PlatformFile? file) {
    setState(() {
      _profileImageFile = file;
    });

    if (file != null) {
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
      name: teacherData.name,
      designation: teacherData.designation,
      department: teacherData.department,
      profileImageUrl: teacherData.profileImageUrl,
      profileImageFile: _profileImageFile, // Changed from _profileImage
      isEditing: _isEditing,
      nameController: _nameController,
      onImageSelected: _handleImageSelected, // Changed from onImageTap
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return StatsCard(
      items: [
        StatItem(
          icon: Icons.group,
          value: '${teacherData.totalStudents}',
          label: 'Students',
          color: Colors.blue.shade600,
        ),
        StatItem(
          icon: Icons.book,
          value: '${teacherData.completedLessons}',
          label: 'Lessons',
          color: Colors.indigo.shade600,
        ),
        StatItem(
          icon: Icons.trending_up,
          value: '${teacherData.attendanceRate}%',
          label: 'Attendance',
          color: Colors.green,
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
            Icon(Icons.subject, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text(
              'Teaching Subjects',
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
          children: teacherData.subjects
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
          value: teacherData.email,
        ),
        EditableField(
          icon: Icons.phone,
          label: 'Phone',
          controller: _phoneController,
          value: teacherData.phone,
        ),
        EditableField(
          icon: Icons.school,
          label: 'Qualification',
          controller: _qualificationController,
          value: teacherData.qualification,
        ),
        EditableField(
          icon: Icons.location_on,
          label: 'Address',
          controller: _addressController,
          value: teacherData.address,
          maxLines: 2,
        ),
      ],
      readOnlyFields: [
        ReadOnlyField(
          icon: Icons.badge,
          label: 'Employee ID',
          value: teacherData.employeeId,
        ),
        ReadOnlyField(
          icon: Icons.work,
          label: 'Experience',
          value: teacherData.experience,
        ),
        ReadOnlyField(
          icon: Icons.calendar_today,
          label: 'Join Date',
          value: teacherData.joinDate,
        ),
      ],
      subjectsSection: _buildSubjectsSection(context),
      classesSection: _buildClassesSection(context),
    );
  }

  Widget _buildClassesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.class_, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text(
              'Assigned Classes',
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
          children: teacherData.classes
              .map(
                (className) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                className,
                style: TextStyle(
                  color: Colors.blue.shade800,
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

  Widget _buildMenuSection(BuildContext context) {
    return ProfileMenuCard(
      items: menuItems,
      onTap: (item) {
        if (item.isLogout) {
          LogoutDialog.show(context);
        } else if (item.title == 'Edit Profile') {
          _toggleEditMode(); // Or pass a callback
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