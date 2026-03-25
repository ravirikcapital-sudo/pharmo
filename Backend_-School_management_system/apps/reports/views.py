from rest_framework import generics
from rest_framework.response import Response
from django.db.models import Count, Sum, F, ExpressionWrapper, DecimalField

from apps.students.models import StudentProfile
from apps.teachers.models import TeacherProfile
from apps.employees.models import EmployeeProfile
from apps.admissions.models import AdmissionApplication
from apps.attendence.models import StudentAttendance
from apps.salary.models import EmployeeSalary,TeacherSalary
from .serializers import (
    OverviewReportSerializer,
    AcademicReportSerializer,
    EnrollmentReportSerializer,
    TeachersReportSerializer,
    FinancialReportSerializer,
)


# =====================================================
# OVERVIEW REPORT
# =====================================================
class OverviewReportAPIView(generics.ListAPIView):
    serializer_class = OverviewReportSerializer
    queryset = StudentProfile.objects.none()

    def list(self, request, *args, **kwargs):
        data = {
            "total_students": StudentProfile.objects.count(),
            "total_teachers": TeacherProfile.objects.count(),
            "total_employees": EmployeeProfile.objects.count(),
        }

        serializer = self.get_serializer(data)
        return Response(serializer.data)


# =====================================================
# ACADEMIC REPORT
# =====================================================
class AcademicReportAPIView(generics.ListAPIView):
    serializer_class = AcademicReportSerializer
    queryset = StudentProfile.objects.none()

    def list(self, request, *args, **kwargs):

        class_strength_qs = (
            StudentProfile.objects
            .filter(class_enrolled__isnull=False)
            .values("class_enrolled__name")
            .annotate(total_students=Count("id"))
            .order_by("class_enrolled__name")
        )

        class_strength = [
            {
                "school_class": item["class_enrolled__name"],
                "total_students": item["total_students"],
            }
            for item in class_strength_qs
        ]

        data = {
            "class_strength": class_strength
        }

        serializer = self.get_serializer(data)
        return Response(serializer.data)


# =====================================================
# ENROLLMENT REPORT
# =====================================================
class EnrollmentReportAPIView(generics.ListAPIView):
    serializer_class = EnrollmentReportSerializer
    queryset = AdmissionApplication.objects.none()

    def list(self, request, *args, **kwargs):

        queryset = AdmissionApplication.objects.all()

        total_applications = queryset.count()
        submitted_applications = queryset.filter(is_submitted=True).count()
        paid_applications = queryset.filter(is_paid=True).count()

        class_wise_qs = (
            queryset.filter(is_submitted=True)
            .values("class_applied")
            .annotate(total_admissions=Count("id"))
            .order_by("class_applied")
        )

        enrollment_summary = list(class_wise_qs)

        gender_qs = (
            queryset.filter(is_submitted=True)
            .values("gender")
            .annotate(total=Count("id"))
        )

        gender_distribution = {
            item["gender"]: item["total"]
            for item in gender_qs
        }

        data = {
            "enrollment_summary": enrollment_summary,
            "total_applications": total_applications,
            "submitted_applications": submitted_applications,
            "paid_applications": paid_applications,
            "gender_distribution": gender_distribution,
        }

        serializer = self.get_serializer(data)
        return Response(serializer.data)


# =====================================================
# TEACHERS REPORT
# =====================================================
class TeachersReportAPIView(generics.ListAPIView):
    serializer_class = TeachersReportSerializer
    queryset = TeacherProfile.objects.none()

    def list(self, request, *args, **kwargs):

        teachers_qs = TeacherProfile.objects.filter(is_deleted=False)


        summary = {
            "total_teachers": teachers_qs.count(),
            "active_teachers": teachers_qs.filter(is_active=True).count(),
            "verified_teachers": teachers_qs.filter(is_verified=True).count(),
            "suspended_teachers": teachers_qs.filter(is_suspended=True).count(),
        }

        subject_qs = (
            teachers_qs
            .filter(subject__isnull=False)
            .values("subject__name")
            .annotate(total=Count("id"))
        )

        subject_wise_teachers = [
            {
                "subject": item["subject__name"],
                "total": item["total"],
            }
            for item in subject_qs
        ]

        designation_qs = (
            teachers_qs
            .filter(designation__isnull=False)
            .values("designation__title")
            .annotate(total=Count("id"))
        )

        designation_wise_teachers = [
            {
                "designation": item["designation__title"],
                "total": item["total"],
            }
            for item in designation_qs
        ]


        gender_wise_teachers = list(
            teachers_qs
            .values("gender")
            .annotate(total=Count("id"))
        )


        salary_expr = ExpressionWrapper(
            F("basic_salary") + F("bonus") - F("deduction"),
            output_field=DecimalField(max_digits=12, decimal_places=2),
        )

        total_salary_paid = (
            TeacherSalary.objects
            .filter(is_paid=True)
            .aggregate(total=Sum(salary_expr))["total"] or 0
        )

        total_salary_unpaid = (
            TeacherSalary.objects
            .filter(is_paid=False)
            .aggregate(total=Sum(salary_expr))["total"] or 0
        )

        salary_summary = {
            "total_salary_paid": total_salary_paid,
            "total_salary_unpaid": total_salary_unpaid,
        }


        attendance_summary = list(
            StudentAttendance.objects
            .values("status")
            .annotate(total=Count("id"))
        )

        data = {
            "summary": summary,
            "subject_wise_teachers": subject_wise_teachers,
            "designation_wise_teachers": designation_wise_teachers,
            "gender_wise_teachers": gender_wise_teachers,
            "salary_summary": salary_summary,
            "attendance_summary": attendance_summary,
        }

        serializer = self.get_serializer(data)
        return Response(serializer.data)


# =====================================================
# FINANCIAL REPORT
# =====================================================
class FinancialReportAPIView(generics.ListAPIView):
    serializer_class = FinancialReportSerializer
    queryset = EmployeeSalary.objects.none()

    def list(self, request, *args, **kwargs):

        salary_expr = ExpressionWrapper(
            F("basic_salary") + F("bonus") - F("deduction"),
            output_field=DecimalField(max_digits=12, decimal_places=2),
        )

        employee_paid = (
            EmployeeSalary.objects
            .filter(is_paid=True)
            .aggregate(total=Sum(salary_expr))["total"] or 0
        )

        employee_unpaid = (
            EmployeeSalary.objects
            .filter(is_paid=False)
            .aggregate(total=Sum(salary_expr))["total"] or 0
        )

        teacher_paid = (
            TeacherSalary.objects
            .filter(is_paid=True)
            .aggregate(total=Sum(salary_expr))["total"] or 0
        )

        teacher_unpaid = (
            TeacherSalary.objects
            .filter(is_paid=False)
            .aggregate(total=Sum(salary_expr))["total"] or 0
        )

        data = {
            "employee_salary": {
                "paid": employee_paid,
                "unpaid": employee_unpaid,
            },
            "teacher_salary": {
                "paid": teacher_paid,
                "unpaid": teacher_unpaid,
            },
            "note": "Fees module not integrated yet.",
        }

        serializer = self.get_serializer(data)
        return Response(serializer.data)
