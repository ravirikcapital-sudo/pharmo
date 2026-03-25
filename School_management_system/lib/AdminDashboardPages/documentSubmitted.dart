import 'package:flutter/material.dart';
import 'package:school/AdminDashboardPages/addTimeTableFormStudent.dart';
import 'package:school/AdminDashboardPages/addTimeTableFormTeacher.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/timeTable.dart';

class DocumentSubmitted extends StatefulWidget {
  @override
  _DocumentSubmittedState createState() => _DocumentSubmittedState();
}

class _DocumentSubmittedState extends State<DocumentSubmitted> {
  final List<TimeTableOption> _timeTableOptions = [
    TimeTableOption(
      icon: Icons.person_outline,
      title: 'Teacher',
      primaryColor: Color(0xFF667EEA),
      secondaryColor: Color(0xFF764BA2),
      type: TimeTableType.teacher,
      stats: '15 Teachers',
    ),
    TimeTableOption(
      icon: Icons.school_outlined,
      title: 'Student',
      primaryColor: Color(0xFF11998E),
      secondaryColor: Color(0xFF38EF7D),
      type: TimeTableType.student,
      stats: '24 Classes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(
                title: 'Documents',
                icon: Icons.document_scanner,
              ),
              Expanded(
                child: Container(
                  child: _buildEnhancedContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(
                context,
              ),
            ),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                AppThemeResponsiveness.getDashboardGridCrossAxisCount(
                  context,
                ),
                crossAxisSpacing:
                AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(
                  context,
                ),
                mainAxisSpacing:
                AppThemeResponsiveness.getDashboardGridMainAxisSpacing(
                  context,
                ),
                childAspectRatio: AppThemeResponsiveness.isTablet(context)
                    ? 1.1
                    : 0.9,
              ),
              itemCount: _timeTableOptions.length,
              itemBuilder: (context, index) {
                return _buildEnhancedOptionCard(
                  _timeTableOptions[index],
                  context,
                );
              },
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
      ],
    );
  }

  Widget _buildEnhancedOptionCard(
      TimeTableOption option,
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(
              0,
              AppThemeResponsiveness.getCardElevation(context) * 0.5,
            ),
          ),
          BoxShadow(
            color: option.primaryColor.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: AppThemeResponsiveness.getCardElevation(context) * 0.6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
          onTap: () => _navigateToTimeTableForm(option.type),
          child: Padding(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getDashboardCardPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
              children: [
                Container(
                  padding: EdgeInsets.all(
                    AppThemeResponsiveness.getDashboardCardIconPadding(context),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [option.primaryColor, option.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppThemeResponsiveness.getInputBorderRadius(context),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: option.primaryColor.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius:
                        AppThemeResponsiveness.getCardElevation(context) *
                            0.8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    option.icon,
                    size: AppThemeResponsiveness.getDashboardCardIconSize(
                      context,
                    ),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: AppThemeResponsiveness.getSmallSpacing(context) * 1.2,
                ),
                Text(
                  option.title,
                  style: AppThemeResponsiveness.getDashboardCardTitleStyle(
                    context,
                  ).copyWith(letterSpacing: -0.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center, // Added text alignment
                ),
                SizedBox(
                  height: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                Expanded(child: Container()),
                SizedBox(
                  height: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeResponsiveness.getSmallSpacing(
                            context,
                          ),
                          vertical:
                          AppThemeResponsiveness.getSmallSpacing(context) *
                              0.5,
                        ),
                        decoration: BoxDecoration(
                          color: option.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppThemeResponsiveness.getInputBorderRadius(
                              context,
                            ) *
                                0.8,
                          ),
                        ),
                        child: Text(
                          option.stats,
                          style:
                          AppThemeResponsiveness.getCaptionTextStyle(
                            context,
                          ).copyWith(
                            fontWeight: FontWeight.w600,
                            color: option.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                        AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(
                          AppThemeResponsiveness.getInputBorderRadius(context) *
                              0.6,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: AppThemeResponsiveness.getCaptionTextStyle(
                          context,
                        ).fontSize,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTimeTableForm(TimeTableType type) {
    if (type == TimeTableType.teacher) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TeacherTimeTableForm()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentTimeTableForm()),
      );
    }
  }
}