from django.urls import path
from .views import (
    NotificationListView,
    RecentNoticesView,
)

urlpatterns = [
    path("", NotificationListView.as_view(), name="notifications"),
    path("recent/", RecentNoticesView.as_view(), name="recent-notices"),
]
