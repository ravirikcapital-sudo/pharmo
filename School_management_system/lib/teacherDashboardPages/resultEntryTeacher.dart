import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/teacherDashboardModel/resultModelTeacher.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/teacherDashboardPages/resultEntryOnly.dart';

class ResultEntryPage extends StatefulWidget {
  const ResultEntryPage({Key? key}) : super(key: key);

  @override
  State<ResultEntryPage> createState() => _ResultEntryPageState();
}

class _ResultEntryPageState extends State<ResultEntryPage>
    with SingleTickerProviderStateMixin {
  final ResultService _resultService = ResultService();
  late TabController _tabController;

  List<Student> _students = [];
  List<Subject> _subjects = [];
  List<Exam> _exams = [];
  List<String> _classes = []; // Fixed: Changed from List<Class> to List<String>

  Exam? _selectedExam;
  Subject? _selectedSubject;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Force rebuild to update FAB visibility
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final students = await _resultService.getStudents();
      final subjects = await _resultService.getSubjects();
      final exams = await _resultService.getExams();
      final classes = await _resultService.getClasses(); // Assuming this method exists

      setState(() {
        _students = students;
        _subjects = subjects;
        _exams = exams;
        _classes = classes; // Fixed: Assign classes
        _selectedExam = exams.isNotEmpty ? exams.first : null;
        _selectedSubject = subjects.isNotEmpty ? subjects.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error loading data: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveResult(ExamResult result) async {
    final success = await _resultService.saveResult(result);
    if (success) {
      _showSnackBar('Result saved successfully!');
      _loadData();
    } else {
      _showSnackBar('Failed to save result.', isError: true);
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.lightGreen;
      case 'C+':
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.amber;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                title: 'Results & Marks',
                icon: Icons.assessment,
              ),
              CustomTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Entry'),
                  Tab(text: 'Result'),
                  Tab(text: 'Statistics'),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                    child: CircularProgressIndicator(color: AppThemeColor.white))
                    : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMarksEntryTab(),
                    _buildViewResultsTab(),
                    _buildStatisticsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
        onPressed: _showGenerateResultDialog,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 6.0,
      )
          : null,
    );
  }

  void _showGenerateResultDialog() {
    Student? selectedStudent;
    Exam? selectedExam;
    String? selectedClass;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Generate Result',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: Colors.blue[700],
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // Limit dialog height
              maxWidth: MediaQuery.of(context).size.width * 0.9,   // Limit dialog width
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Student Selection
                  Autocomplete<Student>(
                    displayStringForOption: (student) => student.name,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _students;
                      }
                      return _students.where((student) => student.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (student) {
                      selectedStudent = student;
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Select Student',
                          prefixIcon: Icon(Icons.person, color: Colors.blue[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0), // Fixed border radius
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 16.0,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0), // Fixed spacing

                  // Exam Selection
                  _buildDropdown<Exam>(
                    value: selectedExam,
                    items: _exams,
                    labelText: 'Select Exam',
                    icon: Icons.quiz,
                    displayText: (exam) => '${exam.name} (${exam.type.replaceAll('_', ' ').toUpperCase()})',
                    onChanged: (exam) => setDialogState(() => selectedExam = exam),
                  ),
                  const SizedBox(height: 16.0), // Fixed spacing

                  // Class Selection
                  _buildDropdown<String>(
                    value: selectedClass,
                    items: _classes,
                    labelText: 'Select Class',
                    icon: Icons.class_,
                    displayText: (className) => className,
                    onChanged: (className) => setDialogState(() => selectedClass = className),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.blue[700])),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedStudent != null && selectedExam != null && selectedClass != null) {
                  _showSnackBar('Result generated for ${selectedStudent!.name} in $selectedClass for ${selectedExam!.name}');
                  Navigator.of(context).pop();
                  _loadData();
                } else {
                  _showSnackBar('Please select a student, exam, and class.', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }

// Also update your _buildDropdown method to handle the dialog context better
  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String labelText,
    required IconData icon,
    required String Function(T) displayText,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Fixed border radius
        ),
        prefixIcon: Icon(icon, size: 20.0), // Fixed icon size
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            displayText(item),
            style: const TextStyle(fontSize: 14.0), // Fixed text style
            overflow: TextOverflow.ellipsis, // Prevent text overflow
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMarksEntryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildExamSubjectSelector(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          if (_selectedExam != null && _selectedSubject != null)
            _buildStudentMarksEntryList(),
        ],
      ),
    );
  }

  Widget _buildExamSubjectSelector() {
    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Exam & Subject',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildDropdown<Exam>(
              value: _selectedExam,
              items: _exams,
              labelText: 'Select Exam',
              icon: Icons.quiz,
              displayText: (exam) => '${exam.name} (${exam.type.replaceAll('_', ' ').toUpperCase()})',
              onChanged: (exam) => setState(() => _selectedExam = exam),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildDropdown<Subject>(
              value: _selectedSubject,
              items: _subjects,
              labelText: 'Select Subject',
              icon: Icons.book,
              displayText: (subject) => '${subject.name} (${subject.code})',
              onChanged: (subject) => setState(() => _selectedSubject = subject),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentMarksEntryList() {
    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enter Marks',
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Max: ${_selectedSubject!.maxMarks}',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _students.length,
              separatorBuilder: (context, index) => SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              itemBuilder: (context, index) {
                final student = _students[index];
                return _buildStudentMarksCard(student);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentMarksCard(Student student) {
    return FutureBuilder<ExamResult?>(
      future: _resultService.getResult(
        student.id,
        _selectedSubject!.id,
        _selectedExam!.id,
      ),
      builder: (context, snapshot) {
        final existingResult = snapshot.data;
        return StudentMarksEntryCard(
          student: student,
          subject: _selectedSubject!,
          exam: _selectedExam!,
          existingResult: existingResult,
          onSave: (result) => _saveResult(result),
        );
      },
    );
  }

  Widget _buildViewResultsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildResultsExamSelector(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          if (_selectedExam != null) _buildStudentResultsDisplay(),
        ],
      ),
    );
  }

  Widget _buildResultsExamSelector() {
    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View Results',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildDropdown<Exam>(
              value: _selectedExam,
              items: _exams,
              labelText: 'Select Exam',
              icon: Icons.quiz,
              displayText: (exam) => '${exam.name} (${exam.type.replaceAll('_', ' ').toUpperCase()})',
              onChanged: (exam) => setState(() => _selectedExam = exam),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentResultsDisplay() {
    return FutureBuilder<List<ExamResult>>(
      future: _resultService.getResultsByExam(_selectedExam!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return _buildEmptyResultsCard();
        }

        // Group results by student
        final studentResults = <String, List<ExamResult>>{};
        for (final result in results) {
          studentResults[result.studentId] ??= [];
          studentResults[result.studentId]!.add(result);
        }

        return _buildResultsLayout(studentResults);
      },
    );
  }

  Widget _buildEmptyResultsCard() {
    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getLargeSpacing(context)),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.assignment,
                size: AppThemeResponsiveness.getHeaderIconSize(context),
                color: Colors.grey,
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              Text(
                'No results found for this exam',
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsLayout(Map<String, List<ExamResult>> studentResults) {
    final isDesktop = AppThemeResponsiveness.isDesktop(context);

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getDesktopGridColumns(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: _getDesktopCardAspectRatio(context),
        ),
        itemCount: studentResults.length,
        itemBuilder: (context, index) {
          final studentId = studentResults.keys.elementAt(index);
          final student = _students.firstWhere((s) => s.id == studentId);
          return _buildDesktopResultCard(student, studentId);
        },
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: studentResults.length,
        separatorBuilder: (context, index) => SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        itemBuilder: (context, index) {
          final studentId = studentResults.keys.elementAt(index);
          final student = _students.firstWhere((s) => s.id == studentId);
          return _buildMobileResultCard(student, studentId);
        },
      );
    }
  }

  int _getDesktopGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1400) return 4;
    if (screenWidth > 1000) return 3;
    return 2;
  }

  double _getDesktopCardAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1400) return 1.1;
    if (screenWidth > 1000) return 1.0;
    return 0.9;
  }

  Widget _buildDesktopResultCard(Student student, String studentId) {
    return FutureBuilder<StudentResultSummary?>(
      future: _resultService.getStudentSummary(studentId, _selectedExam!.id),
      builder: (context, summarySnapshot) {
        final summary = summarySnapshot.data;
        return Card(
          elevation: AppThemeColor.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          child: InkWell(
            onTap: () => _showStudentDetailsDialog(student, summary),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppThemeColor.primaryBlue,
                    radius: 30,
                    child: Text(
                      student.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppThemeColor.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Roll No: ${student.rollNumber}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (summary != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getGradeColor(summary.overallGrade),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${summary.percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: AppThemeColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getGradeColor(summary.overallGrade).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Grade: ${summary.overallGrade}',
                        style: TextStyle(
                          color: _getGradeColor(summary.overallGrade),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileResultCard(Student student, String studentId) {
    return FutureBuilder<StudentResultSummary?>(
      future: _resultService.getStudentSummary(studentId, _selectedExam!.id),
      builder: (context, summarySnapshot) {
        final summary = summarySnapshot.data;
        return Card(
          elevation: AppThemeColor.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: AppThemeColor.primaryBlue,
              radius: AppThemeResponsiveness.getDashboardCardIconSize(context) * 0.5,
              child: Text(
                student.name.substring(0, 1).toUpperCase(),
                style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                  color: AppThemeColor.white,
                  fontSize: AppThemeResponsiveness.getDashboardCardTitleStyle(context).fontSize! * 0.8,
                ),
              ),
            ),
            title: Text(
              student.name,
              style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
            ),
            subtitle: Text(
              'Roll No: ${student.rollNumber}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
            ),
            trailing: summary != null
                ? Container(
              padding: AppThemeResponsiveness.getStatusBadgePadding(context),
              decoration: BoxDecoration(
                color: _getGradeColor(summary.overallGrade),
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getStatusBadgeBorderRadius(context)),
              ),
              child: Text(
                '${summary.percentage.toStringAsFixed(1)}% (${summary.overallGrade})',
                style: TextStyle(
                  color: AppThemeColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                ),
              ),
            )
                : null,
            children: [
              if (summary != null)
                Padding(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResultStat('Total', '${summary.totalMarksObtained.toInt()}/${summary.totalMaxMarks.toInt()}'),
                      _buildResultStat('Percentage', '${summary.percentage.toStringAsFixed(1)}%'),
                      _buildResultStat('Grade', summary.overallGrade),
                      _buildResultStat('Pass/Total', '${summary.subjectsPassed}/${summary.totalSubjects}'),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showStudentDetailsDialog(Student student, StudentResultSummary? summary) {
    if (summary == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildResultStat('Total Marks', '${summary.totalMarksObtained.toInt()}/${summary.totalMaxMarks.toInt()}'),
            const SizedBox(height: 10),
            _buildResultStat('Percentage', '${summary.percentage.toStringAsFixed(1)}%'),
            const SizedBox(height: 10),
            _buildResultStat('Grade', summary.overallGrade),
            const SizedBox(height: 10),
            _buildResultStat('Subjects Passed', '${summary.subjectsPassed}/${summary.totalSubjects}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppThemeResponsiveness.getStatValueStyle(context),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Text(
          label,
          style: AppThemeResponsiveness.getStatTitleStyle(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildStatisticsExamSelector(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          if (_selectedExam != null) _buildClassStatisticsCard(),
        ],
      ),
    );
  }

  Widget _buildStatisticsExamSelector() {
    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Statistics',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildDropdown<Exam>(
              value: _selectedExam,
              items: _exams,
              labelText: 'Select Exam',
              icon: Icons.quiz,
              displayText: (exam) => '${exam.name} (${exam.type.replaceAll('_', ' ').toUpperCase()})',
              onChanged: (exam) => setState(() => _selectedExam = exam),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassStatisticsCard() {
    if (_selectedExam == null) return const SizedBox.shrink();

    final classStats = _resultService.getClassStatistics(_selectedExam!.id);

    if (classStats['totalStudents'] == 0) {
      return Card(
        elevation: AppThemeColor.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppThemeResponsiveness.getLargeSpacing(context)),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.bar_chart,
                  size: AppThemeResponsiveness.getHeaderIconSize(context),
                  color: Colors.grey,
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                Text(
                  'No statistics available for this exam yet.',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: AppThemeColor.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Class Performance for ${_selectedExam!.name}',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildStatRow('Total Students', classStats['totalStudents'].toString()),
            _buildStatRow('Average Percentage', '${classStats['averagePercentage'].toStringAsFixed(1)}%'),
            _buildStatRow('Highest Marks', '${classStats['highestMarks'].toStringAsFixed(1)}%'),
            _buildStatRow('Lowest Marks', '${classStats['lowestMarks'].toStringAsFixed(1)}%'),
            _buildStatRow('Students Passed', classStats['passedStudents'].toString()),
            _buildStatRow('Students Failed', classStats['failedStudents'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(color: Colors.grey[700]),
          ),
          Text(
            value,
            style: AppThemeResponsiveness.getStatValueStyle(context),
          ),
        ],
      ),
    );
  }
}