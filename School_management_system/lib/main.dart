import 'package:flutter/material.dart';
import 'package:school/AdminDashboardPages/academicOption.dart';
import 'package:school/AdminDashboardPages/academicResults.dart';
import 'package:school/AdminDashboardPages/addDesignation.dart';
import 'package:school/AdminDashboardPages/addTeacher.dart';
import 'package:school/AdminDashboardPages/addTimeTable.dart';
import 'package:school/AdminDashboardPages/addNewApplicant.dart';
import 'package:school/AdminDashboardPages/classAndSectionManagement.dart';
import 'package:school/AdminDashboardPages/documentSubmitted.dart';
import 'package:school/AdminDashboardPages/employmentManagement.dart';
import 'package:school/AdminDashboardPages/feeManagement.dart';
import 'package:school/AdminDashboardPages/feeStructureManagement.dart';
import 'package:school/AdminDashboardPages/pendingAdmissions.dart';
import 'package:school/AdminDashboardPages/profileAdmin.dart';
import 'package:school/AdminDashboardPages/reportAndAnalytics.dart';
import 'package:school/AdminDashboardPages/salaryManagementAdmin.dart';
import 'package:school/AdminDashboardPages/studentManagement.dart';
import 'package:school/AdminDashboardPages/systemControl.dart';
import 'package:school/AdminDashboardPages/systemHealth.dart';
import 'package:school/AdminDashboardPages/userRequest.dart';
import 'package:school/Admission/admissionBasicInfo.dart';
import 'package:school/Admission/admissionContactScreen.dart';
import 'package:school/Admission/admissionDocumentsScreen.dart';
import 'package:school/Admission/admissionMainScreen.dart';
import 'package:school/Admission/admissionParentInfo.dart';
import 'package:school/Admission/admissionPaymentsScreen.dart';
import 'package:school/Admission/checkAdmissionStatus.dart';
import 'package:school/Dashboard/academicOfficerDashboard.dart';
import 'package:school/Dashboard/adminDashboard.dart';
import 'package:school/Dashboard/parentsDashBoard.dart';
import 'package:school/Dashboard/studentDashboard.dart';
import 'package:school/Dashboard/teacherDashboard.dart';
import 'package:school/Help/parentHelp.dart';
import 'package:school/Help/schoolHelp.dart';
import 'package:school/Screens/Notifications.dart';
import 'package:school/Screens/changePasswordScreen.dart';
import 'package:school/Screens/complaintPage.dart';
import 'package:school/Screens/forgetPassword.dart';
import 'package:school/Screens/loginScreen.dart';
import 'package:school/Screens/mainChat.dart';
import 'package:school/Screens/setting.dart';
import 'package:school/SignUp/academicOfficerSignUp.dart';
import 'package:school/SignUp/adminSignUp.dart';
import 'package:school/SignUp/mainSignUpPage.dart';
import 'package:school/SignUp/parentSignUp.dart';
import 'package:school/SignUp/studentSignUp.dart';
import 'package:school/SignUp/teacherSignUp.dart';
import 'package:school/StudentDashboardPages/attendanceStudent.dart';
import 'package:school/StudentDashboardPages/feeManagementStudent/feeManagementStudent.dart';
import 'package:school/StudentDashboardPages/noticeAndMessages.dart';
import 'package:school/StudentDashboardPages/profileStudent.dart';
import 'package:school/StudentDashboardPages/progressReport.dart';
import 'package:school/StudentDashboardPages/subjectAndMarks.dart';
import 'package:school/StudentDashboardPages/timeTableStudent.dart';
import 'package:school/academicOfficerDashboardPages/attendanceReport.dart';
import 'package:school/academicOfficerDashboardPages/classroomReportAcademicOfficer.dart';
import 'package:school/academicOfficerDashboardPages/profileAcademicOfficer.dart';
import 'package:school/academicOfficerDashboardPages/sendNotificationAcademicOfficer.dart';
import 'package:school/academicOfficerDashboardPages/teacherPerformance.dart';
import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart' show Employee;
import 'package:school/parentDashboardPages/academicPerformanceOfStudent.dart';
import 'package:school/parentDashboardPages/attendanceManagementParent.dart';
import 'package:school/parentDashboardPages/feeManagementParent.dart';
import 'package:school/parentDashboardPages/homeworkAndAssignment.dart';
import 'package:school/parentDashboardPages/parentCommunity.dart';
import 'package:school/parentDashboardPages/parentFeedbackScreen.dart';
import 'package:school/schoolDetails.dart';
import 'package:school/splashScreen.dart';
import 'package:school/studentConnectionTry.dart'; //Student connection with backend trial
import 'package:school/teacherDashboardPages/attendanceTeacher.dart';
import 'package:school/teacherDashboardPages/messageTeacher.dart';
import 'package:school/teacherDashboardPages/profileTeacher.dart';
import 'package:school/teacherDashboardPages/resultEntryTeacher.dart';
import 'package:school/teacherDashboardPages/studentAttendanceMarking.dart';
import 'package:school/teacherDashboardPages/subjectListTeacher.dart';
import 'package:school/teacherDashboardPages/teacherCampaign.dart';
import 'package:school/teacherDashboardPages/teacherSalary.dart';
import 'package:school/teacherDashboardPages/timeTableTeacher.dart';
import 'academicOfficerDashboardPages/ExamManagementAcademicOfficer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: SplashScreen(),
      // home: MainChat(),
      // home: AppSettingsPage(),
      // home: Notifications(),
      //home: StudentListScreen(), //try for student connection
      routes: {
        '/login': (context) => LoginPage(),
        '/change-password': (context) => ChangePasswordPage(),
        '/school-details': (context) => AboutSchool(),
        '/school-help': (context) => SchoolHelpPage(),
        '/parent-help': (context) => ParentHelpPage(),
        '/main-signup': (context) => MainSignUpPage(),
        '/admin-signup': (context) => AdminSignupPage(),
        '/academic-officer-signup': (context) => AcademicOfficerSignupPage(),
        '/teacher-signup': (context) => TeacherSignupPage(),
        '/student-signup': (context) => StudentSignupPage(),
        '/parent-signup': (context) => ParentSignUpPage(),
        '/admin-dashboard': (context) => AdminDashboard(),
        '/student-dashboard': (context) => StudentDashboard(),
        '/teacher-dashboard': (context) => TeacherDashboard(),
        '/academic-officer-dashboard': (context) => AcademicOfficerDashboard(),
        '/parent-dashboard': (context) => ParentDashboard(),
        '/admission-main': (context) => AdmissionMainScreen(),
        '/admission-basic': (context) => AdmissionBasicInfoScreen(),
        '/admission-parent': (context) => AdmissionParentInfoScreen(),
        '/admission-contact': (context) => AdmissionContactScreen(),
        // '/admission-documents': (context) => AdmissionDocumentsScreen(),
        '/payment-page': (context) => AdmissionPaymentsScreen(),
        '/check-admission-status': (context) => AdmissionStatusScreen(),
        '/forget-password': (context) => ForgotPasswordScreen(),
        '/admin-employee-management': (context) => EmploymentManagementPage(),
        '/admin-student-management': (context) => ClassManagementPage(),
        '/admin-student-management-student-list':
            (context) => ClassManagementPage(),
        '/admin-class-section-management':
            (context) => ClassSectionManagementPage(),
        '/admin-academic-result-screen': (context) => AcademicResultsScreen(),
        '/admin-report-analytics': (context) => AdminReportsAnalytics(),
        '/admin-system-control': (context) => SystemControlsPage(),
        '/admin-fee-management': (context) => FeeManagementPage(),
        '/admin-add-student-applicant': (context) => AddNewApplicantScreen(),
        '/admin-add-teacher': (context) => AddTeacherScreen(),
        '/admin-add-designation': (context) => AddDesignationPage(),
        '/admin-user-request': (context) => UserRequestsPage(),
        '/admin-add-timetable': (context) => AddTimeTableScreen(),
        '/admin-pending-admission': (context) => PendingAdmissionsPage(),
        '/admin-system-health': (context) => SystemHealthScreen(),
        '/admin-profile': (context) => AdminProfilePage(),
        '/admin-salary-management': (context) => SalaryManagementPage(),
        '/admin-fee-structure': (context) => FacilitiesManagementPage(),
        '/admin-document-submitted': (context) => DocumentSubmitted(),
        '/academic-options': (context) => AcademicScreen(),
        '/student-subject-marks': (context) => SubjectsMarksScreen(),
        '/student-notice-message': (context) => NoticesMessage(),
        '/student-fee-management': (context) => FeeManagementScreenStudent(),
        '/student-profile': (context) => StudentProfilePage(),
        '/student-timetable': (context) => TimeTableStudentScreen(),
        '/student-progress-report': (context) => StudentResultsPage(),
        '/student-attendance-report': (context) => StudentAttendanceReport(),
        '/teacher-attendance': (context) => AttendancePageTeacher(),
        '/teacher-result-entry': (context) => ResultEntryPage(),
        '/teacher-message': (context) => MessagePageTeacher(),
        '/teacher-timetable': (context) => TeacherTimetablePage(),
        '/teacher-profile': (context) => TeacherProfilePage(),
        '/teacher-subject-management': (context) => SubjectManagementPage(),
        '/teacher-salary': (context) => SalaryManagementScreenTeacher(),
        '/teacher-campaign': (context) => StudentDetailsCollectionPage(),
        '/teacher-mark-attendance': (context) => TeacherMarkAttendancePage(),
        '/academic-officer-teacher-performance':
            (context) => TeacherPerformanceScreen(),
        '/academic-officer-classroom-report':
            (context) => ClassroomReportsScreen(),
        '/academic-officer-exam-management-screen':
            (context) => ExamManagementScreen(),
        '/academic-officer-notification': (context) => NotificationsScreen(),
        '/academic-officer-profile': (context) => AcademicOfficerProfilePage(),
        '/academic-officer-attendance-reports': (context) => AttendanceReport(),
        '/parent-fee-management': (context) => FeePaymentParentPage(),
        '/parent-community': (context) => ParentCommunity(),
        '/parent-student-performance': (context) => StudentPerformance(),
        '/parent-homework-tracking': (context) => HomeworkTrackingPage(),
        '/parent-attendance': (context) => StudentAttendance(),
        '/parent-feedback': (context) => ParentFeedbackPage(),
        '/notifications': (context) => Notifications(),
        '/main-chat': (context) => MainChat(),
        '/settings': (context) => AppSettingsPage(),
        '/complain': (context) => ComplaintPage(),
      },
    );
  }
}
