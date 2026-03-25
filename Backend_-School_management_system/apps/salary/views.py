from rest_framework import viewsets, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView
from django.db.models import Sum
from django.utils import timezone
from django.contrib.auth.models import AnonymousUser

from .models import EmployeeSalary, TeacherSalary
from .serializers import (
    EmployeeSalarySerializer,
    AdminEmployeeSalarySerializer,
    TeacherSalarySerializer,
    AdminTeacherSalarySerializer,
)


# ======================================================
# EMPLOYEE SALARY
# ======================================================

class AdminEmployeeSalaryViewSet(viewsets.ModelViewSet):
    queryset = EmployeeSalary.objects.select_related(
        "employee", "employee__user"
    )
    serializer_class = AdminEmployeeSalarySerializer


class EmployeeMySalaryView(generics.ListAPIView):
    serializer_class = EmployeeSalarySerializer
    permission_classes = []

    def get_queryset(self):
        user = self.request.user

        if isinstance(user, AnonymousUser) or not user.is_authenticated:
            return EmployeeSalary.objects.none()

        return EmployeeSalary.objects.filter(
            employee__user=user
        ).select_related("employee", "employee__user")


class EmployeeSalaryViewSet(viewsets.ModelViewSet):
    queryset = EmployeeSalary.objects.select_related(
        "employee", "employee__user"
    )
    serializer_class = EmployeeSalarySerializer
    permission_classes = []

    def get_queryset(self):
        queryset = super().get_queryset()
        month = self.request.query_params.get("month")
        is_paid = self.request.query_params.get("is_paid")

        if month:
            queryset = queryset.filter(month=month)

        if is_paid is not None:
            queryset = queryset.filter(
                is_paid=is_paid.lower() == "true"
            )

        return queryset

    @action(detail=True, methods=["post"])
    def pay(self, request, pk=None):
        salary = self.get_object()
        salary.pay_salary()
        return Response({"message": "Employee salary paid successfully"})

    @action(detail=False, methods=["post"])
    def bulk_pay(self, request):
        pending = EmployeeSalary.objects.filter(is_paid=False)

        total_amount = (    
            pending.aggregate(total=Sum("total_salary"))["total"] or 0
        )

        pending.update(
            is_paid=True,
            paid_date=timezone.now().date()
        )

        return Response({
            "message": "Employee bulk payment successful",
            "total_paid": total_amount
        })


# ======================================================
# TEACHER SALARY
# ======================================================

class AdminTeacherSalaryViewSet(viewsets.ModelViewSet):
    queryset = TeacherSalary.objects.select_related(
        "teacher", "teacher__user"
    )
    serializer_class = AdminTeacherSalarySerializer


class TeacherMySalaryView(generics.ListAPIView):
    serializer_class = TeacherSalarySerializer
    permission_classes = []

    def get_queryset(self):
        user = self.request.user

        if isinstance(user, AnonymousUser) or not user.is_authenticated:
            return TeacherSalary.objects.none()

        return TeacherSalary.objects.filter(
            teacher__user=user
        ).select_related("teacher", "teacher__user")


class TeacherSalaryViewSet(viewsets.ModelViewSet):
    queryset = TeacherSalary.objects.select_related(
        "teacher", "teacher__user"
    )
    serializer_class = TeacherSalarySerializer
    permission_classes = []

    def get_queryset(self):
        queryset = super().get_queryset()
        month = self.request.query_params.get("month")
        is_paid = self.request.query_params.get("is_paid")

        if month:
            queryset = queryset.filter(month=month)

        if is_paid is not None:
            queryset = queryset.filter(
                is_paid=is_paid.lower() == "true"
            )

        return queryset

    @action(detail=True, methods=["post"])
    def pay(self, request, pk=None):
        salary = self.get_object()
        salary.pay_salary()
        return Response({"message": "Teacher salary paid successfully"})

    @action(detail=False, methods=["post"])
    def bulk_pay(self, request):
        pending = TeacherSalary.objects.filter(is_paid=False)

        total_amount = (
            pending.aggregate(total=Sum("total_salary"))["total"] or 0
        )

        pending.update(
            is_paid=True,
            paid_date=timezone.now().date()
        )

        return Response({
            "message": "Teacher bulk payment successful",
            "total_paid": total_amount
        })


# ======================================================
# DASHBOARD SUMMARY
# ======================================================

class SalaryDashboardView(APIView):
    permission_classes = []

    def get(self, request):

        teacher_paid_count = TeacherSalary.objects.filter(is_paid=True).count()
        teacher_pending_count = TeacherSalary.objects.filter(is_paid=False).count()

        employee_paid_count = EmployeeSalary.objects.filter(is_paid=True).count()
        employee_pending_count = EmployeeSalary.objects.filter(is_paid=False).count()

        teacher_total_paid = (
            TeacherSalary.objects.filter(is_paid=True)
            .aggregate(total=Sum("total_salary"))["total"] or 0
        )

        employee_total_paid = (
            EmployeeSalary.objects.filter(is_paid=True)
            .aggregate(total=Sum("total_salary"))["total"] or 0
        )

        return Response({
            "teacher": {
                "paid_count": teacher_paid_count,
                "pending_count": teacher_pending_count,
                "total_paid_amount": teacher_total_paid,
            },
            "employee": {
                "paid_count": employee_paid_count,
                "pending_count": employee_pending_count,
                "total_paid_amount": employee_total_paid,
            }
        })
