from django.urls import path
from .views import (
    ExamListCreateView,
    ExamDetailView,
    StudentExamResultCreateView,
    StudentExamReportView,
    ExamStatisticsView,
)

urlpatterns = [
    # Exams
    path("exams/", ExamListCreateView.as_view()),
    path("exams/<int:pk>/", ExamDetailView.as_view()),

    # Marks Entry
    path("results/", StudentExamResultCreateView.as_view()),

    # Student Report
    path("report/", StudentExamReportView.as_view()),

    # Statistics
    path("statistics/", ExamStatisticsView.as_view()),
]
