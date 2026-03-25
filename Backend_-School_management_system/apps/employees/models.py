from django.db import models
from django.conf import settings
from apps.teachers.models import Department


class EmployeeProfile(models.Model):
    ROLE_CHOICES = [
        ('Admin', 'Admin'),
        ('Academic Officer', 'Academic Officer'),
        ('Staff', 'Staff'),
    ]

    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Other', 'Other'),
    ]

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='employee_profile'
    )

    role = models.CharField(max_length=30, choices=ROLE_CHOICES)
    department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    joining_date = models.DateField()

    is_active = models.BooleanField(default=True)
    is_verified = models.BooleanField(default=False)
    is_suspended = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True,blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    @property
    def full_name(self):
        return self.user.full_name

    @property
    def email(self):
        return self.user.email

    @property
    def phone(self):
        return self.user.phone

    @property
    def current_salary(self):
        """Latest salary record"""
        return self.salaries.first()

    def save(self, *args, **kwargs):
        if self.user.role != 'employee':
            self.user.role = 'employee'
            self.user.save(update_fields=['role'])
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.full_name} ({self.role})"
