from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    FacilityListCreateView,
    FacilityDetailView,
    ClassRoomListCreateView,
    ClassRoomDetailView,
    ClassRoomStudentsView
)

urlpatterns = [
    path("", FacilityListCreateView.as_view(), name="facility-list"),
    path("<int:pk>/", FacilityDetailView.as_view(), name="facility-detail"),
    path("classroom/", ClassRoomListCreateView.as_view(), name="classroom-list"),
    path("classroom/<int:pk>/", ClassRoomDetailView.as_view(), name="classroom-detail"),
    path(
        "classroom/<int:class_id>/students/",
        ClassRoomStudentsView.as_view(),
        name="classroom-students",
    ),
]
