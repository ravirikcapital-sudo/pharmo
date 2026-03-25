from rest_framework import generics
from apps.users.models import CustomUser
from apps.users.serializers import UserSerializer
from .models import UserLoginActivity, Announcement, SystemSetting
from .serializers import (
    UserLoginActivitySerializer,
    AnnouncementSerializer,
    SystemSettingSerializer,
)


# =====================================================
# USER ROLES (All Users Listing)
# =====================================================

class UserListCreateView(generics.ListCreateAPIView):
    """
    List all users with role display
    Create new user (optional)
    """
    queryset = CustomUser.objects.all().order_by("-joining_date")
    serializer_class = UserSerializer


class UserRetrieveUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    """
    Retrieve / Update / Delete user
    """
    queryset = CustomUser.objects.all()
    serializer_class = UserSerializer


# =====================================================
# USER LOGIN HISTORY
# =====================================================

class UserLoginActivityListView(generics.ListAPIView):
    """
    Show all login activity
    """
    queryset = UserLoginActivity.objects.select_related("user").all().order_by("-logged_in_at")
    serializer_class = UserLoginActivitySerializer


class UserLoginActivityByUserView(generics.ListAPIView):
    """
    Show login activity of specific user
    """
    serializer_class = UserLoginActivitySerializer

    def get_queryset(self):
        user_id = self.kwargs["user_id"]
        return UserLoginActivity.objects.filter(
            user_id=user_id
        ).order_by("-logged_in_at")


# =====================================================
# ANNOUNCEMENTS
# =====================================================

class AnnouncementListCreateView(generics.ListCreateAPIView):
    queryset = Announcement.objects.all().order_by("-created_at")
    serializer_class = AnnouncementSerializer


class AnnouncementRetrieveUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer


# =====================================================
# SYSTEM SETTINGS
# =====================================================

class SystemSettingListCreateView(generics.ListCreateAPIView):
    queryset = SystemSetting.objects.all()
    serializer_class = SystemSettingSerializer


class SystemSettingRetrieveUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = SystemSetting.objects.all()
    serializer_class = SystemSettingSerializer
