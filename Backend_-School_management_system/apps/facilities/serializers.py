from rest_framework import serializers
from .models import Facility, ClassRoom
from apps.students.models import StudentProfile
from apps.students.serializers import StudentProfileSerializer
from apps.users.models import CustomUser
class FacilitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Facility
        fields = '__all__'

class ClassRoomSerializer(serializers.ModelSerializer):

    class_teacher_name = serializers.CharField(
        source="class_teacher.user.full_name",
        read_only=True
    )
    class_teacher_email = serializers.EmailField(
        source="class_teacher.user.email",
        read_only=True
    )

    school_class_name = serializers.CharField(
        source="school_class.name",
        read_only=True
    )
    school_class_section = serializers.CharField(
        source="school_class.section",
        read_only=True
    )

    students = serializers.SerializerMethodField()

    class Meta:
        model = ClassRoom
        fields = "__all__"
        read_only_fields = ["created_at", "updated_at"]

    def get_students(self, obj):
        students = StudentProfile.objects.filter(
            class_enrolled=obj.school_class
        )
        return StudentProfileSerializer(students, many=True).data

    def validate_class_teacher(self, value):
        if value and value.user.role != "teacher":
            raise serializers.ValidationError("Assigned user must be a teacher.")
        return value

