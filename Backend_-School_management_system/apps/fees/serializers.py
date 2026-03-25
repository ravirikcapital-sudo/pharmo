# apps/fees/serializers.py

from rest_framework import serializers
from .models import ClassFeeStructure, StudentFee, Payment


class ClassFeeStructureSerializer(serializers.ModelSerializer):
    total_fee = serializers.SerializerMethodField()

    class Meta:
        model = ClassFeeStructure
        fields = "__all__"

    def get_total_fee(self, obj):
        return obj.total_fee()


class StudentFeeSerializer(serializers.ModelSerializer):

    student_name = serializers.CharField(
        source="student.user.full_name",
        read_only=True
    )

    class_name = serializers.CharField(
        source="school_class.name",
        read_only=True
    )

    class Meta:
        model = StudentFee
        fields = "__all__"


class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = "__all__"
