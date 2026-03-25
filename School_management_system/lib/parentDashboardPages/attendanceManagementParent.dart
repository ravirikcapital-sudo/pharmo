import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class StudentAttendance extends StatefulWidget {
  const StudentAttendance({Key? key}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  bool _isLoading = false;
  String? _selectedStudentId;
  String? _selectedMonth;
  bool _showAttendance = false;

  // Sample students data
  final List<Map<String, String>> _students = [
    {'id': '1', 'name': 'Emma Johnson', 'class': '10 A', 'roll': '15'},
    {'id': '2', 'name': 'Jake Johnson', 'class': '7 B', 'roll': '23'},
    {'id': '3', 'name': 'Sophia Williams', 'class': '9 C', 'roll': '08'},
    {'id': '4', 'name': 'Michael Brown', 'class': '8 A', 'roll': '12'},
  ];

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Attendance data for students
  Map<String, Map<String, dynamic>> _attendanceData = {
    '1': {
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
      },
    },
    '2': {
      'January': {
        'totalDays': 22,
        'presentDays': 18,
        'absentDays': 4,
        'lateArrivals': 2,
        'earlyDepartures': 1,
        'percentage': 81.8,
        'dailyAttendance': [
          {'date': '1', 'status': 'present'},
          {'date': '2', 'status': 'absent'},
          {'date': '3', 'status': 'present'},
          {'date': '4', 'status': 'late'},
          {'date': '5', 'status': 'present'},
          {'date': '6', 'status': 'present'},
          {'date': '7', 'status': 'absent'},
          {'date': '8', 'status': 'present'},
          {'date': '9', 'status': 'present'},
          {'date': '10', 'status': 'present'},
          {'date': '11', 'status': 'present'},
          {'date': '12', 'status': 'absent'},
          {'date': '13', 'status': 'present'},
          {'date': '14', 'status': 'late'},
          {'date': '15', 'status': 'present'},
          {'date': '16', 'status': 'present'},
          {'date': '17', 'status': 'early'},
          {'date': '18', 'status': 'present'},
          {'date': '19', 'status': 'present'},
          {'date': '20', 'status': 'absent'},
          {'date': '21', 'status': 'present'},
          {'date': '22', 'status': 'present'},
        ],
        'weeklyTrend': [
          {'week': 'Week 1', 'percentage': 85},
          {'week': 'Week 2', 'percentage': 80},
          {'week': 'Week 3', 'percentage': 85},
          {'week': 'Week 4', 'percentage': 75},
        ],
      },
    },
    '3': {
      'January': {
        'totalDays': 22,
        'presentDays': 21,
        'absentDays': 1,
        'lateArrivals': 0,
        'earlyDepartures': 0,
        'percentage': 95.5,
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
          {'date': '10', 'status': 'present'},
          {'date': '11', 'status': 'absent'},
          {'date': '12', 'status': 'present'},
          {'date': '13', 'status': 'present'},
          {'date': '14', 'status': 'present'},
          {'date': '15', 'status': 'present'},
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
          {'week': 'Week 2', 'percentage': 90},
          {'week': 'Week 3', 'percentage': 100},
          {'week': 'Week 4', 'percentage': 100},
        ],
      },
    },
    '4': {
      'January': {
        'totalDays': 22,
        'presentDays': 16,
        'absentDays': 6,
        'lateArrivals': 3,
        'earlyDepartures': 2,
        'percentage': 72.7,
        'dailyAttendance': [
          {'date': '1', 'status': 'present'},
          {'date': '2', 'status': 'absent'},
          {'date': '3', 'status': 'late'},
          {'date': '4', 'status': 'present'},
          {'date': '5', 'status': 'absent'},
          {'date': '6', 'status': 'present'},
          {'date': '7', 'status': 'absent'},
          {'date': '8', 'status': 'late'},
          {'date': '9', 'status': 'present'},
          {'date': '10', 'status': 'early'},
          {'date': '11', 'status': 'present'},
          {'date': '12', 'status': 'absent'},
          {'date': '13', 'status': 'present'},
          {'date': '14', 'status': 'late'},
          {'date': '15', 'status': 'absent'},
          {'date': '16', 'status': 'present'},
          {'date': '17', 'status': 'early'},
          {'date': '18', 'status': 'present'},
          {'date': '19', 'status': 'present'},
          {'date': '20', 'status': 'absent'},
          {'date': '21', 'status': 'present'},
          {'date': '22', 'status': 'present'},
        ],
        'weeklyTrend': [
          {'week': 'Week 1', 'percentage': 70},
          {'week': 'Week 2', 'percentage': 75},
          {'week': 'Week 3', 'percentage': 70},
          {'week': 'Week 4', 'percentage': 75},
        ],
      },
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
    if (_selectedStudentId == null || _selectedMonth == null) return null;
    return _attendanceData[_selectedStudentId!]?[_selectedMonth!];
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
                  title: 'Student Attendance',
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildDropdowns(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildCheckButton(),
                if (_isLoading) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 2),
                  const Center(
                    child: CircularProgressIndicator(color: AppThemeColor.white),
                  ),
                ] else if (_showAttendance && _currentAttendanceData != null) ...[
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildStudentInfo(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildAttendanceSummary(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildWeeklyTrendChart(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildDailyAttendanceCalendar(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildAttendanceStats(),
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
            'Select Student & Month',
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
                    _showAttendance = false;
                  });
                },
              ),
            ),
          ),

          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

          // Month Dropdown
          Text(
            'Month',
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
              'Check Attendance',
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
                  _selectedMonth!,
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
                child: _buildAttendanceCard(
                  'Total Days',
                  '${data['totalDays']}',
                  Icons.calendar_month,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildAttendanceCard(
                  'Present Days',
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
                child: _buildAttendanceCard(
                  'Absent Days',
                  '${data['absentDays']}',
                  Icons.cancel,
                  Colors.red,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildAttendanceCard(
                  'Percentage',
                  '${data['percentage']}%',
                  Icons.percent,
                  Colors.purple,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildAttendanceCard(
                  'Late Arrivals',
                  '${data['lateArrivals']}',
                  Icons.access_time,
                  Colors.orange,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildAttendanceCard(
                  'Early Departures',
                  '${data['earlyDepartures']}',
                  Icons.logout,
                  Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(String title, String value, IconData icon, Color color) {
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
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
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
                barGroups: _buildBarGroups(weeklyTrend),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<dynamic> weeklyTrend) {
    return List.generate(weeklyTrend.length, (index) {
      final percentage = weeklyTrend[index]['percentage'] as int;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: percentage.toDouble(),
            color: _getAttendanceColor(percentage.toDouble()),
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.orange;
    return Colors.red;
  }

  Widget _buildDailyAttendanceCalendar() {
    final dailyAttendance = _currentAttendanceData!['dailyAttendance'] as List<dynamic>;

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
            'Daily Attendance - $_selectedMonth',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildCalendarLegend(),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildCalendarGrid(dailyAttendance),
        ],
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Present', Colors.green),
        _buildLegendItem('Absent', Colors.red),
        _buildLegendItem('Late', Colors.orange),
        _buildLegendItem('Early', Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(List<dynamic> dailyAttendance) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: dailyAttendance.length,
      itemBuilder: (context, index) {
        final attendance = dailyAttendance[index];
        final date = attendance['date'] as String;
        final status = attendance['status'] as String;

        return Container(
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context) / 2),
            border: Border.all(
              color: _getStatusColor(status).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              date,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      case 'early':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAttendanceStats() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Statistics',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildProgressIndicator(percentage),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildAttendanceInsights(data),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Attendance',
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: _getAttendanceColor(percentage),
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
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
    );
  }

  Widget _buildAttendanceInsights(Map<String, dynamic> data) {
    final insights = _generateInsights(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        ...insights.map((insight) => Padding(
          padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                insight['icon'] as IconData,
                size: 16,
                color: insight['color'] as Color,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  insight['text'] as String,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  List<Map<String, dynamic>> _generateInsights(Map<String, dynamic> data) {
    final insights = <Map<String, dynamic>>[];
    final percentage = data['percentage'] as double;
    final lateArrivals = data['lateArrivals'] as int;
    final earlyDepartures = data['earlyDepartures'] as int;
    final absentDays = data['absentDays'] as int;

    if (percentage >= 95) {
      insights.add({
        'icon': Icons.star,
        'color': Colors.green,
        'text': 'Excellent attendance! Keep up the great work.',
      });
    } else if (percentage >= 90) {
      insights.add({
        'icon': Icons.thumb_up,
        'color': Colors.green,
        'text': 'Good attendance record. Well done!',
      });
    } else if (percentage >= 80) {
      insights.add({
        'icon': Icons.warning,
        'color': Colors.orange,
        'text': 'Attendance needs improvement. Try to be more regular.',
      });
    } else {
      insights.add({
        'icon': Icons.error,
        'color': Colors.red,
        'text': 'Poor attendance. Immediate attention required.',
      });
    }

    if (lateArrivals > 0) {
      insights.add({
        'icon': Icons.access_time,
        'color': Colors.orange,
        'text': '$lateArrivals late arrival${lateArrivals > 1 ? 's' : ''} this month.',
      });
    }

    if (earlyDepartures > 0) {
      insights.add({
        'icon': Icons.logout,
        'color': Colors.blue,
        'text': '$earlyDepartures early departure${earlyDepartures > 1 ? 's' : ''} this month.',
      });
    }

    if (absentDays == 0) {
      insights.add({
        'icon': Icons.celebration,
        'color': Colors.green,
        'text': 'Perfect attendance! No absent days.',
      });
    }

    return insights;
  }
}