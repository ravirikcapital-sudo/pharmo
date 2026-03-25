# Create your models here.
# users/models.py
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.db import models

class CustomUserManager(BaseUserManager):
    def create_user(self, email, full_name, phone, password=None, **extra_fields):
        if not email:
            raise ValueError('Email is required')
        email = self.normalize_email(email)
        user = self.model(email=email, full_name=full_name, phone=phone, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, full_name, phone, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, full_name, phone, password, **extra_fields)


class CustomUser(AbstractBaseUser, PermissionsMixin):
    ROLE_CHOICES = [
        ('student', 'Student'),
        ('teacher', 'Teacher'),
        ('parent', 'Parent'),
        ('admin', 'Admin'),
        ('academic_officer', 'Academic Officer'),
    ]
    GENDER_CHOICES = [
        ('male', 'Male'),
        ('female', 'Female'),
        ('other', 'Other'),
    ]
    email = models.EmailField(unique=True)
    
    full_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=15)
   
    profile_picture = models.ImageField(upload_to='profile_pictures/', blank=True, null=True)
    # Additional fields can be added here as needed
    # User role and status fields
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='student')
    subject = models.CharField(max_length=100, blank=True, null=True)
    joining_date = models.DateField(blank=True, null=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)
    dob = models.DateField(blank=True, null=True,unique=False)  # Date of Birth
    address = models.CharField(max_length=255, blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    state = models.CharField(max_length=100, blank=True, null=True)
    zip_code = models.CharField(max_length=10, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)
    is_suspended = models.BooleanField(default=False)
    is_deleted = models.BooleanField(default=False) # Soft delete flag  
    
    updated_at = models.DateTimeField(auto_now=True)
    # Additional fields can be added here as needed
    # Custom user manager   
    
    is_approved = models.BooleanField(default=False)  # new 
    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['full_name', 'phone', 'role']

    def __str__(self):
        return self.email

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
        return self.full_name
    def get_email(self):
        return self.email
    def get_phone(self):
        return self.phone
    def get_role(self):
        return self.role
    def get_address(self):
        # Assuming address is a field in the user model
        return getattr(self, 'address', None)
    def set_password(self, raw_password):
        super().set_password(raw_password)
    def check_password(self, raw_password):
        return super().check_password(raw_password) 
    def has_perm(self, perm, obj=None):
        return self.is_active and self.is_staff
    def has_module_perms(self, app_label):
        return self.is_active and self.is_staff
    def get_short_name(self):
        return self.full_name.split()[0] if self.full_name else ''
    def get_full_address(self):
        # Assuming address is a field in the user model
        return getattr(self, 'address', None)
    def get_profile_picture(self):
        # Assuming profile_picture is a field in the user model
        return getattr(self, 'profile_picture', None)
    def get_permissions(self):
        return self.get_all_permissions()
    def get_groups(self):
        return self.groups.all()    
    def get_user_permissions(self):
        return self.user_permissions.all()
    def get_user_permissions_dict(self):
        return {perm.codename: perm.name for perm in self.get_user_permissions()}
    def get_group_permissions(self):
        return {group.name: group.permissions.all() for group in self.groups.all()}
    def get_user_permissions_list(self):
        return [perm.codename for perm in self.get_user_permissions()]  

RELATIONSHIP_CHOICES = [('mother', 'Mother'), ('father', 'Father'), ('guardian', 'Guardian')]


class ParentStudentMapping(models.Model):
    parent = models.ForeignKey(
        CustomUser,
        on_delete=models.CASCADE,
        related_name='parent_links',
        limit_choices_to={'role': 'parent'}
    )

    student = models.ForeignKey(
        CustomUser,
        on_delete=models.CASCADE,
        related_name='student_links',
        limit_choices_to={'role': 'student'}
    )

    relationship = models.CharField(max_length=20, choices=RELATIONSHIP_CHOICES)
    is_primary_guardian = models.BooleanField(default=False)

    class Meta:
        unique_together = ('parent', 'student')
