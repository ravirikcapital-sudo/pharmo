from rest_framework.routers import DefaultRouter
from django.urls import path, include
from .views import (
    EmployeeSalaryViewSet,
    TeacherSalaryViewSet,
    AdminEmployeeSalaryViewSet,
    AdminTeacherSalaryViewSet,
    SalaryDashboardView,
    EmployeeMySalaryView,
    TeacherMySalaryView,
)

router = DefaultRouter()

# ===============================
# NORMAL SALARY ROUTES
# ===============================

router.register(
    "employee-salaries",
    EmployeeSalaryViewSet,
    basename="employee-salary"
)

router.register(
    "teacher-salaries",
    TeacherSalaryViewSet,
    basename="teacher-salary"
)

# ===============================
# ADMIN SALARY ROUTES
# ===============================

router.register(
    "admin/employee-salaries",
    AdminEmployeeSalaryViewSet,
    basename="admin-employee-salary"
)

router.register(
    "admin/teacher-salaries",
    AdminTeacherSalaryViewSet,
    basename="admin-teacher-salary"
)

urlpatterns = [

    # My salary endpoints
    path("employee/my-salary/", EmployeeMySalaryView.as_view()),
    path("teacher/my-salary/", TeacherMySalaryView.as_view()),

    # Dashboard
    path("dashboard/", SalaryDashboardView.as_view()),

    # Router URLs
    path("", include(router.urls)),
]
