import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/model/dashboard/academicOfficerDashboardModel/NotificationModelAcademicOfficer.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String? hintText;
  final bool enabled;
  final double? height;
  final String Function(T)? itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final IconData? prefixIcon; // Added prefix icon parameter

  const AppDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.enabled = true,
    this.height,
    this.itemLabelBuilder,
    this.itemBuilder,
    this.prefixIcon, // Added prefix icon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      style: AppThemeResponsiveness.getBodyTextStyle(context),
      dropdownColor: Colors.white,
      decoration: _getInputDecoration(context),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: itemBuilder?.call(item) ??
              Text(
                itemLabelBuilder?.call(item) ?? item.toString(),
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.grey[600],
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      hint: hintText != null
          ? Text(
        hintText!,
        style: AppThemeResponsiveness.getSubHeadingStyle(context)?.copyWith(
          color: Colors.grey[600],
        ),
      )
          : null,
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
      // Added prefix icon
      prefixIcon: prefixIcon != null
          ? Icon(
        prefixIcon,
        color: Colors.grey[600],
        size: AppThemeResponsiveness.getIconSize(context),
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        borderSide: BorderSide(
          color: AppThemeColor.blue600,
          width: AppThemeResponsiveness.getFocusedBorderWidth(context),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
        vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Factory constructors for common dropdowns with appropriate icons
  static AppDropdown<String> gender({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return AppDropdown<String>(
      value: value,
      items: const ['Male', 'Female', 'Other'],
      label: 'Gender *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select gender' : null,
      prefixIcon: Icons.person,
    );
  }

  static AppDropdown<String> role({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customRoles,
  }) {
    final defaultRoles = ['Admin', 'Academic Officer', 'Teacher', 'Principal', 'Vice Principal', 'Department Head'];

    return AppDropdown<String>(
      value: value,
      items: customRoles ?? defaultRoles,
      label: 'Role *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a role' : null,
      prefixIcon: Icons.work,
    );
  }

  static AppDropdown<String> houseColor({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customColors,
  }) {
    final defaultColors = ['Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Pink', 'Cyan'];

    return AppDropdown<String>(
      value: value,
      items: customColors ?? defaultColors,
      label: 'House Color *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select house color' : null,
      prefixIcon: Icons.home,
    );
  }

  static AppDropdown<String> relationship({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customRelationships,
  }) {
    // Backend accepts only: 'mother', 'father', 'guardian' (lowercase)
    final defaultRelationships = [
      'mother',
      'father',
      'guardian',
    ];

    return AppDropdown<String>(
      value: value,
      items: customRelationships ?? defaultRelationships,
      label: 'Relationship to Child *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select your relationship to the child' : null,
      prefixIcon: Icons.family_restroom,
      // Capitalize first letter for display
      itemLabelBuilder: (String item) {
        return item[0].toUpperCase() + item.substring(1);
      },
    );
  }

  static AppDropdown<String> subject({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customSubjects,
  }) {
    final defaultSubjects = [
      'Mathematics',
      'Science',
      'English',
      'Hindi',
      'Social Studies',
      'Physics',
      'Chemistry',
      'Biology',
      'Computer Science',
      'Physical Education',
      'History',
      'Geography',
      'Economics',
      'Political Science',
      'Sanskrit',
      'French',
      'German',
      'Art & Craft',
      'Music',
      'Dance',
      'Environmental Science',
      'Psychology',
      'Sociology',
      'Philosophy',
      'Statistics',
      'Business Studies',
      'Accountancy',
    ];

    return AppDropdown<String>(
      value: value,
      items: customSubjects ?? defaultSubjects,
      label: 'Subject *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a subject' : null,
      prefixIcon: Icons.book,
    );
  }

  static AppDropdown<String> category({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return AppDropdown<String>(
      value: value,
      items: const ['General', 'SC', 'ST', 'OBC', 'EWS'],
      label: 'Category *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select category' : null,
      prefixIcon: Icons.category,
    );
  }

  static AppDropdown<String> academicYear({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customYears,
  }) {
    final defaultYears = [
      '2023-2024',
      '2024-2025',
      '2025-2026',
      '2026-2027',
      '2027-2028',
      '2028-2029'
    ];

    return AppDropdown<String>(
      value: value,
      items: customYears ?? defaultYears,
      label: 'Academic Year *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select an academic year' : null,
      prefixIcon: Icons.calendar_today,
    );
  }

  static AppDropdown<String> classGrade({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customClasses,
  }) {
    final defaultClasses = [
      'Nursery', 'LKG', 'UKG',
      '1st Grade', '2nd Grade', '3rd Grade', '4th Grade',
      '5th Grade', '6th Grade', '7th Grade', '8th Grade',
      '9th Grade', '10th Grade', '11th Grade', '12th Grade'
    ];

    return AppDropdown<String>(
      value: value,
      items: customClasses ?? defaultClasses,
      label: 'Class to be Admitted In *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a class' : null,
      prefixIcon: Icons.school,
    );
  }

  static AppDropdown<String> studentType({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customTypes,
  }) {
    final defaultTypes = ['New', 'Transfer'];

    return AppDropdown<String>(
      value: value,
      items: customTypes ?? defaultTypes,
      label: 'Student Type *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select student type' : null,
      prefixIcon: Icons.person_add,
    );
  }

  static AppDropdown<String> bloodGroup({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return AppDropdown<String>(
      value: value,
      items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
      label: 'Blood Group',
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.bloodtype,
    );
  }

  static AppDropdown<String> religion({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customReligions,
  }) {
    final defaultReligions = [
      'Hinduism',
      'Islam',
      'Christianity',
      'Sikhism',
      'Buddhism',
      'Jainism',
      'Judaism',
      'Zoroastrianism',
      'Other',
      'Prefer not to say',
    ];

    return AppDropdown<String>(
      value: value,
      items: customReligions ?? defaultReligions,
      label: 'Religion',
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.account_balance,
    );
  }

  static AppDropdown<String> nationality({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customNationalities,
  }) {
    final defaultNationalities = [
      'Indian',
      'American',
      'British',
      'Canadian',
      'Australian',
      'German',
      'French',
      'Japanese',
      'Chinese',
      'Other',
    ];

    return AppDropdown<String>(
      value: value,
      items: customNationalities ?? defaultNationalities,
      label: 'Nationality',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select nationality' : null,
      prefixIcon: Icons.flag,
    );
  }

  static AppDropdown<String> maritalStatus({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return AppDropdown<String>(
      value: value,
      items: const ['Single', 'Married', 'Divorced', 'Widowed', 'Separated'],
      label: 'Marital Status',
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.favorite,
    );
  }

  static AppDropdown<String> qualification({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customQualifications,
  }) {
    final defaultQualifications = [
      'Below 10th',
      '10th Pass',
      '12th Pass',
      'Diploma',
      'Graduate',
      'Post Graduate',
      'Professional Degree',
      'Doctorate',
    ];

    return AppDropdown<String>(
      value: value,
      items: customQualifications ?? defaultQualifications,
      label: 'Educational Qualification',
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.school,
    );
  }

  static AppDropdown<String> occupation({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customOccupations,
  }) {
    final defaultOccupations = [
      'Government Service',
      'Private Service',
      'Business',
      'Professional',
      'Farmer',
      'Teacher',
      'Doctor',
      'Engineer',
      'Lawyer',
      'Retired',
      'Housewife/Homemaker',
      'Self Employed',
      'Unemployed',
      'Other',
    ];

    return AppDropdown<String>(
      value: value,
      items: customOccupations ?? defaultOccupations,
      label: 'Occupation',
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.work,
    );
  }

  static AppDropdown<String> section({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customSections,
  }) {
    final defaultSections = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

    return AppDropdown<String>(
      value: value,
      items: customSections ?? defaultSections,
      label: 'Section *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select section' : null,
      prefixIcon: Icons.class_,
    );
  }

  static AppDropdown<String> medium({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customMediums,
  }) {
    final defaultMediums = ['English', 'Hindi', 'Regional Language', 'Bilingual'];

    return AppDropdown<String>(
      value: value,
      items: customMediums ?? defaultMediums,
      label: 'Medium of Instruction *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select medium' : null,
      prefixIcon: Icons.language,
    );
  }

  static AppDropdown<String> stream({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customStreams,
  }) {
    final defaultStreams = ['Science', 'Commerce', 'Arts', 'Vocational'];

    return AppDropdown<String>(
      value: value,
      items: customStreams ?? defaultStreams,
      label: 'Stream *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select stream' : null,
      prefixIcon: Icons.trending_up,
    );
  }

  static AppDropdown<String> sportType({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customSportTypes,
  }) {
    final defaultSportTypes = [
      'Football',
      'Basketball',
      'Cricket',
      'Tennis',
      'Swimming',
      'Athletics',
      'Badminton',
      'Volleyball',
      'Hockey',
      'Table Tennis',
      'Baseball',
      'Rugby',
      'Wrestling',
      'Boxing',
      'Gymnastics',
      'Cycling',
      'Running',
      'Chess',
      'Kabaddi',
      'Kho Kho',
    ];

    return AppDropdown<String>(
      value: value,
      items: customSportTypes ?? defaultSportTypes,
      label: 'Sport Type *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select sport type' : null,
      prefixIcon: Icons.sports,
    );
  }

  static AppDropdown<NotificationType> notificationType({
    required NotificationType? value,
    required ValueChanged<NotificationType?> onChanged,
    String? Function(NotificationType?)? validator,
  }) {
    return AppDropdown<NotificationType>(
      value: value,
      items: NotificationType.values,
      label: 'Notification Type *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select notification type' : null,
      prefixIcon: Icons.notifications,
      itemLabelBuilder: (NotificationType type) {
        switch (type) {
          case NotificationType.announcement:
            return 'Announcement';
          case NotificationType.testDate:
            return 'Test Date';
          case NotificationType.holiday:
            return 'Holiday';
          case NotificationType.assignment:
            return 'Assignment';
          case NotificationType.urgent:
            return 'Urgent';
          case NotificationType.general:
            return 'General';
        }
      },
    );
  }

  static AppDropdown<String> notificationRecipients({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customRecipients,
  }) {
    final defaultRecipients = [
      'All Students',
      'All Teachers',
      'All Parents',
      'Class 10-A',
      'Class 10-B',
      'Class 9-A',
      'Class 9-B',
      'Class 8-A',
      'Class 8-B',
      'Class 7-A',
      'Class 7-B',
      'Specific Students',
      'Specific Teachers',
      'Specific Parents',
    ];

    return AppDropdown<String>(
      value: value,
      items: customRecipients ?? defaultRecipients,
      label: 'Recipients *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select recipients' : null,
      prefixIcon: Icons.people,
    );
  }

  static AppDropdown<String> teacher({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customTeachers,
  }) {
    final defaultTeachers = [
      'Mr. Rajesh Kumar',
      'Ms. Priya Sharma',
      'Dr. Anil Gupta',
      'Mrs. Sunita Patel',
      'Mr. Vikram Singh',
      'Ms. Neha Agarwal',
      'Dr. Ramesh Verma',
      'Mrs. Kavita Joshi',
      'Mr. Suresh Reddy',
      'Ms. Anjali Mishra',
      'Dr. Manoj Tiwari',
      'Mrs. Rekha Sinha',
      'Mr. Ashok Pandey',
      'Ms. Deepika Rani',
      'Dr. Sanjay Mehta',
    ];

    return AppDropdown<String>(
      value: value,
      items: customTeachers ?? defaultTeachers,
      label: 'Select Teacher *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a teacher' : null,
      prefixIcon: Icons.person,
    );
  }

  static AppDropdown<String> department({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customDepartments,
  }) {
    final defaultDepartments = [
      'Mathematics',
      'Science',
      'English',
      'Hindi',
      'Social Studies',
      'Computer Science',
      'Physical Education',
      'Arts & Crafts',
      'Music',
      'Languages',
      'Commerce',
      'Administration',
      'Library',
      'Laboratory',
      'Sports',
    ];

    return AppDropdown<String>(
      value: value,
      items: customDepartments ?? defaultDepartments,
      label: 'Select Department *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a department' : null,
      prefixIcon: Icons.business,
    );
  }

  static AppDropdown<String> timeSlot({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customTimeSlots,
  }) {
    final defaultTimeSlots = [
      '08:00 AM - 08:45 AM',
      '08:45 AM - 09:30 AM',
      '09:30 AM - 10:15 AM',
      '10:15 AM - 11:00 AM',
      '11:00 AM - 11:15 AM',
      '11:15 AM - 12:00 PM',
      '12:00 PM - 12:45 PM',
      '12:45 PM - 01:30 PM',
      '01:30 PM - 02:15 PM',
      '02:15 PM - 03:00 PM',
      '03:00 PM - 03:45 PM',
      '03:45 PM - 04:30 PM',
    ];

    return AppDropdown<String>(
      value: value,
      items: customTimeSlots ?? defaultTimeSlots,
      label: 'Select Time Slot *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a time slot' : null,
      prefixIcon: Icons.access_time,
    );
  }

  static AppDropdown<String> dayOfWeek({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customDays,
  }) {
    final defaultDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    return AppDropdown<String>(
      value: value,
      items: customDays ?? defaultDays,
      label: 'Select Day *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a day' : null,
      prefixIcon: Icons.calendar_today,
    );
  }

  static AppDropdown<String> classroom({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customClassrooms,
  }) {
    final defaultClassrooms = [
      'Room 101',
      'Room 102',
      'Room 103',
      'Room 201',
      'Room 202',
      'Room 203',
      'Lab 1 - Computer',
      'Lab 2 - Physics',
      'Lab 3 - Chemistry',
      'Lab 4 - Biology',
      'Library',
      'Auditorium',
      'Gymnasium',
      'Music Room',
      'Art Room',
    ];

    return AppDropdown<String>(
      value: value,
      items: customClassrooms ?? defaultClassrooms,
      label: 'Select Classroom *',
      onChanged: onChanged,
      validator: validator ?? (value) => value == null ? 'Please select a classroom' : null,
      prefixIcon: Icons.room,
    );
  }

  static AppDropdown<String> teacherDesignation({
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    List<String>? customDesignations,
  }) {
    final defaultDesignations = [
      'Teacher',
      'Senior Teacher',
      'Head of Department',
      'Assistant Professor',
      'Associate Professor',
      'Professor',
      'Principal',
      'Vice Principal',
      'Coordinator',
      'Subject Expert',
      'Guest Lecturer',
    ];

    return AppDropdown<String>(
      value: value,
      items: customDesignations ?? defaultDesignations,
      label: 'Designation (Optional)',
      onChanged: onChanged,
      validator: validator,
      prefixIcon: Icons.badge,
    );
  }

  // Generic factory constructor for custom dropdowns
  static AppDropdown<T> custom<T>({
    required T? value,
    required List<T> items,
    required String label,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
    String? hintText,
    bool enabled = true,
    double? height,
    String Function(T)? itemLabelBuilder,
    Widget Function(T)? itemBuilder,
    IconData? prefixIcon, // Added prefix icon parameter
  }) {
    return AppDropdown<T>(
      value: value,
      items: items,
      label: label,
      onChanged: onChanged,
      validator: validator,
      hintText: hintText,
      enabled: enabled,
      height: height,
      itemLabelBuilder: itemLabelBuilder,
      itemBuilder: itemBuilder,
      prefixIcon: prefixIcon, // Added prefix icon parameter
    );
  }
}