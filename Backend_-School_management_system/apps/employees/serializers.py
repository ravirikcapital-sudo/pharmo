from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import EmployeeProfile

User = get_user_model()


class EmployeeSerializer(serializers.ModelSerializer):
    # =========================
    # READ (API → Frontend)
    # =========================
    name = serializers.CharField(source='user.full_name', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)

    # =========================
    # WRITE (Frontend → API)
    # =========================
    name_write = serializers.CharField(write_only=True, required=False)
    email_write = serializers.EmailField(write_only=True, required=False)
    phone_write = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = EmployeeProfile
        fields = [
            'id',
            'name',
            'email',
            'phone',
            'name_write',
            'email_write',
            'phone_write',
            'role',
            'department',
            'gender',
            'joining_date',
            'is_active',
        ]

    # =========================
    # CREATE
    # =========================
    def create(self, validated_data):
        name = validated_data.pop('name_write', '')
        email = validated_data.pop('email_write', '')
        phone = validated_data.pop('phone_write', '')

        user = User.objects.create(
            full_name=name,
            email=email,
            phone=phone,
            role='employee',
        )
        user.set_unusable_password()
        user.save()

        return EmployeeProfile.objects.create(
            user=user,
            **validated_data
        )

    # =========================
    # UPDATE
    # =========================
    def update(self, instance, validated_data):
        user = instance.user

        if 'name_write' in validated_data:
            user.full_name = validated_data.pop('name_write')

        if 'email_write' in validated_data:
            user.email = validated_data.pop('email_write')

        if 'phone_write' in validated_data:
            user.phone = validated_data.pop('phone_write')

        user.save()
        return super().update(instance, validated_data)


