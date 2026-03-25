# apps/users/serializers.py

from rest_framework import serializers
from .models import CustomUser


class RegisterUserSerializer(serializers.ModelSerializer):
    gender = serializers.ChoiceField(choices=CustomUser.GENDER_CHOICES)
    dob = serializers.DateField(required=False)
    address = serializers.CharField(required=False)
    profile_picture = serializers.ImageField(required=True)

    phone = serializers.CharField(max_length=15, required=False)
    role = serializers.ChoiceField(choices=CustomUser.ROLE_CHOICES, default="student")
    email = serializers.EmailField(max_length=255, required=True)
    full_name = serializers.CharField(max_length=255)
    password = serializers.CharField(write_only=True, min_length=8)
    confirm_password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = CustomUser
        fields = [
            "email",
            "full_name",
            "phone",
            "profile_picture",
            "role",
            "gender",
            "dob",
            "address",
            "password",
            "confirm_password",
        ]

    def validate(self, data):
        if data["password"] != data["confirm_password"]:
            raise serializers.ValidationError("Passwords do not match.")
        if data["role"] not in dict(CustomUser.ROLE_CHOICES):
            raise serializers.ValidationError({"role": "Invalid role selected."})
        return data

    def create(self, validated_data):
        validated_data.pop("confirm_password")
        return CustomUser.objects.create_user(**validated_data)


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ["id", "email", "full_name", "phone", "role"]
        read_only_fields = ["id", "email", "role"]

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation["role"] = instance.get_role_display()
        return representation


# users/serializers.py

from rest_framework import serializers
from .models import CustomUser


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


class UserLoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ["id", "email", "full_name", "role", "is_approved"]


class UserApprovalSerializer(serializers.ModelSerializer):
    requested_role = serializers.CharField(source="role")

    class Meta:
        model = CustomUser
        fields = [
            "id",
            "email",
            "requested_role",
            "is_approved",
        ]


class ChangePasswordSerializer(serializers.Serializer):
    """Serializer for password change endpoint."""
    current_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True, min_length=8)
    confirm_password = serializers.CharField(write_only=True, min_length=8)

    def validate(self, data):
        if data.get("new_password") != data.get("confirm_password"):
            raise serializers.ValidationError("New passwords do not match.")
        # Validate password strength using Django's validators
        from django.contrib.auth.password_validation import validate_password
        request = self.context.get("request")
        user = getattr(request, "user", None)
        validate_password(data.get("new_password"), user=user)
        return data
