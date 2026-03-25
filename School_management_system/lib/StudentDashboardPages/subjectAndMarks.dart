import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/studentDashboardModel/studentAndMarksModelStudent.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class SubjectsMarksScreen extends StatefulWidget {
  const SubjectsMarksScreen({Key? key}) : super(key: key);

  @override
  State<SubjectsMarksScreen> createState() => _SubjectsMarksScreenState();
}

class _SubjectsMarksScreenState extends State<SubjectsMarksScreen> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late TabController _tabController;

  // Sample data for subjects
  final List<Subject> subjects = [
    Subject('Mathematics', 'A+', 95, Icons.calculate, Colors.green),
    Subject('English', 'A', 88, Icons.book, AppThemeColor.primaryBlue),
    Subject('Science', 'A+', 92, Icons.science, Colors.green),
    Subject('History', 'B+', 82, Icons.history_edu, Colors.orange),
    Subject('Geography', 'A', 86, Icons.public, AppThemeColor.primaryBlue),
    Subject('Computer Science', 'A+', 94, Icons.computer, Colors.green),
    Subject('Physical Education', 'A', 89, Icons.sports, AppThemeColor.primaryBlue),
    Subject('Art', 'B+', 84, Icons.palette, Colors.orange),
  ];

  // Sample exam results data
  final List<ExamResult> examResults = [
    ExamResult('Mid-Term Exam', 'September 2024', 87.5, 'A'),
    ExamResult('Unit Test 1', 'August 2024', 91.2, 'A+'),
    ExamResult('Final Exam', 'December 2024', 89.8, 'A'),
    ExamResult('Unit Test 2', 'October 2024', 85.6, 'A'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
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
              // Header Section - Fixed at top
              Padding(
                padding: EdgeInsets.only(
                  top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
                  left: AppThemeResponsiveness.getSmallSpacing(context),
                  right: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                child: HeaderSection(
                  title: 'Subjects list',
                  icon: Icons.book_outlined,
                ),
              ),

              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Main content container - Expandable
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                  ),
                  margin: EdgeInsets.only(
                    left: AppThemeResponsiveness.getDashboardHorizontalPadding(context) +
                        AppThemeResponsiveness.getSmallSpacing(context),
                    right: AppThemeResponsiveness.getDashboardHorizontalPadding(context) +
                        AppThemeResponsiveness.getSmallSpacing(context),
                    bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    ),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tab Bar
                      CustomTabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Subject List'),
                          Tab(text: 'Grades and Results'),
                        ],
                      ),

                      // Tab Content - Expandable
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildSubjectListTab(context),
                            _buildGradesResultsTab(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectListTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Summary Card
          Container(
            margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppThemeColor.primaryBlue.withOpacity(0.1),
                  AppThemeColor.primaryIndigo.withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              border: Border.all(color: AppThemeColor.primaryBlue.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildSummaryLayout(context),
          ),

          // Subject List/Grid
          _buildSubjectLayout(context),

          // Action Buttons
          _buildActionButtons(context),
          SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
        ],
      ),
    );
  }

  Widget _buildSummaryLayout(BuildContext context) {
    if (AppThemeResponsiveness.isMobile(context)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(context, 'Total Subjects', '${subjects.length}', Icons.subject),
              _buildSummaryItem(context, 'Average', '${_calculateAverage().toStringAsFixed(1)}%', Icons.trending_up),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildSummaryItem(context, 'Overall Grade', _getOverallGrade(), Icons.star),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(context, 'Total Subjects', '${subjects.length}', Icons.subject),
          _buildSummaryItem(context, 'Average', '${_calculateAverage().toStringAsFixed(1)}%', Icons.trending_up),
          _buildSummaryItem(context, 'Overall Grade', _getOverallGrade(), Icons.star),
        ],
      );
    }
  }

  Widget _buildSubjectLayout(BuildContext context) {
    if (AppThemeResponsiveness.isMobile(context)) {
      return _buildSubjectList(context);
    } else {
      return _buildSubjectHorizontalGrid(context);
    }
  }

  Widget _buildGradesResultsTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Overall Performance Card
          Container(
            margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            decoration: BoxDecoration(
              color: AppThemeColor.blue50,
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Performance Overview',
                  style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(color: Colors.black87),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                _buildPerformanceMetrics(context),
              ],
            ),
          ),

          // Exam Results
          _buildExamResults(context),

          // Progress Chart
          _buildProgressChart(context),

          // Action Buttons
          _buildActionButtons(context),
          SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildPerformanceMetric(context, 'Current GPA', '3.7/4.0', Icons.school, Colors.green),
        ),
        SizedBox(width: AppThemeResponsiveness.isMobile(context) ?
        AppThemeResponsiveness.getSmallSpacing(context) :
        AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: _buildPerformanceMetric(context, 'Class Rank', '12/45', Icons.emoji_events, Colors.orange),
        ),
      ],
    );
  }

  Widget _buildExamResults(BuildContext context) {
    if (AppThemeResponsiveness.isDesktop(context)) {
      return _buildExamResultsGrid(context);
    } else {
      return _buildExamResultsList(context);
    }
  }

  // New optimized subject grid with horizontal scrolling
  Widget _buildSubjectHorizontalGrid(BuildContext context) {
    double cardWidth = AppThemeResponsiveness.isDesktop(context) ? 180 : 160;
    double cardHeight = AppThemeResponsiveness.isDesktop(context) ? 260 : 220;

    return Container(
      height: cardHeight + 40, // Extra space for padding
      margin: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getDefaultSpacing(context)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Container(
            width: cardWidth,
            margin: EdgeInsets.only(
              right: index < subjects.length - 1 ? AppThemeResponsiveness.getMediumSpacing(context) : 0,
            ),
            child: _buildSubjectCard(context, subjects[index], isGrid: true),
          );
        },
      ),
    );
  }

  Widget _buildSubjectList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return _buildSubjectCard(context, subjects[index], isGrid: false);
        },
      ),
    );
  }

  Widget _buildExamResultsGrid(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
          mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
          childAspectRatio: 1.6,
        ),
        itemCount: examResults.length,
        itemBuilder: (context, index) {
          return _buildExamResultCard(context, examResults[index], isGrid: true);
        },
      ),
    );
  }

  Widget _buildExamResultsList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: examResults.length,
        itemBuilder: (context, index) {
          return _buildExamResultCard(context, examResults[index], isGrid: false);
        },
      ),
    );
  }

  // Updated subject card with grid/list flexibility
  Widget _buildSubjectCard(BuildContext context, Subject subject, {required bool isGrid}) {
    if (isGrid) {
      return Container(
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _showSubjectDetails(context, subject),
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          child: Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context)),
                  decoration: BoxDecoration(
                    color: AppThemeColor.blue50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    subject.icon,
                    color: AppThemeColor.primaryBlue,
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                Text(
                  subject.name,
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  '${subject.percentage}%',
                  style: AppThemeResponsiveness.getStatValueStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: subject.gradeColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    subject.grade,
                    style: TextStyle(
                      color: AppThemeColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
          leading: Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
            decoration: BoxDecoration(
              color: AppThemeColor.blue50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              subject.icon,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getDashboardCardIconSize(context),
            ),
          ),
          title: Text(
            subject.name,
            style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Percentage: ${subject.percentage}%',
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: subject.percentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(subject.gradeColor),
                  minHeight: AppThemeResponsiveness.isMobile(context) ? 4 : 6,
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: AppThemeResponsiveness.getStatusBadgePadding(context),
            decoration: BoxDecoration(
              color: subject.gradeColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              subject.grade,
              style: TextStyle(
                color: AppThemeColor.white,
                fontWeight: FontWeight.bold,
                fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
              ),
            ),
          ),
          onTap: () => _showSubjectDetails(context, subject),
        ),
      );
    }
  }

  // Updated exam result card with grid/list flexibility
  Widget _buildExamResultCard(BuildContext context, ExamResult result, {required bool isGrid}) {
    if (isGrid) {
      return Container(
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
                    decoration: BoxDecoration(
                      color: _getGradeColor(result.grade).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: _getGradeColor(result.grade),
                      size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getGradeColor(result.grade),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      result.grade,
                      style: TextStyle(
                        color: AppThemeColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              Text(
                result.examName,
                style: AppThemeResponsiveness.getHeadingStyle(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                result.date,
                style: AppThemeResponsiveness.getSubHeadingStyle(context),
              ),
              const Spacer(),
              Text(
                'Score: ${result.percentage}%',
                style: AppThemeResponsiveness.getStatValueStyle(context),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
          leading: Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
            decoration: BoxDecoration(
              color: _getGradeColor(result.grade).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.assignment,
              color: _getGradeColor(result.grade),
              size: AppThemeResponsiveness.getDashboardCardIconSize(context),
            ),
          ),
          title: Text(
            result.examName,
            style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                result.date,
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Score: ${result.percentage}%',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: AppThemeResponsiveness.getStatusBadgePadding(context),
            decoration: BoxDecoration(
              color: _getGradeColor(result.grade),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              result.grade,
              style: TextStyle(
                color: AppThemeColor.white,
                fontWeight: FontWeight.bold,
                fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildProgressChart(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trend',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Container(
            height: AppThemeResponsiveness.isMobile(context) ? 60 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppThemeColor.primaryBlue.withOpacity(0.3),
                  AppThemeColor.primaryIndigo.withOpacity(0.3)
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '📈 Showing consistent improvement',
                style: TextStyle(
                  fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! + 2,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppThemeColor.primaryBlue,
          size: AppThemeResponsiveness.getHeaderIconSize(context),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Text(
          value,
          style: AppThemeResponsiveness.getStatValueStyle(context),
        ),
        Text(
          title,
          style: AppThemeResponsiveness.getStatTitleStyle(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPerformanceMetric(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            value,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.getStatValueStyle(context).fontSize,
              fontWeight: FontWeight.bold,
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
    child: AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context)
    ? Column(
    children: [
    SizedBox(
    width: double.infinity,
    height: AppThemeResponsiveness.getButtonHeight(context),
    child: ElevatedButton.icon(
    onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Downloading mark sheet...')),
    );
    },
    icon: Icon(
    Icons.download,
    color: AppThemeColor.white,
    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
    ),
    label: Text('Download', style: AppThemeResponsiveness.getButtonTextStyle(context)),
    style: ElevatedButton.styleFrom(
    backgroundColor: AppThemeColor.primaryBlue,
    elevation: AppThemeResponsiveness.getButtonElevation(context),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
    ),
    ),
    ),
    ),
    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
    SizedBox(
    width: double.infinity,
      height: AppThemeResponsiveness.getButtonHeight(context),
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sharing mark sheet...')),
          );
        },
        icon: Icon(
          Icons.share,
          color: AppThemeColor.primaryBlue,
          size: AppThemeResponsiveness.getIconSize(context) * 0.8,
        ),
        label: Text('Share', style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(color: AppThemeColor.primaryBlue)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppThemeColor.primaryBlue),
          elevation: AppThemeResponsiveness.getButtonElevation(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
          ),
        ),
      ),
    ),
    ],
    )
        : Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppThemeResponsiveness.getButtonHeight(context),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading mark sheet...')),
                );
              },
              icon: Icon(
                Icons.download,
                color: AppThemeColor.white,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              label: Text('Download', style: AppThemeResponsiveness.getButtonTextStyle(context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColor.primaryBlue,
                elevation: AppThemeResponsiveness.getButtonElevation(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: SizedBox(
            height: AppThemeResponsiveness.getButtonHeight(context),
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing mark sheet...')),
                );
              },
              icon: Icon(
                Icons.share,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              label: Text('Share', style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(color: AppThemeColor.primaryBlue)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppThemeColor.primaryBlue),
                elevation: AppThemeResponsiveness.getButtonElevation(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  // Helper methods
  double _calculateAverage() {
    if (subjects.isEmpty) return 0;
    double total = subjects.fold(0, (sum, subject) => sum + subject.percentage);
    return total / subjects.length;
  }

  String _getOverallGrade() {
    double average = _calculateAverage();
    if (average >= 90) return 'A+';
    if (average >= 80) return 'A';
    if (average >= 70) return 'B+';
    if (average >= 60) return 'B';
    if (average >= 50) return 'C+';
    return 'C';
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green;
      case 'A':
        return AppThemeColor.primaryBlue;
      case 'B+':
        return Colors.orange;
      case 'B':
        return Colors.amber;
      case 'C+':
        return Colors.deepOrange;
      case 'C':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showSubjectDetails(BuildContext context, Subject subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          title: Row(
            children: [
              Icon(
                subject.icon,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  subject.name,
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'Grade', subject.grade, subject.gradeColor),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildDetailRow(context, 'Percentage', '${subject.percentage}%', Colors.black87),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildDetailRow(context, 'Status', subject.percentage >= 60 ? 'Pass' : 'Fail',
                  subject.percentage >= 60 ? Colors.green : Colors.red),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
                decoration: BoxDecoration(
                  color: AppThemeColor.blue50,
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Analysis',
                      style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      subject.percentage >= 90
                          ? 'Excellent performance! Keep up the great work.'
                          : subject.percentage >= 80
                          ? 'Good performance. There\'s room for improvement.'
                          : subject.percentage >= 70
                          ? 'Average performance. Consider additional study.'
                          : 'Needs improvement. Please seek help from teachers.',
                      style: AppThemeResponsiveness.getBodyTextStyle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: AppThemeColor.primaryBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing detailed report for ${subject.name}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColor.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
                ),
              ),
              child: Text(
                'View Details',
                style: AppThemeResponsiveness.getButtonTextStyle(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
