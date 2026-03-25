import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class TeacherTimetablePage extends StatefulWidget {
  const TeacherTimetablePage({Key? key}) : super(key: key);

  @override
  State<TeacherTimetablePage> createState() => _TeacherTimetablePageState();
}

class _TeacherTimetablePageState extends State<TeacherTimetablePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample timetable data
  final Map<String, List<TimeSlot>> weeklySchedule = {
    'Monday': [
      TimeSlot('9:00 AM', '10:00 AM', 'Mathematics', 'Class 10A', 'Room 101'),
      TimeSlot('10:30 AM', '11:30 AM', 'Physics', 'Class 12B', 'Lab 203'),
      TimeSlot('12:00 PM', '1:00 PM', 'Mathematics', 'Class 11C', 'Room 105'),
      TimeSlot('2:00 PM', '3:00 PM', 'Study Hall', 'Class 10A', 'Room 101'),
    ],
    'Tuesday': [
      TimeSlot('8:30 AM', '9:30 AM', 'Physics', 'Class 11A', 'Lab 201'),
      TimeSlot('10:00 AM', '11:00 AM', 'Mathematics', 'Class 9B', 'Room 102'),
      TimeSlot('11:30 AM', '12:30 PM', 'Physics', 'Class 12A', 'Lab 203'),
      TimeSlot('1:30 PM', '2:30 PM', 'Mathematics', 'Class 10C', 'Room 104'),
    ],
    'Wednesday': [
      TimeSlot('9:00 AM', '10:00 AM', 'Mathematics', 'Class 11B', 'Room 103'),
      TimeSlot('10:30 AM', '11:30 AM', 'Physics', 'Class 10A', 'Lab 201'),
      TimeSlot('1:00 PM', '2:00 PM', 'Study Hall', 'Class 12C', 'Room 106'),
      TimeSlot('2:30 PM', '3:30 PM', 'Mathematics', 'Class 9A', 'Room 101'),
    ],
    'Thursday': [
      TimeSlot('8:30 AM', '9:30 AM', 'Physics', 'Class 12B', 'Lab 203'),
      TimeSlot('10:00 AM', '11:00 AM', 'Mathematics', 'Class 10B', 'Room 105'),
      TimeSlot('11:30 AM', '12:30 PM', 'Physics', 'Class 11C', 'Lab 201'),
      TimeSlot('2:00 PM', '3:00 PM', 'Mathematics', 'Class 12A', 'Room 102'),
    ],
    'Friday': [
      TimeSlot('9:00 AM', '10:00 AM', 'Mathematics', 'Class 9C', 'Room 101'),
      TimeSlot('10:30 AM', '11:30 AM', 'Physics', 'Class 10C', 'Lab 202'),
      TimeSlot('12:00 PM', '1:00 PM', 'Mathematics', 'Class 11A', 'Room 104'),
      TimeSlot('2:00 PM', '3:00 PM', 'Faculty Meeting', 'All Staff', 'Conference Room'),
    ],
  };

  final List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: weekDays.length, vsync: this);
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
              _buildHeader(context),
              _buildTabBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: AppThemeColor.defaultSpacing,
                    left: AppThemeColor.mediumSpacing,
                    right: AppThemeColor.mediumSpacing,
                  ),
                  decoration: const BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppThemeColor.cardBorderRadius),
                      topRight: Radius.circular(AppThemeColor.cardBorderRadius),
                    ),
                  ),
                  child: _buildTimetableContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppThemeColor.defaultSpacing),
      child: Row(
        children: [
          const SizedBox(width: AppThemeColor.mediumSpacing),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Timetable',
                  style: AppThemeResponsiveness.FontStyle,
                ),
                Text(
                  'View your weekly teaching schedule',
                  style: AppThemeResponsiveness.splashSubtitleStyle,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppThemeColor.smallSpacing),
            decoration: BoxDecoration(
              color: AppThemeColor.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: AppThemeColor.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppThemeColor.mediumSpacing),
      decoration: BoxDecoration(
        color: AppThemeColor.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppThemeColor.buttonBorderRadius),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeColor.buttonBorderRadius),
        ),
        labelColor: AppThemeColor.primaryBlue,
        unselectedLabelColor: AppThemeColor.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: weekDays.map((day) => Tab(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(day.substring(0, 3).toUpperCase()),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTimetableContent() {
    return TabBarView(
      controller: _tabController,
      children: weekDays.map((day) => _buildDaySchedule(day)).toList(),
    );
  }

  Widget _buildDaySchedule(String day) {
    final daySchedule = weeklySchedule[day] ?? [];

    if (daySchedule.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.free_breakfast,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: AppThemeColor.mediumSpacing),
            Text(
              'No classes scheduled',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppThemeColor.defaultSpacing),
      itemCount: daySchedule.length,
      itemBuilder: (context, index) {
        return _buildTimeSlotCard(daySchedule[index], index);
      },
    );
  }

  Widget _buildTimeSlotCard(TimeSlot timeSlot, int index) {
    return AnimatedContainer(
      duration: AppThemeColor.buttonAnimationDuration,
      margin: const EdgeInsets.only(bottom: AppThemeColor.mediumSpacing),
      child: Card(
        elevation: AppThemeColor.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppThemeColor.blue50,
                AppThemeColor.blue100,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppThemeColor.mediumSpacing),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppThemeColor.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppThemeColor.mediumSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeSlot.subject,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppThemeColor.blue800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppThemeColor.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${timeSlot.startTime} - ${timeSlot.endTime}',
                              style: const TextStyle(
                                color: AppThemeColor.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.group,
                            size: 16,
                            color: AppThemeColor.blue600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeSlot.className,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppThemeColor.blue600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: AppThemeColor.mediumSpacing),
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppThemeColor.blue600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeSlot.room,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppThemeColor.blue600,
                              fontWeight: FontWeight.w500,
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
      ),
    );
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;
  final String subject;
  final String className;
  final String room;

  TimeSlot(this.startTime, this.endTime, this.subject, this.className, this.room);
}