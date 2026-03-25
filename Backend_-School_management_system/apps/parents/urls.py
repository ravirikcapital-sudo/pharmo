from django.urls import path
from .views import (
    ParentRegisterView, ParentLoginView, ParentChildView,
    ParentChildrenListView, ParentAttendanceSummaryView,
    ParentExamResultsView, ParentStudentTimetableView, ParentStudentPerformanceView, ParentStudentMonthlyAttendanceView, ComplaintListView,
)
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('register/', ParentRegisterView.as_view(), name='parent-register'),
    path('login/', ParentLoginView.as_view()),
    path('child/', ParentChildView.as_view(), name='parent-child-details'),
    path('children/', ParentChildrenListView.as_view(), name='parent-children-list'),
    path('children/<int:student_id>/attendance/', ParentAttendanceSummaryView.as_view(), name='parent-student-attendance'),
    path('children/<int:student_id>/exams/', ParentExamResultsView.as_view(), name='parent-student-exams'),
    path('children/<int:student_id>/timetable/', ParentStudentTimetableView.as_view(), name='parent-student-timetable'),
    path('student-performance/', ParentStudentPerformanceView.as_view(), name='parent-student-performance'),
    path('student-attendance/monthly/', ParentStudentMonthlyAttendanceView.as_view(), name='parent-student-attendance-monthly'),
    path('complaints/', ComplaintListView.as_view(), name='parent-complaints-list'),
]

