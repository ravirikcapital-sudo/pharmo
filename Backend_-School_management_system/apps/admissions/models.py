from django.db import models
from apps.schoolclassesmanage.models import SchoolClass

CATEGORY_CHOICES = [
    ('GEN', 'General'),
    ('SC', 'Scheduled Caste'),
    ('ST', 'Scheduled Tribe'),
    ('OBC', 'Other Backward Class'),
    ('EWS', 'Economically Weaker Section'),
]

GENDER_CHOICES = [
    ('Male', 'Male'),
    ('Female', 'Female'),
    ('Other', 'Other'),
]

STUDENT_TYPE = [
    ('New', 'New'),
    ('Transfer', 'Transfer'),
]

STATUS_CHOICES = [
    ('Pending', 'Pending'),
    ('Approved', 'Approved'),
    ('Rejected', 'Rejected'),
]
 
STATS_CHOICES = [
    ('New', 'New'),
    ('Under Review', 'Under Review'),
    ('Pending Documents', 'Pending Documents'),
]
class AdmissionApplication(models.Model):
    # Step 1: Basic Information
    full_name = models.CharField(max_length=100)
    dob = models.DateField()
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    nationality = models.CharField(max_length=50)
    aadhaar_number = models.CharField(max_length=12)
    category = models.CharField(max_length=10, choices=CATEGORY_CHOICES)
    academic_year = models.CharField(max_length=9)  # e.g. "2025-26"
    class_applied = models.ForeignKey(
        SchoolClass,
        on_delete=models.PROTECT,
        related_name="admission_applications"
    )
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Approved')
    admission_date = models.DateField(null=True)
    student_type = models.CharField(max_length=10, choices=STUDENT_TYPE)
    email = models.EmailField()
    phone = models.CharField(max_length=15)
    
    created_at = models.DateTimeField(auto_now_add=True,null=True)

    # Step 2: Parent / Guardian Details
    father_name = models.CharField(max_length=100)
    father_occupation = models.CharField(max_length=100, blank=True)
    mother_name = models.CharField(max_length=100)
    mother_occupation = models.CharField(max_length=100, blank=True)
    guardian_name = models.CharField(max_length=100, blank=True)
    guardian_relationship = models.CharField(max_length=50, blank=True)
    guardian_contact = models.CharField(max_length=15, blank=True)

    # Step 3: Contact & Address
    address = models.TextField()
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    zip_code = models.CharField(max_length=10)
    alternate_number = models.CharField(max_length=15, blank=True)

    # Step 4: Document Upload
    photo = models.FileField(upload_to='admissions/photos/')
    signature = models.FileField(upload_to='admissions/signatures/')
    birth_certificate = models.FileField(upload_to='admissions/birth_certificates/')
    aadhaar_card = models.FileField(upload_to='admissions/id_proofs/')
    transfer_certificate = models.FileField(upload_to='admissions/tc/', blank=True, null=True)
    previous_report = models.FileField(upload_to='admissions/reports/', blank=True, null=True)
    caste_certificate = models.FileField(upload_to='admissions/caste/', blank=True, null=True)
    medical_certificate = models.FileField(upload_to='admissions/medical/', blank=True, null=True)

    # Payment & Submission
    is_paid = models.BooleanField(default=False)
    transaction_id = models.CharField(max_length=100, blank=True, null=True)
    payment_date = models.DateTimeField(blank=True, null=True)
    is_submitted = models.BooleanField(default=False)
    submitted_at = models.DateTimeField(auto_now_add=True, null=True)

    def __str__(self):
        return f"{self.full_name} - {self.class_applied}"
