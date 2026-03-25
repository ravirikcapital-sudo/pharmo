from rest_framework import serializers
from .models import (
    StudentAttendance,
    TeacherAttendance,
    EmployeeAttendance,
    EmployeeLeave,
    TeacherLeave
)


class StudentAttendanceSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(
        source="student.user.full_name",
        read_only=True
    )

    class Meta:
        model = StudentAttendance
        fields = "__all__"


class TeacherAttendanceSerializer(serializers.ModelSerializer):
    teacher_name = serializers.CharField(
        source="teacher.user.full_name", read_only=True
    )

    class Meta:
        model = TeacherAttendance
        fields = "__all__"


class EmployeeAttendanceSerializer(serializers.ModelSerializer):
    employee_name = serializers.CharField(
        source="employee.user.full_name", read_only=True
    )

    class Meta:
        model = EmployeeAttendance
        fields = "__all__"


class TeacherLeaveSerializer(serializers.ModelSerializer):
    teacher_name = serializers.CharField(
        source="teacher.user.full_name",
        read_only=True
    )

    class Meta:
        model = TeacherLeave
        fields = "__all__"

    def validate(self, data):
        if data["from_date"] > data["to_date"]:
            raise serializers.ValidationError("Invalid date range")
        return data


class EmployeeLeaveSerializer(serializers.ModelSerializer):
    employee_name = serializers.CharField(
        source="employee.user.full_name",
        read_only=True
    )

    class Meta:
        model = EmployeeLeave
        fields = "__all__"

    def validate(self, data):
        if data["from_date"] > data["to_date"]:
            raise serializers.ValidationError("Invalid date range")
        return data
    


class StudentMonthlyReportSerializer(serializers.Serializer):
    student__id = serializers.IntegerField()
    student__user__full_name = serializers.CharField()
    present = serializers.IntegerField()
    absent = serializers.IntegerField()
    leave = serializers.IntegerField()
    total = serializers.IntegerField()


class TeacherMonthlyReportSerializer(serializers.Serializer):
    teacher__id = serializers.IntegerField()
    teacher__user__full_name = serializers.CharField()
    present = serializers.IntegerField()
    absent = serializers.IntegerField()
    leave = serializers.IntegerField()
    total = serializers.IntegerField()



