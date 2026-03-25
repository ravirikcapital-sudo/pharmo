from django.urls import path,include
from .views import TimetableListCreateView,StudentTimetableListCreateView,StudentTimetableUpdateView

urlpatterns = [
    path("create/",TimetableListCreateView.as_view(),name="create-timetable"),
    path("student/timetable/",StudentTimetableListCreateView.as_view(),name="student-timetable-list-create"),
    path("student/timetable/<int:pk>/update/",StudentTimetableUpdateView.as_view(),name="student-timetable-update"),
]
