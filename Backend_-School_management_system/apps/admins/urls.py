from django.urls import path
from .views import (
    AdminDashboardView,
    AdminClassListView,
    AdminStudentListView,
    AdminStudentDetailView,
    AdminProfileAPIView
)

urlpatterns = [
    path("", AdminDashboardView.as_view()),
    path("classes/", AdminClassListView.as_view()),
    path("classes/<int:class_id>/students/", AdminStudentListView.as_view()),
    path("students/<int:pk>/", AdminStudentDetailView.as_view()),
    path('profile/', AdminProfileAPIView.as_view()),
]