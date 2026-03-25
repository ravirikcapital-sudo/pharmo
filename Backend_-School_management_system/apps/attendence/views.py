from rest_framework import generics, status
from rest_framework.response import Response
from django.utils import timezone
from django.shortcuts import get_object_or_404

from django.db.models import Count
from django.db.models.functions import ExtractMonth, ExtractYear

from apps.students.models import StudentProfile
from apps.schoolclassesmanage.models import SchoolClass
from apps.teachers.models import TeacherProfile
from apps.employees.models import EmployeeProfile

from .models import (
    StudentAttendance,
    TeacherAttendance,
    EmployeeAttendance,
    TeacherLeave,
    EmployeeLeave
)
from .serializers import (
    StudentAttendanceSerializer,
    TeacherAttendanceSerializer,
    EmployeeAttendanceSerializer,
    TeacherLeaveSerializer,
    EmployeeLeaveSerializer,
    StudentMonthlyReportSerializer,
    TeacherMonthlyReportSerializer
)

# ======================================================
# STUDENT ATTENDANCE
# ======================================================

class MarkStudentAttendanceView(generics.ListCreateAPIView):
    queryset = StudentAttendance.objects.all()
    serializer_class = StudentAttendanceSerializer
    permission_classes = []

    def create(self, request, *args, **kwargs):
        class_id = request.data.get("class_id")
        date = request.data.get("date")
        students = request.data.get("students", [])

        school_class = get_object_or_404(SchoolClass, id=class_id)

        records = []
        for item in students:
            attendance, _ = StudentAttendance.objects.update_or_create(
                student_id=item["student_id"],
                school_class=school_class,
                date=date,
                defaults={"status": item["status"]},
            )
            records.append(attendance)

        serializer = self.get_serializer(records, many=True)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


# ======================================================
# TEACHER CHECK-IN / CHECK-OUT
# ======================================================

