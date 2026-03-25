import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/services/api_services.dart';

class AdminReportsAnalytics extends StatefulWidget {
  const AdminReportsAnalytics({Key? key}) : super(key: key);

  @override
  State<AdminReportsAnalytics> createState() => _AdminReportsAnalyticsState();
}

class _AdminReportsAnalyticsState extends State<AdminReportsAnalytics>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String _selectedTimeRange = 'This Month';
  String _selectedClass = 'All Classes';
  
  // API Service
  final ApiService _apiService = ApiService();
  
  // API Data
  OverviewReport? _overviewData;
  AcademicReport? _academicData;
  FinancialReport? _financialData;
  EnrollmentReport? _enrollmentData;
  TeachersReport? _teachersData;
  
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Fetch all reports in parallel
      final results = await Future.wait([
        _apiService.fetchOverviewReport(),
        _apiService.fetchAcademicReport(),
        _apiService.fetchFinancialReport(),
        _apiService.fetchEnrollmentReport(),
        _apiService.fetchTeachersReport(),
      ]);
      
      setState(() {
        _overviewData = results[0] as OverviewReport;
        _academicData = results[1] as AcademicReport;
        _financialData = results[2] as FinancialReport;
        _enrollmentData = results[3] as EnrollmentReport;
        _teachersData = results[4] as TeachersReport;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reports: $e';
        _isLoading = false;
      });
      print('Error loading reports: $e');
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
              : _errorMessage != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppThemeColor.white),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
                  child: Text(
                    _errorMessage!,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: AppThemeColor.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                ElevatedButton(
                  onPressed: _loadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeColor.white,
                    foregroundColor: AppThemeColor.primaryBlue,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
              : Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                child: Column(
                  children: [
                    HeaderSection(
                      title: 'Reports & Analytics',
                      icon: Icons.analytics_outlined,
                    ),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    _buildFilterSection(),
                  ],
                ),
              ),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildAcademicTab(),
                    _buildFinancialTab(),
                    _buildEnrollmentTab(),
                    _buildTeacherTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownFilter(
              'Time Range',
              _selectedTimeRange,
              ['Today', 'This Week', 'This Month', 'This Year'],
                  (value) => setState(() => _selectedTimeRange = value!),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: _buildDropdownFilter(
              'Class/Grade',
              _selectedClass,
              ['All Classes', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6'],
                  (value) => setState(() => _selectedClass = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(
      String label,
      String value,
      List<String> items,
      void Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getMediumSpacing(context),
              vertical: AppThemeResponsiveness.getSmallSpacing(context),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppThemeColor.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppThemeColor.primaryBlue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppThemeColor.primaryBlue,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Academic'),
          Tab(text: 'Financial'),
          Tab(text: 'Enrollment'),
          Tab(text: 'Teachers'),
        ],
      ),
    );
  }

  // ==================== OVERVIEW TAB ====================
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildOverviewStats(),
        ],
      ),
    );
  }

  Widget _buildOverviewStats() {
    if (_overviewData == null) {
      return const SizedBox.shrink();
    }

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
            'School Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            crossAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
mainAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
            children: [
              _buildOverviewCard('Total Students', _overviewData!.totalStudents.toString(), Icons.school, Colors.blue),
              _buildOverviewCard('Total Teachers', _overviewData!.totalTeachers.toString(), Icons.person, Colors.green),
              _buildOverviewCard('Total Employees', _overviewData!.totalEmployees.toString(), Icons.business_center, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 200,
      ),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 20),
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==================== ACADEMIC TAB ====================
  Widget _buildAcademicTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildClassStrengthChart(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildAcademicSummary(),
        ],
      ),
    );
  }

  Widget _buildClassStrengthChart() {
    if (_academicData == null || _academicData!.classStrength.isEmpty) {
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
        child: Center(
          child: Text(
            'No class strength data available',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
        ),
      );
    }

    final classStrength = _academicData!.classStrength;
    final maxCount = classStrength.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble();

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
            'Class Strength',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount + 10,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < classStrength.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              classStrength[value.toInt()].className,
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
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
                          value.toInt().toString(),
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                barGroups: List.generate(
                  classStrength.length,
                      (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: classStrength[index].count.toDouble(),
                        color: AppThemeColor.primaryBlue,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicSummary() {
    if (_academicData == null || _academicData!.classStrength.isEmpty) {
      return const SizedBox.shrink();
    }

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
            'Academic Summary',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            'Total Classes: ${_academicData!.classStrength.length}',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Total Students: ${_academicData!.classStrength.fold(0, (sum, item) => sum + item.count)}',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
        ],
      ),
    );
  }

  // ==================== FINANCIAL TAB ====================
  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildFinancialSalarySummary(),
        ],
      ),
    );
  }

  Widget _buildFinancialSalarySummary() {
    if (_financialData == null) {
      return const SizedBox.shrink();
    }

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
            'Financial Summary',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          
          // Teacher Salary Section
          _buildSalarySection(
            'Teacher Salary',
            _financialData!.teacherSalary,
            Colors.blue,
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          
          // Employee Salary Section
          _buildSalarySection(
            'Employee Salary',
            _financialData!.employeeSalary,
            Colors.green,
          ),
          
          // Note Section
          if (_financialData!.note.isNotEmpty) ...[
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                  Expanded(
                    child: Text(
                      _financialData!.note,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.amber[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSalarySection(String title, SalaryInfo salaryInfo, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Row(
          children: [
            Expanded(
              child: _buildFinancialCard(
                'Paid',
                '₹${salaryInfo.paid}',
                Colors.green,
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: _buildFinancialCard(
                'Unpaid',
                '₹${salaryInfo.unpaid}',
                Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialCard(String label, String amount, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            amount,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ENROLLMENT TAB ====================
  Widget _buildEnrollmentTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildEnrollmentOverview(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildEnrollmentSummaryChart(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildGenderDistribution(),
        ],
      ),
    );
  }

  Widget _buildEnrollmentOverview() {
    if (_enrollmentData == null) {
      return const SizedBox.shrink();
    }

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
            'Enrollment Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildEnrollmentCard(
                  'Total Applications',
                  _enrollmentData!.totalApplications.toString(),
                  Icons.apps,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: _buildEnrollmentCard(
                  'Submitted',
                  _enrollmentData!.submittedApplications.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: _buildEnrollmentCard(
                  'Paid',
                  _enrollmentData!.paidApplications.toString(),
                  Icons.payment,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentSummaryChart() {
    if (_enrollmentData == null || _enrollmentData!.enrollmentSummary.isEmpty) {
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
        child: Center(
          child: Text(
            'No enrollment summary data available',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
        ),
      );
    }

    final summary = _enrollmentData!.enrollmentSummary;

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
            'Enrollment by Class',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ...summary.map((item) => Padding(
            padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.className,
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppThemeColor.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.count.toString(),
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: AppThemeColor.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildGenderDistribution() {
    if (_enrollmentData == null || _enrollmentData!.genderDistribution.isEmpty) {
      return const SizedBox.shrink();
    }

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
            'Gender Distribution',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ..._enrollmentData!.genderDistribution.entries.map((entry) => Padding(
            padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.value.toString(),
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  // ==================== TEACHERS TAB ====================
  Widget _buildTeacherTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildTeacherOverview(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildTeacherSalaryInfo(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildTeacherDetails(),
        ],
      ),
    );
  }

  Widget _buildTeacherOverview() {
    if (_teachersData == null) {
      return const SizedBox.shrink();
    }

    final summary = _teachersData!.summary;

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
            'Teacher Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            crossAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
            mainAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
            children: [
              _buildTeacherCard(
                'Total Teachers',
                summary.totalTeachers.toString(),
                Icons.people,
                Colors.blue,
              ),
              _buildTeacherCard(
                'Active Teachers',
                summary.activeTeachers.toString(),
                Icons.check_circle,
                Colors.green,
              ),
              _buildTeacherCard(
                'Verified Teachers',
                summary.verifiedTeachers.toString(),
                Icons.verified,
                Colors.purple,
              ),
              _buildTeacherCard(
                'Suspended',
                summary.suspendedTeachers.toString(),
                Icons.block,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherSalaryInfo() {
    if (_teachersData == null) {
      return const SizedBox.shrink();
    }

    final salary = _teachersData!.salarySummary;

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
            'Salary Summary',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildFinancialCard(
                  'Total Paid',
                  '₹${salary.totalSalaryPaid}',
                  Colors.green,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: _buildFinancialCard(
                  'Total Unpaid',
                  '₹${salary.totalSalaryUnpaid}',
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherDetails() {
    if (_teachersData == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Subject-wise Teachers
        if (_teachersData!.subjectWiseTeachers.isNotEmpty)
          _buildTeacherDetailCard(
            'Subject-wise Distribution',
            _teachersData!.subjectWiseTeachers,
            Colors.blue,
          ),
        
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        
        // Designation-wise Teachers
        if (_teachersData!.designationWiseTeachers.isNotEmpty)
          _buildTeacherDetailCard(
            'Designation-wise Distribution',
            _teachersData!.designationWiseTeachers,
            Colors.green,
          ),
        
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        
        // Gender-wise Teachers
        if (_teachersData!.genderWiseTeachers.isNotEmpty)
          _buildTeacherDetailCard(
            'Gender-wise Distribution',
            _teachersData!.genderWiseTeachers,
            Colors.purple,
          ),
      ],
    );
  }

  Widget _buildTeacherDetailCard(String title, List<Map<String, dynamic>> data, Color color) {
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
            title,
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ...data.map((item) {
            final key = item.keys.first;
            final value = item[key];
            return Padding(
              padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    key,
                    style: AppThemeResponsiveness.getBodyTextStyle(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value.toString(),
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
