from django.db import models


class Facility(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    monthly_fee = models.DecimalField(max_digits=8, decimal_places=2)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class ClassRoom(models.Model):
    
    ROOM_TYPE_CHOICES = [
        ("Normal", "Normal"),
        ("Lab", "Lab"),
        ("Smart", "Smart"),
    ]
    

    school_class = models.OneToOneField(
        "schoolclassesmanage.SchoolClass",
        on_delete=models.CASCADE,
        blank=True,
        null=True
    )

    class_teacher = models.ForeignKey(
        "teachers.TeacherProfile",
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    
    room_number = models.CharField(
        max_length=20,
        unique=True,
        blank=True,
        null=True
    )

    building = models.CharField(
        max_length=50,
        blank=True,
        null=True
    )

    floor = models.CharField(
        max_length=20,
        blank=True,
        null=True
    )

    capacity = models.PositiveIntegerField(blank=True, null=True)

    room_type = models.CharField(
        max_length=20,
        choices=ROOM_TYPE_CHOICES,
        default="Normal"
    )

    is_active = models.BooleanField(default=True)

    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.school_class} → Room {self.room_number}"
