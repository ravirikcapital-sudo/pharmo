import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/academicOfficerDashboardModel/classroomReportAcademicOfficer.dart';

class ClassroomReportsScreen extends StatefulWidget {
  @override
  _ClassroomReportsScreenState createState() => _ClassroomReportsScreenState();
}

class _ClassroomReportsScreenState extends State<ClassroomReportsScreen> {
  // Sample data for classroom reports
  final List<ClassReport> classReports = [
    ClassReport(
      className: "Class 10-A",
      totalStudents: 35,
      averagePerformance: 85.5,
      absenteeRate: 12.0,
      topPerformer: "Sarah Johnson",
      recentActivity: "Math Quiz - 92% average",
      subject: "Mathematics",
    ),
    ClassReport(
      className: "Class 9-B",
      totalStudents: 32,
      averagePerformance: 78.2,
      absenteeRate: 8.5,
      topPerformer: "Michael Chen",
      recentActivity: "Science Project - 87% average",
      subject: "Science",
    ),
    ClassReport(
      className: "Class 8-C",
      totalStudents: 30,
      averagePerformance: 82.7,
      absenteeRate: 15.2,
      topPerformer: "Emma Davis",
      recentActivity: "English Essay - 79% average",
      subject: "English",
    ),
    ClassReport(
      className: "Class 11-A",
      totalStudents: 28,
      averagePerformance: 88.9,
      absenteeRate: 6.8,
      topPerformer: "Alex Rodriguez",
      recentActivity: "Physics Test - 91% average",
      subject: "Physics",
    ),
  ];

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
                title: 'Classroom Report',
                icon: Icons.pending_actions,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              // Reports List
              Expanded(
                child: Container(
                  padding: AppThemeResponsiveness.getScreenPadding(context),
                  child: _buildResponsiveLayout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout() {
    // Use different layouts based on screen size
    if (AppThemeResponsiveness.isDesktop(context)) {
      return _buildDesktopLayout();
    } else if (AppThemeResponsiveness.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      itemCount: classReports.length,
      itemBuilder: (context, index) {
        return _buildClassReportCard(classReports[index]);
      },
    );
  }

  Widget _buildTabletLayout() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: 0.8,
      ),
      itemCount: classReports.length,
      itemBuilder: (context, index) {
        return _buildClassReportCard(classReports[index]);
      },
    );
  }

  Widget _buildDesktopLayout() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: 0.75,
      ),
      itemCount: classReports.length,
      itemBuilder: (context, index) {
        return _buildClassReportCard(classReports[index]);
      },
    );
  }

  Widget _buildClassReportCard(ClassReport report) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Container(
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
                    decoration: BoxDecoration(
                      gradient: AppThemeColor.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        AppThemeResponsiveness.getResponsiveRadius(context, 12.0),
                      ),
                    ),
                    child: Icon(
                      _getSubjectIcon(report.subject),
                      color: AppThemeColor.white,
                      size: AppThemeResponsiveness.getDashboardCardIconSize(context),
                    ),
                  ),
                  SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.className,
                          style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${report.totalStudents} Students • ${report.subject}',
                          style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDetailedReport(report),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: AppThemeResponsiveness.getResponsiveIconSize(context, 16.0),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

              // Performance Metrics
              _buildResponsiveMetricsRow(report),

              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Additional Info
              Container(
                padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
                decoration: BoxDecoration(
                  color: AppThemeColor.blue50,
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getResponsiveRadius(context, 8.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: AppThemeResponsiveness.getResponsiveIconSize(context, 16.0),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Top Performer: ${report.topPerformer}',
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.assignment,
                          color: AppThemeColor.blue600,
                          size: AppThemeResponsiveness.getResponsiveIconSize(context, 16.0),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Recent: ${report.recentActivity}',
                            style: AppThemeResponsiveness.getBodyTextStyle(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveMetricsRow(ClassReport report) {
    if (AppThemeResponsiveness.isSmallPhone(context)) {
      // Stack metrics vertically on small phones
      return Column(
        children: [
          _buildMetricCard(
            'Performance',
            '${report.averagePerformance.toStringAsFixed(1)}%',
            Icons.trending_up,
            _getPerformanceColor(report.averagePerformance),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          _buildMetricCard(
            'Absentee Rate',
            '${report.absenteeRate.toStringAsFixed(1)}%',
            Icons.person_off,
            _getAbsenteeColor(report.absenteeRate),
          ),
        ],
      );
    } else {
      // Side by side for larger screens
      return Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              'Performance',
              '${report.averagePerformance.toStringAsFixed(1)}%',
              Icons.trending_up,
              _getPerformanceColor(report.averagePerformance),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: _buildMetricCard(
              'Absentee Rate',
              '${report.absenteeRate.toStringAsFixed(1)}%',
              Icons.person_off,
              _getAbsenteeColor(report.absenteeRate),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getResponsiveRadius(context, 8.0),
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppThemeResponsiveness.getDashboardCardIconSize(context),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getStatTitleStyle(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'english':
        return Icons.menu_book;
      case 'physics':
        return Icons.electrical_services;
      default:
        return Icons.school;
    }
  }

  Color _getPerformanceColor(double performance) {
    if (performance >= 85) return Colors.green;
    if (performance >= 75) return Colors.orange;
    return Colors.red;
  }

  Color _getAbsenteeColor(double absenteeRate) {
    if (absenteeRate <= 5) return Colors.green;
    if (absenteeRate <= 10) return Colors.orange;
    return Colors.red;
  }

  void _showDetailedReport(ClassReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: AppThemeResponsiveness.getScreenPadding(context),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${report.className} Detailed Report',
                      style: AppThemeResponsiveness.getDialogTitleStyle(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: AppThemeResponsiveness.getIconSize(context),
                    ),
                  ),
                ],
              ),
            ),

            // Detailed content
            Expanded(
              child: SingleChildScrollView(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Total Students', '${report.totalStudents}'),
                    _buildDetailRow('Average Performance', '${report.averagePerformance}%'),
                    _buildDetailRow('Absentee Rate', '${report.absenteeRate}%'),
                    _buildDetailRow('Top Performer', report.topPerformer),
                    _buildDetailRow('Subject', report.subject),
                    _buildDetailRow('Recent Activity', report.recentActivity),

                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                    Text(
                      'Performance Breakdown',
                      style: AppThemeResponsiveness.getHeadingStyle(context),
                    ),

                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

                    // Performance indicators
                    _buildPerformanceIndicator('Excellent (90-100%)', 8, Colors.green),
                    _buildPerformanceIndicator('Good (80-89%)', 15, Colors.blue),
                    _buildPerformanceIndicator('Average (70-79%)', 10, Colors.orange),
                    _buildPerformanceIndicator('Below Average (<70%)', 2, Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppThemeResponsiveness.isSmallPhone(context) ? 100 : 120,
            child: Text(
              '$label:',
              style: AppThemeResponsiveness.getSubHeadingStyle(context),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicator(String category, int count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: AppThemeResponsiveness.getBodyTextStyle(context),
            ),
          ),
          Text(
            '$count students',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}