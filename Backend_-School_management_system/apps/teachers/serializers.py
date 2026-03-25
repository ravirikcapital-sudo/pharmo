from rest_framework import serializers
from apps.users.models import CustomUser
from .models import TeacherProfile
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers
from apps.users.models import CustomUser
from django.utils import timezone
from apps.teachers.models import Designation, TeacherProfile
from django.contrib.auth.password_validation import validate_password


class DesignationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Designation
        fields = ["id", "title", "description", "is_active"]

    def validate_title(self, value):
        if Designation.objects.filter(title__iexact=value).exists():
            raise serializers.ValidationError("Designation with this title already exists.")
        return value



from rest_framework import serializers
from django.utils import timezone
from .models import TeacherProfile, Designation
from apps.users.models import CustomUser
from apps.academics.models import Subject

class AdminCreateTeacherSerializer(serializers.Serializer):
    # -------- USER FIELDS (write_only) --------
    full_name = serializers.CharField(max_length=255, write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(max_length=15, write_only=True)

    # -------- TEACHER PROFILE FIELDS --------
    gender = serializers.ChoiceField(choices=TeacherProfile.GENDER_CHOICES, write_only=True)
    dob = serializers.DateField(required=False, write_only=True)

    subject = serializers.PrimaryKeyRelatedField(
        queryset=Subject.objects.all()
    )
    designation = serializers.PrimaryKeyRelatedField(
        queryset=Designation.objects.filter(is_active=True),
        write_only=True
    )

    qualification = serializers.CharField(required=False, allow_blank=True, write_only=True)
    experience_years = serializers.IntegerField(required=False, min_value=0, write_only=True)
    experience_details = serializers.CharField(required=False, allow_blank=True, write_only=True)

    joining_date = serializers.DateField(required=False, write_only=True)
    profile_picture = serializers.ImageField(required=False, write_only=True)

    # -------- READ ONLY FIELDS --------
    id = serializers.IntegerField(read_only=True)
    full_name_display = serializers.SerializerMethodField()
    email_display = serializers.SerializerMethodField()
    phone_display = serializers.SerializerMethodField()

    def get_full_name_display(self, obj):
        return obj.user.full_name

    def get_email_display(self, obj):
        return obj.user.email

    def get_phone_display(self, obj):
        return obj.user.phone

    # ---------- VALIDATION ----------
    def validate_email(self, value):
        if CustomUser.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists.")
        return value

    # ---------- CREATE ----------
    def create(self, validated_data):
        # 1️⃣ Create USER
        user = CustomUser.objects.create(
            full_name=validated_data["full_name"],
            email=validated_data["email"],
            phone=validated_data["phone"],
            role="teacher",
            is_active=True
        )
        user.set_unusable_password()
        user.save()

        # 2️⃣ Create TEACHER PROFILE
        teacher = TeacherProfile.objects.create(
            user=user,
            gender=validated_data["gender"],
            dob=validated_data.get("dob"),
            subject=validated_data["subject"],
            designation=validated_data.get("designation"),
            qualification=validated_data.get("qualification"),
            experience_years=validated_data.get("experience_years", 0),
            experience_details=validated_data.get("experience_details"),
            joining_date=validated_data.get("joining_date", timezone.now().date()),
            profile_picture=validated_data.get("profile_picture"),
            is_active=True,
            is_verified=False
        )

        return teacher

class TeacherRegisterSerializer(serializers.Serializer):
    # CustomUser fields
    full_name = serializers.CharField()
    email = serializers.EmailField()
    phone = serializers.CharField()
    password = serializers.CharField(write_only=True, validators=[validate_password])
    confirm_password = serializers.CharField(write_only=True)
    gender = serializers.ChoiceField(choices=CustomUser.GENDER_CHOICES)
    dob = serializers.DateField()
    profile_picture = serializers.ImageField(required=False)

    # TeacherProfile fields
    subject = serializers.PrimaryKeyRelatedField(
        queryset=Subject.objects.all()
    )

    joining_date = serializers.DateField()
    qualification = serializers.CharField(required=False, allow_blank=True)
    experience_years = serializers.IntegerField(required=False, default=0)
    experience_details = serializers.CharField(required=False, allow_blank=True)
    designation = serializers.PrimaryKeyRelatedField(queryset=Designation.objects.all(), required=False)

    def validate(self, data):
        if data["password"] != data["confirm_password"]:
            raise serializers.ValidationError({"confirm_password": "Passwords do not match"})
        return data

    def create(self, validated_data):
        validated_data.pop("confirm_password")

        user = CustomUser.objects.create(
            full_name=validated_data.pop("full_name"),
            email=validated_data.pop("email"),
            phone=validated_data.pop("phone"),
            gender=validated_data.pop("gender"),
            role="teacher",
        )
        user.set_password(validated_data.pop("password"))
        user.save()

        TeacherProfile.objects.create(
            user=user,
            dob=validated_data.pop("dob"),
            profile_picture=validated_data.pop("profile_picture", None),
            **validated_data
        )
        return user



class TeacherProfileSerializer(serializers.ModelSerializer):    
    class Meta:
        model = TeacherProfile
        fields = "__all__"
        read_only_fields = ['id', 'user']   
        
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['user'] = {
            'id': instance.user.id,
            'email': instance.user.email,
            'full_name': instance.user.full_name,
            'phone': instance.user.phone,
            'role': instance.user.role
        }
        return representation
    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', None)    
        if user_data:
            user = instance.user
            user.email = user_data.get('email', user.email)
            user.full_name = user_data.get('full_name', user.full_name)
            user.phone = user_data.get('phone', user.phone)
            user.save()
            instance.gender = validated_data.get('gender', instance.gender)
            instance.dob = validated_data.get('dob', instance.dob)
            instance.subject = validated_data.get('subject', instance.subject)
            instance.joining_date = validated_data.get('joining_date', instance.joining_date)
            instance.save()
        return instance
    
class TeacherProfileListSerializer(serializers.ModelSerializer):
    user = serializers.SerializerMethodField()  
    class Meta:
        model = TeacherProfile
        fields = ['id', 'user', 'gender', 'dob', 'subject', 'joining_date']
    def get_user(self, obj):    
        return {
            'id': obj.user.id,
            'email': obj.user.email,
            'full_name': obj.user.full_name,
            'phone': obj.user.phone,
            'role': obj.user.role
        }
    

class TeacherListSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source="user.get_full_name")
    email = serializers.EmailField(source="user.email")

    class Meta:
        model = TeacherProfile
        fields = [
            "id",
            "full_name",
            "email",
            "subject",
            "qualification",
            "is_available",
        ]

 # Serializer to update only the CustomUser part
