from rest_framework import serializers


# =========================
# OVERVIEW
# =========================
class OverviewReportSerializer(serializers.Serializer):
    total_students = serializers.IntegerField()
    total_teachers = serializers.IntegerField()
    total_employees = serializers.IntegerField()


# =========================
# STATUS BREAKDOWN
# =========================
class StatusCountSerializer(serializers.Serializer):
    active = serializers.IntegerField()
    inactive = serializers.IntegerField()


# =========================
# ACADEMIC (Class strength)
# =========================
class AcademicClassStrengthSerializer(serializers.Serializer):
    school_class = serializers.CharField()
    total_students = serializers.IntegerField()


class AcademicReportSerializer(serializers.Serializer):
    class_strength = AcademicClassStrengthSerializer(many=True)
    
class ClassSectionStrengthSerializer(serializers.Serializer):
    school_class = serializers.CharField()
    section = serializers.CharField(allow_null=True)
    total_students = serializers.IntegerField()



# =========================
# ENROLLMENT
# =========================
class EnrollmentItemSerializer(serializers.Serializer):
    class_applied = serializers.CharField()
    total_admissions = serializers.IntegerField()


class EnrollmentReportSerializer(serializers.Serializer):
    enrollment_summary = EnrollmentItemSerializer(many=True)
    total_applications = serializers.IntegerField()
    submitted_applications = serializers.IntegerField()
    paid_applications = serializers.IntegerField()
    gender_distribution = serializers.DictField(child=serializers.IntegerField())

# =========================
# TEACHERS
# =========================
class TeachersByDesignationSerializer(serializers.Serializer):
    designation = serializers.CharField()
    total = serializers.IntegerField()


class TeachersBySubjectSerializer(serializers.Serializer):
    subject = serializers.CharField()
    total = serializers.IntegerField()


class TeachersByGenderSerializer(serializers.Serializer):
    gender = serializers.CharField()
    total = serializers.IntegerField()


class SalarySummarySerializer(serializers.Serializer):
    total_salary_paid = serializers.DecimalField(max_digits=12, decimal_places=2)
    total_salary_unpaid = serializers.DecimalField(max_digits=12, decimal_places=2)


class AttendanceSummarySerializer(serializers.Serializer):
    status = serializers.CharField()
    total = serializers.IntegerField()


class TeachersReportSerializer(serializers.Serializer):
    summary = serializers.DictField()
    subject_wise_teachers = TeachersBySubjectSerializer(many=True)
    designation_wise_teachers = TeachersByDesignationSerializer(many=True)
    gender_wise_teachers = TeachersByGenderSerializer(many=True)
    salary_summary = SalarySummarySerializer()
    attendance_summary = AttendanceSummarySerializer(many=True)



# =========================
# RATIOS
# =========================
class RatioSerializer(serializers.Serializer):
    student_teacher_ratio = serializers.FloatField()
    student_employee_ratio = serializers.FloatField()

# =========================
# FINANCIAL
# =========================
class SalarySummarySerializer(serializers.Serializer):
    paid = serializers.DecimalField(max_digits=12, decimal_places=2)
    unpaid = serializers.DecimalField(max_digits=12, decimal_places=2)

class FinancialReportSerializer(serializers.Serializer):
    employee_salary = SalarySummarySerializer()
    teacher_salary = SalarySummarySerializer()
    note = serializers.CharField()

class FeeSummarySerializer(serializers.Serializer):
    collected = serializers.DecimalField(max_digits=12, decimal_places=2)
    pending = serializers.DecimalField(max_digits=12, decimal_places=2)


class TimeBasedSummarySerializer(serializers.Serializer):
    monthly = serializers.DictField(child=serializers.DecimalField(max_digits=12, decimal_places=2))
    yearly = serializers.DictField(child=serializers.DecimalField(max_digits=12, decimal_places=2))


class PaymentModeSerializer(serializers.Serializer):
    cash = serializers.DecimalField(max_digits=12, decimal_places=2)
    online = serializers.DecimalField(max_digits=12, decimal_places=2)
    
    
    

class ClassroomReportSerializer(serializers.Serializer):
    class_name = serializers.CharField()
    subject = serializers.CharField()
    total_students = serializers.IntegerField()
    performance = serializers.FloatField()
    absentee_rate = serializers.FloatField()
    top_performer = serializers.CharField(allow_null=True)
    recent_activity = serializers.CharField(allow_null=True)