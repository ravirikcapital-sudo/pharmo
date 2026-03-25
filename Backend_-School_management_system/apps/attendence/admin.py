from django.contrib import admin
from .models import (
    StudentAttendance,
    TeacherAttendance,
    EmployeeAttendance,
    TeacherLeave,
    EmployeeLeave
)


@admin.register(StudentAttendance)
class StudentAttendanceAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "student",
        "school_class",
        "date",
        "status",
        "created_at",
    )
    list_filter = ("school_class", "status", "date")
    search_fields = ("student__user__full_name",)


@admin.register(TeacherAttendance)
class TeacherAttendanceAdmin(admin.ModelAdmin):
    list_display = (
        "teacher",
        "date",
        "status",
        "check_in_time",
        "check_out_time",
    )
    list_filter = ("status", "date")


@admin.register(EmployeeAttendance)
class EmployeeAttendanceAdmin(admin.ModelAdmin):
    list_display = (
        "employee",
        "date",
        "status",
        "check_in_time",
        "check_out_time",
    )
    list_filter = ("status", "date")


@admin.register(TeacherLeave)
class TeacherLeaveAdmin(admin.ModelAdmin):
    list_display = (
        "teacher",
        "leave_type",
        "from_date",
        "to_date",
        "approved",
    )
    list_filter = ("leave_type", "approved")


@admin.register(EmployeeLeave)
class EmployeeLeaveAdmin(admin.ModelAdmin):
    list_display = (
        "employee",
        "leave_type",
        "from_date",
        "to_date",
        "approved",
    )
    list_filter = ("leave_type", "approved")
    