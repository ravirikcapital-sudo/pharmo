# apps/fees/urls.py

from django.urls import path
from .views import (
    ClassFeeStructureView,
    StudentFeeListCreateView,
    StudentFeeDetailView,
    PaymentCreateView,
    MonthlyFeeStatusView
)

urlpatterns = [
    path("fee-structure/", ClassFeeStructureView.as_view()),
    path("student-fees/", StudentFeeListCreateView.as_view()),
    path("student-fees/<int:pk>/", StudentFeeDetailView.as_view()),
    path("payment/", PaymentCreateView.as_view()),
    path("monthly-status/", MonthlyFeeStatusView.as_view()),
]
