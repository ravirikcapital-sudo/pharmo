from django.contrib import admin
from .models import Notification


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ("title", "recipient", "notification_type", "is_read", "created_at")
    list_filter = ("notification_type", "is_read", "created_at")
    search_fields = ("title", "message", "recipient__username")
    readonly_fields = ("created_at",)
    fieldsets = (
        (
            "Notification Info",
            {"fields": ("recipient", "title", "message", "notification_type")},
        ),
        ("Status", {"fields": ("is_read",)}),
        ("Timestamps", {"fields": ("created_at",), "classes": ("collapse",)}),
    )
    ordering = ("-created_at",)