class TeacherUserUpdateSerializer(serializers.ModelSerializer):      
    class Meta:
        model = CustomUser
        fields = ['email', 'full_name', 'phone']

    def validate_email(self, value):
        if CustomUser.objects.exclude(id=self.instance.id).filter(email=value).exists():
            raise serializers.ValidationError("Email is already in use.")
        return value

    def validate_phone(self, value):
        if CustomUser.objects.exclude(id=self.instance.id).filter(phone=value).exists():
            raise serializers.ValidationError("Phone number is already in use.")
        return value

    def update(self, instance, validated_data): 
        instance.email = validated_data.get('email', instance.email)
        instance.full_name = validated_data.get('full_name', instance.full_name)
        instance.phone = validated_data.get('phone', instance.phone)
        instance.save()
        return instance

# Main serializer to update the TeacherProfile + nested user
class TeacherProfileUpdateSerializer(serializers.ModelSerializer):  
    user = TeacherUserUpdateSerializer() 

    class Meta:
        model = TeacherProfile
        fields = ['gender', 'dob', 'subject', 'joining_date', 'user']

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', None)
        
        if user_data:
            user_serializer = TeacherUserUpdateSerializer(instance.user, data=user_data, partial=True)
            user_serializer.is_valid(raise_exception=True)
            user_serializer.save()

        # Update the profile fields
        instance.subject = validated_data.get('subject', instance.subject)
        instance.dob = validated_data.get('dob', instance.dob)
        instance.gender = validated_data.get('gender', instance.gender)
        instance.joining_date = validated_data.get('joining_date', instance.joining_date)
        instance.save()
        return instance


