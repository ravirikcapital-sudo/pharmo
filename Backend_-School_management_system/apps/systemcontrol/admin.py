from django.contrib import admin
from .models import UserLoginActivity, Announcement, SystemSetting


@admin.register(UserLoginActivity)
class UserLoginActivityAdmin(admin.ModelAdmin):
    list_display = ("user", "role", "logged_in_at")
    ordering = ("-logged_in_at",)


@admin.register(Announcement)
class AnnouncementAdmin(admin.ModelAdmin):
    list_display = ("title", "created_by", "created_at", "is_active")
    list_filter = ("is_active",)
    ordering = ("-created_at",)


@admin.register(SystemSetting)
class SystemSettingAdmin(admin.ModelAdmin):
    list_display = (
        "enable_notifications",
        "school_class_name",
        "capacity_per_class",
        "current_academic_year",
        "updated_at",
    )
