import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/studentDashboardModel/progressReportModel.dart';

class StudentResultsPage extends StatefulWidget {
  @override
  _StudentResultsPageState createState() => _StudentResultsPageState();
}

class _StudentResultsPageState extends State<StudentResultsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedSemester = 0;

  // Sample data for demonstration
  final List<SemesterResult> semesterResults = [
    SemesterResult(
      semester: 'Semester 1',
      subjects: [
        SubjectResult('Maths', 95, 'A+', 4.0),
        SubjectResult('Science', 88, 'A', 3.7),
        SubjectResult('English', 85, 'A', 3.5),
        SubjectResult('Computer', 97, 'A+', 4.0),
        SubjectResult('Biology', 89, 'A', 3.8),
      ],
      overallGPA: 3.83,
      percentage: 91.0,
      rank: 5,
      totalStudents: 120,
    ),
    SemesterResult(
      semester: 'Semester 2',
      subjects: [
        SubjectResult('Maths', 92, 'A+', 4.0),
        SubjectResult('Physics', 85, 'A', 3.5),
        SubjectResult('Chemistry', 89, 'A', 3.8),
        SubjectResult('English', 88, 'A', 3.7),
        SubjectResult('Computer Science', 95, 'A+', 4.0),
        SubjectResult('Biology', 87, 'A', 3.6),
      ],
      overallGPA: 3.77,
      percentage: 89.3,
      rank: 7,
      totalStudents: 120,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: semesterResults.length, vsync: this);
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
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                title: 'Academic Result',
                icon: Icons.auto_graph_outlined,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context) * 1.5),

                      ),
                    ),
                    child: Column(
                      children: [
                        CustomTabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'Sem 1'),
                            Tab(text: 'Sem 2'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: semesterResults.map((semester) =>
                                _buildSemesterContent(context, semester)
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterContent(BuildContext context, SemesterResult semester) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(context, semester),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5),
          _buildProgressChart(context, semester),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5),
          _buildSubjectsResults(context, semester),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, SemesterResult semester) {
    return Row(
      children: [
        _buildOverviewCard(
          context,
          'Overall GPA',
          semester.overallGPA.toStringAsFixed(2),
          Icons.school_rounded,
          Colors.purple,
        ),
        SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildOverviewCard(
          context,
          'Percentage',
          '${semester.percentage.toStringAsFixed(1)}%',
          Icons.pie_chart_rounded,
          Colors.blue,
        ),
        SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildOverviewCard(
          context,
          'Class Rank',
          '${semester.rank}/${semester.totalStudents}',
          Icons.emoji_events_rounded,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: AppThemeResponsiveness.getCardElevation(context),
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
              ),
              child: Icon(
                icon,
                color: color,
                size: AppThemeResponsiveness.getIconSize(context) * 1.2,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              value,
              style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
            Text(
              title,
              style: AppThemeResponsiveness.getCaptionTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context, SemesterResult semester) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: Colors.indigo.shade600,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Subject Performance',
                style: AppThemeResponsiveness.getSubtitleTextStyle(context),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: semester.subjects.length,
              itemBuilder: (context, index) {
                final subject = semester.subjects[index];
                return Container(
                  width: 80,
                  margin: EdgeInsets.only(right: AppThemeResponsiveness.getSmallSpacing(context)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 40,
                                height: (subject.marks / 100) * 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: _getGradeColors(subject.grade),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                      Text(
                        '${subject.marks}%',
                        style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
                      Text(
                        subject.name.length > 8
                            ? subject.name.substring(0, 8) + '...'
                            : subject.name,
                        style: AppThemeResponsiveness.getCaptionTextStyle(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsResults(BuildContext context, SemesterResult semester) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Row(
              children: [
                Icon(
                  Icons.subject_rounded,
                  color: Colors.indigo.shade600,
                  size: AppThemeResponsiveness.getIconSize(context),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  'Subject-wise Results',
                  style: AppThemeResponsiveness.getSubtitleTextStyle(context),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: semester.subjects.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 0.5,
              indent: AppThemeResponsiveness.getDefaultSpacing(context),
              endIndent: AppThemeResponsiveness.getDefaultSpacing(context),
            ),
            itemBuilder: (context, index) {
              final subject = semester.subjects[index];
              return _buildSubjectResultItem(context, subject);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectResultItem(BuildContext context, SubjectResult subject) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
            decoration: BoxDecoration(
              color: _getGradeColors(subject.grade)[0].withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: Icon(
              Icons.book_rounded,
              color: _getGradeColors(subject.grade)[0],
              size: AppThemeResponsiveness.getIconSize(context),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
                Text(
                  'GPA: ${subject.gpa.toStringAsFixed(1)}',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradeColors(subject.grade),
                  ),
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
                ),
                child: Text(
                  subject.grade,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
              Text(
                '${subject.marks}%',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getGradeColors(subject.grade)[0],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getGradeColors(String grade) {
    switch (grade) {
      case 'A+':
        return [Colors.green.shade600, Colors.green.shade400];
      case 'A':
        return [Colors.blue.shade600, Colors.blue.shade400];
      case 'B+':
        return [Colors.orange.shade600, Colors.orange.shade400];
      case 'B':
        return [Colors.yellow.shade700, Colors.yellow.shade500];
      case 'C':
        return [Colors.red.shade600, Colors.red.shade400];
      default:
        return [Colors.grey.shade600, Colors.grey.shade400];
    }
  }
}