#Searializer for Teacher Login
from django.contrib.auth import authenticate

class TeacherLoginSerializer(serializers.Serializer):
    full_name = serializers.CharField()
    password = serializers.CharField(write_only=True)
    role = serializers.ChoiceField(choices=[('teacher', 'Teacher')])

    def validate(self, attrs):
        full_name = attrs.get('full_name')
        password = attrs.get('password')
        role = attrs.get('role')

        try:
            user = CustomUser.objects.get(full_name=full_name, role=role)
        except CustomUser.DoesNotExist:
            raise serializers.ValidationError("User not found with the provided name and role.")
        except CustomUser.MultipleObjectsReturned:
            raise serializers.ValidationError("Multiple users found with the same name. Please contact admin.")

        # Now use email for authenticate
        authenticated_user = authenticate(email=user.email, password=password)

        if not authenticated_user:
            raise serializers.ValidationError("Invalid password.")

        if not authenticated_user.is_active:
            raise serializers.ValidationError("User account is not active.")

        attrs['user'] = authenticated_user
        return attrs
    
    
    
    #Mark Attendance
# from .models import Attendance
# from django.utils import timezone

# class MarkAttendanceSerializer(serializers.ModelSerializer):
#     status = serializers.ChoiceField(choices=[('present', 'Present'), ('late', 'Late'), ('absent', 'Absent')])
#     reason = serializers.CharField(required=False, allow_blank=True)
#     date = serializers.DateField(required=False)  

#     class Meta:
#         model = Attendance
#         fields = ['status', 'reason', 'date']

#     def validate(self, attrs):
#         status = attrs.get('status')
#         reason = attrs.get('reason', '')

#         if status in ['late', 'absent'] and not reason:
#             raise serializers.ValidationError("Reason is required for late or absent status.")
#         return attrs

#     def create(self, validated_data):
#         user = self.context['request'].user
#         teacher = user

#         # Use provided date or default to today
#         date = validated_data.get('date', timezone.now().date())

#         # Check if already marked
#         if Attendance.objects.filter(teacher=teacher, date=date).exists():
#             raise serializers.ValidationError("Attendance for this date already marked.")
        
#         # Set current time as check-in
#         check_in_time = timezone.now()

#         return Attendance.objects.create(
#         teacher=teacher,
#         date=date,
#         status=validated_data['status'],
#         reason=validated_data.get('reason', ''),
#         check_in_time=check_in_time
#     )


#     #Attendace Checkout
# from datetime import date
# class AttendanceCheckoutSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Attendance
#         fields = ['check_out_time']

#     def update(self, instance, validated_data):
#         if instance.check_out_time:
#             raise serializers.ValidationError("Check-out already marked for today.")

#         instance.check_out_time = validated_data.get('check_out_time', timezone.now())
#         instance.save()
#         return instance
    
# #attendace history
# class AttendanceHistorySerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Attendance
#         fields = ['date', 'status', 'check_in_time', 'check_out_time', 'reason']

#Attendace Leave FIeld
# from .models import Leave
#Substitute Field
class SubstituteTeacherSerializer(serializers.ModelSerializer):
    subject = serializers.SerializerMethodField()

    class Meta:
        model = CustomUser
        fields = ['id', 'full_name', 'subject']

    def get_subject(self, obj):
        try:
            return obj.teacherprofile.subject
        except TeacherProfile.DoesNotExist:
            return None
#Leave Form
# class LeaveCreateSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Leave
#         fields = "__all__"

#     def validate(self, data):
#         if data['from_date'] > data['to_date']:
#             raise serializers.ValidationError("From date cannot be after To date.")
#         return data

