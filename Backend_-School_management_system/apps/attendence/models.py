from django.db import models
from django.utils import timezone
from datetime import timedelta

from apps.teachers.models import TeacherProfile
from apps.students.models import StudentProfile
from apps.schoolclassesmanage.models import SchoolClass
from apps.employees.models import EmployeeProfile


STATUS_CHOICES = (
    ("Present", "Present"),
    ("Absent", "Absent"),
    ("Late", "Late"),
    ("Half Day", "Half Day"),
    ("On Leave", "On Leave"),
)

LEAVE_CHOICES = (
    ("sick", "Sick"),
    ("personal", "Personal"),
    ("emergency", "Emergency"),
    ("vacation", "Vacation"),
    ("other", "Other"),
)


class StudentAttendance(models.Model):
    student = models.ForeignKey(StudentProfile, on_delete=models.CASCADE)
    school_class = models.ForeignKey(SchoolClass, on_delete=models.CASCADE)
    date = models.DateField()
    status = models.CharField(max_length=15, choices=STATUS_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("student", "school_class", "date")

    def __str__(self):
        return f"{self.student} - {self.date}"


class TeacherAttendance(models.Model):
    teacher = models.ForeignKey(
        TeacherProfile,
        on_delete=models.CASCADE,
        related_name="attendance"
    )
    date = models.DateField(default=timezone.now)
    status = models.CharField(max_length=15, choices=STATUS_CHOICES)
    check_in_time = models.DateTimeField(null=True, blank=True)
    check_out_time = models.DateTimeField(null=True, blank=True)
    reason = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("teacher", "date")

    def __str__(self):
        return f"{self.teacher.user.full_name} - {self.date}"


class EmployeeAttendance(models.Model):
    employee = models.ForeignKey(
        EmployeeProfile,
        on_delete=models.CASCADE,
        related_name="attendance"
    )
    date = models.DateField(default=timezone.now)
    status = models.CharField(max_length=15, choices=STATUS_CHOICES)
    check_in_time = models.DateTimeField(null=True, blank=True)
    check_out_time = models.DateTimeField(null=True, blank=True)
    reason = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("employee", "date")

    def __str__(self):
        return f"{self.employee.user.full_name} - {self.date}"


class TeacherLeave(models.Model):

    teacher = models.ForeignKey(
        TeacherProfile,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="leaves"
    )

    leave_type = models.CharField(max_length=20, choices=LEAVE_CHOICES)
    from_date = models.DateField()
    to_date = models.DateField()
    reason = models.TextField()
    approved = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        target = self.teacher or self.employee
        return f"{target} - {self.leave_type}"


class EmployeeLeave(models.Model):
    employee = models.ForeignKey(
        EmployeeProfile,
        on_delete=models.CASCADE,
        related_name="leaves"
    )
    leave_type = models.CharField(
        max_length=20,
        choices=LEAVE_CHOICES
    )
    from_date = models.DateField()
    to_date = models.DateField()
    reason = models.TextField()
    approved = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.employee.user.full_name} - {self.leave_type}"
    