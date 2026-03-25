import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/mainChat.dart';

// Complaint Model
class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String userType;
  final String userName;
  final DateTime timestamp;
  final ComplaintStatus status;
  final String? resolution;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.userType,
    required this.userName,
    required this.timestamp,
    required this.status,
    this.resolution,
  });

  Complaint copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? userType,
    String? userName,
    DateTime? timestamp,
    ComplaintStatus? status,
    String? resolution,
  }) {
    return Complaint(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      userType: userType ?? this.userType,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      resolution: resolution ?? this.resolution,
    );
  }
}

enum ComplaintStatus {
  pending,
  inProgress,
  resolved,
}

// Main Complaint Page
class ComplaintPage extends StatefulWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  List<Complaint> complaints = [
    Complaint(
      id: '1',
      title: 'Classroom AC Not Working',
      description: 'The air conditioning in Room 101 has been broken for a week. Students are uncomfortable during classes.',
      category: 'Facilities',
      userType: 'Teacher',
      userName: 'Ms. Johnson',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: ComplaintStatus.pending,
    ),
    Complaint(
      id: '2',
      title: 'Homework Load Too Heavy',
      description: 'My child is getting too much homework daily. It\'s affecting their sleep and health.',
      category: 'Academic',
      userType: 'Parent',
      userName: 'Mr. Smith',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: ComplaintStatus.inProgress,
    ),
    Complaint(
      id: '3',
      title: 'Cafeteria Food Quality',
      description: 'The food in the cafeteria is often cold and doesn\'t taste good. We need better meal options.',
      category: 'Food Services',
      userType: 'Student',
      userName: 'Alex Kumar',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: ComplaintStatus.resolved,
      resolution: 'Spoke with cafeteria management. They have updated the menu and improved food heating procedures. New chef hired to ensure quality.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemeColor.primaryBlue,
        toolbarHeight: AppThemeResponsiveness.getAppBarHeight(context),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppThemeColor.white,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ),
        title: Text(
          'Complaints',
          style: TextStyle(
            color: AppThemeColor.white,
            fontSize: AppThemeResponsiveness.isMobile(context) ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSubmitComplaintDialog(context);
            },
            icon: Icon(
              Icons.add,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: AppThemeResponsiveness.getMaxWidth(context),
            ),
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              children: [
                // Filter Tabs
                _buildFilterTabs(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                // Complaints List
                Expanded(
                  child: ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      return _buildComplaintCard(complaints[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: AppThemeResponsiveness.getButtonHeight(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab('All', true),
          ),
          Expanded(
            child: _buildFilterTab('Pending', false),
          ),
          Expanded(
            child: _buildFilterTab('In Progress', false),
          ),
          Expanded(
            child: _buildFilterTab('Resolved', false),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        gradient: isSelected ? AppThemeColor.primaryGradient : null,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppThemeColor.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: AppThemeResponsiveness.isMobile(context) ? 12 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        onTap: () {
          _showComplaintDetails(complaint);
        },
        child: Container(
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(complaint.status),
                ],
              ),

              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

              // Description
              Text(
                complaint.description,
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

              // Footer Row
              Row(
                children: [
                  _buildUserTypeChip(complaint.userType),
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                  Text(
                    complaint.userName,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(complaint.timestamp),
                    style: AppThemeResponsiveness.getCaptionTextStyle(context),
                  ),
                ],
              ),

              // Resolution Action Button
              if (complaint.status != ComplaintStatus.resolved)
                Padding(
                  padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _showResolveDialog(complaint);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColor.primaryBlue,
                        foregroundColor: AppThemeColor.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                          vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                        ),
                      ),
                      child: Text(
                        'Resolve',
                        style: TextStyle(
                          fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                        ),
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

  Widget _buildStatusChip(ComplaintStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case ComplaintStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        text = 'Pending';
        break;
      case ComplaintStatus.inProgress:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[700]!;
        text = 'In Progress';
        break;
      case ComplaintStatus.resolved:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        text = 'Resolved';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) / 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserTypeChip(String userType) {
    Color backgroundColor;
    Color textColor;

    switch (userType) {
      case 'Teacher':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[700]!;
        break;
      case 'Parent':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        break;
      case 'Student':
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple[700]!;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) / 2),
      ),
      child: Text(
        userType,
        style: TextStyle(
          color: textColor,
          fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showComplaintDetails(Complaint complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Complaint Details',
                      style: AppThemeResponsiveness.getFontStyle(context).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      complaint.title,
                      style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

                    // Status and User Info
                    Row(
                      children: [
                        _buildStatusChip(complaint.status),
                        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                        _buildUserTypeChip(complaint.userType),
                      ],
                    ),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // Description
                    Text(
                      'Description:',
                      style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      complaint.description,
                      style: AppThemeResponsiveness.getBodyTextStyle(context),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // Submitted by
                    Text(
                      'Submitted by:',
                      style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      '${complaint.userName} (${complaint.userType})',
                      style: AppThemeResponsiveness.getBodyTextStyle(context),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // Date
                    Text(
                      'Date:',
                      style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      _formatDateTime(complaint.timestamp),
                      style: AppThemeResponsiveness.getBodyTextStyle(context),
                    ),

                    // Resolution section
                    if (complaint.resolution != null) ...[
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                      Text(
                        'Resolution:',
                        style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                      Container(
                        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Text(
                          complaint.resolution!,
                          style: AppThemeResponsiveness.getBodyTextStyle(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResolveDialog(Complaint complaint) {
    final TextEditingController resolutionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Complaint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint: ${complaint.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Resolution Details:'),
            const SizedBox(height: 8),
            TextField(
              controller: resolutionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter resolution details...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (resolutionController.text.trim().isNotEmpty) {
                setState(() {
                  final index = complaints.indexWhere((c) => c.id == complaint.id);
                  if (index != -1) {
                    complaints[index] = complaint.copyWith(
                      status: ComplaintStatus.resolved,
                      resolution: resolutionController.text.trim(),
                    );
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complaint resolved successfully!')),
                );
              }
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _showSubmitComplaintDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String selectedUserType = 'Student';
    String selectedCategory = 'General';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Submit Complaint'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('User Type:'),
                DropdownButton<String>(
                  value: selectedUserType,
                  isExpanded: true,
                  items: ['Student', 'Teacher', 'Parent'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUserType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Category:'),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: ['General', 'Academic', 'Facilities', 'Food Services', 'Transportation'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty &&
                    descriptionController.text.trim().isNotEmpty) {
                  final newComplaint = Complaint(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    category: selectedCategory,
                    userType: selectedUserType,
                    userName: 'Current User', // This would come from user session
                    timestamp: DateTime.now(),
                    status: ComplaintStatus.pending,
                  );

                  this.setState(() {
                    complaints.insert(0, newComplaint);
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Complaint submitted successfully!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}