from rest_framework import serializers
from django.utils.translation import gettext_lazy as _
from apps.users.models import CustomUser
from .models import (
    UserLoginActivity,
    Announcement,
    SystemSetting,
)


# ================= USER ROLES =================
class UserLoginActivitySerializer(serializers.ModelSerializer):
    """Serializer for user login activity tracking"""

    user_name = serializers.CharField(source="user.full_name", read_only=True)
    email = serializers.CharField(source="user.email", read_only=True)

    class Meta:
        model = UserLoginActivity
        fields = [
            "id",
            "user",
            "user_name",
            "email",
            "role",
            "logged_in_at",
        ]
        read_only_fields = ["logged_in_at", "user", "role"]


# ================= ANNOUNCEMENTS =================
class AnnouncementSerializer(serializers.ModelSerializer):
    """Serializer for system announcements"""

    created_by = serializers.PrimaryKeyRelatedField(
        queryset=CustomUser.objects.filter(role="admin"),
        required=False,
        allow_null=True,
    )

    created_by_name = serializers.SerializerMethodField()

    class Meta:
        model = Announcement
        fields = [
            "id",
            "title",
            "message",
            "created_by",
            "created_by_name",
            "created_at",
            "updated_at",
            "is_active",
        ]
        read_only_fields = ["created_at", "updated_at"]

    def validate_title(self, value):
        """Validate title is not blank"""
        if not value or not value.strip():
            raise serializers.ValidationError(_("Title cannot be empty."))
        if len(value) > 200:
            raise serializers.ValidationError(
                _("Title must not exceed 200 characters.")
            )
        return value

    def validate_message(self, value):
        """Validate message is not blank"""
        if not value or not value.strip():
            raise serializers.ValidationError(_("Message cannot be empty."))
        return value

    def get_created_by_name(self, obj):
        """Get the name of the creator"""
        if obj.created_by and obj.created_by.role == "admin":
            return obj.created_by.full_name
        return None


# ================= SYSTEM SETTINGS =================
class SystemSettingSerializer(serializers.ModelSerializer):
    """Serializer for global system settings"""

    class Meta:
        model = SystemSetting
        fields = [
            "enable_notifications",
            "school_class_name",
            "capacity_per_class",
            "current_academic_year",
            "updated_at",
        ]
        read_only_fields = ["updated_at"]

    def validate_capacity_per_class(self, value):
        """Validate capacity is positive"""
        if value <= 0:
            raise serializers.ValidationError(
                _("Capacity per class must be greater than 0.")
            )
        if value > 1000:
            raise serializers.ValidationError(
                _("Capacity per class cannot exceed 1000.")
            )
        return value

    def validate_school_class_name(self, value):
        """Validate school name is not blank"""
        if not value or not value.strip():
            raise serializers.ValidationError(_("School class name cannot be empty."))
        return value

    def validate_current_academic_year(self, value):
        """Validate academic year format"""
        if not value or not value.strip():
            raise serializers.ValidationError(_("Academic year cannot be empty."))
        # Simple validation for format like 2026-2027
        if "-" not in value or len(value) != 9:
            raise serializers.ValidationError(
                _("Academic year must be in format YYYY-YYYY (e.g., 2026-2027).")
            )
        return value
