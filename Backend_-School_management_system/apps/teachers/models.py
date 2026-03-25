from django.db import models
from django.conf import settings


class Designation(models.Model):
    title = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.title


class TeacherProfile(models.Model):

    GENDER_CHOICES = [
        ("Male", "Male"), ("Female", "Female"), ("Other", "Other")
        ]
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="teacher_profile",
    )

    role = models.CharField(max_length=20, default="teacher", editable=False)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    dob = models.DateField(blank=True, null=True)

    subject = models.ForeignKey(
        "academics.Subject",
        on_delete=models.SET_NULL,
        null=True,
        related_name="teachers",
    )

    joining_date = models.DateField()

    designation = models.ForeignKey(
        "teachers.Designation",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="teachers",
    )

    qualification = models.CharField(max_length=255, blank=True, null=True)
    experience_years = models.PositiveIntegerField(default=0)
    experience_details = models.TextField(blank=True, null=True)

    profile_picture = models.ImageField(
        upload_to="teacher_profiles/", blank=True, null=True
    )

    is_available = models.BooleanField(default=True)
    is_active = models.BooleanField(default=True)
    is_verified = models.BooleanField(default=False)
    is_suspended = models.BooleanField(default=False)
    is_deleted = models.BooleanField(default=False)

    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = "Teacher Profile"
        verbose_name_plural = "Teacher Profiles"

    def __str__(self):
        return f"{self.user.full_name} - {self.subject}"

    def save(self, *args, **kwargs):
        if self.user.role != "teacher":
            self.user.role = "teacher"
            self.user.save(update_fields=["role"])
        super().save(*args, **kwargs)

    # Soft delete
    def delete(self, *args, **kwargs):
        self.is_deleted = True
        self.save(update_fields=["is_deleted"])


class Department(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class StudentApplicant(models.Model):
    full_name = models.CharField(max_length=255)
    father_name = models.CharField(max_length=255)
    mother_name = models.CharField(max_length=255)
    date_of_birth = models.DateField()

    city = models.CharField(max_length=100)
    current_address = models.TextField()
    photo = models.ImageField(upload_to="student_photos/", blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.full_name
