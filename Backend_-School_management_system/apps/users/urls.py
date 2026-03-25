# apps/users/urls.py

from django.urls import path
from .views import (
    RegisterUserView,
    CurrentUserView,
    LogoutView,
    ChangePasswordView,
    PendingUserRequestsAPIView,
    ApproveUserAPIView,
    DeclineUserAPIView,
    ModifyUserRoleAPIView,
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('signup/', RegisterUserView.as_view(), name='signup'),
    path('login/', TokenObtainPairView.as_view(), name='login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('me/', CurrentUserView.as_view(), name='current_user'),
    path('change-password/', ChangePasswordView.as_view(), name='change_password'),
    path('user-requests/', PendingUserRequestsAPIView.as_view(),name="User-request"),
    path('approve-user/<int:user_id>/', ApproveUserAPIView.as_view(),name="User-request-approval"),
    path('decline-user/<int:user_id>/', DeclineUserAPIView.as_view(),name="User-request-decline"),
    path('modify-user/<int:user_id>/', ModifyUserRoleAPIView.as_view(),name="User-request-modify"),
]
