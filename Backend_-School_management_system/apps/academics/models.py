from django.db import models


class Subject(models.Model):
    name = models.CharField(max_length=100, null=True, blank=True)
    code = models.CharField(max_length=20, unique=True)
    description = models.TextField(blank=True, null=True)
    credits = models.PositiveIntegerField(null=True, blank=True)

    assigned_classes = models.ManyToManyField(
        "schoolclassesmanage.SchoolClass",
        blank=True,
        related_name="subjects"
    )

    def __str__(self):
        return f"{self.name} ({self.code})"



class SportsGroup(models.Model):
    SPORT_CHOICES = [
        ('Football', 'Football'),
        ('Basketball', 'Basketball'),
        ('Cricket', 'Cricket'),
        ('Tennis', 'Tennis'),
        ('Swimming', 'Swimming'),
        ('Athletics', 'Athletics'),
        ('Badminton', 'Badminton'),
        ('Volleyball', 'Volleyball'),
        ('Hockey', 'Hockey'),
        ('Table Tennis', 'Table Tennis'),
        ('Baseball', 'Baseball'),
        ('Rugby', 'Rugby'),
        ('Wrestling', 'Wrestling'),
    ]

    group_name = models.CharField(max_length=100)
    sport_type = models.CharField(max_length=50, choices=SPORT_CHOICES)
    coach_name = models.CharField(max_length=100)
    max_members = models.PositiveIntegerField()
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("group_name", "sport_type")

    def __str__(self):
        return f"{self.group_name} ({self.sport_type})"


class HouseGroup(models.Model):
    house_name = models.CharField(max_length=100, unique=True)
    house_color = models.CharField(max_length=20)
    house_captain = models.CharField(max_length=100, blank=True, null=True)
    vice_captain = models.CharField(max_length=100, blank=True, null=True)
    house_motto = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.house_name
