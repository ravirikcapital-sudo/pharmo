from django.urls import path
from .views import *

urlpatterns = [
    path("students/mark/", MarkStudentAttendanceView.as_view()),

    path("teacher/check-in/", TeacherCheckInView.as_view()),
    path("teacher/check-out/", TeacherCheckOutView.as_view()),

    path("employee/check-in/", EmployeeCheckInView.as_view()),
    path("employee/check-out/", EmployeeCheckOutView.as_view()),

    path("leave/apply/teacher/", TeacherLeaveCreateView.as_view()),
    path("leave/apply/employee/", EmployeeLeaveCreateView.as_view()),

    path(
        "student/<int:student_id>/percentage/",
        StudentAttendancePercentageView.as_view(),
    ),
    path(
        "class/percentage/",
        ClassAttendancePercentageView.as_view(),
    ),
    
     path(
        "monthly/report/students/",
        StudentMonthlyReportView.as_view(),
        name="student-monthly-report"
    ),
    path(
        "monthly/report/teachers/",
        TeacherMonthlyReportView.as_view(),
        name="teacher-monthly-report"
    ),
    
    
]   
