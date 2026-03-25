import 'package:flutter/material.dart';
import 'package:school/StudentDashboardPages/timeTableData.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class TimeTableStudentScreen extends StatefulWidget {
  @override
  _TimeTableStudentScreenState createState() => _TimeTableStudentScreenState();
}

class _TimeTableStudentScreenState extends State<TimeTableStudentScreen> {
  String selectedDay = 'Monday';
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  // Sample time table data
  final Map<String, List<ClassSchedule>> timeTable = {
    'Monday': [
      ClassSchedule('Mathematics', '9:00 AM - 10:00 AM', 'Room 101'),
      ClassSchedule('Physics', '10:15 AM - 11:15 AM', 'Room 102'),
      ClassSchedule('Chemistry', '11:30 AM - 12:30 PM', 'Room 103'),
      ClassSchedule('English', '1:30 PM - 2:30 PM', 'Room 104'),
      ClassSchedule('History', '2:45 PM - 3:45 PM', 'Room 105'),
    ],
    'Tuesday': [
      ClassSchedule('Biology', '9:00 AM - 10:00 AM', 'Room 106'),
      ClassSchedule('Mathematics', '10:15 AM - 11:15 AM', 'Room 101'),
      ClassSchedule('Computer Science', '11:30 AM - 12:30 PM', 'Room 107'),
      ClassSchedule('Physical Education', '1:30 PM - 2:30 PM', 'Gym'),
      ClassSchedule('Art', '2:45 PM - 3:45 PM', 'Room 108'),
    ],
    'Wednesday': [
      ClassSchedule('Geography', '9:00 AM - 10:00 AM', 'Room 109'),
      ClassSchedule('Physics', '10:15 AM - 11:15 AM', 'Room 102'),
      ClassSchedule('Mathematics', '11:30 AM - 12:30 PM', 'Room 101'),
      ClassSchedule('Chemistry', '1:30 PM - 2:30 PM', 'Room 103'),
      ClassSchedule('Music', '2:45 PM - 3:45 PM', 'Room 110'),
    ],
    'Thursday': [
      ClassSchedule('English', '9:00 AM - 10:00 AM', 'Room 104'),
      ClassSchedule('Biology', '10:15 AM - 11:15 AM', 'Room 106'),
      ClassSchedule('History', '11:30 AM - 12:30 PM', 'Room 105'),
      ClassSchedule('Mathematics', '1:30 PM - 2:30 PM', 'Room 101'),
      ClassSchedule('Computer Science', '2:45 PM - 3:45 PM', 'Room 107'),
    ],
    'Friday': [
      ClassSchedule('Physics', '9:00 AM - 10:00 AM', 'Room 102'),
      ClassSchedule('Chemistry', '10:15 AM - 11:15 AM', 'Room 103'),
      ClassSchedule('English', '11:30 AM - 12:30 PM', 'Room 104'),
      ClassSchedule('Geography', '1:30 PM - 2:30 PM', 'Room 109'),
      ClassSchedule('Library Period', '2:45 PM - 3:45 PM', 'Library'),
    ],
    'Saturday': [
      ClassSchedule('Mathematics', '9:00 AM - 10:00 AM', 'Room 101'),
      ClassSchedule('Science Lab', '10:15 AM - 12:15 PM', 'Lab 1'),
      ClassSchedule('Sports', '1:30 PM - 3:30 PM', 'Playground'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              left: AppThemeResponsiveness.getSmallSpacing(context),
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Time Table',
                  icon: Icons.schedule,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                // Responsive Day Selection
                _buildDaySelection(context),

                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                // Responsive Time Table Content
                Expanded(
                  child: _buildTimeTableContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      height: AppThemeResponsiveness.getButtonHeight(context),
      child: AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context)
          ? _buildMobileDaySelection(context)
          : _buildDesktopTabletDaySelection(context),
    );
  }

  Widget _buildMobileDaySelection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: days.map((day) {
          final isSelected = selectedDay == day;
          return GestureDetector(
            onTap: () => setState(() => selectedDay = day),
            child: Container(
              margin: EdgeInsets.only(right: AppThemeResponsiveness.getSmallSpacing(context)),
              padding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                vertical: AppThemeResponsiveness.getSmallSpacing(context),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppThemeColor.white
                    : AppThemeColor.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getButtonBorderRadius(context)),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  AppThemeResponsiveness.isSmallPhone(context) ? day.substring(0, 3) : day,
                  style: TextStyle(
                    color: isSelected ? AppThemeColor.blue600 : AppThemeColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppThemeResponsiveness
                        .getBodyTextStyle(context)
                        .fontSize,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopTabletDaySelection(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isSelected = selectedDay == day;
        return GestureDetector(
          onTap: () => setState(() => selectedDay = day),
          child: Container(
            margin: EdgeInsets.only(right: AppThemeResponsiveness.getMediumSpacing(context)),
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
              vertical: AppThemeResponsiveness.getMediumSpacing(context),
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppThemeColor.white
                  : AppThemeColor.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getButtonBorderRadius(context)),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? AppThemeColor.blue600 : AppThemeColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppThemeResponsiveness
                      .getBodyTextStyle(context)
                      .fontSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeTableContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with day info and quick stats
          _buildContentHeader(context),

          // Schedule content
          Expanded(
            child: AppThemeResponsiveness.isDesktop(context) ||
                (AppThemeResponsiveness.isTablet(context) && !AppThemeResponsiveness.isMobile(context))
                ? _buildGridView(context)
                : _buildListView(context),
          ),

          // Footer with summary
          _buildContentFooter(context),
        ],
      ),
    );
  }

  Widget _buildContentHeader(BuildContext context) {
    final classCount = timeTable[selectedDay]?.length ?? 0;
    final totalHours = _calculateTotalHours();

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$selectedDay Schedule',
            style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
              color: AppThemeColor.blue800,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context)
              ? Column(
            children: [
              _buildQuickStat(context, 'Classes', '$classCount', Icons.class_),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildQuickStat(
                  context, 'Total Hours', '$totalHours hrs', Icons.schedule),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: _buildQuickStat(
                    context, 'Classes', '$classCount', Icons.class_),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildQuickStat(
                    context, 'Total Hours', '$totalHours hrs', Icons.schedule),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(BuildContext context, String label, String value,
      IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppThemeColor.primaryBlue,
            size: AppThemeResponsiveness.getHeaderIconSize(context),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppThemeResponsiveness.getStatValueStyle(context),
              ),
              Text(
                label,
                style: AppThemeResponsiveness.getStatTitleStyle(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppThemeResponsiveness.getGridCrossAxisCount(context),
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: AppThemeResponsiveness.getGridChildAspectRatio(context) * 1.2,
      ),
      itemCount: timeTable[selectedDay]?.length ?? 0,
      itemBuilder: (context, index) {
        final classSchedule = timeTable[selectedDay]![index];
        return ClassCardGrid(classSchedule: classSchedule);
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: timeTable[selectedDay]?.length ?? 0,
      itemBuilder: (context, index) {
        final classSchedule = timeTable[selectedDay]![index];
        return ClassCard(classSchedule: classSchedule);
      },
    );
  }

  Widget _buildContentFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        border: Border(
          top: BorderSide(
            color: AppThemeColor.blue200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  _getScheduleNote(),
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: AppThemeColor.blue600,
                    fontSize: AppThemeResponsiveness
                        .getBodyTextStyle(context)
                        .fontSize! - 1,
                  ),
                ),
              ),
            ],
          ),
          if (AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)) ...[
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context)
        ? Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppThemeResponsiveness.getButtonHeight(context),
          child: ElevatedButton.icon(
            onPressed: _exportSchedule,
            icon: Icon(
              Icons.download,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
            label: Text('Export', style: AppThemeResponsiveness.getButtonTextStyle(context)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColor.primaryBlue,
              elevation: AppThemeResponsiveness.getButtonElevation(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getButtonBorderRadius(context)),
              ),
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        SizedBox(
          width: double.infinity,
          height: AppThemeResponsiveness.getButtonHeight(context),
          child: OutlinedButton.icon(
            onPressed: _shareSchedule,
            icon: Icon(
              Icons.share,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
            label: Text(
              'Share',
              style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                color: AppThemeColor.primaryBlue,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppThemeColor.primaryBlue,
                width: AppThemeResponsiveness.getFocusedBorderWidth(context),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getButtonBorderRadius(context)),
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
              onPressed: _exportSchedule,
              icon: Icon(
                Icons.download,
                color: AppThemeColor.white,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              label: Text('Export Schedule',
                  style: AppThemeResponsiveness.getButtonTextStyle(context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColor.primaryBlue,
                elevation: AppThemeResponsiveness.getButtonElevation(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppThemeResponsiveness.getButtonBorderRadius(context)),
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
              onPressed: _shareSchedule,
              icon: Icon(
                Icons.share,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              label: Text(
                'Share Schedule',
                style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                  color: AppThemeColor.primaryBlue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppThemeColor.primaryBlue,
                  width: AppThemeResponsiveness.getFocusedBorderWidth(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppThemeResponsiveness.getButtonBorderRadius(context)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Methods
  int _calculateTotalHours() {
    final classes = timeTable[selectedDay] ?? [];
    return classes
        .length; // Simplified calculation - each class is approximately 1 hour
  }

  String _getScheduleNote() {
    final classCount = timeTable[selectedDay]?.length ?? 0;
    if (classCount == 0) {
      return 'No classes scheduled for $selectedDay';
    } else if (classCount <= 3) {
      return 'Light schedule with $classCount classes';
    } else if (classCount <= 5) {
      return 'Regular schedule with $classCount classes';
    } else {
      return 'Busy schedule with $classCount classes - stay organized!';
    }
  }

  void _exportSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting $selectedDay schedule...'),
        backgroundColor: AppThemeColor.primaryBlue,
      ),
    );
  }
  void _shareSchedule() {
    final classes = timeTable[selectedDay] ?? [];
    String scheduleText = '$selectedDay Schedule:\n\n';

    for (int i = 0; i < classes.length; i++) {
      final classSchedule = classes[i];
      scheduleText += '${i + 1}. ${classSchedule.subject}\n'
          'Time: ${classSchedule.time}\n'
          'Room: ${classSchedule.room}\n\n';
    }

    // For actual sharing, you would need to add the share_plus package
    // and use: Share.share(scheduleText, subject: '$selectedDay Schedule');

    // For now, showing a snackbar with preview
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Schedule ready to share: ${classes.length} classes'),
        backgroundColor: AppThemeColor.primaryBlue,
        action: SnackBarAction(
          label: 'Preview',
          textColor: AppThemeColor.white,
          onPressed: () {
            // You could show a dialog with the schedule text here
            print(scheduleText); // For debugging
          },
        ),
      ),
    );

  }
}