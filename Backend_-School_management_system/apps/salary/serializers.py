from rest_framework import serializers
from .models import EmployeeSalary, TeacherSalary


# ======================================================
# EMPLOYEE SALARY SERIALIZERS
# ======================================================

class EmployeeSalarySerializer(serializers.ModelSerializer):
    employee_name = serializers.CharField(
        source="employee.user.get_full_name",
        read_only=True
    )

    class Meta:
        model = EmployeeSalary
        fields = [
            "id",
            "employee",
            "employee_name",
            "month",
            "basic_salary",
            "bonus",
            "deduction",
            "total_salary",
            "is_paid",
            "paid_date",
            "remark",
        ]
        read_only_fields = [
            "total_salary",
            "is_paid",
            "paid_date",
        ]


class AdminEmployeeSalarySerializer(serializers.ModelSerializer):
    employee_name = serializers.CharField(
        source="employee.user.get_full_name",
        read_only=True
    )

    class Meta:
        model = EmployeeSalary
        fields = "__all__"


# ======================================================
# TEACHER SALARY SERIALIZERS
# ======================================================

class TeacherSalarySerializer(serializers.ModelSerializer):
    teacher_name = serializers.CharField(
        source="teacher.user.get_full_name",
        read_only=True
    )

    class Meta:
        model = TeacherSalary
        fields = [
            "id",
            "teacher",
            "teacher_name",
            "month",
            "basic_salary",
            "bonus",
            "deduction",
            "total_salary",
            "is_paid",
            "paid_date",
            "remark",
        ]
        read_only_fields = [
            "total_salary",
            "is_paid",
            "paid_date",
        ]


class AdminTeacherSalarySerializer(serializers.ModelSerializer):
    teacher_name = serializers.CharField(
        source="teacher.user.get_full_name",
        read_only=True
    )

    class Meta:
        model = TeacherSalary
        fields = "__all__"
