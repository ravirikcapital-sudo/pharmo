import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/model/mainNotification.dart';
import 'package:school/services/api_services.dart';
import 'package:school/customWidgets/snackBar.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationItem> notifications = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getNotifications();
      
      if (response.success && response.data != null) {
        final notificationsList = (response.data as List)
            .map((json) => NotificationItem.fromJson(json))
            .toList();
        
        // Sort by creation date (newest first)
        notificationsList.sort((a, b) {
          if (a.createdAt != null && b.createdAt != null) {
            return b.createdAt!.compareTo(a.createdAt!);
          }
          return 0;
        });
        
        setState(() {
          notifications = notificationsList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Failed to load notifications';
          _isLoading = false;
          // Don't fallback to sample data if API returns empty list
          if (response.data == null) {
            _loadSampleData();
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
        // Fallback to sample data on error
        _loadSampleData();
      });
    }
  }

  void _loadSampleData() {
    notifications = [
      NotificationItem(
        title: 'Assignment Due Tomorrow',
        message: 'Mathematics homework is due tomorrow at 11:59 PM',
        time: '2 hours ago',
        icon: Icons.assignment,
        isRead: false,
      ),
      NotificationItem(
        title: 'Parent-Teacher Meeting',
        message: 'Scheduled for March 15th at 3:00 PM in classroom 101',
        time: '1 day ago',
        icon: Icons.event,
        isRead: true,
      ),
      NotificationItem(
        title: 'School Holiday Notice',
        message: 'School will be closed on March 20th for maintenance',
        time: '3 days ago',
        icon: Icons.info,
        isRead: true,
      ),
    ];
  }

  Future<void> _markAllAsRead() async {
    try {
      // Mark all as read locally
      setState(() {
        for (var notification in notifications) {
          notification.isRead = true;
        }
      });

      // Call API for each unread notification
      for (var notification in notifications) {
        if (notification.id != null && !notification.isRead) {
          await ApiService().markNotificationAsRead(notification.id!);
        }
      }

      AppSnackBar.show(
        context,
        message: 'All notifications marked as read',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Failed to mark all as read',
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
    }
  }

  Future<void> _markAsRead(NotificationItem notification) async {
    if (notification.id != null && !notification.isRead) {
      try {
        final response = await ApiService().markNotificationAsRead(notification.id!);
        
        if (response.success) {
          setState(() {
            notification.isRead = true;
          });
        }
      } catch (e) {
        print('Error marking as read: $e');
      }
    }
  }

  Future<void> _deleteNotification(int index) async {
    final notification = notifications[index];
    
    if (notification.id != null) {
      try {
        final response = await ApiService().deleteNotification(notification.id!);
        
        if (response.success) {
          setState(() {
            notifications.removeAt(index);
          });
          
          AppSnackBar.show(
            context,
            message: 'Notification deleted successfully',
            backgroundColor: Colors.green,
            icon: Icons.check_circle_outline,
          );
        } else {
          AppSnackBar.show(
            context,
            message: 'Failed to delete notification',
            backgroundColor: Colors.red,
            icon: Icons.error_outline,
          );
        }
      } catch (e) {
        AppSnackBar.show(
          context,
          message: 'Error deleting notification',
          backgroundColor: Colors.red,
          icon: Icons.error_outline,
        );
      }
    } else {
      // Local notification without ID
      setState(() {
        notifications.removeAt(index);
      });
      
      AppSnackBar.show(
        context,
        message: 'Notification deleted',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppThemeColor.white,
                unselectedLabelColor: AppThemeColor.white.withOpacity(0.6),
                indicatorColor: AppThemeColor.white,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'All Notifications'),
                  Tab(text: 'Send Notification'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationsTab(),
                  _buildSendNotificationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (_errorMessage.isNotEmpty && notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.white70),
            SizedBox(height: 16),
            Text(_errorMessage,
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    } else if (notifications.isEmpty) {
      return _buildEmptyState(context);
    } else {
      return RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _buildNotificationsList(context),
      );
    }
  }

  Widget _buildSendNotificationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardHorizontalPadding(context)),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 900),
          child: _SendNotificationForm(
            onNotificationSent: () async {
              // Wait for backend to persist the notification
              await Future.delayed(Duration(milliseconds: 500));
              
              // Force reload notifications (clear existing data first)
              setState(() {
                notifications = [];
                _errorMessage = '';
                _isLoading = true;
              });
              
              await _loadNotifications();
              
              // Switch to notifications tab after data is loaded
              _tabController.animateTo(0);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
        vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
      ),
      child: Row(
        children: [
          // Notification Icon
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
            decoration: BoxDecoration(
              color: AppThemeColor.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getInputBorderRadius(context),
              ),
            ),
            child: Icon(
              Icons.notifications,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
          ),

          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

          // Title
          Expanded(
            child: Text(
              'Notifications',
              style: AppThemeResponsiveness.getSectionTitleStyle(context),
            ),
          ),

          // Mark all as read button
          Container(
            height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
            child: TextButton(
              onPressed: _markAllAsRead,
              style: TextButton.styleFrom(
                backgroundColor: AppThemeColor.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
              ),
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: AppThemeColor.white,
                  fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
          vertical: AppThemeResponsiveness.getSmallSpacing(context),
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(context, notifications[index], index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Card(
        elevation: notification.isRead
            ? AppThemeResponsiveness.getCardElevation(context) * 0.5
            : AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
          onTap: () {
            _markAsRead(notification);
          },
          child: Container(
            padding: AppThemeResponsiveness.getCardPadding(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getCardBorderRadius(context),
              ),
              color: notification.isRead
                  ? Colors.white
                  : AppThemeColor.blue50,
              border: notification.isRead
                  ? null
                  : Border.all(
                color: AppThemeColor.blue200,
                width: AppThemeResponsiveness.getFocusedBorderWidth(context) * 0.5,
              ),
            ),
            child: _buildNotificationContent(context, notification, index),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent(BuildContext context, NotificationItem notification, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon Container
        Container(
          padding: EdgeInsets.all(
            AppThemeResponsiveness.getActivityIconPadding(context),
          ),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppThemeColor.greyl
                : AppThemeColor.blue100,
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
          ),
          child: Icon(
            notification.icon,
            color: notification.isRead
                ? Colors.grey.shade600
                : AppThemeColor.primaryBlue600,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ),

        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

        // Content Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row with Read Indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: AppThemeResponsiveness.getHeadingStyle(context).fontSize,
                        fontWeight: notification.isRead
                            ? FontWeight.w600
                            : FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  if (!notification.isRead) ...[
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                    Container(
                      width: AppThemeResponsiveness.isSmallPhone(context) ? 6 : 8,
                      height: AppThemeResponsiveness.isSmallPhone(context) ? 6 : 8,
                      decoration: BoxDecoration(
                        color: AppThemeColor.primaryBlue600,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),

              // Message
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                maxLines: AppThemeResponsiveness.isSmallPhone(context) ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

              // Time Chip
              Container(
                padding: AppThemeResponsiveness.getTimeChipPadding(context),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? AppThemeColor.greyl
                      : AppThemeColor.blue100,
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context) * 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: AppThemeResponsiveness.getTimeChipIconSize(context),
                      color: notification.isRead
                          ? Colors.grey.shade500
                          : AppThemeColor.primaryBlue600,
                    ),
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                    Text(
                      notification.time ?? 'Just now',
                      style: TextStyle(
                        fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                        color: notification.isRead
                            ? Colors.grey.shade500
                            : AppThemeColor.primaryBlue600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // More Options Menu
        _buildMoreOptionsMenu(context, notification, index),
      ],
    );
  }

  Widget _buildMoreOptionsMenu(BuildContext context, NotificationItem notification, int index) {
    return Container(
      margin: EdgeInsets.only(left: AppThemeResponsiveness.getSmallSpacing(context)),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context) * 0.6,
            ),
          ),
          child: Icon(
            Icons.more_vert,
            color: Colors.grey.shade600,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'mark_read',
            height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
            child: Row(
              children: [
                Icon(
                  notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                  size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  notification.isRead ? 'Mark as unread' : 'Mark as read',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  color: Colors.red.shade600,
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'mark_read') {
            setState(() {
              notification.isRead = !notification.isRead;
            });
            
            // Update on server if notification has ID
            if (notification.id != null) {
              if (notification.isRead) {
                ApiService().markNotificationAsRead(notification.id!);
              }
            }
            
            AppSnackBar.show(
              context,
              message: notification.isRead ? 'Marked as read' : 'Marked as unread',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline,
            );
          } else if (value == 'delete') {
            _showDeleteConfirmation(context, index);
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          title: Text(
            'Delete Notification',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          content: Text(
            'Are you sure you want to delete this notification?',
            style: AppThemeResponsiveness.getSubHeadingStyle(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNotification(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context) * 0.8,
        ),
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                AppThemeResponsiveness.getExtraLargeSpacing(context),
              ),
              decoration: BoxDecoration(
                color: AppThemeColor.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off,
                size: AppThemeResponsiveness.getLogoSize(context) * 1.5,
                color: AppThemeColor.white.withOpacity(0.8),
              ),
            ),

            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

            Text(
              'No notifications yet',
              style: TextStyle(
                color: AppThemeColor.white,
                fontSize: AppThemeResponsiveness.getSectionTitleStyle(context).fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            Text(
              'You\'ll see notifications here when they arrive',
              style: TextStyle(
                color: AppThemeColor.white.withOpacity(0.8),
                fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Send Notification Form Widget
class _SendNotificationForm extends StatefulWidget {
  final VoidCallback? onNotificationSent;

  const _SendNotificationForm({Key? key, this.onNotificationSent}) : super(key: key);

  @override
  _SendNotificationFormState createState() => _SendNotificationFormState();
}

class _SendNotificationFormState extends State<_SendNotificationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedType = NotificationTypes.general;
  String? _selectedRecipient = RecipientTypes.allStudents;
  bool _isSending = false;

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

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 900 : double.infinity,
        ),
        child: Card(
          elevation: AppThemeResponsiveness.getCardElevation(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              isDesktop ? 24.0 : AppThemeResponsiveness.getDefaultSpacing(context),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppThemeResponsiveness.getSmallSpacing(context),
                        ),
                        decoration: BoxDecoration(
                          gradient: AppThemeColor.primaryGradient,
                          borderRadius: BorderRadius.circular(
                            AppThemeResponsiveness.getInputBorderRadius(context),
                          ),
                        ),
                        child: Icon(
                          Icons.send,
                          color: AppThemeColor.white,
                          size: AppThemeResponsiveness.getIconSize(context),
                        ),
                      ),
                      SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                      Text(
                        'Send Notification',
                        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                          color: AppThemeColor.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

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
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

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
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                  // Type and Recipient Dropdowns
                  if (isDesktop)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            child: _buildTypeDropdown(),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: _buildRecipientDropdown(),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _buildTypeDropdown(),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    _buildRecipientDropdown(),
                  ],

                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Send Button
                  SizedBox(
                    height: AppThemeResponsiveness.getButtonHeight(context),
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _sendNotification,
                      icon: _isSending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppThemeColor.white,
                                ),
                              ),
                            )
                          : Icon(Icons.send),
                      label: Text(_isSending ? 'Sending...' : 'Send Notification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColor.primaryBlue,
                        foregroundColor: AppThemeColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppThemeResponsiveness.getInputBorderRadius(context),
                          ),
                        ),
                        textStyle: AppThemeResponsiveness.getHeadingStyle(context),
                      ),
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

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Notification Type',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: NotificationTypes.all
          .map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
          .toList(),
      onChanged: (value) {
        setState(() => _selectedType = value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select notification type';
        }
        return null;
      },
    );
  }

  Widget _buildRecipientDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRecipient,
      decoration: InputDecoration(
        labelText: 'Recipients',
        prefixIcon: Icon(Icons.people),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: RecipientTypes.all
          .map((recipient) => DropdownMenuItem<String>(
                value: recipient,
                child: Text(recipient),
              ))
          .toList(),
      onChanged: (value) {
        setState(() => _selectedRecipient = value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select recipients';
        }
        return null;
      },
    );
  }

  Future<void> _sendNotification() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      try {
        final response = await ApiService().createNotification(
          recipient: _selectedRecipient!,
          title: _titleController.text,
          message: _messageController.text,
          notificationType: _selectedType!,
        );

        if (response.success) {
          // Clear form
          _titleController.clear();
          _messageController.clear();
          setState(() {
            _selectedType = NotificationTypes.general;
            _selectedRecipient = RecipientTypes.allStudents;
          });

          // Show success message
          AppSnackBar.show(
            context,
            message: 'Notification sent successfully!',
            backgroundColor: Colors.green,
            icon: Icons.check_circle_outline,
          );

          // Call callback to switch tabs and reload
          widget.onNotificationSent?.call();
        } else {
          AppSnackBar.show(
            context,
            message: response.message ?? 'Failed to send notification',
            backgroundColor: Colors.red,
            icon: Icons.error_outline,
          );
        }
      } catch (e) {
        AppSnackBar.show(
          context,
          message: 'Error sending notification: $e',
          backgroundColor: Colors.red,
          icon: Icons.error_outline,
        );
      } finally {
        setState(() => _isSending = false);
      }
    }
  }
}
