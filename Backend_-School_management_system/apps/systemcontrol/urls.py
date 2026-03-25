from django.urls import path
from .views import *

urlpatterns = [

    # USERS
    path("users/", UserListCreateView.as_view()),
    path("users/<int:pk>/", UserRetrieveUpdateDeleteView.as_view()),

    # LOGIN HISTORY
    path("login-history/", UserLoginActivityListView.as_view()),
    path("login-history/<int:user_id>/", UserLoginActivityByUserView.as_view()),

    # ANNOUNCEMENTS
    path("announcements/", AnnouncementListCreateView.as_view()),
    path("announcements/<int:pk>/", AnnouncementRetrieveUpdateDeleteView.as_view()),

    # SYSTEM SETTINGS
    path("settings/", SystemSettingListCreateView.as_view()),
    path("settings/<int:pk>/", SystemSettingRetrieveUpdateDeleteView.as_view()),
]
