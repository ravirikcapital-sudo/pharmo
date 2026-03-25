// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:school/customWidgets/profile/infoCard.dart';
// import 'package:school/customWidgets/profile/mainProfileCard.dart';
// import 'package:school/customWidgets/profile/menuCard.dart';
// import 'package:school/customWidgets/profile/stats.dart';
// import 'package:school/customWidgets/snackBar.dart';
// import 'package:school/model/adminProfileModel.dart';
// import 'package:school/model/profileModel.dart';
// import 'package:school/CommonLogic/logout.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

// class AdminProfilePage extends StatefulWidget {
//   const AdminProfilePage({Key? key}) : super(key: key);

//   @override
//   State<AdminProfilePage> createState() => _AdminProfilePageState();
// }

// class _AdminProfilePageState extends State<AdminProfilePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   // Profile image using PlatformFile
//   PlatformFile? _profileImage;

//   // Controllers for editing
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _qualificationController = TextEditingController();

//   // Editing state
//   bool _isEditing = false;

//   // Sample admin data
//   AdminProfile adminData = AdminProfile(
//     name: 'Mr. Rajesh Kumar Sharma',
//     email: 'admin@royalpublic.edu',
//     phone: '+91 98765 43210',
//     adminId: 'ADM001',
//     role: 'System Administrator',
//     designation: 'Principal Administrator',
//     experience: '15 years',
//     qualification: 'M.B.A (Education Management), B.Ed',
//     address: '123 Administrative Block, Royal Public School, Mumbai, Maharashtra',
//     joinDate: 'March 15, 2009',
//     permissions: ['Full System Access', 'User Management', 'Academic Oversight', 'Financial Control', 'Reports Generation'],
//     managedSections: ['Academic Affairs', 'Student Management', 'Faculty Management', 'Finance', 'Infrastructure'],
//     totalUsers: 1250,
//     activeStudents: 875,
//     totalFaculty: 95,
//     totalStaff: 45,
//     systemUptime: '99.8%',
//     profileImageUrl: '', // Empty for default avatar
//   );

//   final List<MenuItemData> menuItems = [
//     MenuItemData(Icons.edit, 'Edit Profile', 'Update administrative information', '/edit-profile'),
//     MenuItemData(Icons.lock, 'Change Password', 'Update your password', '/change-password'),
//     MenuItemData(Icons.dashboard, 'System Dashboard', 'View system analytics', '/system-dashboard'),
//     MenuItemData(Icons.people, 'User Management', 'Manage all system users', '/user-management'),
//     MenuItemData(Icons.school, 'Academic Control', 'Oversee academic operations', '/academic-control'),
//     MenuItemData(Icons.account_balance_wallet, 'Financial Management', 'Manage school finances', '/financial-management'),
//     MenuItemData(Icons.assessment, 'Reports & Analytics', 'Generate system reports', '/reports-analytics'),
//     MenuItemData(Icons.settings, 'System Settings', 'Configure system parameters', '/system-settings'),
//     MenuItemData(Icons.security, 'Security Center', 'Manage security settings', '/security-center'),
//     MenuItemData(Icons.backup, 'Data Management', 'Backup and restore data', '/data-management'),
//     MenuItemData(Icons.notifications, 'Notifications', 'Manage notification settings', '/notifications'),
//     MenuItemData(Icons.language, 'Language', 'Change app language', '/language'),
//     MenuItemData(Icons.help, 'Help & Support', 'Get help and support', '/help'),
//     MenuItemData(Icons.logout, 'Logout', 'Sign out of your account', '/', isLogout: true),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeControllers();
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: AppThemeColor.slideAnimationDuration,
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutCubic,
//     ));

//     _animationController.forward();
//   }

//   void _initializeControllers() {
//     _nameController.text = adminData.name;
//     _emailController.text = adminData.email;
//     _phoneController.text = adminData.phone;
//     _addressController.text = adminData.address;
//     _qualificationController.text = adminData.qualification;
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _qualificationController.dispose();
//     super.dispose();
//   }

//   void _toggleEditMode() {
//     setState(() {
//       _isEditing = !_isEditing;
//       if (!_isEditing) {
//         // Reset controllers if canceling edit
//         _initializeControllers();
//       }
//     });
//   }

