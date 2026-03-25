import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/systemControlModel.dart';
import 'package:school/services/api_services.dart';


class SystemControlsPage extends StatefulWidget {
  @override
  _SystemControlsPageState createState() => _SystemControlsPageState();
}

class _SystemControlsPageState extends State<SystemControlsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  // Data lists
  List<LoginHistory> loginHistories = [];
  List<Announcement> announcements = [];
  SystemSetting? systemSettings;

  // Loading states
  bool isLoadingLoginHistory = false;
  bool isLoadingAnnouncements = false;
  bool isLoadingSettings = false;

  // Selected user for login history filtering
  int? selectedUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllData();
  }

  // Load all data
  Future<void> _loadAllData() async {
    await Future.wait([
      _loadLoginHistory(),
      _loadAnnouncements(),
      _loadSystemSettings(),
    ]);
  }

  // ========== LOGIN HISTORY METHODS ==========

  Future<void> _loadLoginHistory() async {
    setState(() => isLoadingLoginHistory = true);
    try {
      print('Loading login history...');
      final response = await _apiService.getAllLoginHistory();
      print('Login history response: success=${response.success}, statusCode=${response.statusCode}');
      if (response.success && response.data != null) {
        setState(() {
          loginHistories = response.data!.map((json) => LoginHistory.fromJson(json)).toList();
        });
        print('Loaded ${loginHistories.length} login history records');
      } else {
        if (response.statusCode != 401) {
          _showErrorSnackBar('Failed to load login history: ${response.message}');
        }
      }
    } catch (e) {
      print('Error loading login history: $e');
      _showErrorSnackBar('Error loading login history: $e');
    } finally {
      setState(() => isLoadingLoginHistory = false);
    }
  }

  Future<void> _loadUserLoginHistory(int userId) async {
    setState(() => isLoadingLoginHistory = true);
    try {
      final response = await _apiService.getUserLoginHistory(userId);
      if (response.success && response.data != null) {
        setState(() {
          loginHistories = response.data!.map((json) => LoginHistory.fromJson(json)).toList();
          selectedUserId = userId;
        });
      } else {
        _showErrorSnackBar('Failed to load user login history: ${response.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Error loading user login history: $e');
    } finally {
      setState(() => isLoadingLoginHistory = false);
    }
  }

  // ========== ANNOUNCEMENT METHODS ==========

  Future<void> _loadAnnouncements() async {
    setState(() => isLoadingAnnouncements = true);
    try {
      print('Loading announcements...');
      final response = await _apiService.getAllAnnouncements();
      print('Announcements response: success=${response.success}, statusCode=${response.statusCode}');
      if (response.success && response.data != null) {
        setState(() {
          announcements = response.data!.map((json) => Announcement.fromJson(json)).toList();
        });
        print('Loaded ${announcements.length} announcements');
      } else {
        if (response.statusCode != 401) {
          _showErrorSnackBar('Failed to load announcements: ${response.message}');
        }
      }
    } catch (e) {
      print('Error loading announcements: $e');
      _showErrorSnackBar('Error loading announcements: $e');
    } finally {
      setState(() => isLoadingAnnouncements = false);
    }
  }

  Future<void> _createAnnouncement({
    required String title,
    required String message,
    required bool isActive,
  }) async {
    try {
      final response = await _apiService.createAnnouncement(
        title: title,
        message: message,
        isActive: isActive,
      );
      if (response.success) {
        _showSuccessSnackBar('Announcement created successfully');
        await _loadAnnouncements();
      } else {
        _showErrorSnackBar('Failed to create announcement: ${response.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Error creating announcement: $e');
    }
  }

  Future<void> _updateAnnouncement({
    required int id,
    required String title,
    required String message,
    required bool isActive,
  }) async {
    try {
      final response = await _apiService.updateAnnouncement(
        id: id,
        title: title,
        message: message,
        isActive: isActive,
      );
      if (response.success) {
        _showSuccessSnackBar('Announcement updated successfully');
        await _loadAnnouncements();
      } else {
        _showErrorSnackBar('Failed to update announcement: ${response.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating announcement: $e');
    }
  }

  Future<void> _deleteAnnouncementAPI(int id) async {
    try {
      final response = await _apiService.deleteAnnouncement(id);
      if (response.success) {
        _showSuccessSnackBar('Announcement deleted successfully');
        await _loadAnnouncements();
      } else {
        _showErrorSnackBar('Failed to delete announcement: ${response.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Error deleting announcement: $e');
    }
  }

  // ========== SYSTEM SETTINGS METHODS ==========

  Future<void> _loadSystemSettings() async {
    setState(() => isLoadingSettings = true);
    try {
      final response = await _apiService.getSystemSettings();
      if (response.success) {
        setState(() {
          // data can be null if no settings exist yet
          systemSettings = response.data != null ? SystemSetting.fromJson(response.data!) : null;
        });
      } else {
        setState(() {
          systemSettings = null;
        });
        // Only show error if it's not authentication issue and not an empty result
        if (response.statusCode != 401 && response.message != 'No settings found') {
          _showErrorSnackBar('Failed to load system settings: ${response.message}');
        }
      }
    } catch (e) {
      setState(() {
        systemSettings = null;
      });
      print('Error loading system settings: $e');
      _showErrorSnackBar('Error loading system settings: $e');
    } finally {
      setState(() => isLoadingSettings = false);
    }
  }

  Future<void> _updateSystemSettingsAPI({
    required bool enableNotifications,
    required String schoolClassName,
    int? capacityPerClass,
    required String currentAcademicYear,
  }) async {
    try {
      if (systemSettings?.id != null) {
        final response = await _apiService.updateSystemSettings(
          id: systemSettings!.id!,
          enableNotifications: enableNotifications,
          schoolClassName: schoolClassName,
          capacityPerClass: capacityPerClass,
          currentAcademicYear: currentAcademicYear,
        );
        if (response.success) {
          _showSuccessSnackBar('Settings updated successfully');
          await _loadSystemSettings();
        } else {
          _showErrorSnackBar('Failed to update settings: ${response.message}');
        }
      } else {
        final response = await _apiService.createSystemSettings(
          enableNotifications: enableNotifications,
          schoolClassName: schoolClassName,
          capacityPerClass: capacityPerClass,
          currentAcademicYear: currentAcademicYear,
        );
        if (response.success) {
          _showSuccessSnackBar('Settings created successfully');
          await _loadSystemSettings();
        } else {
          _showErrorSnackBar('Failed to create settings: ${response.message}');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error updating settings: $e');
    }
  }

  // Helper methods for snackbars
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Announcement Methods
  void _addAnnouncement() {
    _showAnnouncementDialog();
  }

  void _editAnnouncement(Announcement announcement) {
    _showAnnouncementDialog(announcement: announcement);
  }

  void _deleteAnnouncement(int announcementId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to remove this announcement?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteAnnouncementAPI(announcementId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAnnouncementDialog({Announcement? announcement}) {
    final isEditing = announcement != null;
    final titleController = TextEditingController(text: announcement?.title ?? '');
    final contentController = TextEditingController(text: announcement?.message ?? '');
    bool isActive = announcement?.isActive ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Announcement' : 'Create New Announcement'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Title', titleController, Icons.title),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        prefixIcon: Icon(Icons.message),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                          borderSide: BorderSide(
                            color: AppThemeColor.primaryBlue,
                            width: AppThemeColor.focusedBorderWidth,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    SwitchListTile(
                      title: Text('Active Status'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      Navigator.pop(context);
                      if (isEditing) {
                        await _updateAnnouncement(
                          id: announcement.id!,
                          title: titleController.text,
                          message: contentController.text,
                          isActive: isActive,
                        );
                      } else {
                        await _createAnnouncement(
                          title: titleController.text,
                          message: contentController.text,
                          isActive: isActive,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
                  child: Text(
                    isEditing ? 'Update' : 'Create',
                    style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // System Settings Methods
  void _editSystemSetting() {
    if (systemSettings == null) return;

    final schoolNameController = TextEditingController(text: systemSettings!.schoolClassName);
    final capacityController = TextEditingController(
      text: systemSettings!.capacityPerClass?.toString() ?? '',
    );
    final academicYearController = TextEditingController(text: systemSettings!.currentAcademicYear);
    bool enableNotifications = systemSettings!.enableNotifications;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit System Settings'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text('Enable Notifications'),
                      subtitle: Text('Allow system to send notifications'),
                      value: enableNotifications,
                      onChanged: (value) {
                        setDialogState(() {
                          enableNotifications = value;
                        });
                      },
                    ),
                    SizedBox(height: AppThemeColor.mediumSpacing),
                    _buildTextField('School Class Name', schoolNameController, Icons.school),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    TextField(
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Capacity Per Class',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                          borderSide: BorderSide(
                            color: AppThemeColor.primaryBlue,
                            width: AppThemeColor.focusedBorderWidth,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    _buildTextField('Current Academic Year', academicYearController, Icons.calendar_today),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _updateSystemSettingsAPI(
                      enableNotifications: enableNotifications,
                      schoolClassName: schoolNameController.text,
                      capacityPerClass: capacityController.text.isNotEmpty
                          ? int.tryParse(capacityController.text)
                          : null,
                      currentAcademicYear: academicYearController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
                  child: Text(
                    'Update',
                    style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
          borderSide: BorderSide(
            color: AppThemeColor.primaryBlue,
            width: AppThemeColor.focusedBorderWidth,
          ),
        ),
      ),
    );
  }

  // Tab Views
  Widget _buildLoginHistoryTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Login History (${loginHistories.length})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.primaryBlue,
                ),
              ),
              Row(
                children: [
                  if (selectedUserId != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => selectedUserId = null);
                        _loadLoginHistory();
                      },
                      icon: Icon(Icons.clear),
                      label: Text('Show All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  SizedBox(width: AppThemeColor.smallSpacing),
                  ElevatedButton.icon(
                    onPressed: _loadLoginHistory,
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeColor.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isLoadingLoginHistory)
          Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadLoginHistory,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
                itemCount: loginHistories.length,
                itemBuilder: (context, index) {
                  final history = loginHistories[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(history.role),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        history.userName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${history.email}'),
                          Text('Role: ${history.role.toUpperCase()}'),
                          Text(
                            'Logged in: ${_formatDateTime(history.loggedInAt)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.filter_list, color: AppThemeColor.primaryBlue),
                        onPressed: () => _loadUserLoginHistory(history.user),
                        tooltip: 'Filter by this user',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'teacher':
        return Colors.blue;
      case 'parent':
        return Colors.green;
      case 'student':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
;
  }

  Widget _buildAnnouncementsTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Announcements (${announcements.length})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.primaryBlue,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadAnnouncements,
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: AppThemeColor.smallSpacing),
                  ElevatedButton.icon(
                    onPressed: _addAnnouncement,
                    icon: Icon(Icons.add),
                    label: Text('New Post'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeColor.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isLoadingAnnouncements)
          Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAnnouncements,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: announcement.isActive ? Colors.green : Colors.grey,
                        child: Icon(
                          Icons.announcement,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        announcement.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (announcement.createdDate != null)
                            Text('Date: ${_formatDateTime(announcement.createdDate!)}'),
                          Row(
                            children: [
                              Text('Status: '),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: announcement.isActive ? Colors.green.shade100 : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  announcement.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: announcement.isActive ? Colors.green.shade800 : Colors.red.shade800,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editAnnouncement(announcement);
                          } else if (value == 'delete') {
                            _deleteAnnouncement(announcement.id!);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: AppThemeColor.primaryBlue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                          child: Text(
                            announcement.message,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSystemSettingsTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'System Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.primaryBlue,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadSystemSettings,
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: AppThemeColor.smallSpacing),
                  Icon(Icons.settings, color: AppThemeColor.primaryBlue),
                ],
              ),
            ],
          ),
        ),
        if (isLoadingSettings)
          Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (systemSettings == null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: AppThemeColor.mediumSpacing),
                  Text('No settings found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: AppThemeColor.mediumSpacing),
                  ElevatedButton.icon(
                    onPressed: _editSystemSetting,
                    icon: Icon(Icons.add),
                    label: Text('Create Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeColor.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadSystemSettings,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      leading: CircleAvatar(
                        backgroundColor: AppThemeColor.primaryBlue,
                        child: Icon(Icons.notifications, color: Colors.white),
                      ),
                      title: Text(
                        'Enable Notifications',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Value: ${systemSettings!.enableNotifications ? "Enabled" : "Disabled"}'),
                          Text(
                            'Allow system to send push notifications',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      leading: CircleAvatar(
                        backgroundColor: AppThemeColor.primaryBlue,
                        child: Icon(Icons.school, color: Colors.white),
                      ),
                      title: Text(
                        'School Class Name',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Value: ${systemSettings!.schoolClassName.isEmpty ? "Not Set" : systemSettings!.schoolClassName}'),
                          Text(
                            'Name of the school class',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      leading: CircleAvatar(
                        backgroundColor: AppThemeColor.primaryBlue,
                        child: Icon(Icons.people, color: Colors.white),
                      ),
                      title: Text(
                        'Capacity Per Class',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Value: ${systemSettings!.capacityPerClass?.toString() ?? "Not Set"}'),
                          Text(
                            'Maximum number of students per class',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      leading: CircleAvatar(
                        backgroundColor: AppThemeColor.primaryBlue,
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      title: Text(
                        'Current Academic Year',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Value: ${systemSettings!.currentAcademicYear.isEmpty ? "Not Set" : systemSettings!.currentAcademicYear}'),
                          Text(
                            'Active academic year',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (systemSettings!.updatedAt != null)
                    Padding(
                      padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      child: Text(
                        'Last Updated: ${_formatDateTime(systemSettings!.updatedAt!)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: AppThemeColor.mediumSpacing),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppThemeColor.mediumSpacing),
                    child: ElevatedButton.icon(
                      onPressed: _editSystemSetting,
                      icon: Icon(Icons.edit),
                      label: Text('Edit Settings'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColor.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: AppThemeColor.defaultSpacing),
                ],
              ),
            ),
          ),
      ],
    );
  }

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
              // Header
              HeaderSection(
                title: 'System Control',
              ),
              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppThemeColor.blue800,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: AppThemeColor.blue700,
                  tabs: [
                    Tab(text: 'Login History', icon: Icon(Icons.history)),
                    Tab(text: 'Announcements', icon: Icon(Icons.announcement)),
                    Tab(text: 'Settings', icon: Icon(Icons.settings)),
                  ],
                ),
              ),

              // Tab Bar View
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    AppThemeColor.defaultSpacing,
                    AppThemeColor.smallSpacing,
                    AppThemeColor.defaultSpacing,
                    AppThemeColor.defaultSpacing,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginHistoryTab(),
                      _buildAnnouncementsTab(),
                      _buildSystemSettingsTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}