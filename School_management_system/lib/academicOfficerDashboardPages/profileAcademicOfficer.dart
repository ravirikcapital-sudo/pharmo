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
import 'package:school/model/dashboard/academicOfficerDashboardModel/profileAcademicOfficerModel.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class AcademicOfficerProfilePage extends StatefulWidget {
  const AcademicOfficerProfilePage({Key? key}) : super(key: key);

  @override
  State<AcademicOfficerProfilePage> createState() => _AcademicOfficerProfilePageState();
}

class _AcademicOfficerProfilePageState extends State<AcademicOfficerProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Changed from File? to PlatformFile? to match ProfileCard
  PlatformFile? _profileImageFile;

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();

  // Editing state
  bool _isEditing = false;

  // Sample academic officer data
  AcademicOfficerProfile officerData = AcademicOfficerProfile(
    name: 'Dr. Michael Rodriguez',
    email: 'michael.rodriguez@royalpublic.edu',
    phone: '+91 98765 43211',
    employeeId: 'AO001',
    department: 'Academic Affairs',
    designation: 'Senior Academic Officer',
    experience: '12 years',
    qualification: 'Ph.D Education Administration, M.Ed',
    address: '456 Academic Street, Mumbai, Maharashtra',
    joinDate: 'June 10, 2012',
    responsibilities: ['Curriculum Development', 'Academic Planning', 'Quality Assurance', 'Faculty Coordination'],
    managedDepartments: ['Mathematics', 'Science', 'English', 'Social Studies'],
    totalFaculty: 45,
    activeCourses: 32,
    completedProjects: 18,
    profileImageUrl: '', // Empty for default avatar
  );

  final List<MenuItemData> menuItems = [
    MenuItemData(Icons.edit, 'Edit Profile', 'Update professional information', '/edit-profile'),
    MenuItemData(Icons.lock, 'Change Password', 'Update your password', '/change-password'),
    MenuItemData(Icons.analytics, 'Academic Reports', 'View department analytics', '/academic-reports'),
    MenuItemData(Icons.schedule, 'Course Management', 'Manage academic schedules', '/course-management'),
    MenuItemData(Icons.group, 'Faculty Management', 'Manage faculty members', '/faculty-management'),
    MenuItemData(Icons.notifications, 'Notifications', 'Manage notification settings', '/notifications'),
    MenuItemData(Icons.language, 'Language', 'Change app language', '/language'),
    MenuItemData(Icons.help, 'Help & Support', 'Get help and support', '/help'),
    MenuItemData(Icons.logout, 'Logout', 'Sign out of your account', '/', isLogout: true),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeControllers();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppThemeColor.slideAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _initializeControllers() {
    _nameController.text = officerData.name;
    _emailController.text = officerData.email;
    _phoneController.text = officerData.phone;
    _addressController.text = officerData.address;
    _qualificationController.text = officerData.qualification;
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      officerData = AcademicOfficerProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        qualification: _qualificationController.text,
        employeeId: officerData.employeeId,
        department: officerData.department,
        designation: officerData.designation,
        experience: officerData.experience,
        joinDate: officerData.joinDate,
        responsibilities: officerData.responsibilities,
        managedDepartments: officerData.managedDepartments,
        totalFaculty: officerData.totalFaculty,
        activeCourses: officerData.activeCourses,
        completedProjects: officerData.completedProjects,
        profileImageUrl: officerData.profileImageUrl,
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

  // Updated image selection handler to match ProfileCard's callback
  void _handleImageSelection(PlatformFile? file) {
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
        title: const Text('Academic Officer Profile'),
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
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildProfileCard(context),
                    _buildStatsCard(context),
                    _buildInfoSection(context),
                    _buildMenuSection(context),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return ProfileCard(
      name: officerData.name,
      designation: officerData.designation,
      department: officerData.department,
      profileImageUrl: officerData.profileImageUrl,
      profileImageFile: _profileImageFile,
      isEditing: _isEditing,
      nameController: _nameController,
      onImageSelected: _handleImageSelection, // Fixed: changed from onImageTap
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return StatsCard(
      items: [
        StatItem(
          icon: Icons.people,
          value: '${officerData.totalFaculty}',
          label: 'Faculty',
          color: AppThemeColor.primaryBlue,
        ),
        StatItem(
          icon: Icons.library_books,
          value: '${officerData.activeCourses}',
          label: 'Courses',
          color: AppThemeColor.primaryIndigo,
        ),
        StatItem(
          icon: Icons.assignment_turned_in,
          value: '${officerData.completedProjects}',
          label: 'Projects',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildResponsibilitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assignment, size: 20, color: AppThemeColor.blue600),
            const SizedBox(width: 8),
            const Text(
              'Key Responsibilities',
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
          children: officerData.responsibilities
              .map(
                (responsibility) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: const BoxDecoration(
                gradient: AppThemeColor.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                responsibility,
                style: const TextStyle(
                  color: AppThemeColor.white,
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

  Widget _buildDepartmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.business, size: 20, color: AppThemeColor.blue600),
            const SizedBox(width: 8),
            const Text(
              'Managed Departments',
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
          children: officerData.managedDepartments
              .map(
                (department) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppThemeColor.blue100,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: AppThemeColor.blue200),
              ),
              child: Text(
                department,
                style: TextStyle(
                  color: AppThemeColor.blue800,
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
      title: 'Professional Information',
      isEditing: _isEditing,
      onToggleEditMode: _toggleEditMode,
      onSaveChanges: _saveProfile,
      editableFields: [
        EditableField(
          icon: Icons.email,
          label: 'Email',
          controller: _emailController,
          value: officerData.email,
        ),
        EditableField(
          icon: Icons.phone,
          label: 'Phone',
          controller: _phoneController,
          value: officerData.phone,
        ),
        EditableField(
          icon: Icons.school,
          label: 'Qualification',
          controller: _qualificationController,
          value: officerData.qualification,
        ),
        EditableField(
          icon: Icons.location_on,
          label: 'Address',
          controller: _addressController,
          value: officerData.address,
          maxLines: 2,
        ),
      ],
      readOnlyFields: [
        ReadOnlyField(
          icon: Icons.badge,
          label: 'Employee ID',
          value: officerData.employeeId,
        ),
        ReadOnlyField(
          icon: Icons.work,
          label: 'Experience',
          value: officerData.experience,
        ),
        ReadOnlyField(
          icon: Icons.calendar_today,
          label: 'Join Date',
          value: officerData.joinDate,
        ),
      ],
      subjectsSection: _buildResponsibilitiesSection(context),
      classesSection: _buildDepartmentsSection(context),
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