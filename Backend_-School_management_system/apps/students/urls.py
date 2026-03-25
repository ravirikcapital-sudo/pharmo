# apps/students/urls.py

from django.urls import path,include
from .views import (
    StudentViewSet,
    StudentsByClassView,
    AssignmentListCreateView,
    AssignmentSubmitView,
    AssignmentSubmissionsListView,
)
from rest_framework.routers import DefaultRouter


router = DefaultRouter()
router.register(r"", StudentViewSet, basename="students")

urlpatterns = [
    path("", include(router.urls)),
    path('by-class/', StudentsByClassView.as_view(), name='students-by-class'),

    # Assignments
    path('assignments/', AssignmentListCreateView.as_view(), name='assignments-list-create'),
    path('assignments/<int:pk>/submit/', AssignmentSubmitView.as_view(), name='assignment-submit'),
    path('assignments/<int:pk>/submissions/', AssignmentSubmissionsListView.as_view(), name='assignment-submissions'),
]
