import 'package:flutter/material.dart';
import 'package:school/AdminDashboardPages/documentDetails.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class PendingAdmissionsPage extends StatefulWidget {
  const PendingAdmissionsPage({Key? key}) : super(key: key);

  @override
  State<PendingAdmissionsPage> createState() => _PendingAdmissionsPageState();
}

class _PendingAdmissionsPageState extends State<PendingAdmissionsPage> {
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'New', 'Under Review', 'Pending Documents'];

  // Sample data for pending admissions
  final List<Map<String, dynamic>> _pendingAdmissions = [
    {
      'id': 'ADM001',
      'name': 'John Smith',
      'grade': 'Grade 10',
      'submittedDate': '2024-01-15',
      'status': 'New',
      'parentName': 'Robert Smith',
      'phone': '+91 9876543210',
      'email': 'robert.smith@email.com',
      'priority': 'High',
      'interviewDate': null,
    },
    {
      'id': 'ADM002',
      'name': 'Emma Johnson',
      'grade': 'Grade 8',
      'submittedDate': '2024-01-14',
      'status': 'Under Review',
      'parentName': 'Michael Johnson',
      'phone': '+91 9876543211',
      'email': 'michael.johnson@email.com',
      'priority': 'Medium',
      'interviewDate': null,
    },
    {
      'id': 'ADM003',
      'name': 'Rahul Sharma',
      'grade': 'Grade 12',
      'submittedDate': '2024-01-13',
      'status': 'Pending Documents',
      'parentName': 'Suresh Sharma',
      'phone': '+91 9876543212',
      'email': 'suresh.sharma@email.com',
      'priority': 'Low',
      'interviewDate': null,
    },
    {
      'id': 'ADM004',
      'name': 'Priya Patel',
      'grade': 'Grade 9',
      'submittedDate': '2024-01-12',
      'status': 'New',
      'parentName': 'Amit Patel',
      'phone': '+91 9876543213',
      'email': 'amit.patel@email.com',
      'priority': 'High',
      'interviewDate': null,
    },
    {
      'id': 'ADM005',
      'name': 'David Wilson',
      'grade': 'Grade 11',
      'submittedDate': '2024-01-11',
      'status': 'Under Review',
      'parentName': 'James Wilson',
      'phone': '+91 9876543214',
      'email': 'james.wilson@email.com',
      'priority': 'Medium',
      'interviewDate': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredAdmissions {
    if (_selectedFilter == 'All') {
      return _pendingAdmissions;
    }
    return _pendingAdmissions
        .where((admission) => admission['status'] == _selectedFilter)
        .toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.green;
      case 'Under Review':
        return Colors.orange;
      case 'Pending Documents':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showActionDialog(Map<String, dynamic> admission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
          ),
          elevation: AppThemeResponsiveness.getCardElevation(context),
          child: Container(
            padding: AppThemeResponsiveness.getResponsivePadding(context, 24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Actions for ${admission['name']}',
                  style: AppThemeResponsiveness.getDialogTitleStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildActionButton(
                  'Approve Application',
                  Icons.check_circle,
                  Colors.green,
                      () => _performAction('approve', admission),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildActionButton(
                  'Request Documents',
                  Icons.description,
                  Colors.orange,
                      () => _performAction('request_docs', admission),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildActionButton(
                  'Schedule Interview',
                  Icons.calendar_today,
                  Colors.blue,
                      () => _showScheduleDialog(admission),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildActionButton(
                  'Reject Application',
                  Icons.cancel,
                  Colors.red,
                      () => _performAction('reject', admission),
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildActionButton(
                  'Student Details',
                  Icons.list,
                  Colors.green,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailsPage(
                        studentData: admission, // Pass the admission data as studentData
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showScheduleDialog(Map<String, dynamic> admission) {
    Navigator.of(context).pop(); // Close the action dialog first

    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
              ),
              elevation: AppThemeResponsiveness.getCardElevation(context),
              child: Container(
                padding: AppThemeResponsiveness.getResponsivePadding(context, 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule Interview',
                      style: AppThemeResponsiveness.getDialogTitleStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      'Student: ${admission['name']}',
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // Date Selection
                    Container(
                      width: double.infinity,
                      padding: AppThemeResponsiveness.getResponsivePadding(context, 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey.shade600),
                            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                            Text(
                              selectedDate != null
                                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                  : 'Select Interview Date',
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                color: selectedDate != null ? Colors.black : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                    // Time Selection
                    Container(
                      width: double.infinity,
                      padding: AppThemeResponsiveness.getResponsivePadding(context, 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 10, minute: 0),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey.shade600),
                            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                            Text(
                              selectedTime != null
                                  ? '${selectedTime!.format(context)}'
                                  : 'Select Interview Time',
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                color: selectedTime != null ? Colors.black : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                    // Notes TextField
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Additional notes (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                        ),
                        contentPadding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
                      ),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                              ),
                              padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (selectedDate != null && selectedTime != null)
                                ? () => _scheduleInterview(admission, selectedDate!, selectedTime!, notesController.text)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                              ),
                              padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
                            ),
                            child: Text(
                              'Schedule',
                              style: AppThemeResponsiveness.getButtonTextStyle(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _scheduleInterview(Map<String, dynamic> admission, DateTime date, TimeOfDay time, String notes) {
    Navigator.of(context).pop(); // Close the schedule dialog

    // Create DateTime object combining date and time
    final DateTime scheduledDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Update the admission data
    setState(() {
      admission['interviewDate'] = scheduledDateTime;
      admission['interviewNotes'] = notes;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Interview scheduled for ${admission['name']} on ${date.day}/${date.month}/${date.year} at ${time.format(context)}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: AppThemeResponsiveness.getIconSize(context)),
        label: Text(
          title,
          style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
        ),
      ),
    );
  }

  void _performAction(String action, Map<String, dynamic> admission) {
    Navigator.of(context).pop();

    String message = '';
    switch (action) {
      case 'approve':
        message = 'Application approved for ${admission['name']}';
        break;
      case 'request_docs':
        message = 'Document request sent to ${admission['name']}';
        break;
      case 'reject':
        message = 'Application rejected for ${admission['name']}';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterBar(),
              Expanded(
                child: _buildAdmissionsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: AppThemeResponsiveness.getResponsivePadding(context, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.pending_actions_rounded,
              color: Colors.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Admissions',
                  style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_filteredAdmissions.length} applications',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: AppThemeResponsiveness.getResponsiveSize(context, 14.0, 16.0, 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: AppThemeResponsiveness.getResponsiveSize(context, 60.0, 65.0, 70.0),
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = _selectedFilter == option;

          return Container(
            margin: EdgeInsets.only(
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: FilterChip(
              label: Text(
                option,
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = option;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppThemeColor.blue600,
              checkmarkColor: Colors.white,
              elevation: isSelected ? 4 : 2,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                side: BorderSide(
                  color: isSelected ? AppThemeColor.blue600 : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdmissionsList() {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      )
          : _filteredAdmissions.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        itemCount: _filteredAdmissions.length,
        itemBuilder: (context, index) {
          return _buildAdmissionCard(_filteredAdmissions[index], index);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: AppThemeResponsiveness.getResponsivePadding(context, 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: AppThemeResponsiveness.getResponsiveSize(context, 64.0, 72.0, 80.0),
              color: Colors.white.withOpacity(0.7),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            Text(
              'No pending admissions',
              style: AppThemeResponsiveness.getHeadingTextStyle(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              'All admission applications have been processed',
              textAlign: TextAlign.center,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdmissionCard(Map<String, dynamic> admission, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppThemeResponsiveness.getCardElevation(context) * 2,
            offset: Offset(0, AppThemeResponsiveness.getSmallSpacing(context)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          onTap: () => _showActionDialog(admission),
          child: Padding(
            padding: AppThemeResponsiveness.getCardPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  admission['name'],
                                  style: AppThemeResponsiveness.getRecentTitleStyle(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                                  vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(admission['priority']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12.0)),
                                  border: Border.all(
                                    color: _getPriorityColor(admission['priority']).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  admission['priority'],
                                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                    color: _getPriorityColor(admission['priority']),
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppThemeResponsiveness.getResponsiveSize(context, 12.0, 13.0, 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                          Text(
                            'ID: ${admission['id']} • ${admission['grade']}',
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: AppThemeResponsiveness.getIconSize(context),
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Expanded(
                      child: Text(
                        admission['parentName'],
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: AppThemeResponsiveness.getIconSize(context),
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Expanded(
                      child: Text(
                        admission['phone'],
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                // Show interview date if scheduled
                if (admission['interviewDate'] != null) ...[
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: AppThemeResponsiveness.getIconSize(context),
                        color: Colors.blue,
                      ),
                      SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                      Expanded(
                        child: Text(
                          'Interview: ${_formatDateTime(admission['interviewDate'])}',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                        vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(admission['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 16.0)),
                        border: Border.all(
                          color: _getStatusColor(admission['status']).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        admission['status'],
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          color: _getStatusColor(admission['status']),
                          fontWeight: FontWeight.w600,
                          fontSize: AppThemeResponsiveness.getResponsiveSize(context, 12.0, 13.0, 14.0),
                        ),
                      ),
                    ),
                    Text(
                      'Submitted: ${admission['submittedDate']}',
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey.shade500,
                        fontSize: AppThemeResponsiveness.getResponsiveSize(context, 12.0, 13.0, 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${time.format(context)}';
  }
}