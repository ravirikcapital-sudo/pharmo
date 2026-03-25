import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/model/dashboard/examManagement.dart';

// Main Exam Management Screen
class ExamManagementScreen extends StatefulWidget {
  const ExamManagementScreen({Key? key}) : super(key: key);

  @override
  State<ExamManagementScreen> createState() => _ExamManagementScreenState();
}

class _ExamManagementScreenState extends State<ExamManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<ExamSession> examSessions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSampleData();
  }

  void _loadSampleData() {
    setState(() {
      examSessions = [
        ExamSession(
          id: '1',
          name: 'Mid-Term Examination',
          className: 'Class 10-A',
          subject: 'Mathematics',
          deadline: DateTime.now().add(const Duration(days: 2)),
          totalStudents: 35,
          marksEntered: 28,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ExamSession(
          id: '2',
          name: 'Unit Test 2',
          className: 'Class 9-B',
          subject: 'Science',
          deadline: DateTime.now().subtract(const Duration(days: 1)),
          isLocked: false,
          totalStudents: 40,
          marksEntered: 15,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        ExamSession(
          id: '3',
          name: 'Final Assessment',
          className: 'Class 8-C',
          subject: 'English',
          deadline: DateTime.now().add(const Duration(days: 5)),
          isLocked: true,
          totalStudents: 32,
          marksEntered: 32,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

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
                title: 'Exam Management',
                icon: Icons.school,
              ),

              CustomTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Overdue'),
                  Tab(text: 'Completed'),
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
                    _buildActiveExamsTab(context),
                    _buildOverdueExamsTab(context),
                    _buildCompletedExamsTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context, isSmallScreen),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, bool isSmallScreen) {
    if (isSmallScreen) {
      return FloatingActionButton(
        onPressed: () => _showCreateExamDialog(),
        backgroundColor: AppThemeColor.primaryIndigo,
        child: const Icon(Icons.add, color: AppThemeColor.white),
      );
    }

    return FloatingActionButton.extended(
      onPressed: () => _showCreateExamDialog(),
      backgroundColor: AppThemeColor.primaryIndigo,
      icon: const Icon(Icons.add, color: AppThemeColor.white),
      label: const Text(
        'New Exam',
        style: TextStyle(color: AppThemeColor.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActiveExamsTab(BuildContext context) {
    final activeExams = examSessions
        .where((exam) => !exam.isLocked && !exam.isOverdue)
        .toList();

    return _buildExamsList(activeExams, 'No active exams found', context);
  }

  Widget _buildOverdueExamsTab(BuildContext context) {
    final overdueExams = examSessions.where((exam) => exam.isOverdue).toList();

    return _buildExamsList(overdueExams, 'No overdue exams', context);
  }

  Widget _buildCompletedExamsTab(BuildContext context) {
    final completedExams = examSessions.where((exam) => exam.isLocked).toList();

    return _buildExamsList(completedExams, 'No completed exams', context);
  }

  Widget _buildExamsList(List<ExamSession> exams, String emptyMessage, BuildContext context) {
    if (exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppThemeColor.white.withAlpha(128), // 50% opacity
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                emptyMessage,
                style: const TextStyle(
                  color: AppThemeColor.white70,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        return _buildExamCard(exams[index], context);
      },
    );
  }

  Widget _buildExamCard(ExamSession exam, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: Card(
        elevation: AppThemeColor.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExamHeader(exam, context),
              SizedBox(height: screenWidth * 0.03),
              _buildExamDetails(exam, context),
              SizedBox(height: screenWidth * 0.03),
              _buildProgressBar(exam, context),
              SizedBox(height: screenWidth * 0.03),
              _buildExamActions(exam, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamHeader(ExamSession exam, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: exam.isOverdue
                    ? Colors.red.withAlpha(51) // 20% opacity
                    : exam.isLocked
                    ? Colors.green.withAlpha(51) // 20% opacity
                    : AppThemeColor.blue50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                exam.isLocked
                    ? Icons.lock_outline
                    : exam.isOverdue
                    ? Icons.warning_outlined
                    : Icons.assignment_outlined,
                color: exam.isOverdue
                    ? Colors.red
                    : exam.isLocked
                    ? Colors.green
                    : AppThemeColor.primaryBlue,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.name,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${exam.className} • ${exam.subject}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isSmallScreen) ...[
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatusChip(exam, context),
          ),
        ] else
          Positioned(
            top: 0,
            right: 0,
            child: _buildStatusChip(exam, context),
          ),
      ],
    );
  }

  Widget _buildStatusChip(ExamSession exam, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Color chipColor;
    String chipText;

    if (exam.isLocked) {
      chipColor = Colors.green;
      chipText = 'Completed';
    } else if (exam.isOverdue) {
      chipColor = Colors.red;
      chipText = 'Overdue';
    } else {
      chipColor = AppThemeColor.primaryBlue;
      chipText = 'Active';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        chipText,
        style: TextStyle(
          color: AppThemeColor.white,
          fontSize: screenWidth < 400 ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExamDetails(ExamSession exam, BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    if (isSmallScreen) {
      return Column(
        children: [
          _buildInfoItem(
            Icons.schedule,
            'Deadline',
            dateFormat.format(exam.deadline),
            exam.isOverdue ? Colors.red : Colors.black54,
            context,
          ),
          SizedBox(height: 8),
          _buildInfoItem(
            Icons.people_outline,
            'Students',
            '${exam.marksEntered}/${exam.totalStudents}',
            Colors.black54,
            context,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            Icons.schedule,
            'Deadline',
            dateFormat.format(exam.deadline),
            exam.isOverdue ? Colors.red : Colors.black54,
            context,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            Icons.people_outline,
            'Students',
            '${exam.marksEntered}/${exam.totalStudents}',
            Colors.black54,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color? valueColor, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Row(
      children: [
        Icon(icon, size: isSmallScreen ? 14 : 16, color: Colors.black54),
        SizedBox(width: screenWidth * 0.015),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ExamSession exam, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: screenWidth < 400 ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              '${exam.completionPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: screenWidth < 400 ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: exam.completionPercentage / 100,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            exam.completionPercentage == 100
                ? Colors.green
                : exam.isOverdue
                ? Colors.red
                : AppThemeColor.primaryBlue,
          ),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildExamActions(ExamSession exam, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    if (isSmallScreen) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _editDeadline(exam),
              icon: const Icon(Icons.edit_calendar, size: 16),
              label: const Text('Edit Deadline'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColor.blue100,
                foregroundColor: AppThemeColor.blue800,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _toggleExamLock(exam),
              icon: Icon(
                exam.isLocked ? Icons.lock_open : Icons.lock,
                size: 16,
              ),
              label: Text(exam.isLocked ? 'Unlock' : 'Lock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: exam.isLocked ? Colors.green : Colors.orange,
                foregroundColor: AppThemeColor.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _editDeadline(exam),
            icon: const Icon(Icons.edit_calendar, size: 16),
            label: const Text('Edit Deadline'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColor.blue100,
              foregroundColor: AppThemeColor.blue800,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _toggleExamLock(exam),
            icon: Icon(
              exam.isLocked ? Icons.lock_open : Icons.lock,
              size: 16,
            ),
            label: Text(exam.isLocked ? 'Unlock' : 'Lock'),
            style: ElevatedButton.styleFrom(
              backgroundColor: exam.isLocked ? Colors.green : Colors.orange,
              foregroundColor: AppThemeColor.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _editDeadline(ExamSession exam) async {
    final DateTime? newDeadline = await showDatePicker(
      context: context,
      initialDate: exam.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppThemeColor.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDeadline != null) {
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(exam.deadline),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppThemeColor.primaryBlue,
              ),
            ),
            child: child!,
          );
        },
      );

      if (newTime != null) {
        final updatedDeadline = DateTime(
          newDeadline.year,
          newDeadline.month,
          newDeadline.day,
          newTime.hour,
          newTime.minute,
        );

        setState(() {
          final index = examSessions.indexWhere((e) => e.id == exam.id);
          if (index != -1) {
            examSessions[index] = exam.copyWith(deadline: updatedDeadline);
          }
        });

        _showSuccessSnackBar('Deadline updated successfully');
      }
    }
  }

  void _toggleExamLock(ExamSession exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        title: Text(exam.isLocked ? 'Unlock Exam' : 'Lock Exam'),
        content: Text(
          exam.isLocked
              ? 'Are you sure you want to unlock this exam? Teachers will be able to modify marks again.'
              : 'Are you sure you want to lock this exam? No further modifications will be allowed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final index = examSessions.indexWhere((e) => e.id == exam.id);
                if (index != -1) {
                  examSessions[index] = exam.copyWith(isLocked: !exam.isLocked);
                }
              });
              _showSuccessSnackBar(
                  exam.isLocked ? 'Exam unlocked successfully' : 'Exam locked successfully'
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: exam.isLocked ? Colors.green : Colors.orange,
            ),
            child: Text(exam.isLocked ? 'Unlock' : 'Lock'),
          ),
        ],
      ),
    );
  }

  void _showCreateExamDialog() {
    // Implementation for creating new exam
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        title: const Text('Create New Exam'),
        content: const Text('Feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    AppSnackBar.show(
      context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}