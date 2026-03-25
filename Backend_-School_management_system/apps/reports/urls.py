from django.urls import path
from .views import OverviewReportAPIView,AcademicReportAPIView,FinancialReportAPIView,EnrollmentReportAPIView,TeachersReportAPIView

urlpatterns = [
    path("overview/", OverviewReportAPIView.as_view()),
    path("academic/", AcademicReportAPIView.as_view()),
    path("financial/", FinancialReportAPIView.as_view()),
    path("enrollment/", EnrollmentReportAPIView.as_view()),
    path("teachers/", TeachersReportAPIView.as_view()),
    # path("classroom-report/", ClassroomReportAPIView.as_view()),
]
