import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class StudentAttendanceReport extends StatefulWidget {
  const StudentAttendanceReport({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceReport> createState() => _StudentAttendanceReportState();
}

class _StudentAttendanceReportState extends State<StudentAttendanceReport> {
  bool _isLoading = false;
  String? _selectedMonth;
  bool _showAttendance = false;

  // Current student data (would typically come from user session/authentication)
  final Map<String, String> _currentStudent = {
    'id': '1',
    'name': 'Emma Johnson',
    'class': '10 A',
    'roll': '15',
    'studentId': 'STU001',
  };

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Student's attendance data
  final Map<String, Map<String, dynamic>> _attendanceData = {
    'January': {
      'totalDays': 22,
      'presentDays': 20,
      'absentDays': 2,
      'lateArrivals': 1,
      'earlyDepartures': 0,
      'percentage': 90.9,
      'dailyAttendance': [
        {'date': '1', 'status': 'present'},
        {'date': '2', 'status': 'present'},
        {'date': '3', 'status': 'absent'},
        {'date': '4', 'status': 'present'},
        {'date': '5', 'status': 'present'},
        {'date': '6', 'status': 'present'},
        {'date': '7', 'status': 'present'},
        {'date': '8', 'status': 'late'},
        {'date': '9', 'status': 'present'},
        {'date': '10', 'status': 'present'},
        {'date': '11', 'status': 'present'},
        {'date': '12', 'status': 'present'},
        {'date': '13', 'status': 'present'},
        {'date': '14', 'status': 'present'},
        {'date': '15', 'status': 'absent'},
        {'date': '16', 'status': 'present'},
        {'date': '17', 'status': 'present'},
        {'date': '18', 'status': 'present'},
        {'date': '19', 'status': 'present'},
        {'date': '20', 'status': 'present'},
        {'date': '21', 'status': 'present'},
        {'date': '22', 'status': 'present'},
      ],
      'weeklyTrend': [
        {'week': 'Week 1', 'percentage': 100},
        {'week': 'Week 2', 'percentage': 85},
        {'week': 'Week 3', 'percentage': 90},
        {'week': 'Week 4', 'percentage': 95},
      ],
      'subjectWiseAttendance': [
        {'subject': 'Mathematics', 'present': 18, 'total': 22, 'percentage': 81.8},
        {'subject': 'English', 'present': 20, 'total': 22, 'percentage': 90.9},
        {'subject': 'Science', 'present': 19, 'total': 22, 'percentage': 86.4},
        {'subject': 'History', 'present': 21, 'total': 22, 'percentage': 95.5},
        {'subject': 'Geography', 'present': 20, 'total': 22, 'percentage': 90.9},
      ],
    },
    'February': {
      'totalDays': 20,
      'presentDays': 19,
      'absentDays': 1,
      'lateArrivals': 0,
      'earlyDepartures': 1,
      'percentage': 95.0,
      'dailyAttendance': [
        {'date': '1', 'status': 'present'},
        {'date': '2', 'status': 'present'},
        {'date': '3', 'status': 'present'},
        {'date': '4', 'status': 'present'},
        {'date': '5', 'status': 'present'},
        {'date': '6', 'status': 'present'},
        {'date': '7', 'status': 'present'},
        {'date': '8', 'status': 'present'},
        {'date': '9', 'status': 'present'},
        {'date': '10', 'status': 'absent'},
        {'date': '11', 'status': 'present'},
        {'date': '12', 'status': 'present'},
        {'date': '13', 'status': 'present'},
        {'date': '14', 'status': 'present'},
        {'date': '15', 'status': 'early'},
        {'date': '16', 'status': 'present'},
        {'date': '17', 'status': 'present'},
        {'date': '18', 'status': 'present'},
        {'date': '19', 'status': 'present'},
        {'date': '20', 'status': 'present'},
      ],
      'weeklyTrend': [
        {'week': 'Week 1', 'percentage': 100},
        {'week': 'Week 2', 'percentage': 90},
        {'week': 'Week 3', 'percentage': 95},
        {'week': 'Week 4', 'percentage': 100},
      ],
      'subjectWiseAttendance': [
        {'subject': 'Mathematics', 'present': 19, 'total': 20, 'percentage': 95.0},
        {'subject': 'English', 'present': 20, 'total': 20, 'percentage': 100.0},
        {'subject': 'Science', 'present': 18, 'total': 20, 'percentage': 90.0},
        {'subject': 'History', 'present': 19, 'total': 20, 'percentage': 95.0},
        {'subject': 'Geography', 'present': 20, 'total': 20, 'percentage': 100.0},
      ],
    },
    'March': {
      'totalDays': 21,
      'presentDays': 18,
      'absentDays': 3,
      'lateArrivals': 2,
      'earlyDepartures': 1,
      'percentage': 85.7,
      'dailyAttendance': [
        {'date': '1', 'status': 'present'},
        {'date': '2', 'status': 'present'},
        {'date': '3', 'status': 'absent'},
        {'date': '4', 'status': 'present'},
        {'date': '5', 'status': 'late'},
        {'date': '6', 'status': 'present'},
        {'date': '7', 'status': 'present'},
        {'date': '8', 'status': 'present'},
        {'date': '9', 'status': 'absent'},
        {'date': '10', 'status': 'present'},
        {'date': '11', 'status': 'present'},
        {'date': '12', 'status': 'late'},
        {'date': '13', 'status': 'present'},
        {'date': '14', 'status': 'present'},
        {'date': '15', 'status': 'early'},
        {'date': '16', 'status': 'present'},
        {'date': '17', 'status': 'absent'},
        {'date': '18', 'status': 'present'},
        {'date': '19', 'status': 'present'},
        {'date': '20', 'status': 'present'},
        {'date': '21', 'status': 'present'},
      ],
      'weeklyTrend': [
        {'week': 'Week 1', 'percentage': 85},
        {'week': 'Week 2', 'percentage': 80},
        {'week': 'Week 3', 'percentage': 90},
        {'week': 'Week 4', 'percentage': 88},
      ],
      'subjectWiseAttendance': [
        {'subject': 'Mathematics', 'present': 17, 'total': 21, 'percentage': 81.0},
        {'subject': 'English', 'present': 19, 'total': 21, 'percentage': 90.5},
        {'subject': 'Science', 'present': 18, 'total': 21, 'percentage': 85.7},
        {'subject': 'History', 'present': 20, 'total': 21, 'percentage': 95.2},
        {'subject': 'Geography', 'present': 18, 'total': 21, 'percentage': 85.7},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months.first;
  }

  Future<void> _loadAttendanceData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _showAttendance = true;
    });
  }

  void _onViewReportPressed() {
    if (_selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a month'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _loadAttendanceData();
  }

  Map<String, dynamic>? get _currentAttendanceData {
    if (_selectedMonth == null) return null;
    return _attendanceData[_selectedMonth!];
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
                  title: 'My Attendance Report',
                  icon: Icons.assessment,
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildStudentProfile(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildMonthSelector(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildViewReportButton(),
                if (_isLoading) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 2),
                  const Center(
                    child: CircularProgressIndicator(color: AppThemeColor.white),
                  ),
                ] else if (_showAttendance && _currentAttendanceData != null) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildAttendanceOverview(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildAttendanceSummary(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildWeeklyTrendChart(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildSubjectWiseAttendance(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildDailyAttendanceCalendar(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildAttendanceGoals(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentProfile() {
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
            radius: 35,
            backgroundColor: AppThemeColor.primaryBlue.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 35,
              color: AppThemeColor.primaryBlue,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentStudent['name']!,
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 20),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  'Class: ${_currentStudent['class']} | Roll: ${_currentStudent['roll']}',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Student ID: ${_currentStudent['studentId']}',
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

  Widget _buildMonthSelector() {
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
            'Select Month',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getMediumSpacing(context)),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMonth,
                isExpanded: true,
                items: _months.map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month, style: AppThemeResponsiveness.getBodyTextStyle(context)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value;
                    _showAttendance = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewReportButton(){
    return
    SecondaryButton(
      title: 'View My Report',
      icon: Icon(Icons.assessment),
      onPressed: _onViewReportPressed,
      color: AppThemeColor.grey600,
    );
  }

  Widget _buildAttendanceOverview() {
    final data = _currentAttendanceData!;
    final percentage = data['percentage'] as double;

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Overview - $_selectedMonth',
                style: AppThemeResponsiveness.getHeadingStyle(context),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                decoration: BoxDecoration(
                  color: _getAttendanceColor(percentage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    color: _getAttendanceColor(percentage),
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(_getAttendanceColor(percentage)),
            minHeight: 10,
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildAttendanceMessage(percentage),
        ],
      ),
    );
  }

  Widget _buildAttendanceMessage(double percentage) {
    String message;
    IconData icon;
    Color color;

    if (percentage >= 95) {
      message = "Excellent! You're doing great! 🌟";
      icon = Icons.star;
      color = Colors.green;
    } else if (percentage >= 90) {
      message = "Good work! Keep it up! 👍";
      icon = Icons.thumb_up;
      color = Colors.green;
    } else if (percentage >= 80) {
      message = "You can do better! Try to improve! 💪";
      icon = Icons.trending_up;
      color = Colors.orange;
    } else {
      message = "Need to focus on attendance! 📚";
      icon = Icons.warning;
      color = Colors.red;
    }

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Text(
              message,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    final data = _currentAttendanceData!;

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
            'Attendance Summary',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Days',
                  '${data['totalDays']}',
                  Icons.calendar_month,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildSummaryCard(
                  'Present',
                  '${data['presentDays']}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Absent',
                  '${data['absentDays']}',
                  Icons.cancel,
                  Colors.red,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildSummaryCard(
                  'Late',
                  '${data['lateArrivals']}',
                  Icons.access_time,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
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
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendChart() {
    final weeklyTrend = _currentAttendanceData!['weeklyTrend'] as List<dynamic>;

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
            'Weekly Attendance Trend',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < weeklyTrend.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              weeklyTrend[value.toInt()]['week'].toString().replaceAll('Week ', 'W'),
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 12),
                            ),
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
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: weeklyTrend.length.toDouble() - 1,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyTrend.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['percentage'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: AppThemeColor.primaryBlue,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppThemeColor.primaryBlue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectWiseAttendance() {
    final subjectData = _currentAttendanceData!['subjectWiseAttendance'] as List<dynamic>;

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
            'Subject-wise Attendance',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ...subjectData.map((subject) => _buildSubjectAttendanceItem(subject)),
        ],
      ),
    );
  }

  Widget _buildSubjectAttendanceItem(Map<String, dynamic> subject) {
    final percentage = subject['percentage'] as double;

    return Container(
        margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(
          subject['subject'],
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
        '${subject['present']}/${subject['total']} (${percentage.toStringAsFixed(1)}%)',
    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
    color: Colors.green,
        ),
    ),
    ],
    ),
    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
    LinearProgressIndicator(
    value: percentage / 100,
    backgroundColor: Colors.grey.shade300,
    valueColor: AlwaysStoppedAnimation<Color>(_getAttendanceColor(percentage)),
    minHeight: 8,
    ),
    ],
    ),
    );
  }

  Widget _buildDailyAttendanceCalendar() {
    final dailyData = _currentAttendanceData!['dailyAttendance'] as List<dynamic>;
    final totalDays = _currentAttendanceData!['totalDays'] as int;

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
            'Daily Attendance Calendar',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildAttendanceLegend(),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: totalDays,
            itemBuilder: (context, index) {
              final dayData = dailyData[index];
              return _buildDayCell(dayData);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Present', Colors.green, Icons.check_circle),
        _buildLegendItem('Absent', Colors.red, Icons.cancel),
        _buildLegendItem('Late', Colors.orange, Icons.access_time),
        _buildLegendItem('Early', Colors.blue, Icons.schedule),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(height: 4),
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(Map<String, dynamic> dayData) {
    final status = dayData['status'] as String;
    final date = dayData['date'] as String;

    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'present':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'absent':
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red;
        icon = Icons.cancel;
        break;
      case 'late':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        icon = Icons.access_time;
        break;
      case 'early':
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue;
        icon = Icons.schedule;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 16),
          SizedBox(height: 2),
          Text(
            date,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceGoals() {
    final currentPercentage = _currentAttendanceData!['percentage'] as double;
    final totalDays = _currentAttendanceData!['totalDays'] as int;
    final presentDays = _currentAttendanceData!['presentDays'] as int;

    // Calculate days needed to reach 95% attendance
    final daysNeededFor95 = _calculateDaysNeededForTarget(95, totalDays, presentDays);
    final daysNeededFor90 = _calculateDaysNeededForTarget(90, totalDays, presentDays);

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
            'Attendance Goals',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          if (currentPercentage < 95) ...[
            _buildGoalCard(
              'Target: 95% Attendance',
              'Attend $daysNeededFor95 more consecutive days',
              Icons.star,
              Colors.green,
              currentPercentage >= 95,
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ],
          if (currentPercentage < 90) ...[
            _buildGoalCard(
              'Target: 90% Attendance',
              'Attend $daysNeededFor90 more consecutive days',
              Icons.thumb_up,
              Colors.blue,
              currentPercentage >= 90,
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ],
          _buildGoalCard(
            'Current Status',
            'You have ${currentPercentage.toStringAsFixed(1)}% attendance',
            Icons.assessment,
            _getAttendanceColor(currentPercentage),
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(String title, String description, IconData icon, Color color, bool isAchieved) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isAchieved ? Icons.check_circle : icon,
            color: color,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  description,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 95) return Colors.green;
    if (percentage >= 90) return Colors.blue;
    if (percentage >= 80) return Colors.orange;
    return Colors.red;
  }

  int _calculateDaysNeededForTarget(double targetPercentage, int totalDays, int presentDays) {
    // Calculate how many consecutive days of attendance are needed to reach target percentage
    // Formula: (presentDays + x) / (totalDays + x) = targetPercentage / 100
    // Solving for x: x = (targetPercentage * totalDays - 100 * presentDays) / (100 - targetPercentage)

    final currentPercentage = (presentDays / totalDays) * 100;
    if (currentPercentage >= targetPercentage) return 0;

    final numerator = (targetPercentage * totalDays) - (100 * presentDays);
    final denominator = 100 - targetPercentage;

    if (denominator == 0) return 0;

    final daysNeeded = (numerator / denominator).ceil();
    return daysNeeded > 0 ? daysNeeded : 0;
  }
}