#     def create(self, validated_data):
#         validated_data['teacher'] = self.context['request'].user
#         return super().create(validated_data)
    

class TeacherDailyStatusSerializer(serializers.Serializer):
    date = serializers.DateField()
    type = serializers.CharField()  
    status = serializers.CharField()  
    reason = serializers.CharField(allow_blank=True, required=False)
    check_in_time = serializers.TimeField(allow_null=True)
    check_out_time = serializers.TimeField(allow_null=True)



# Assign classrooms
# from .models import ClassRoom
from apps.users.models import CustomUser
from apps.students.serializers import StudentProfileSerializer
from apps.students.models import StudentProfile


# class ClassRoomSerializer(serializers.ModelSerializer):
#     teacher_name = serializers.CharField(source='class_teacher.full_name', read_only=True)
#     teacher_email = serializers.EmailField(source='class_teacher.email', read_only=True)

#  # Add students field
#     students = StudentProfileSerializer(many=True, read_only=True)
#     student_ids = serializers.PrimaryKeyRelatedField(
#         queryset=StudentProfile.objects.all(), many=True, write_only=True, required=False
#     )

#     class Meta:
#         model = ClassRoom
#         fields = "__all__"
#         read_only_fields = ['created_at', 'updated_at']
#         extra_kwargs = {
#             'class_teacher': {'required': False, 'allow_null': True}
#         }

#     def validate_class_teacher(self, value):
#         if not value:
#             raise serializers.ValidationError("Class teacher is required.")
#         if value.role != 'teacher':
#             raise serializers.ValidationError("Assigned user must be a teacher.")
#         return value

#     def create(self, validated_data):
#         # Directly create a new ClassRoom
#         return ClassRoom.objects.create(**validated_data)

#     def update(self, instance, validated_data):
#         # Update allowed fields
#         instance.name = validated_data.get('name', instance.name)
#         instance.section = validated_data.get('section', instance.section)
#         instance.class_teacher = validated_data.get('class_teacher', instance.class_teacher)
#         instance.description = validated_data.get('description', instance.description)
#         instance.save()
#         return instance
    
#Add student to classroom


class StudentCreateSerializer(serializers.ModelSerializer):
    name = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True)
    address = serializers.CharField(write_only=True)
    dob = serializers.DateField(write_only=True)
    admission_status = serializers.ChoiceField(choices=[('active', 'Active'), ('pending', 'Pending')], write_only=True)

    class Meta:
        model = StudentProfile
        fields = ["name", "email", "phone", "address", "dob", "admission_status"]

    def create(self, validated_data):
        name = validated_data.pop("name")
        email = validated_data.pop("email")
        phone = validated_data.pop("phone")
        address = validated_data.pop("address")
        dob = validated_data.pop("dob")
        admission_status = validated_data.pop("admission_status")

        classroom = self.context.get("classroom")   
        
        user = CustomUser.objects.create_user(
            email=email,
            phone=phone,
            full_name=name, 
            password="defaultpassword123"  
        )


        student = StudentProfile.objects.create(
            user=user,
             classroom=classroom,   
            address=address,
            dob=dob,
            admission_status=admission_status
        )

        return student
    

# adding timetable for teacher
# from .models import Timetable

# class TimetableSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Timetable
#         fields = "__all__"

#     # ✅ Ensure selected user is actually a teacher
#     def validate_teacher(self, value):
#         if value.role.lower() != "teacher":
#             raise serializers.ValidationError(
#                 "Selected user is not a teacher."
#             )
#         return value

#     # ✅ Prevent teacher timetable clashes
#     def validate(self, attrs):
#         teacher = attrs.get("teacher")
#         day = attrs.get("day")
#         time_slot = attrs.get("time_slot")
#         academic_year = attrs.get("academic_year")
#         semester = attrs.get("semester")

#         if Timetable.objects.filter(
#             teacher=teacher,
#             day=day,
#             time_slot=time_slot,
#             academic_year=academic_year,
#             semester=semester,
#         ).exists():
#             raise serializers.ValidationError(
#                 "Teacher already has a class in this time slot."
#             )

