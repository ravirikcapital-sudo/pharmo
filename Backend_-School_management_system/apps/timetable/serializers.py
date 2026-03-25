from rest_framework import serializers
from .models import Timetable,StudentTimetable


class TimetableSerializer(serializers.ModelSerializer):
    class Meta:
        model = Timetable
        fields = "__all__"

    # ✅ Ensure selected user is actually a teacher
    def validate_teacher(self, value):
        if value.role.lower() != "teacher":
            raise serializers.ValidationError(
                "Selected user is not a teacher."
            )
        return value

    # ✅ Prevent teacher timetable clashes
    def validate(self, attrs):
        teacher = attrs.get("teacher")
        day = attrs.get("day")
        time_slot = attrs.get("time_slot")
        academic_year = attrs.get("academic_year")
        semester = attrs.get("semester")

        if Timetable.objects.filter(
            teacher=teacher,
            day=day,
            time_slot=time_slot,
            academic_year=academic_year,
            semester=semester,
        ).exists():
            raise serializers.ValidationError(
                "Teacher already has a class in this time slot."
            )

        return attrs

    # ✅ Document validation
    def validate_document(self, value):
        if value:
            if value.size > 5 * 1024 * 1024:
                raise serializers.ValidationError(
                    "File size must be ≤ 5MB"
                )

            allowed_extensions = ('.pdf', '.png', '.jpg', '.jpeg')
            if not value.name.lower().endswith(allowed_extensions):
                raise serializers.ValidationError(
                    "Only PDF, PNG, JPG, JPEG files are allowed"
                )

        return value

class StudentTimetableSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentTimetable
        fields = "__all__"

