import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class StudentPerformance extends StatefulWidget {
  const StudentPerformance({Key? key}) : super(key: key);

  @override
  State<StudentPerformance> createState() => _StudentPerformanceState();
}

class _StudentPerformanceState extends State<StudentPerformance> {
  bool _isLoading = false;
  String? _selectedStudentId;
  String? _selectedSemester;
  bool _showPerformance = false;

  // Reduced sample students data - only 2 students
  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'Emma Johnson', 'class': '10 A', 'roll': '15'},
    {'id': '2', 'name': 'Jake Johnson', 'class': '7 B', 'roll': '23'},
  ];

  final List<String> _semesters = ['Semester 1', 'Semester 2'];

  // Reduced performance data - only for 2 students
  Map<String, Map<String, dynamic>> _performanceData = {
    '1': {
      'Semester 1': {
        'subjects': [
          {'name': 'Mathematics', 'marks': 85, 'maxMarks': 100, 'grade': 'A'},
          {'name': 'Science', 'marks': 78, 'maxMarks': 100, 'grade': 'B+'},
          {'name': 'English', 'marks': 92, 'maxMarks': 100, 'grade': 'A+'},
          {'name': 'History', 'marks': 76, 'maxMarks': 100, 'grade': 'B+'},
          {'name': 'Geography', 'marks': 81, 'maxMarks': 100, 'grade': 'A-'},
        ],
        'totalMarks': 412,
        'maxTotalMarks': 500,
        'percentage': 82.4,
        'overallGrade': 'A-',
        'rank': 3,
        'attendance': 94.5,
        'monthlyProgress': [
          {'month': 'Jan', 'percentage': 78},
          {'month': 'Feb', 'percentage': 82},
          {'month': 'Mar', 'percentage': 85},
          {'month': 'Apr', 'percentage': 83},
          {'month': 'May', 'percentage': 87},
        ],
      },
      'Semester 2': {
        'subjects': [
          {'name': 'Mathematics', 'marks': 88, 'maxMarks': 100, 'grade': 'A'},
          {'name': 'Science', 'marks': 82, 'maxMarks': 100, 'grade': 'A-'},
          {'name': 'English', 'marks': 95, 'maxMarks': 100, 'grade': 'A+'},
          {'name': 'History', 'marks': 79, 'maxMarks': 100, 'grade': 'B+'},
          {'name': 'Geography', 'marks': 84, 'maxMarks': 100, 'grade': 'A-'},
        ],
        'totalMarks': 428,
        'maxTotalMarks': 500,
        'percentage': 85.6,
        'overallGrade': 'A',
        'rank': 2,
        'attendance': 96.2,
        'monthlyProgress': [
          {'month': 'Jun', 'percentage': 85},
          {'month': 'Jul', 'percentage': 87},
          {'month': 'Aug', 'percentage': 89},
          {'month': 'Sep', 'percentage': 86},
          {'month': 'Oct', 'percentage': 91},
        ],
      },
    },
    '2': {
      'Semester 1': {
        'subjects': [
          {'name': 'Mathematics', 'marks': 72, 'maxMarks': 100, 'grade': 'B'},
          {'name': 'Science', 'marks': 68, 'maxMarks': 100, 'grade': 'B-'},
          {'name': 'English', 'marks': 81, 'maxMarks': 100, 'grade': 'A-'},
          {'name': 'Social Studies', 'marks': 75, 'maxMarks': 100, 'grade': 'B+'},
          {'name': 'Hindi', 'marks': 79, 'maxMarks': 100, 'grade': 'B+'},
        ],
        'totalMarks': 375,
        'maxTotalMarks': 500,
        'percentage': 75.0,
        'overallGrade': 'B+',
        'rank': 8,
        'attendance': 91.2,
        'monthlyProgress': [
          {'month': 'Jan', 'percentage': 72},
          {'month': 'Feb', 'percentage': 74},
          {'month': 'Mar', 'percentage': 76},
          {'month': 'Apr', 'percentage': 75},
          {'month': 'May', 'percentage': 78},
        ],
      },
      'Semester 2': {
        'subjects': [
          {'name': 'Mathematics', 'marks': 76, 'maxMarks': 100, 'grade': 'B+'},
          {'name': 'Science', 'marks': 71, 'maxMarks': 100, 'grade': 'B'},
          {'name': 'English', 'marks': 84, 'maxMarks': 100, 'grade': 'A-'},
          {'name': 'Social Studies', 'marks': 78, 'maxMarks': 100, 'grade': 'B+'},
          {'name': 'Hindi', 'marks': 82, 'maxMarks': 100, 'grade': 'A-'},
        ],
        'totalMarks': 391,
        'maxTotalMarks': 500,
        'percentage': 78.2,
        'overallGrade': 'B+',
        'rank': 6,
        'attendance': 93.8,
        'monthlyProgress': [
          {'month': 'Jun', 'percentage': 76},
          {'month': 'Jul', 'percentage': 78},
          {'month': 'Aug', 'percentage': 80},
          {'month': 'Sep', 'percentage': 79},
          {'month': 'Oct', 'percentage': 82},
        ],
      },
    },
  };

  @override
  void initState() {
    super.initState();
    _selectedSemester = _semesters.first;
  }

  Future<void> _loadPerformanceData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _showPerformance = true;
    });
  }

  void _onCheckPressed() {
    if (_selectedStudentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a student'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedSemester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a semester'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _loadPerformanceData();
  }

  Map<String, dynamic>? get _currentPerformanceData {
    if (_selectedStudentId == null || _selectedSemester == null) return null;
    return _performanceData[_selectedStudentId!]?[_selectedSemester!];
  }

  String get _selectedStudentName {
    if (_selectedStudentId == null) return '';
    final student = _students.firstWhere((s) => s['id'] == _selectedStudentId);
    return student['name'] ?? '';
  }

  String get _selectedStudentClass {
    if (_selectedStudentId == null) return '';
    final student = _students.firstWhere((s) => s['id'] == _selectedStudentId);
    return 'Class: ${student['class']} | Roll: ${student['roll']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Student Performance',
                  icon: Icons.star,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildDropdowns(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildCheckButton(),
                if (_isLoading) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 2),
                  const Center(
                    child: CircularProgressIndicator(color: AppThemeColor.white),
                  ),
                ] else if (_showPerformance && _currentPerformanceData != null) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildStudentInfo(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildOverallPerformance(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildSubjectPerformance(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildProgressChart(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildPerformanceDistribution(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Student & Semester',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

          // Student Dropdown
          Text(
            'Student Name',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getMediumSpacing(context)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStudentId,
                hint: Text('Select a student', style: AppThemeResponsiveness.getBodyTextStyle(context)),
                isExpanded: true,
                items: _students.map((student) {
                  return DropdownMenuItem<String>(
                    value: student['id'],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          student['name']!,
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Class: ${student['class']} | Roll: ${student['roll']}',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudentId = value;
                    _showPerformance = false; // Reset performance display
                  });
                },
              ),
            ),
          ),

          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

          // Semester Dropdown
          Text(
            'Semester',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getMediumSpacing(context)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSemester,
                isExpanded: true,
                items: _semesters.map((semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(semester, style: AppThemeResponsiveness.getBodyTextStyle(context)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                    _showPerformance = false; // Reset performance display
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
      child: ElevatedButton(
        onPressed: _onCheckPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColor.white,
          foregroundColor: AppThemeColor.primaryBlue,
          padding: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getMediumSpacing(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              'Check Performance',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
                color: AppThemeColor.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppThemeColor.primaryBlue.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 30,
              color: AppThemeColor.primaryBlue,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedStudentName,
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  _selectedStudentClass,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  _selectedSemester!,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: AppThemeColor.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallPerformance() {
    final data = _currentPerformanceData!;

    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Total Marks',
                  '${data['totalMarks']}/${data['maxTotalMarks']}',
                  Icons.assignment,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildPerformanceCard(
                  'Percentage',
                  '${data['percentage']}%',
                  Icons.percent,
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Grade',
                  data['overallGrade'],
                  Icons.grade,
                  Colors.orange,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildPerformanceCard(
                  'Class Rank',
                  '#${data['rank']}',
                  Icons.emoji_events,
                  Colors.purple,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Attendance',
                  '${data['attendance']}%',
                  Icons.check_circle,
                  Colors.teal,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(child: Container()), // Empty space for alignment
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppThemeResponsiveness.getIconSize(context)),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    final subjects = _currentPerformanceData!['subjects'] as List<dynamic>;

    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject-wise Performance',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ...subjects.map((subject) => _buildSubjectRow(subject)).toList(),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(Map<String, dynamic> subject) {
    final percentage = (subject['marks'] / subject['maxMarks'] * 100);
    Color gradeColor = _getGradeColor(subject['grade']);

    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject['name'],
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gradeColor.withOpacity(0.3)),
                ),
                child: Text(
                  subject['grade'],
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: gradeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${subject['marks']}/${subject['maxMarks']}',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A+':
        return Colors.green.shade700;
      case 'A':
      case 'A-':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.blue;
      case 'B-':
        return Colors.orange;
      case 'C+':
      case 'C':
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  Widget _buildProgressChart() {
    final monthlyProgress = _currentPerformanceData!['monthlyProgress'] as List<dynamic>;

    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Progress Trend',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyProgress.length) {
                          return Text(
                            monthlyProgress[value.toInt()]['month'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _buildProgressSpots(),
                    isCurved: true,
                    color: AppThemeColor.primaryBlue,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppThemeColor.primaryBlue.withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
                minY: 60,
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildProgressSpots() {
    final monthlyProgress = _currentPerformanceData!['monthlyProgress'] as List<dynamic>;
    List<FlSpot> spots = [];

    for (int i = 0; i < monthlyProgress.length; i++) {
      final data = monthlyProgress[i] as Map<String, dynamic>;
      spots.add(FlSpot(
        i.toDouble(),
        (data['percentage'] as int).toDouble(),
      ));
    }

    return spots;
  }

  Widget _buildPerformanceDistribution() {
    final subjects = _currentPerformanceData!['subjects'] as List<dynamic>;

    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Distribution',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildPieChartSections(subjects),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildPieChartLegend(subjects),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(List<dynamic> subjects) {
    List<Color> pieColors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
      Colors.teal.shade300,
    ];
    double totalMarksObtained = 0;
    for (var subject in subjects) {
      totalMarksObtained += (subject['marks'] as int);
    }

    return List.generate(subjects.length, (i) {
      final subject = subjects[i];
      final double percentage = (subject['marks'] / totalMarksObtained) * 100;
      final Color color = pieColors[i % pieColors.length];

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppThemeColor.white,
        ),
      );
    });
  }

  Widget _buildPieChartLegend(List<dynamic> subjects) {
    List<Color> pieColors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
      Colors.teal.shade300,
    ];

    return Wrap(
      spacing: AppThemeResponsiveness.getSmallSpacing(context),
      runSpacing: AppThemeResponsiveness.getSmallSpacing(context),
      children: List.generate(subjects.length, (i) {
        final subject = subjects[i];
        final Color color = pieColors[i % pieColors.length];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: color,
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            Text(
              subject['name'],
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }
}