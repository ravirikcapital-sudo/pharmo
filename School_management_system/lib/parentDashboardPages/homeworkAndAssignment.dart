import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class HomeworkTrackingPage extends StatefulWidget {
  @override
  State<HomeworkTrackingPage> createState() => _HomeworkTrackingPageState();
}

class _HomeworkTrackingPageState extends State<HomeworkTrackingPage> with TickerProviderStateMixin {
  String? selectedChild;
  late TabController _tabController;

  // Sample data for children
  final List<Map<String, dynamic>> children = [
    {
      'name': 'Emma Johnson',
      'class': 'Class 10-A',
      'rollNo': '15',
      'icon': Icons.girl,
      'color': Colors.pink,
    },
    {
      'name': 'Jake Johnson',
      'class': 'Class 7-B',
      'rollNo': '23',
      'icon': Icons.boy,
      'color': Colors.blue,
    },
  ];

  // Sample homework data
  final Map<String, List<Map<String, dynamic>>> homeworkData = {
    'Emma Johnson': [
      {
        'subject': 'Mathematics',
        'title': 'Quadratic Equations Practice',
        'description': 'Solve problems 1-15 from chapter 4. Show all working steps.',
        'assignedDate': 'June 20, 2025',
        'dueDate': 'June 25, 2025',
        'status': 'pending',
        'priority': 'high',
        'teacher': 'Mrs. Smith',
        'attachments': ['quadratic_problems.pdf'],
        'type': 'homework',
        'icon': Icons.calculate_rounded,
        'color': Colors.blue,
      },
      {
        'subject': 'English Literature',
        'title': 'Character Analysis Essay',
        'description': 'Write a 500-word essay analyzing the main character in "To Kill a Mockingbird".',
        'assignedDate': 'June 18, 2025',
        'dueDate': 'June 24, 2025',
        'status': 'submitted',
        'priority': 'medium',
        'teacher': 'Mr. Johnson',
        'attachments': [],
        'type': 'assignment',
        'icon': Icons.article_rounded,
        'color': Colors.purple,
      },
      {
        'subject': 'Chemistry',
        'title': 'Lab Report - Acid-Base Reactions',
        'description': 'Complete lab report based on last week\'s experiment. Include observations and conclusions.',
        'assignedDate': 'June 19, 2025',
        'dueDate': 'June 26, 2025',
        'status': 'overdue',
        'priority': 'high',
        'teacher': 'Dr. Wilson',
        'attachments': ['lab_template.docx'],
        'type': 'assignment',
        'icon': Icons.science_rounded,
        'color': Colors.green,
      },
      {
        'subject': 'History',
        'title': 'World War II Timeline',
        'description': 'Create a detailed timeline of major events during World War II.',
        'assignedDate': 'June 21, 2025',
        'dueDate': 'June 28, 2025',
        'status': 'pending',
        'priority': 'low',
        'teacher': 'Ms. Davis',
        'attachments': [],
        'type': 'homework',
        'icon': Icons.history_edu_rounded,
        'color': Colors.orange,
      },
    ],
    'Jake Johnson': [
      {
        'subject': 'Mathematics',
        'title': 'Fractions and Decimals',
        'description': 'Complete worksheet on converting fractions to decimals and vice versa.',
        'assignedDate': 'June 21, 2025',
        'dueDate': 'June 24, 2025',
        'status': 'pending',
        'priority': 'medium',
        'teacher': 'Mrs. Brown',
        'attachments': ['fractions_worksheet.pdf'],
        'type': 'homework',
        'icon': Icons.calculate_rounded,
        'color': Colors.blue,
      },
      {
        'subject': 'Science',
        'title': 'Plant Life Cycle Project',
        'description': 'Create a poster showing the different stages of plant life cycle with drawings.',
        'assignedDate': 'June 19, 2025',
        'dueDate': 'June 27, 2025',
        'status': 'in_progress',
        'priority': 'high',
        'teacher': 'Mr. Garcia',
        'attachments': [],
        'type': 'assignment',
        'icon': Icons.nature_rounded,
        'color': Colors.green,
      },
      {
        'subject': 'English',
        'title': 'Reading Comprehension',
        'description': 'Read chapter 3 of "The Secret Garden" and answer the questions at the end.',
        'assignedDate': 'June 20, 2025',
        'dueDate': 'June 23, 2025',
        'status': 'submitted',
        'priority': 'medium',
        'teacher': 'Ms. Anderson',
        'attachments': [],
        'type': 'homework',
        'icon': Icons.menu_book_rounded,
        'color': Colors.purple,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredHomework {
    if (selectedChild == null) return [];
    return homeworkData[selectedChild!] ?? [];
  }

  List<Map<String, dynamic>> get homeworkList {
    return filteredHomework.where((item) => item['type'] == 'homework').toList();
  }

  List<Map<String, dynamic>> get assignmentList {
    return filteredHomework.where((item) => item['type'] == 'assignment').toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'submitted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'submitted':
        return 'Submitted';
      case 'pending':
        return 'Pending';
      case 'overdue':
        return 'Overdue';
      case 'in_progress':
        return 'In Progress';
      default:
        return 'Unknown';
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icons.priority_high_rounded;
      case 'medium':
        return Icons.remove_rounded;
      case 'low':
        return Icons.keyboard_arrow_down_rounded;
      default:
        return Icons.remove_rounded;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
                title: 'Homework & Assignment',
                icon: Icons.assignment_rounded,
              ),
              _buildChildSelector(context),
              if (selectedChild != null) ...[
                CustomTabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Homework'),
                    Tab(text: 'Assignment'),
                  ],
                  getSpacing: AppThemeResponsiveness.getDefaultSpacing,
                  getBorderRadius: AppThemeResponsiveness.getInputBorderRadius,
                  getFontSize: AppThemeResponsiveness.getTabFontSize,
                  backgroundColor: AppThemeColor.blue50,
                  selectedColor: AppThemeColor.primaryBlue,
                  unselectedColor: AppThemeColor.blue600,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildHomeworkTab(context),
                      _buildAssignmentTab(context),
                    ],
                  ),
                ),
              ] else
                Expanded(
                  child: _buildEmptyState(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildSelector(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Child',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedChild,
                hint: Text(
                  'Choose a child',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
                items: children.map((child) {
                  return DropdownMenuItem<String>(
                    value: child['name'],
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.6),
                          decoration: BoxDecoration(
                            color: child['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context) * 0.6),
                          ),
                          child: Icon(
                            child['icon'],
                            color: child['color'],
                            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                          ),
                        ),
                        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                        Text(
                          child['name'],
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedChild = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkTab(BuildContext context) {
    if (homeworkList.isEmpty) {
      return _buildEmptyTaskState(context, 'No homework found', Icons.home_work_rounded);
    }

    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: homeworkList.length,
        itemBuilder: (context, index) => _buildTaskCard(context, homeworkList[index]),
      ),
    );
  }

  Widget _buildAssignmentTab(BuildContext context) {
    if (assignmentList.isEmpty) {
      return _buildEmptyTaskState(context, 'No assignments found', Icons.assignment_rounded);
    }

    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: assignmentList.length,
        itemBuilder: (context, index) => _buildTaskCard(context, assignmentList[index]),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with subject and status
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            decoration: BoxDecoration(
              color: (task['color'] as Color).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                  decoration: BoxDecoration(
                    color: (task['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                  ),
                  child: Icon(
                    task['icon'],
                    color: task['color'],
                    size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['subject'],
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: task['color'],
                        ),
                      ),
                      Text(
                        'by ${task['teacher']}',
                        style: AppThemeResponsiveness.getCaptionTextStyle(context),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                    vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task['status']),
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                  ),
                  child: Text(
                    _getStatusText(task['status']),
                    style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                // Priority indicator
                Icon(
                  _getPriorityIcon(task['priority']),
                  color: _getPriorityColor(task['priority']),
                  size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                Text(
                  task['description'],
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _buildDateInfo(
                        context,
                        'Assigned',
                        task['assignedDate'],
                        Icons.calendar_today_rounded,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                    Expanded(
                      child: _buildDateInfo(
                        context,
                        'Due Date',
                        task['dueDate'],
                        Icons.event_rounded,
                        task['status'] == 'overdue' ? Colors.red : Colors.orange,
                      ),
                    ),
                  ],
                ),

                // Attachments
                if (task['attachments'].isNotEmpty) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  Text(
                    'Attachments',
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                  ...task['attachments'].map<Widget>((attachment) => _buildAttachment(context, attachment)).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context, String label, String date, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppThemeResponsiveness.getIconSize(context) * 0.7),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    color: Colors.grey.shade700,
                    fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize! * 0.9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(BuildContext context, String attachment) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            attachment.endsWith('.pdf') ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
            color: attachment.endsWith('.pdf') ? Colors.red : Colors.blue,
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Text(
              attachment,
              style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Icon(
            Icons.download_rounded,
            color: Colors.grey.shade600,
            size: AppThemeResponsiveness.getIconSize(context) * 0.7,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context) * 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.family_restroom_rounded,
              size: AppThemeResponsiveness.getIconSize(context) * 3,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          Text(
            'Select a Child',
            style: AppThemeResponsiveness.getHeadingTextStyle(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Please select a child from the dropdown above to view their homework and assignments.',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTaskState(BuildContext context, String message, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context) * 2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: AppThemeResponsiveness.getCardElevation(context),
                  offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: AppThemeResponsiveness.getIconSize(context) * 2.5,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          Text(
            message,
            style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'No tasks available at the moment.',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}