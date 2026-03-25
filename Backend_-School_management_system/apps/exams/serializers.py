from rest_framework import serializers
from .models import Exam, StudentExamResult


class ExamSerializer(serializers.ModelSerializer):
    class_name = serializers.CharField(
        source="school_class.name",
        read_only=True
    )

    class Meta:
        model = Exam
        fields = [
            "id",
            "name",
            "exam_type",
            "school_class",
            "class_name",
            "exam_date",
            "is_published",
            "created_at",
        ]


class StudentExamResultSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(
        source="student.user.full_name",
        read_only=True
    )
    subject_name = serializers.CharField(
        source="subject.name",
        read_only=True
    )

    class Meta:
        model = StudentExamResult
        fields = [
            "id",
            "student",
            "student_name",
            "exam",
            "subject",
            "subject_name",
            "marks_obtained",
            "total_marks",
            "percentage",
            "grade",
        ]
        read_only_fields = ["percentage", "grade"]
