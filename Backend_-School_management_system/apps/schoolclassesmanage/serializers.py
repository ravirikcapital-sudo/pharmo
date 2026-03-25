from rest_framework import serializers
from .models import SchoolClass
from apps.students.models import StudentProfile
from apps.students.serializers import StudentListSerializer

class ClassSerializer(serializers.ModelSerializer):
    students = StudentListSerializer(many=True, read_only=True)
    student_count = serializers.SerializerMethodField()
    teacher_name = serializers.SerializerMethodField()
    class Meta: 
        model = SchoolClass
        fields = [
            "id",
            "name",
            "section",
            "academic_year",
            "code",
            "created_at",
            "student_count",
            "students",
            "teacher_name",
        ]
        read_only_fields = ["code", "created_at"]
    def get_student_count(self, obj):
        return obj.students.count()
    
    def get_teacher_name(self, obj):
        if hasattr(obj, "class_teacher") and obj.class_teacher:
            return obj.class_teacher.user.full_name
        return "Not Assigned"