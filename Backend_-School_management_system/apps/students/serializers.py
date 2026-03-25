from rest_framework import serializers
from apps.users.models import CustomUser
from .models import StudentProfile
from django.db import transaction
from apps.schoolclassesmanage.models import SchoolClass

class StudentRegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True)
    full_name = serializers.CharField(write_only=True)
    phone = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = StudentProfile
        exclude = ("user", "admission_number", "roll_number", "created_at")

    @transaction.atomic
    def create(self, validated_data):
        email = validated_data.pop("email")
        full_name = validated_data.pop("full_name")
        phone = validated_data.pop("phone")
        password = validated_data.pop("password", "student@123")

        user = CustomUser.objects.create_user(
            email=email,
            full_name=full_name,
            phone=phone,
            password=password,
            role="student",
        )

        student = StudentProfile.objects.create(user=user, **validated_data)
        return student

from rest_framework import serializers
from .models import StudentProfile


class StudentListSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source="user.full_name", read_only=True)

    class Meta:
        model = StudentProfile
        fields = [
            "id",
            "full_name",
            "admission_number",
            "roll_number",
            "admission_status",
        ]


class StudentProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source="user.full_name", read_only=True)
    email = serializers.EmailField(source="user.email", read_only=True)
    phone = serializers.CharField(source="user.phone", read_only=True)

    class Meta:
        model = StudentProfile
        fields = "__all__"
        read_only_fields = ["admission_number", "roll_number", "created_at"]


class StudentCreateSerializer(serializers.ModelSerializer):

    name = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True)

    class_enrolled = serializers.PrimaryKeyRelatedField(
        queryset=SchoolClass.objects.all()
    )

    class Meta:
        model = StudentProfile
        fields = [
            "name",
            "email",
            "phone",
            "address",
            "dob",
            "admission_status",
            "class_enrolled",
        ]

    def create(self, validated_data):
        name = validated_data.pop("name")
        email = validated_data.pop("email")
        phone = validated_data.pop("phone")

        user = CustomUser.objects.create_user(
            email=email,
            phone=phone,
            full_name=name,
            password="defaultpassword123",
            role="student"
        )

        return StudentProfile.objects.create(
            user=user,
            **validated_data
        )


class StudentSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source="user.full_name", read_only=True)
    email = serializers.EmailField(source="user.email", read_only=True)

    class Meta:
        model = StudentProfile
        fields = [
            "id",
            "name",
            "email",
            "admission_number",
            "class_enrolled",
            "admission_status",
            "dob",
            "mobile_number",
            "address",
            "created_at",
        ]


# Assignment serializers
from .models import Assignment, AssignmentAttachment, AssignmentSubmission, SubmissionAttachment
from apps.schoolclassesmanage.models import SchoolClass


class AssignmentAttachmentSerializer(serializers.ModelSerializer):
    file_name = serializers.SerializerMethodField()
    url = serializers.SerializerMethodField()

    class Meta:
        model = AssignmentAttachment
        fields = ['file_name', 'url']

    def get_file_name(self, obj):
        return obj.file.name.split('/')[-1]

    def get_url(self, obj):
        request = self.context.get('request')
        if request:
            return request.build_absolute_uri(obj.file.url)
        return obj.file.url


class AssignmentSerializer(serializers.ModelSerializer):
    attachments = AssignmentAttachmentSerializer(many=True, read_only=True)
    assignment_id = serializers.CharField(read_only=True)
    subject_color = serializers.CharField(read_only=True)

    class Meta:
        model = Assignment
        fields = ['assignment_id', 'title', 'subject', 'subject_color', 'instructor', 'status', 'type', 'description', 'assigned_date', 'due_date', 'attachments', 'class_assigned']


class AssignmentCreateSerializer(serializers.ModelSerializer):
    attachments = serializers.ListField(child=serializers.FileField(), write_only=True, required=False)

    class Meta:
        model = Assignment
        fields = ['title', 'description', 'subject', 'subject_color', 'instructor', 'type', 'class_assigned', 'assigned_date', 'due_date', 'attachments']

    def create(self, validated_data):
        files = validated_data.pop('attachments', [])
        user = self.context['request'].user
        assignment = Assignment.objects.create(created_by=user, **validated_data)
        for f in files:
            AssignmentAttachment.objects.create(assignment=assignment, file=f)
        return assignment


class SubmissionAttachmentSerializer(serializers.ModelSerializer):
    file_name = serializers.SerializerMethodField()
    url = serializers.SerializerMethodField()

    class Meta:
        model = SubmissionAttachment
        fields = ['file_name', 'url']

    def get_file_name(self, obj):
        return obj.file.name.split('/')[-1]

    def get_url(self, obj):
        request = self.context.get('request')
        if request:
            return request.build_absolute_uri(obj.file.url)
        return obj.file.url


class AssignmentSubmissionSerializer(serializers.ModelSerializer):
    attachments = SubmissionAttachmentSerializer(many=True, read_only=True)
    student_name = serializers.CharField(source='student.user.full_name', read_only=True)

    class Meta:
        model = AssignmentSubmission
        fields = ['id', 'assignment', 'student', 'student_name', 'content', 'status', 'grade', 'feedback', 'submitted_at', 'attachments']


class AssignmentSubmissionCreateSerializer(serializers.ModelSerializer):
    attachments = serializers.ListField(child=serializers.FileField(), write_only=True, required=False)

    class Meta:
        model = AssignmentSubmission
        fields = ['content', 'attachments']

    def create(self, validated_data):
        files = validated_data.pop('attachments', [])
        request = self.context.get('request')
        student_profile = getattr(request.user, 'student_profile', None)
        if not student_profile:
            raise serializers.ValidationError('Only students can submit assignments')
        assignment = self.context.get('assignment')
        submission, created = AssignmentSubmission.objects.update_or_create(
            assignment=assignment,
            student=student_profile,
            defaults={
                'content': validated_data.get('content', ''),
                'status': 'Submitted'
            }
        )
        # remove existing attachments? keep for now
        for f in files:
            SubmissionAttachment.objects.create(submission=submission, file=f)
        return submission

