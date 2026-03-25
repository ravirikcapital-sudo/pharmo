import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/sectionTitle.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/model/dashboard/academicOfficerDashboardModel/NotificationModelAcademicOfficer.dart';
import 'package:school/model/mainNotification.dart' as MainModel;
import 'package:school/services/api_services.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Math Quiz Results',
      message: 'Math Quiz results entered for Class 10-A',
      type: NotificationType.announcement,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      sender: 'Academic Officer',
      recipients: ['Class 10-A'],
    ),
    NotificationModel(
      id: '2',
      title: 'Attendance Update',
      message: 'Attendance marked for today\'s classes',
      type: NotificationType.general,
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      sender: 'System',
      recipients: ['All Students'],
    ),
    NotificationModel(
      id: '3',
      title: 'Important Notice',
      message: 'New message from Academic Officer',
      type: NotificationType.urgent,
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      sender: 'Academic Officer',
      recipients: ['All Students'],
    ),
  ];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  List<NotificationModel> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  // Load notifications from API
  Future<void> loadNotificationsFromApi() async {
    try {
      final response = await ApiService().getNotifications();
      if (response.success && response.data != null) {
        _notifications.clear();
        
        for (var json in response.data as List) {
          final apiNotification = MainModel.NotificationItem.fromJson(json);
          
          // Convert to local notification model
          _notifications.add(NotificationModel(
            id: apiNotification.id?.toString() ?? '',
            title: apiNotification.title,
            message: apiNotification.message,
            type: _mapNotificationType(apiNotification.notificationType),
            timestamp: apiNotification.createdAt ?? DateTime.now(),
            sender: 'System',
            recipients: [apiNotification.recipient ?? 'All'],
            isRead: apiNotification.isRead,
          ));
        }
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  NotificationType _mapNotificationType(String? type) {
    switch (type) {
      case 'Academic':
        return NotificationType.announcement;
      case 'Attendance':
        return NotificationType.assignment;
      case 'Admission':
        return NotificationType.general;
      case 'Fees':
        return NotificationType.general;
      default:
        return NotificationType.general;
    }
  }
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationService.loadNotificationsFromApi().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              HeaderSection(
                title: 'Notifications',
                icon: Icons.notifications,
              ),
              // Responsive container for tabs
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width > 768 ? 1200 : double.infinity,
                ),
                child: CustomTabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Inbox'),
                    Tab(text: 'Send'),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width > 768 ? 1200 : double.infinity,
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildNotificationsList(),
                        _buildSendNotificationTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Container(
      margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
      child: ListView.builder(
        itemCount: _notificationService.notifications.length,
        itemBuilder: (context, index) {
          final notification = _notificationService.notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeColor.mediumSpacing),
      child: Card(
        elevation: AppThemeColor.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
          onTap: () {
            _notificationService.markAsRead(notification.id);
            setState(() {});
            _showNotificationDetails(notification);
          },
          child: Container(
            padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
            child: Row(
              children: [
                _buildNotificationIcon(notification.type),
                SizedBox(width: AppThemeColor.mediumSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: notification.isRead
                                    ? Colors.grey.shade600
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppThemeColor.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            notification.sender,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                          Spacer(),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData iconData;
    Color backgroundColor;

    switch (type) {
      case NotificationType.announcement:
        iconData = Icons.campaign;
        backgroundColor = AppThemeColor.primaryIndigo;
        break;
      case NotificationType.testDate:
        iconData = Icons.quiz;
        backgroundColor = Colors.orange;
        break;
      case NotificationType.holiday:
        iconData = Icons.event;
        backgroundColor = Colors.green;
        break;
      case NotificationType.assignment:
        iconData = Icons.assignment;
        backgroundColor = AppThemeColor.blue600;
        break;
      case NotificationType.urgent:
        iconData = Icons.priority_high;
        backgroundColor = Colors.red;
        break;
      default:
        iconData = Icons.info;
        backgroundColor = AppThemeColor.primaryBlue;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(
        iconData,
        color: AppThemeColor.white,
        size: 24,
      ),
    );
  }

  Widget _buildSendNotificationTab() {
    return Container(
      margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SendNotificationForm(),
          );
        },
      ),
    );
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            SizedBox(height: AppThemeColor.mediumSpacing),
            Text(
              'From: ${notification.sender}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppThemeColor.primaryBlue,
              ),
            ),
            Text(
              'Time: ${_formatTimestamp(notification.timestamp)}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            if (notification.recipients.isNotEmpty) ...[
              SizedBox(height: AppThemeColor.smallSpacing),
              Text(
                'Recipients: ${notification.recipients.join(', ')}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Updated SendNotificationForm with responsive design
class SendNotificationForm extends StatefulWidget {
  @override
  _SendNotificationFormState createState() => _SendNotificationFormState();
}

class _SendNotificationFormState extends State<SendNotificationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  NotificationType? _selectedType = NotificationType.general;
  String? _selectedRecipient = 'All Students';

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final isTablet = screenWidth > 480 && screenWidth <= 768;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 900 : double.infinity,
        ),
        child: Card(
          elevation: AppThemeColor.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
          ),
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 24.0 : AppThemeColor.defaultSpacing),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionTitleBlueAdmission(title: 'Send Notification'),
                  SizedBox(height: AppThemeColor.defaultSpacing),

                  // Title Field
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: isDesktop ? 80 : 70,
                    ),
                    child: AppTextFieldBuilder.build(
                      context: context,
                      controller: _titleController,
                      label: 'Title',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: AppThemeColor.mediumSpacing),

                  // Message Field
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: isDesktop ? 120 : 100,
                    ),
                    child: AppTextFieldBuilder.build(
                      context: context,
                      controller: _messageController,
                      label: 'Message',
                      icon: Icons.message,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: AppThemeColor.mediumSpacing),

                  // For desktop, show dropdowns in a row
                  if (isDesktop) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            child: AppDropdown.notificationType(
                              value: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select notification type';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: AppDropdown.notificationRecipients(
                              value: _selectedRecipient,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRecipient = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select recipients';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // For mobile/tablet, show dropdowns stacked
                    AppDropdown.notificationType(
                      value: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select notification type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppThemeColor.mediumSpacing),
                    AppDropdown.notificationRecipients(
                      value: _selectedRecipient,
                      onChanged: (value) {
                        setState(() {
                          _selectedRecipient = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select recipients';
                        }
                        return null;
                      },
                    ),
                  ],

                  SizedBox(height: AppThemeColor.defaultSpacing),

                  // Send Button
                  Container(
                    height: isDesktop ? 55 : 50,
                    child: PrimaryButton(
                      title: 'Send Notification',
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendNotification,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendNotification() {
    if (_formKey.currentState!.validate()) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Map NotificationType to API notification type
      String apiNotificationType = 'General';
      switch (_selectedType!) {
        case NotificationType.announcement:
          apiNotificationType = 'Academic';
          break;
        case NotificationType.assignment:
          apiNotificationType = 'Academic';
          break;
        case NotificationType.testDate:
          apiNotificationType = 'Academic';
          break;
        case NotificationType.holiday:
          apiNotificationType = 'General';
          break;
        case NotificationType.urgent:
          apiNotificationType = 'General';
          break;
        default:
          apiNotificationType = 'General';
      }

      // Send to API
      ApiService().createNotification(
        recipient: _selectedRecipient!,
        title: _titleController.text,
        message: _messageController.text,
        notificationType: apiNotificationType,
      ).then((response) {
        Navigator.pop(context); // Close loading dialog

        if (response.success) {
          // Add to local list for immediate display
          final notification = NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text,
            message: _messageController.text,
            type: _selectedType!,
            timestamp: DateTime.now(),
            sender: 'You',
            recipients: [_selectedRecipient!],
          );

          NotificationService().addNotification(notification);

          // Show success message
          AppSnackBar.show(
            context,
            message: 'Notification sent successfully!',
            backgroundColor: Colors.green,
            icon: Icons.check_circle_outline,
          );

          // Clear form
          _titleController.clear();
          _messageController.clear();
          setState(() {
            _selectedType = NotificationType.general;
            _selectedRecipient = 'All Students';
          });
        } else {
          AppSnackBar.show(
            context,
            message: response.message ?? 'Failed to send notification',
            backgroundColor: Colors.red,
            icon: Icons.error_outline,
          );
        }
      }).catchError((error) {
        Navigator.pop(context); // Close loading dialog
        AppSnackBar.show(
          context,
          message: 'Error sending notification: $error',
          backgroundColor: Colors.red,
          icon: Icons.error_outline,
        );
      });
    }
  }
}