from django.urls import path
from .views import RoleBasedDashboardRedirectView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('redirect/', RoleBasedDashboardRedirectView.as_view(), name='role-based-dashboard'),
]