class TeacherCheckInView(generics.ListCreateAPIView):
    queryset = TeacherAttendance.objects.all()
    serializer_class = TeacherAttendanceSerializer
    permission_classes = []

    def create(self, request, *args, **kwargs):
        teacher = get_object_or_404(
            TeacherProfile, id=request.data.get("teacher_id")
        )
        today = timezone.now().date()

        attendance, created = TeacherAttendance.objects.get_or_create(
            teacher=teacher,
            date=today,
            defaults={
                "status": request.data.get("status", "Present"),
                "check_in_time": timezone.now(),
                "reason": request.data.get("reason", ""),
            },
        )

        if not created:
            return Response(
                {"detail": "Teacher already checked in"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        serializer = self.get_serializer(attendance)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class TeacherCheckOutView(generics.ListCreateAPIView):
    queryset = TeacherAttendance.objects.all()
    serializer_class = TeacherAttendanceSerializer
    permission_classes = []

    def create(self, request, *args, **kwargs):
        teacher = get_object_or_404(
            TeacherProfile, id=request.data.get("teacher_id")
        )
        today = timezone.now().date()

        attendance = get_object_or_404(
            TeacherAttendance, teacher=teacher, date=today
        )

        attendance.check_out_time = timezone.now()
        attendance.save()

        serializer = self.get_serializer(attendance)
        return Response(serializer.data)


# ======================================================
# EMPLOYEE CHECK-IN / CHECK-OUT
# ======================================================

class EmployeeCheckInView(generics.ListCreateAPIView):
    queryset = EmployeeAttendance.objects.all()
    serializer_class = EmployeeAttendanceSerializer
    permission_classes = []

    def create(self, request, *args, **kwargs):
        employee = get_object_or_404(
            EmployeeProfile, id=request.data.get("employee_id")
        )
        today = timezone.now().date()

        attendance, _ = EmployeeAttendance.objects.get_or_create(
            employee=employee,
            date=today,
            defaults={
                "status": request.data.get("status", "Present"),
                "check_in_time": timezone.now(),
                "reason": request.data.get("reason", ""),
            },
        )

        serializer = self.get_serializer(attendance)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class EmployeeCheckOutView(generics.ListCreateAPIView):
    queryset = EmployeeAttendance.objects.all()
    serializer_class = EmployeeAttendanceSerializer
    permission_classes = []

    def create(self, request, *args, **kwargs):
        employee = get_object_or_404(
            EmployeeProfile, id=request.data.get("employee_id")
        )
        today = timezone.now().date()

        attendance = get_object_or_404(
            EmployeeAttendance, employee=employee, date=today
        )

        attendance.check_out_time = timezone.now()
        attendance.save()

        serializer = self.get_serializer(attendance)
        return Response(serializer.data)


# ======================================================
# LEAVE
# ======================================================

class TeacherLeaveCreateView(generics.ListCreateAPIView):
    queryset = TeacherLeave.objects.all()
    serializer_class = TeacherLeaveSerializer
    permission_classes = []


class EmployeeLeaveCreateView(generics.ListCreateAPIView):
    queryset = EmployeeLeave.objects.all()
    serializer_class = EmployeeLeaveSerializer
    permission_classes = []


# ======================================================
# STUDENT ATTENDANCE PERCENTAGE
# ======================================================

class StudentAttendancePercentageView(generics.ListCreateAPIView):
    serializer_class = StudentAttendanceSerializer
    permission_classes = []

    def get_queryset(self):
        return StudentAttendance.objects.none()

    def list(self, request, *args, **kwargs):
        student_id = kwargs.get("student_id")

        student = get_object_or_404(StudentProfile, id=student_id)
        records = StudentAttendance.objects.filter(student=student)

        working_days = records.exclude(status="On Leave").count()
        present_days = records.filter(
            status__in=["Present", "Late", "Half Day"]
        ).count()

        percentage = (
            round((present_days / working_days) * 100, 2)
            if working_days > 0 else 0
        )

        return Response({
            "student_id": student.id,
            "student_name": student.user.full_name,
            "working_days": working_days,
            "present_days": present_days,
            "attendance_percentage": percentage,
        })



# ======================================================
# CLASS ATTENDANCE PERCENTAGE
# ======================================================

class ClassAttendancePercentageView(generics.ListCreateAPIView):
    serializer_class = StudentAttendanceSerializer
    permission_classes = []

    def get_queryset(self):
        return StudentAttendance.objects.none()

    def list(self, request, *args, **kwargs):
        class_id = request.query_params.get("class_id")

        if not class_id:
            return Response(
                {"detail": "class_id is required"},
                status=400
            )

        students = StudentProfile.objects.filter(
            class_enrolled_id=class_id
        ).select_related("user")

        result = []

        for student in students:
            records = StudentAttendance.objects.filter(student=student)

            working_days = records.exclude(status="On Leave").count()
            present_days = records.filter(
                status__in=["Present", "Late", "Half Day"]
            ).count()

            percentage = (
                round((present_days / working_days) * 100, 2)
                if working_days > 0 else 0
            )

            result.append({
                "student_id": student.id,
                "student_name": student.user.full_name,
                "attendance_percentage": percentage,
            })

        return Response(result)



class StudentMonthlyReportView(generics.ListCreateAPIView):
    serializer_class = StudentMonthlyReportSerializer
    permission_classes = []

    def get_queryset(self):
        return StudentAttendance.objects.none()

    def list(self, request, *args, **kwargs):
        month = request.query_params.get("month")
        year = request.query_params.get("year")
        class_id = request.query_params.get("class_id")

        if not month or not year:
            return Response(
                {"detail": "month and year are required"},
                status=400
            )

        students = StudentProfile.objects.select_related("user")
        if class_id:
            students = students.filter(class_enrolled_id=class_id)

        data = []

        for student in students:
            records = StudentAttendance.objects.filter(
                student=student,
                date__month=month,
                date__year=year,
            )

            data.append({
                "student_id": student.id,
                "student_name": student.user.full_name,
                "present": records.filter(status="Present").count(),
                "absent": records.filter(status="Absent").count(),
                "late": records.filter(status="Late").count(),
                "half_day": records.filter(status="Half Day").count(),
                "leave": records.filter(status="On Leave").count(),
            })

        return Response(data)


class TeacherMonthlyReportView(generics.ListCreateAPIView):
    serializer_class = TeacherMonthlyReportSerializer
    permission_classes = []

    def get_queryset(self):
        return TeacherAttendance.objects.none()

    def list(self, request, *args, **kwargs):
        month = request.query_params.get("month")
        year = request.query_params.get("year")

        if not month or not year:
            return Response(
                {"detail": "month and year are required"},
                status=400
            )

        teachers = TeacherProfile.objects.select_related("user")
        data = []

        for teacher in teachers:
            records = TeacherAttendance.objects.filter(
                teacher=teacher,
                date__month=month,
                date__year=year,
            )

            data.append({
                "teacher_id": teacher.id,
                "teacher_name": teacher.user.full_name,
                "present": records.filter(status="Present").count(),
                "absent": records.filter(status="Absent").count(),
                "late": records.filter(status="Late").count(),
                "half_day": records.filter(status="Half Day").count(),
                "leave": records.filter(status="On Leave").count(),
            })

        return Response(data)


