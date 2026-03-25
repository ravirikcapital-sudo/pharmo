from django.db import models

# Create your models here.
# apps/parents/models.py
from django.db import models
from django.conf import settings


RELATIONSHIP_CHOICES = [('mother', 'Mother'), ('father', 'Father'), ('guardian', 'Guardian')]

class ParentProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='parent_profile')
    relationship = models.CharField(max_length=20, choices=RELATIONSHIP_CHOICES)
    child_admission_number = models.CharField(max_length=50)
    address = models.CharField(max_length=255, default='No Address')
    city = models.CharField(max_length=100, blank=True)
    state = models.CharField(max_length=100, blank=True)
    zip_code = models.CharField(max_length=10, blank=True)
    mobile_number = models.CharField(max_length=15, blank=True)
    alternate_number = models.CharField(max_length=15, blank=True)
    is_active = models.BooleanField(default=True)
    is_verified = models.BooleanField(default=False)
    is_suspended = models.BooleanField(default=False)
    is_deleted = models.BooleanField(default=False)
   
    updated_at = models.DateTimeField(auto_now=True)    
    class Meta:
        verbose_name = 'Parent Profile'
        verbose_name_plural = 'Parent Profiles'
    def delete(self, *args, **kwargs):
        self.is_deleted = True
        self.save(update_fields=['is_deleted'])
    def restore(self):
        self.is_deleted = False
        self.save(update_fields=['is_deleted'])
    def suspend(self):
        self.is_suspended = True
        self.save(update_fields=['is_suspended'])
    def unsuspend(self):
        self.is_suspended = False   
        self.save(update_fields=['is_suspended'])
    def verify(self):
        self.is_verified = True
        self.save(update_fields=['is_verified'])
    def unverify(self):
        self.is_verified = False
        self.save(update_fields=['is_verified'])
    def activate(self):
        self.is_active = True
        self.save(update_fields=['is_active'])
    def deactivate(self):
        self.is_active = False
        self.save(update_fields=['is_active'])
    def get_full_name(self):
        return self.user.full_name
    def get_email(self):
        return self.user.email
    def get_phone(self):
        return self.user.phone
    def get_address(self):
        return f"{self.address}, {self.city}, {self.state}, {self.zip_code}"
    def get_relationship(self):
        return self.relationship
    def get_child_admission_number(self):
        return self.child_admission_number
    def get_mobile_number(self):
        return self.mobile_number
    def get_alternate_number(self):
        return self.alternate_number
    def save(self, *args, **kwargs):
        if not self.user.role:
            self.user.role = 'parent'
        super().save(*args, **kwargs)
        self.user.save(update_fields=['role'])
    def __repr__(self):
        return f"<ParentProfile: {self.user.full_name} ({self.relationship})>"  
    
    def __str__(self):
        return f"Parent: {self.user.full_name}"


class Complaint(models.Model):
    USER_TYPE_CHOICES = [
        ('Student', 'Student'),
        ('Parent', 'Parent'),
        ('Teacher', 'Teacher'),
        ('Staff', 'Staff')
    ]

    STATUS_CHOICES = [
        ('Pending', 'Pending'),
        ('In Progress', 'In Progress'),
        ('Resolved', 'Resolved')
    ]

    id = models.BigAutoField(primary_key=True)
    complaint_id = models.CharField(max_length=10, unique=True, blank=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True)
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES)
    category = models.CharField(max_length=50, default='General')
    title = models.CharField(max_length=255)
    description = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    reported_by_name = models.CharField(max_length=255, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def save(self, *args, **kwargs):
        created = self.pk is None
        super().save(*args, **kwargs)
        if created and not self.complaint_id:
            self.complaint_id = f"c{self.id:03d}"
            super().save(update_fields=['complaint_id'])

    def __str__(self):
        return f"Complaint {self.complaint_id}: {self.title}"