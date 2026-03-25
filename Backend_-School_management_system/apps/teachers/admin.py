# apps/teachers/admin.py

from django.contrib import admin
from apps.teachers.models import  Designation,TeacherProfile, Department

@admin.register(Designation)
class DesignationAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "title",
        "is_active",
    )
    list_filter = ("is_active",)
    search_fields = ("title",)
    ordering = ("title",)

@admin.register(TeacherProfile)
class TeacherProfileAdmin(admin.ModelAdmin):

    list_display = (
        "get_full_name",
        "get_email",
        "subject",
        "designation",
        "experience_years",
        "is_active",
        "is_verified",
        "is_available",
    )

    list_filter = (
        "subject",
        "designation",
        "is_active",
        "is_verified",
        "is_available",
    )

    search_fields = (
        "user__full_name",
        "user__email",
        "subject",
        "designation__title",
    )

    readonly_fields = ("updated_at",)

    fieldsets = (
        ("Basic Information", {
            "fields": (
                "user",
                "gender",
                "dob",
                "profile_picture",
            )
        }),
        ("Professional Details", {
            "fields": (
                "subject",
                "designation",
                "qualification",
                "experience_years",
                "experience_details",
                "joining_date",
            )
        }),
        ("Status & Permissions", {
            "fields": (
                "is_available",
                "is_active",
                "is_verified",
                "is_suspended",
            )
        }),
        ("System", {
            "fields": (
                "is_deleted",
                "updated_at",
            )
        }),
    )

    def get_full_name(self, obj):
        return obj.user.full_name
    get_full_name.short_description = "Full Name"

    def get_email(self, obj):
        return obj.user.email
    get_email.short_description = "Email"


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ( 'name',)
    search_fields = ('name',)
 