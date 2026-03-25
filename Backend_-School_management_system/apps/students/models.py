from django.db import models, transaction
from django.conf import settings
from django.utils import timezone
from django.db.models import Max
from datetime import datetime, date
from apps.schoolclassesmanage.models import SchoolClass


class StudentProfile(models.Model):

    GENDER_CHOICES = [
        ("Male", "Male"),
        ("Female", "Female"),
        ("Other", "Other"),
    ]

    BLOOD_GROUP_CHOICES = [
        ("A+", "A+"), ("A-", "A-"),
        ("B+", "B+"), ("B-", "B-"),
        ("O+", "O+"), ("O-", "O-"),
        ("AB+", "AB+"), ("AB-", "AB-"),
    ]

    ADMISSION_STATUS_CHOICES = [
        ("Active", "Active"),
        ("Inactive", "Inactive"),
        ("Pending", "Pending"),
    ]

    # 🔗 Link to CustomUser
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="student_profile",
    )

    admission_number = models.CharField(max_length=50, unique=True, editable=False)
    admission_date = models.DateField(default=date.today)

    # 🎯 Dropdown will come from this ForeignKey
    class_enrolled = models.ForeignKey(
        SchoolClass,
        on_delete=models.SET_NULL,
        null=True,
        related_name="students",
    )

    roll_number = models.PositiveIntegerField(editable=False, null=True, blank=True)

    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)
    dob = models.DateField(blank=True, null=True)
    blood_group = models.CharField(max_length=5, choices=BLOOD_GROUP_CHOICES, blank=True)
    admission_status = models.CharField(max_length=10, choices=ADMISSION_STATUS_CHOICES, default="Active")

    guardian_name = models.CharField(max_length=100, blank=True, null=True)
    guardian_relationship = models.CharField(max_length=50, blank=True, null=True)

    address = models.CharField(max_length=255, blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    state = models.CharField(max_length=100, blank=True, null=True)
    zip_code = models.CharField(max_length=10, blank=True, null=True)
    phone = models.CharField(max_length=15, blank=True, null=True)

    created_at = models.DateTimeField(default=timezone.now)

    # 🔢 Auto Admission Number + Roll Number
    def save(self, *args, **kwargs):

        # Generate Admission Number once
        if not self.admission_number:
            with transaction.atomic():
                current_year = datetime.now().year
                last_student = StudentProfile.objects.filter(
                    admission_number__startswith=f"STU_{current_year}_"
                ).aggregate(max_number=Max("admission_number"))

                if last_student["max_number"]:
                    last_seq = int(last_student["max_number"].split("_")[-1])
                    next_seq = last_seq + 1
                else:
                    next_seq = 1

                self.admission_number = f"STU_{current_year}_{str(next_seq).zfill(4)}"

        # Assign roll number based on class
        if not self.roll_number and self.class_enrolled:
            existing_rolls = StudentProfile.objects.filter(
                class_enrolled=self.class_enrolled
            ).count()
            self.roll_number = existing_rolls + 1

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.user.full_name} - {self.class_enrolled}"


# Assignment models
class Assignment(models.Model):
    TYPE_CHOICES = [
        ("Assignment", "Assignment"),
        ("Homework", "Homework"),
    ]

    STATUS_CHOICES = [
        ("Assigned", "Assigned"),
        ("Submitted", "Submitted"),
        ("Overdue", "Overdue"),
        ("Graded", "Graded"),
    ]

    id = models.BigAutoField(primary_key=True)
    assignment_id = models.CharField(max_length=10, unique=True, blank=True)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    subject = models.CharField(max_length=100, blank=True)
    subject_color = models.CharField(max_length=50, blank=True)
    instructor = models.CharField(max_length=255, blank=True)
    type = models.CharField(max_length=20, choices=TYPE_CHOICES, default="Assignment")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="Assigned")

    class_assigned = models.ForeignKey(SchoolClass, on_delete=models.SET_NULL, null=True, blank=True, related_name='assignments')

    assigned_date = models.DateField(null=True, blank=True)
    due_date = models.DateField(null=True, blank=True)

    created_by = models.ForeignKey(settings.AUTH_USER_MODEL, null=True, blank=True, on_delete=models.SET_NULL, related_name='created_assignments')

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def save(self, *args, **kwargs):
        created = self.pk is None
        super().save(*args, **kwargs)
        if created and not self.assignment_id:
            self.assignment_id = f"a{self.id:03d}"
            super().save(update_fields=['assignment_id'])

    def __str__(self):
        return f"Assignment {self.assignment_id}: {self.title}"


class AssignmentAttachment(models.Model):
    assignment = models.ForeignKey(Assignment, on_delete=models.CASCADE, related_name='attachments')
    file = models.FileField(upload_to='assignments/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Attachment for {self.assignment.assignment_id} - {self.file.name}"


class AssignmentSubmission(models.Model):
    STATUS_CHOICES = [
        ('Submitted', 'Submitted'),
        ('Late', 'Late'),
        ('Graded', 'Graded'),
    ]

    id = models.BigAutoField(primary_key=True)
    assignment = models.ForeignKey(Assignment, on_delete=models.CASCADE, related_name='submissions')
    student = models.ForeignKey(StudentProfile, on_delete=models.CASCADE, related_name='submissions')
    content = models.TextField(blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Submitted')
    grade = models.CharField(max_length=20, blank=True)
    feedback = models.TextField(blank=True)
    submitted_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('assignment', 'student')
        ordering = ['-submitted_at']

    def __str__(self):
        return f"Submission {self.assignment.assignment_id} by {self.student.user.full_name}"


class SubmissionAttachment(models.Model):
    submission = models.ForeignKey(AssignmentSubmission, on_delete=models.CASCADE, related_name='attachments')
    file = models.FileField(upload_to='assignment_submissions/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Submission attachment {self.file.name} for {self.submission}"
