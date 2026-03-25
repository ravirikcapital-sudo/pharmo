from rest_framework import serializers
from .models import AdmissionApplication

class AdmissionApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = '__all__'
        read_only_fields = ['is_paid', 'is_submitted', 'submitted_at']

class AdmissionStep1Serializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            "id", "full_name", "dob", "gender", "nationality",
            "aadhaar_number", "category", "academic_year",
            "class_applied", "admission_date", "student_type",
            "email", "phone"
        ]

class ParentGuardianDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            'father_name', 'father_occupation',
            'mother_name', 'mother_occupation',
            'guardian_name', 'guardian_relationship', 'guardian_contact'
        ]

class ContactAddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            'address', 'city', 'state', 'zip_code',
            'mobile_number', 'alternate_number'
        ]

# admissions/serializers.py

class DocumentUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            'photo', 'signature', 'birth_certificate', 'aadhaar_card',
            'transfer_certificate', 'previous_report',
            'caste_certificate', 'medical_certificate',
            'is_paid', 'is_submitted'
        ]


from rest_framework import serializers
from .models import AdmissionApplication
from apps.schoolclassesmanage.models import SchoolClass

# --------------------------
# STEP 1 — BASIC INFORMATION
# --------------------------
class AdmissionStep1Serializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            "id",
            "full_name", "dob", "gender", "nationality",
            "aadhaar_number", "category", "academic_year",
            "class_applied", "admission_date", "student_type",
            "email", "phone",
        ]


# ----------------------------------
# STEP 2 — PARENT / GUARDIAN DETAILS
# ----------------------------------
class ParentGuardianDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            "father_name",
            "father_occupation",
            "mother_name",
            "mother_occupation",
            "guardian_name",
            "guardian_relationship",
            "guardian_contact",
        ]


# ----------------------------
# STEP 3 — CONTACT & ADDRESS
# ----------------------------
class ContactAddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            "address",
            "city",
            "state",
            "zip_code",
            "mobile_number",
            "alternate_number",
        ]


# -------------------------
# STEP 4 — DOCUMENT UPLOAD
# -------------------------
class DocumentUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = [
            "photo",
            "signature",
            "birth_certificate",
            "aadhaar_card",
            "transfer_certificate",
            "previous_report",
            "caste_certificate",
            "medical_certificate",
        ]
        extra_kwargs = {
            "photo": {"required": False},
            "signature": {"required": False},
            "birth_certificate": {"required": False},
            "aadhaar_card": {"required": False},
            "transfer_certificate": {"required": False},
            "previous_report": {"required": False},
            "caste_certificate": {"required": False},
            "medical_certificate": {"required": False},
        }


# ----------------------------------
# FULL MODEL SERIALIZER (ADMIN USE)
# ----------------------------------
class AdmissionApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdmissionApplication
        fields = '__all__'
        read_only_fields = [
            "is_paid",
            "transaction_id",
            "payment_date",
            "is_submitted",
            "submitted_at",
        ]


class PendingAdmissionListSerializer(serializers.ModelSerializer):
    class_applied = serializers.CharField(source="class_applied.name", read_only=True)

    class Meta:
        model = AdmissionApplication
        fields = [
            "id",
            "full_name",
            "father_name",
            "phone",
            "class_applied",
            "status",
            "created_at",
        ]


class NewApplicantSerializer(serializers.ModelSerializer):
    class_applied = serializers.SlugRelatedField(
        slug_field="name",
        queryset=SchoolClass.objects.all()
    )

    class Meta:
        model = AdmissionApplication
        fields = [
            "id",
            "photo",
            "full_name",
            "father_name",
            "mother_name",
            "status",
            "class_applied",
            "dob",
            "gender",
            "city",
            "address",
            "created_at",
        ]
        read_only_fields = ["id", "created_at"]
        