//   void _saveProfile() {
//     setState(() {
//       adminData = AdminProfile(
//         name: _nameController.text,
//         email: _emailController.text,
//         phone: _phoneController.text,
//         address: _addressController.text,
//         qualification: _qualificationController.text,
//         adminId: adminData.adminId,
//         role: adminData.role,
//         designation: adminData.designation,
//         experience: adminData.experience,
//         joinDate: adminData.joinDate,
//         permissions: adminData.permissions,
//         managedSections: adminData.managedSections,
//         totalUsers: adminData.totalUsers,
//         activeStudents: adminData.activeStudents,
//         totalFaculty: adminData.totalFaculty,
//         totalStaff: adminData.totalStaff,
//         systemUptime: adminData.systemUptime,
//         profileImageUrl: adminData.profileImageUrl,
//       );
//       _isEditing = false;
//     });

//     AppSnackBar.show(
//       context,
//       message: 'Admin profile updated successfully!',
//       backgroundColor: Colors.green,
//       icon: Icons.check_circle_outline,
//     );
//   }

//   // Handle image selection from ProfileCard
//   void _onImageSelected(PlatformFile? file) {
//     setState(() {
//       _profileImage = file;
//     });

//     if (file != null) {
//       AppSnackBar.show(
//         context,
//         message: 'Profile image updated successfully!',
//         backgroundColor: Colors.green,
//         icon: Icons.check_circle_outline,
//       );
//     } else {
//       AppSnackBar.show(
//         context,
//         message: 'Profile image removed!',
//         backgroundColor: Colors.orange,
//         icon: Icons.info_outline,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('System Administrator'),
//         backgroundColor: AppThemeColor.primaryBlue,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           if (_isEditing) ...[
//             IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: _toggleEditMode,
//               tooltip: 'Cancel',
//             ),
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _saveProfile,
//               tooltip: 'Save',
//             ),
//           ],
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppThemeColor.primaryGradient,
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: Column(
//                   children: [
//                     _buildProfileCard(context),
//                     _buildStatsCard(context),
//                     _buildSystemStatsCard(context),
//                     _buildInfoSection(context),
//                     _buildMenuSection(context),
//                     SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard(BuildContext context) {
//     return ProfileCard(
//       name: adminData.name,
//       designation: adminData.designation,
//       department: adminData.role,
//       profileImageUrl: adminData.profileImageUrl,
//       profileImageFile: _profileImage,
//       isEditing: _isEditing,
//       nameController: _nameController,
//       onImageSelected: _onImageSelected,
//     );
//   }

//   Widget _buildStatsCard(BuildContext context) {
//     return StatsCard(
//       items: [
//         StatItem(
//           icon: Icons.people,
//           value: '${adminData.totalUsers}',
//           label: 'Total Users',
//           color: AppThemeColor.primaryBlue,
//         ),
//         StatItem(
//           icon: Icons.school,
//           value: '${adminData.activeStudents}',
//           label: 'Students',
//           color: AppThemeColor.primaryIndigo,
//         ),
//         StatItem(
//           icon: Icons.person,
//           value: '${adminData.totalFaculty}',
//           label: 'Faculty',
//           color: Colors.green,
//         ),
//       ],
//     );
//   }

//   Widget _buildSystemStatsCard(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'System Overview',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppThemeColor.primaryBlue,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildSystemStatItem(
//                   Icons.trending_up,
//                   adminData.systemUptime,
//                   'System Uptime',
//                   Colors.green,
//                 ),
//               ),
//               Expanded(
//                 child: _buildSystemStatItem(
//                   Icons.group_work,
//                   '${adminData.totalStaff}',
//                   'Staff Members',
//                   Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSystemStatItem(IconData icon, String value, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: color.withOpacity(0.8),
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPermissionsSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.security, size: 20, color: AppThemeColor.blue600),
//             const SizedBox(width: 8),
//             const Text(
//               'System Permissions',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Wrap(
//           spacing: 6,
//           runSpacing: 6,
//           children: adminData.permissions
//               .map(
//                 (permission) => Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 10,
//                 vertical: 4,
//               ),
//               decoration: const BoxDecoration(
//                 gradient: AppThemeColor.primaryGradient,
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Text(
//                 permission,
//                 style: const TextStyle(
//                   color: AppThemeColor.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           )
//               .toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildManagedSectionsSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.business, size: 20, color: AppThemeColor.blue600),
//             const SizedBox(width: 8),
//             const Text(
//               'Managed Sections',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Wrap(
//           spacing: 6,
//           runSpacing: 6,
//           children: adminData.managedSections
//               .map(
//                 (section) => Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 10,
//                 vertical: 4,
//               ),
//               decoration: BoxDecoration(
//                 color: AppThemeColor.blue100,
//                 borderRadius: const BorderRadius.all(Radius.circular(20)),
//                 border: Border.all(color: AppThemeColor.blue200),
//               ),
//               child: Text(
//                 section,
//                 style: TextStyle(
//                   color: AppThemeColor.blue800,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           )
//               .toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoSection(BuildContext context) {
//     return ProfileInfoCard(
//       title: 'Administrative Information',
//       isEditing: _isEditing,
//       onToggleEditMode: _toggleEditMode,
//       onSaveChanges: _saveProfile,
//       editableFields: [
//         EditableField(
//           icon: Icons.email,
//           label: 'Email',
//           controller: _emailController,
//           value: adminData.email,
//         ),
//         EditableField(
//           icon: Icons.phone,
//           label: 'Phone',
//           controller: _phoneController,
//           value: adminData.phone,
//         ),
//         EditableField(
//           icon: Icons.school,
//           label: 'Qualification',
//           controller: _qualificationController,
//           value: adminData.qualification,
//         ),
//         EditableField(
//           icon: Icons.location_on,
//           label: 'Address',
//           controller: _addressController,
//           value: adminData.address,
//           maxLines: 2,
//         ),
//       ],
//       readOnlyFields: [
//         ReadOnlyField(
//           icon: Icons.badge,
//           label: 'Admin ID',
//           value: adminData.adminId,
//         ),
//         ReadOnlyField(
//           icon: Icons.work,
//           label: 'Experience',
//           value: adminData.experience,
//         ),
//         ReadOnlyField(
//           icon: Icons.calendar_today,
//           label: 'Join Date',
//           value: adminData.joinDate,
//         ),
//       ],
//       subjectsSection: _buildPermissionsSection(context),
//       classesSection: _buildManagedSectionsSection(context),
//     );
//   }

//   Widget _buildMenuSection(BuildContext context) {
//     return ProfileMenuCard(
//       items: menuItems,
//       onTap: (item) {
//         if (item.isLogout) {
//           LogoutDialog.show(context);
//         } else if (item.title == 'Edit Profile') {
//           _toggleEditMode();
//         } else {
//           try {
//             Navigator.pushNamed(context, item.path);
//           } catch (e) {
//             AppSnackBar.show(
//               context,
//               message: '${item.title} - Coming Soon!',
//               backgroundColor: Colors.green,
//               icon: Icons.check_circle_outline,
//             );
//           }
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/profile/infoCard.dart';
import 'package:school/customWidgets/profile/mainProfileCard.dart';
import 'package:school/customWidgets/profile/menuCard.dart';
import 'package:school/customWidgets/profile/stats.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/model/adminProfileModel.dart';
import 'package:school/model/profileModel.dart';
import 'package:school/CommonLogic/logout.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/services/api_services.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  PlatformFile? _profileImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;

  late AdminProfile adminData;

  final List<MenuItemData> menuItems = [
    MenuItemData(Icons.edit, 'Edit Profile', 'Update administrative information', '/edit-profile'),
    MenuItemData(Icons.lock, 'Change Password', 'Update your password', '/change-password'),
    MenuItemData(Icons.dashboard, 'System Dashboard', 'View system analytics', '/system-dashboard'),
    MenuItemData(Icons.people, 'User Management', 'Manage all system users', '/user-management'),
    MenuItemData(Icons.school, 'Academic Control', 'Oversee academic operations', '/academic-control'),
    MenuItemData(Icons.account_balance_wallet, 'Financial Management', 'Manage school finances', '/financial-management'),
    MenuItemData(Icons.assessment, 'Reports & Analytics', 'Generate system reports', '/reports-analytics'),
    MenuItemData(Icons.settings, 'System Settings', 'Configure system parameters', '/system-settings'),
    MenuItemData(Icons.security, 'Security Center', 'Manage security settings', '/security-center'),
    MenuItemData(Icons.backup, 'Data Management', 'Backup and restore data', '/data-management'),
    MenuItemData(Icons.notifications, 'Notifications', 'Manage notification settings', '/notifications'),
    MenuItemData(Icons.language, 'Language', 'Change app language', '/language'),
    MenuItemData(Icons.help, 'Help & Support', 'Get help and support', '/help'),
    MenuItemData(Icons.logout, 'Logout', 'Sign out of your account', '/', isLogout: true),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAdminProfile();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppThemeColor.slideAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  Future<void> _loadAdminProfile() async {
    try {
      final profile = await ApiService().getAdminProfile();

      setState(() {
        adminData = profile;

        _nameController.text = adminData.name;
        _emailController.text = adminData.email;
        _phoneController.text = adminData.phone;
        _addressController.text = adminData.address;
        _qualificationController.text = adminData.qualification;

        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        AppSnackBar.show(context,
            message: 'Failed to load profile: $e',
            backgroundColor: Colors.red,
            icon: Icons.error_outline);
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _loadAdminProfile();
    });
  }

  Future<void> _saveProfile() async {
    try {
      final updated = adminData.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        qualification: _qualificationController.text,
      );

      final success = await ApiService().updateAdminProfile(updated);

      if (success) {
        setState(() {
          adminData = updated;
          _isEditing = false;
        });

        if (mounted) {
          AppSnackBar.show(context,
              message: 'Admin profile updated successfully!',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline);
        }
      } else {
        if (mounted) {
          AppSnackBar.show(context,
              message: 'Failed to update profile. Please try again.',
              backgroundColor: Colors.red,
              icon: Icons.error_outline);
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context,
            message: 'Error updating profile: $e',
            backgroundColor: Colors.red,
            icon: Icons.error_outline);
      }
    }
  }

  void _onImageSelected(PlatformFile? file) {
    setState(() => _profileImage = file);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Administrator'),
        backgroundColor: AppThemeColor.primaryBlue,
        foregroundColor: Colors.white,
        actions: _isEditing
            ? [
                IconButton(icon: const Icon(Icons.close), onPressed: _toggleEditMode),
                IconButton(icon: const Icon(Icons.check), onPressed: _saveProfile),
              ]
            : [],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    ProfileCard(
                      name: adminData.name,
                      designation: adminData.designation,
                      department: adminData.role,
                      profileImageUrl: adminData.profileImageUrl,
                      profileImageFile: _profileImage,
                      isEditing: _isEditing,
                      nameController: _nameController,
                      onImageSelected: _onImageSelected,
                    ),
                    StatsCard(items: [
                      StatItem(icon: Icons.people, value: '${adminData.totalUsers}', label: 'Total Users', color: AppThemeColor.primaryBlue),
                      StatItem(icon: Icons.school, value: '${adminData.activeStudents}', label: 'Students', color: AppThemeColor.primaryIndigo),
                      StatItem(icon: Icons.person, value: '${adminData.totalFaculty}', label: 'Faculty', color: Colors.green),
                    ]),
                    ProfileInfoCard(
                      title: 'Administrative Information',
                      isEditing: _isEditing,
                      onToggleEditMode: _toggleEditMode,
                      onSaveChanges: _saveProfile,
                      editableFields: [
                        EditableField(icon: Icons.email, label: 'Email', controller: _emailController, value: adminData.email),
                        EditableField(icon: Icons.phone, label: 'Phone', controller: _phoneController, value: adminData.phone),
                        EditableField(icon: Icons.school, label: 'Qualification', controller: _qualificationController, value: adminData.qualification),
                        EditableField(icon: Icons.location_on, label: 'Address', controller: _addressController, value: adminData.address, maxLines: 2),
                      ],
                      readOnlyFields: [
                        ReadOnlyField(icon: Icons.badge, label: 'Admin ID', value: adminData.adminId),
                        ReadOnlyField(icon: Icons.work, label: 'Experience', value: adminData.experience),
                        ReadOnlyField(icon: Icons.calendar_today, label: 'Join Date', value: adminData.joinDate),
                      ],
                    ),
                    ProfileMenuCard(
                      items: menuItems,
                      onTap: (item) {
                        if (item.isLogout) LogoutDialog.show(context);
                        else if (item.title == 'Edit Profile') _toggleEditMode();
                        else Navigator.pushNamed(context, item.path);
                      },
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
