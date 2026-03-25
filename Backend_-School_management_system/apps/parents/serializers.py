# apps/parents/serializers.py

from rest_framework import serializers
from apps.users.models import CustomUser
from .models import ParentProfile
from rest_framework import serializers
from django.contrib.auth import authenticate
from apps.users.models import CustomUser
from apps.students.models import StudentProfile

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)
    class Meta:
        model = ParentProfile
        fields = [
            'email','password'
        ]


    def validate(self, data):
        email = data.get('email')
        password = data.get('password')

        user = authenticate(email=email, password=password)

        if not user:
            raise serializers.ValidationError("Invalid email or password")

        if not user.is_active:
            raise serializers.ValidationError("User account is inactive")

        if user.role != 'parent':
            raise serializers.ValidationError("Not a parent account")

        data['user'] = user
        return data

class ParentRegisterSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.full_name')
    email = serializers.EmailField(source='user.email')
    phone = serializers.CharField(source='user.phone')
    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = ParentProfile
        fields = [
            'full_name', 'email', 'phone',
            'password', 'confirm_password',
            'relationship', 'child_admission_number',
            'mobile_number', 'alternate_number',
            'address', 'city', 'state', 'zip_code'
        ]

    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError({"confirm_password": "Passwords do not match."})
        return data

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        password = validated_data.pop('password')
        validated_data.pop('confirm_password')

        user = CustomUser.objects.create_user(
            full_name=user_data['full_name'],
            email=user_data['email'],
            phone=user_data['phone'],
            role='parent',
            password=password
        )

        parent = ParentProfile.objects.create(user=user, **validated_data)
        return parent



class ParentStudentProfileSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source='user.full_name')
    email = serializers.EmailField(source='user.email')
    phone = serializers.CharField(source='user.phone')
    studentId = serializers.CharField(source='admission_number')
    rollNumber = serializers.CharField(source='roll_number')
    className = serializers.CharField(source='class_enrolled')
    section = serializers.SerializerMethodField()

    def get_section(self, obj):
        # Older StudentProfile model stores section elsewhere; tolerate missing attribute
        return getattr(obj, 'section', obj.class_enrolled.section if obj.class_enrolled and getattr(obj.class_enrolled, 'section', None) else "")
    academicYear = serializers.SerializerMethodField()

    def get_academicYear(self, obj):
        return obj.class_enrolled.academic_year if obj.class_enrolled and getattr(obj.class_enrolled, 'academic_year', None) else ""
    dateOfBirth = serializers.DateField(source='dob', format="%Y-%m-%d")
    address = serializers.CharField()
    admissionDate = serializers.DateField(source='admission_date', format="%Y-%m-%d")
    parentName = serializers.CharField(source='guardian_name')
    parentPhone = serializers.CharField(source='phone')
    bloodGroup = serializers.CharField(source='blood_group')

    # Dummy/Default fields not yet in backend
    emergencyContact = serializers.SerializerMethodField()

    def get_emergencyContact(self, obj):
        return obj.phone or ""
    religion = serializers.SerializerMethodField()
    category = serializers.SerializerMethodField()
    subjects = serializers.SerializerMethodField()
    currentGrade = serializers.SerializerMethodField()
    overallPercentage = serializers.SerializerMethodField()
    attendance = serializers.SerializerMethodField()
    totalSubjects = serializers.SerializerMethodField()
    completedAssignments = serializers.SerializerMethodField()
    pendingAssignments = serializers.SerializerMethodField()
    profileImageUrl = serializers.SerializerMethodField()

    class Meta:
        model = StudentProfile
        fields = [
            'name', 'email', 'phone', 'studentId', 'rollNumber', 'className',
            'section', 'academicYear', 'dateOfBirth', 'address', 'admissionDate',
            'parentName', 'parentPhone', 'emergencyContact', 'bloodGroup',
            'religion', 'category', 'subjects', 'currentGrade', 'overallPercentage',
            'attendance', 'totalSubjects', 'completedAssignments', 'pendingAssignments',
            'profileImageUrl'
        ]


    def get_religion(self, obj):
        return "Not Specified"

    def get_category(self, obj):
        return "General"

    def get_subjects(self, obj):
        return ["Mathematics", "Science", "English", "Social Studies"]

    def get_currentGrade(self, obj):
        return "A"

    def get_overallPercentage(self, obj):
        return 0.0

    def get_attendance(self, obj):
        return 0.0

    def get_totalSubjects(self, obj):
        return 4

    def get_completedAssignments(self, obj):
        return 0

    def get_pendingAssignments(self, obj):
        return 0

    def get_profileImageUrl(self, obj):
        return ""


class StudentPerformanceRequestSerializer(serializers.Serializer):
    """Serializer to validate frontend request that sends name, rollno, semister."""
    classs = serializers.CharField()
    name = serializers.CharField()
    semister = serializers.CharField(required=False, allow_blank=True)


class SelectStudentMonthSerializer(serializers.Serializer):
    """Validate request for selecting student attendance by name and month."""
    student_name = serializers.CharField()
    month = serializers.CharField()


# Complaint serializers
from apps.parents.models import Complaint
from django.utils.timesince import timesince


class ComplaintSerializer(serializers.ModelSerializer):
    reported_by = serializers.SerializerMethodField()
    time_ago = serializers.SerializerMethodField()

    class Meta:
        model = Complaint
        fields = ['complaint_id', 'title', 'status', 'description', 'reported_by', 'time_ago', 'user_type', 'category', 'created_at']

    def get_reported_by(self, obj):
        if obj.user:
            return getattr(obj.user, 'full_name', '')
        return obj.reported_by_name or ''

    def get_time_ago(self, obj):
        # timesince returns e.g. '2 days, 4 hours' — we'll simplify to the first part
        delta = timesince(obj.created_at)
        first_part = delta.split(',')[0]
        return f"{first_part} ago"


class ComplaintCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Complaint
        fields = ['user_type', 'category', 'title', 'description']

    def create(self, validated_data):
        request = self.context.get('request')
        user = getattr(request, 'user', None)
        reported_name = getattr(user, 'full_name', '') if user and user.is_authenticated else ''
        complaint = Complaint.objects.create(
            user=user if user and user.is_authenticated else None,
            reported_by_name=reported_name,
            **validated_data
        )
        return complaint

