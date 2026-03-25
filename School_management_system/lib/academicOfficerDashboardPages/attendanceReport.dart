import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/services/api_services.dart';
import 'package:school/customWidgets/snackBar.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  bool _isLoading = true;
  final ApiService _apiService = ApiService();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _selectedReportType = 'students'; // 'students' or 'teachers'
  List<Map<String, dynamic>> _reportData = [];

  // Safe division helper to prevent NaN errors
  double _safeDivide(num a, num b) {
    if (b == 0 || a.isNaN || b.isNaN) return 0.0;
    return a / b;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Fetch monthly report from API
      final response = _selectedReportType == 'students'
          ? await _apiService.getStudentMonthlyReport(
              month: _selectedMonth,
              year: _selectedYear,
            )
          : await _apiService.getTeacherMonthlyReport(
              month: _selectedMonth,
              year: _selectedYear,
            );

      if (response.success && response.data != null) {
        setState(() {
          _reportData = response.data!;
        });
      } else {
        throw Exception(response.message ?? 'Failed to load report');
      }
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error loading attendance report: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(color: AppThemeColor.white),
          )
              : SingleChildScrollView(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Attendance Report',
                  icon: Icons.analytics,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildFilters(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                if (_reportData.isNotEmpty) ...[                  _buildOverviewStats(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildAttendanceCharts(),
                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                  _buildMonthlyReportTable(),
                ] else
                  Container(
                    padding: AppThemeResponsiveness.getCardPadding(context),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.info_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No attendance data available',
                            style: AppThemeResponsiveness.getSubHeadingStyle(context),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Select filters and click "Generate Report" to view data',
                            style: AppThemeResponsiveness.getBodyTextStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

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
            'Report Filters',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Report Type', style: AppThemeResponsiveness.getBodyTextStyle(context)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedReportType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        DropdownMenuItem(value: 'students', child: Text('Students')),
                        DropdownMenuItem(value: 'teachers', child: Text('Teachers')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedReportType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Month', style: AppThemeResponsiveness.getBodyTextStyle(context)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _selectedMonth,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(months[index]),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Year', style: AppThemeResponsiveness.getBodyTextStyle(context)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _selectedYear,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: List.generate(5, (index) {
                        final year = DateTime.now().year - index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loadData,
              icon: Icon(Icons.search),
              label: Text('Generate Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColor.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyReportTable() {
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
            'Monthly Attendance Report',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                AppThemeColor.primaryBlue.withOpacity(0.1),
              ),
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Present', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                DataColumn(label: Text('Absent', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                DataColumn(label: Text('Leave', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                DataColumn(label: Text('Attendance %', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              ],
              rows: _reportData.map((record) {
                final idKey = _selectedReportType == 'students' ? 'student__id' : 'teacher__id';
                final nameKey = _selectedReportType == 'students' 
                    ? 'student__user__full_name' 
                    : 'teacher__user__full_name';
                final present = (record['present'] ?? 0) as int;
                final total = (record['total'] ?? 1) as int;
                final percentageValue = _safeDivide(present, total) * 100;
                final percentage = percentageValue.toStringAsFixed(1);
                final color = percentageValue >= 90 
                    ? Colors.green 
                    : percentageValue >= 75 
                        ? Colors.orange 
                        : Colors.red;

                return DataRow(
                  cells: [
                    DataCell(Text(record[idKey]?.toString() ?? 'N/A')),
                    DataCell(
                      Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          record[nameKey]?.toString() ?? 'N/A',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(
                      record['present']?.toString() ?? '0',
                      style: TextStyle(color: Colors.green),
                    )),
                    DataCell(Text(
                      record['absent']?.toString() ?? '0',
                      style: TextStyle(color: Colors.red),
                    )),
                    DataCell(Text(
                      record['leave']?.toString() ?? '0',
                      style: TextStyle(color: Colors.orange),
                    )),
                    DataCell(Text(
                      record['total']?.toString() ?? '0',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$percentage%',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Calculate aggregate statistics from API data
  Map<String, int> _calculateStats() {
    int totalPresent = 0;
    int totalAbsent = 0;
    int totalLeave = 0;
    int totalRecords = _reportData.length;

    for (var record in _reportData) {
      totalPresent += (record['present'] ?? 0) as int;
      totalAbsent += (record['absent'] ?? 0) as int;
      totalLeave += (record['leave'] ?? 0) as int;
    }

    return {
      'totalPresent': totalPresent,
      'totalAbsent': totalAbsent,
      'totalLeave': totalLeave,
      'totalRecords': totalRecords,
      'avgAttendance': totalRecords > 0 
          ? (_safeDivide(totalPresent, (totalPresent + totalAbsent + totalLeave)) * 100).round() 
          : 0,
    };
  }

  Widget _buildOverviewStats() {
    final stats = _calculateStats();
    final avgAttendance = stats['avgAttendance']!;

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
            'Overall Statistics',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total ${_selectedReportType == "students" ? "Students" : "Teachers"}',
                  stats['totalRecords'].toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildStatCard(
                  'Avg Attendance',
                  '$avgAttendance%',
                  Icons.trending_up,
                  avgAttendance >= 90 ? Colors.green : avgAttendance >= 75 ? Colors.orange : Colors.red,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildStatCard(
                  'Total Present',
                  stats['totalPresent'].toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildStatCard(
                  'Total Absent',
                  stats['totalAbsent'].toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
            style: AppThemeResponsiveness.getBodyTextStyle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 20),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCharts() {
    final stats = _calculateStats();
    final totalPresent = stats['totalPresent']!;
    final totalAbsent = stats['totalAbsent']!;
    final totalLeave = stats['totalLeave']!;
    final totalDays = totalPresent + totalAbsent + totalLeave;

    if (totalDays == 0) return SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
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
                  'Attendance Distribution',
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: totalPresent.toDouble(),
                          title: '${(_safeDivide(totalPresent, totalDays) * 100).round()}%',
                          color: Colors.green,
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: totalAbsent.toDouble(),
                          title: '${(_safeDivide(totalAbsent, totalDays) * 100).round()}%',
                          color: Colors.red,
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: totalLeave.toDouble(),
                          title: '${(_safeDivide(totalLeave, totalDays) * 100).round()}%',
                          color: Colors.orange,
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      centerSpaceRadius: 50,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem('Present', Colors.green, totalPresent),
                    _buildLegendItem('Absent', Colors.red, totalAbsent),
                    _buildLegendItem('Leave', Colors.orange, totalLeave),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
        Expanded(
          child: Container(
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
                  'Top & Bottom Performers',
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                SizedBox(
                  height: 250,
                  child: _buildPerformanceChart(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart() {
    // Sort by attendance percentage
    final sortedData = List<Map<String, dynamic>>.from(_reportData);
    sortedData.sort((a, b) {
      final aPresent = (a['present'] ?? 0) as int;
      final aTotal = (a['total'] ?? 1) as int;
      final bPresent = (b['present'] ?? 0) as int;
      final bTotal = (b['total'] ?? 1) as int;
      
      final aPercentage = _safeDivide(aPresent, aTotal) * 100;
      final bPercentage = _safeDivide(bPresent, bTotal) * 100;
      
      return bPercentage.compareTo(aPercentage);
    });

    // Take top 5 and bottom 5
    final top5 = sortedData.take(5).toList();
    final bottom5 = sortedData.length > 5 ? sortedData.skip(sortedData.length - 5).toList().reversed.toList() : [];
    final displayData = [...top5, ...bottom5];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < displayData.length) {
                  final nameKey = _selectedReportType == 'students' 
                      ? 'student__user__full_name' 
                      : 'teacher__user__full_name';
                  final name = displayData[value.toInt()][nameKey]?.toString() ?? 'N/A';
                  final firstName = name.split(' ').first;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      firstName.length > 8 ? '${firstName.substring(0, 8)}...' : firstName,
                      style: TextStyle(fontSize: 10),
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
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(displayData.length, (index) {
          final record = displayData[index];
          final present = (record['present'] ?? 0) as int;
          final total = (record['total'] ?? 1) as int;
          final percentage = _safeDivide(present, total) * 100;
          
          final color = percentage >= 90 
              ? Colors.green 
              : percentage >= 75 
                  ? Colors.orange 
                  : Colors.red;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: percentage,
                color: color,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontSize: 12,
          ),
        ),
        Text(
          count.toString(),
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
