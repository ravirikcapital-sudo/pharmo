import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/sectionTitle.dart';

class TeacherPerformanceScreen extends StatefulWidget {
  const TeacherPerformanceScreen({Key? key}) : super(key: key);

  @override
  State<TeacherPerformanceScreen> createState() => _TeacherPerformanceScreenState();
}

class _TeacherPerformanceScreenState extends State<TeacherPerformanceScreen> with TickerProviderStateMixin{
  bool _isLoading = false;
  late TabController _tabController;

  // Sample data - replace with actual API calls
  final List<AttendanceEntry> _attendanceEntries = [
    AttendanceEntry(
      className: 'Class 10-A',
      subject: 'Mathematics',
      date: DateTime.now().subtract(const Duration(days: 0)),
      status: AttendanceStatus.completed,
      studentsPresent: 28,
      totalStudents: 30,
    ),
    AttendanceEntry(
      className: 'Class 9-B',
      subject: 'Physics',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: AttendanceStatus.pending,
      studentsPresent: 0,
      totalStudents: 32,
    ),
    AttendanceEntry(
      className: 'Class 10-C',
      subject: 'Mathematics',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: AttendanceStatus.completed,
      studentsPresent: 25,
      totalStudents: 28,
    ),
  ];

  final List<ResultEntry> _resultEntries = [
    ResultEntry(
      examName: 'Mid-Term Exam',
      className: 'Class 10-A',
      subject: 'Mathematics',
      totalStudents: 30,
      resultsEntered: 30,
      status: ResultStatus.completed,
      deadline: DateTime.now().add(const Duration(days: 5)),
    ),
    ResultEntry(
      examName: 'Unit Test 2',
      className: 'Class 9-B',
      subject: 'Physics',
      totalStudents: 32,
      resultsEntered: 15,
      status: ResultStatus.inProgress,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    ResultEntry(
      examName: 'Final Exam',
      className: 'Class 10-C',
      subject: 'Mathematics',
      totalStudents: 28,
      resultsEntered: 0,
      status: ResultStatus.pending,
      deadline: DateTime.now().add(const Duration(days: 10)),
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                title: 'Teacher Performance',
                icon: Icons.account_circle_outlined,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: AppThemeColor.defaultSpacing, left: AppThemeColor.defaultSpacing, right: AppThemeColor.defaultSpacing),
                  decoration: const BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppThemeColor.cardBorderRadius),
                      topRight: Radius.circular(AppThemeColor.cardBorderRadius),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        CustomTabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Attendance Entry'),
            Tab(text: 'Result Entry Status'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAttendanceTab(),
              _buildResultTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            title: 'Attendance Summary',
            completed: _attendanceEntries.where((e) => e.status == AttendanceStatus.completed).length,
            pending: _attendanceEntries.where((e) => e.status == AttendanceStatus.pending).length,
            icon: Icons.fact_check_outlined,
            color: AppThemeColor.primaryBlue,
          ),
          const SizedBox(height: AppThemeColor.defaultSpacing),
          SectionTitleBlueAdmission(title: 'Recent Attendance Entries'),
          const SizedBox(height: AppThemeColor.smallSpacing),
          Expanded(
            child: ListView.builder(
              itemCount: _attendanceEntries.length,
              itemBuilder: (context, index) {
                return _buildAttendanceCard(_attendanceEntries[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            title: 'Result Entry Summary',
            completed: _resultEntries.where((e) => e.status == ResultStatus.completed).length,
            pending: _resultEntries.where((e) => e.status == ResultStatus.pending).length,
            icon: Icons.assignment_turned_in_outlined,
            color: AppThemeColor.primaryIndigo,
          ),
          const SizedBox(height: AppThemeColor.defaultSpacing),
          const SectionTitleBlueAdmission(title: 'Result Entry Status'),
          const SizedBox(height: AppThemeColor.smallSpacing),
          Expanded(
            child: ListView.builder(
              itemCount: _resultEntries.length,
              itemBuilder: (context, index) {
                return _buildResultCard(_resultEntries[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int completed,
    required int pending,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppThemeColor.defaultSpacing),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: AppThemeColor.mediumSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _buildStatusChip('Completed: $completed', Colors.green),
                      const SizedBox(width: 10),
                      _buildStatusChip('Pending: $pending', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeColor.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${entry.className} - ${entry.subject}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                _buildStatusBadge(entry.status),
              ],
            ),
            const SizedBox(height: AppThemeColor.smallSpacing),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 5),
                Text(
                  _formatDate(entry.date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            if (entry.status == AttendanceStatus.completed) ...[
              const SizedBox(height: AppThemeColor.smallSpacing),
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 5),
                  Text(
                    'Present: ${entry.studentsPresent}/${entry.totalStudents}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ResultEntry entry) {
    double progress = entry.totalStudents > 0 ? entry.resultsEntered / entry.totalStudents : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeColor.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.examName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                _buildResultStatusBadge(entry.status),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '${entry.className} - ${entry.subject}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: AppThemeColor.smallSpacing),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 5),
                Text(
                  'Deadline: ${_formatDate(entry.deadline)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: AppThemeColor.smallSpacing),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress: ${entry.resultsEntered}/${entry.totalStudents}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          entry.status == ResultStatus.completed
                              ? Colors.green
                              : entry.status == ResultStatus.inProgress
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AttendanceStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case AttendanceStatus.completed:
        color = Colors.green;
        text = 'Completed';
        icon = Icons.check_circle;
        break;
      case AttendanceStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStatusBadge(ResultStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ResultStatus.completed:
        color = Colors.green;
        text = 'Completed';
        icon = Icons.check_circle;
        break;
      case ResultStatus.inProgress:
        color = Colors.orange;
        text = 'In Progress';
        icon = Icons.hourglass_empty;
        break;
      case ResultStatus.pending:
        color = Colors.red;
        text = 'Pending';
        icon = Icons.pending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Data Models
class AttendanceEntry {
  final String className;
  final String subject;
  final DateTime date;
  final AttendanceStatus status;
  final int studentsPresent;
  final int totalStudents;

  AttendanceEntry({
    required this.className,
    required this.subject,
    required this.date,
    required this.status,
    required this.studentsPresent,
    required this.totalStudents,
  });
}

class ResultEntry {
  final String examName;
  final String className;
  final String subject;
  final int totalStudents;
  final int resultsEntered;
  final ResultStatus status;
  final DateTime deadline;

  ResultEntry({
    required this.examName,
    required this.className,
    required this.subject,
    required this.totalStudents,
    required this.resultsEntered,
    required this.status,
    required this.deadline,
  });
}

enum AttendanceStatus { completed, pending }
enum ResultStatus { completed, inProgress, pending }