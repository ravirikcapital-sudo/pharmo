# apps/teachers/urls.py

from django.urls import path, include
from .views import StudentApplicantListView, StudentApplicantCreateView,TeacherRegisterView,TeacherLoginView,TeacherListView,TeacherProfileView,TeacherMyProfileView,TeacherUpdateProfileView,TeacherDashboardView,AdminCreateTeacherView,AdminCreateDesignationView
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
# router.register(
#     "admin/teacher-salary",
#     AdminTeacherSalaryViewSet,
#     basename="admin-teacher-salary"
# )

urlpatterns = [
    #salary
    # path("my-salary/",TeacherMySalaryView.as_view(),name="my-salary"),
    path('lists/',TeacherListView.as_view(),name="teacher-list"),
    path('register/', TeacherRegisterView.as_view(), name='teacher_register'),
    # path('profile/', TeacherProfileView.as_view(), name='teacher_profile'),
    path('login/', TeacherLoginView.as_view(), name='teacher-login'),   
    # path('attendance/mark/', MarkAttendanceView.as_view(), name='mark-attendance'),
    # path('checkout/', AttendanceCheckoutView.as_view(), name='attendance-checkout'),
    # path('history/', AttendanceHistoryView.as_view(), name='attendance-history'),
    # path('leave/apply/', LeaveCreateView.as_view(), name='leave-apply'),
    # path('leave/substitutes/', SubstituteTeacherListView.as_view(), name='substitute-list'),
    # path('classrooms/', views.ClassRoomListCreateView.as_view(), name='classroom-list-create'),
    # path('classrooms/<int:pk>/', views.ClassRoomDetailView.as_view(), name='classroom-detail'),
    # path('classrooms/<int:class_id>/students/', views.ClassRoomStudentsView.as_view(), name='classroom-students'),
    # path('classrooms/<int:classroom_id>/add-student/', AddStudentToClassroomView.as_view(), name='add-student'),
    # path("timetable/create/", TimetableCreateView.as_view(), name="create-timetable"),
    # path("timetable/all/", TimetableListView.as_view(), name="all-timetables"),
    # path(
    #     "timetable/",
    #     TimetableListCreateView.as_view(),
    #     name="timetable-list-create"
    # ),
    # path(
    #     "student/timetable/",
    #     StudentTimetableListCreateView.as_view(),
    #     name="student-timetable-list-create"
    # ),
    # path(
    #     "student/timetable/<int:pk>/update/",
    #     StudentTimetableUpdateView.as_view(),
    #     name="student-timetable-update"
    # ),
    # # Add class url #
    # path("academic/classroom/create/", CreateAcademicClassroomView.as_view(), name="create-academic-classroom"),
    path("create-teacher/",AdminCreateTeacherView.as_view(),name="create-teacher"),
    path("designation/",AdminCreateDesignationView.as_view(),name="designation"),


    # Add Subject urls #
    # path('add-subject/', SubjectCreateView.as_view(), name='create-subject'),
    # path('subject/list/', SubjectListView.as_view(), name='list-subjects'),    

    # # Sport Groups url #
    # path('add-sport-group/', CreateSportGroupView.as_view(), name='add-sport-group'),

    # # House Groups url #
    # path('house-group/create/', CreateHouseGroupView.as_view(), name='create-house-group'),

    # Add Applicant url #
    path("applicants/", StudentApplicantListView.as_view(), name="applicant-list"),
    path("applicants/add/", StudentApplicantCreateView.as_view(), name="applicant-create"),
    path("profile/", TeacherProfileView.as_view(), name="teacher-profile"),
    path("my-profile/", TeacherMyProfileView.as_view(), name="teacher-my-profile"),
    path("update-profile/", TeacherUpdateProfileView.as_view(), name="teacher-update-profile"),

# Dashboard API
    path("dashboard/", TeacherDashboardView.as_view(), name="teacher-dashboard"),

# Salary list (if you want separate from my-salary)
    # path("salary/", TeacherSalaryListView.as_view(), name="teacher-salary"),
    #Subject url#
    # path('subjects/', SubjectListCreateView.as_view(), name='subject-list-create'),
    # path('subjects/<int:id>/', SubjectDetailView.as_view(), name='subject-detail'),
    path('', include(router.urls)),
]