#         return attrs

#     # ✅ Document validation
#     def validate_document(self, value):
#         if value:
#             if value.size > 5 * 1024 * 1024:
#                 raise serializers.ValidationError(
#                     "File size must be ≤ 5MB"
#                 )

#             allowed_extensions = ('.pdf', '.png', '.jpg', '.jpeg')
#             if not value.name.lower().endswith(allowed_extensions):
#                 raise serializers.ValidationError(
#                     "Only PDF, PNG, JPG, JPEG files are allowed"
#                 )

#         return value

# # Timetable for students

# from .models import StudentTimetable

# class StudentTimetableSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = StudentTimetable
#         fields = "__all__"


# Result Entry
# Serializer #

# from .models import ExamResult
# from apps.students.models import StudentProfile

# # Entry #
# class StudentInfoSerializer(serializers.ModelSerializer):
#     full_name = serializers.CharField(source="user.full_name")

#     class Meta:
#         model = StudentProfile
#         fields = ["id", "full_name", "roll_number", "admission_number", "class_enrolled", "section"]


# # Result Entry

# # Entry #
# from .models import ExamResult
# from apps.students.models import StudentProfile

# class StudentInfoSerializer(serializers.ModelSerializer):
#     full_name = serializers.CharField(source="user.full_name")

#     class Meta:
#         model = StudentProfile
#         fields = ["id", "full_name", "roll_number", "admission_number", "class_enrolled", "section"]

# # Result #

# class ExamResultSerializer(serializers.ModelSerializer):
#     student_name = serializers.CharField(source="student.user.full_name", read_only=True)
#     roll_number = serializers.CharField(source="student.roll_number", read_only=True)
#     percentage = serializers.SerializerMethodField()
#     grade = serializers.SerializerMethodField()

#     class Meta:
#         model = ExamResult
#         fields = [
#             "id", "exam", "subject",
#             "student_name", "roll_number",
#             "marks_obtained","percentage", "grade"
#         ]

#     def get_percentage(self, obj):
#         return round((obj.marks_obtained / obj.max_marks) * 100, 1)

#     def get_grade(self, obj):
#         percent = (obj.marks_obtained / obj.max_marks) * 100
#         if percent >= 80:
#             return "A"
#         elif percent >= 70:
#             return "B+"
#         elif percent >= 60:
#             return "B"
#         elif percent >= 50:
#             return "C"
#         else:
#             return "F"

# # Statistics #
# class ExamStatisticsSerializer(serializers.Serializer):
#     total_students = serializers.IntegerField()
#     average_percentage = serializers.FloatField()
#     highest_percentage = serializers.FloatField()
#     lowest_percentage = serializers.FloatField()
#     students_passed = serializers.IntegerField()
#     students_failed = serializers.IntegerField()

#Academic Optionsclassroom
# from .models import AcademicClassRoom

# class AcademicClassroomSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = AcademicClassRoom
#         fields = '__all__'

# Academic Subject
# from .models import Subject
# from .models import TeacherProfile
# from .models import ClassRoom

# class SubjectSerializer(serializers.ModelSerializer):
#     subject_name = serializers.CharField(source='teacher.subject', read_only=True)
#     teacher_id = serializers.PrimaryKeyRelatedField(queryset=TeacherProfile.objects.all(), source='teacher')

#     class Meta:
#         model = Subject
#         fields = ['id', 'teacher_id', 'subject_name', 'subject_code', 'description', 'assigned_classes']

# # Academic Sport Group
# from .models import SportGroup

# class SportGroupSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = SportGroup
#         fields = '_all_'

# # Academic House Group
# from .models import HouseGroup  

# class HouseGroupSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = HouseGroup
#         fields = '_all_'


# Add Applicant
from .models import StudentApplicant

class StudentApplicantSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentApplicant
        fields = '__all__'

#Subject

# from .models import Subject

# class SubjectSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Subject
#         fields = '__all__'

