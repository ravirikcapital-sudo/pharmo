from django.urls import path
from .views import (
    SchoolClassCreateAPIView,
    SubjectListCreateAPIView,
    SubjectDetailAPIView,
    SportsGroupListCreateAPIView,
    HouseGroupListCreateAPIView,
    AcademicDashboardAPIView,
)

urlpatterns = [
    # Classes
    path("classes/create/", SchoolClassCreateAPIView.as_view()),

    # Subjects (ONLY ONE SET – NO DUPLICATES)
    path("subjects/", SubjectListCreateAPIView.as_view()),
    path("subjects/<int:id>/", SubjectDetailAPIView.as_view()),

    # Sports & House
    path("sports/", SportsGroupListCreateAPIView.as_view()),
    path("houses/", HouseGroupListCreateAPIView.as_view()),

    # Dashboard
    path("dashboard/", AcademicDashboardAPIView.as_view()),
]
