from rest_framework import serializers
from apps.students.models import StudentProfile
from apps.schoolclassesmanage.models import SchoolClass
from apps.users.models import CustomUser


class AdminClassSerializer(serializers.ModelSerializer):
    students_count = serializers.SerializerMethodField()

    class Meta:
        model = SchoolClass
        fields = ["id", "name", "students_count"]

    def get_students_count(self, obj):
        return obj.students.count()


class AdminStudentListSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source="user.full_name", read_only=True)
    email = serializers.EmailField(source="user.email", read_only=True)
    class_name = serializers.CharField(source="class_enrolled.name", read_only=True)

    class Meta:
        model = StudentProfile
        fields = [
            "id",
            "admission_number",
            "name",
            "email",
            "class_name",
            "admission_status",
        ]


class AdminStudentDetailSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source="user.full_name", read_only=True)
    email = serializers.EmailField(source="user.email", read_only=True)
    class_name = serializers.CharField(source="class_enrolled.name", read_only=True)

    class Meta:
        model = StudentProfile
        fields = [
            "id",
            "admission_number",
            "name",
            "email",
            "phone",
            "class_name",
            "admission_status",
            "dob",
            "address",
            "created_at",
        ]


class AdminProfileSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source="full_name", read_only=True)

    profile_picture = serializers.SerializerMethodField()
    totalUsers = serializers.SerializerMethodField()
    activeStudents = serializers.SerializerMethodField()
    totalFaculty = serializers.SerializerMethodField()

    class Meta:
        model = CustomUser
        fields = [
            "name",
            "email",
            "role",
            "phone",
            "address",
            "joining_date",
            "gender",
            "totalUsers",
            "activeStudents",
            "totalFaculty",
            "profile_picture",
        ]

    def get_profile_picture(self, obj):
        if obj.profile_picture:
            request = self.context.get("request")
            return request.build_absolute_uri(obj.profile_picture.url)
        return ""


    def get_totalUsers(self, obj):
        return CustomUser.objects.filter(is_deleted=False).count()

    def get_activeStudents(self, obj):
        return CustomUser.objects.filter(role="student", is_active=True).count()

    def get_totalFaculty(self, obj):
        return CustomUser.objects.filter(role="teacher").count()
