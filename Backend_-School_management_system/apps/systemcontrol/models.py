from django.conf import settings
from django.db import models


# =====================================
# 1. USER ROLES (LOGIN ACTIVITY)
# =====================================
class UserLoginActivity(models.Model):
    """Tracks user login activity"""

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    role = models.CharField(max_length=50)
    logged_in_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-logged_in_at"]
        verbose_name = "User Login Activity"
        verbose_name_plural = "User Login Activities"
        indexes = [
            models.Index(fields=["-logged_in_at"]),
        ]

    def __str__(self):
        return f"{self.user} - {self.role}"


# =====================================
# 2. ANNOUNCEMENTS
# =====================================
class Announcement(models.Model):
    """System announcements created by admins"""

    title = models.CharField(max_length=200, help_text="Announcement title")
    message = models.TextField(help_text="Announcement message content")
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="announcements",
        help_text="Admin user who created this announcement",
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(
        default=True, help_text="Whether this announcement is currently active"
    )

    class Meta:
        ordering = ["-created_at"]
        verbose_name = "Announcement"
        verbose_name_plural = "Announcements"
        indexes = [
            models.Index(fields=["-created_at"]),
            models.Index(fields=["is_active", "-created_at"]),
        ]

    def __str__(self):
        return self.title


# =====================================
# 3. SYSTEM SETTINGS (SINGLE ROW)
# =====================================
class SystemSettingManager(models.Manager):
    """Custom manager for SystemSetting singleton"""

    def get_settings(self):
        """Get or create the single system settings instance"""
        obj, _ = self.get_or_create(id=1)
        return obj


class SystemSetting(models.Model):
    """Global system configuration (singleton pattern)"""

    enable_notifications = models.BooleanField(
        default=True, help_text="Enable/disable system notifications"
    )
    school_class_name = models.CharField(
        max_length=100,
        default="Royal Public School",
        help_text="Official name of the school",
    )
    capacity_per_class = models.PositiveIntegerField(
        default=30, help_text="Maximum capacity per class"
    )
    current_academic_year = models.CharField(
        max_length=20,
        default="2026-2027",
        help_text="Current academic year (e.g., 2026-2027)",
    )
    updated_at = models.DateTimeField(auto_now=True)

    objects = SystemSettingManager()

    class Meta:
        verbose_name = "System Setting"
        verbose_name_plural = "System Settings"

    def __str__(self):
        return "System Settings"

    def save(self, *args, **kwargs):
        """Ensure only one settings object exists"""
        self.id = 1
        super().save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        """Prevent deletion of the settings object"""
        pass
