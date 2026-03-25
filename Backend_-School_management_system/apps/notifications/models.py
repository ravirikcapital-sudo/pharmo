from django.db import models
from django.conf import settings

User = settings.AUTH_USER_MODEL


class Notification(models.Model):
    NOTIFICATION_TYPES = (
        ("Admission", "Admission"),
        ("Attendance", "Attendance"),
        ("Academic", "Academic"),
        ("Fees", "Fees"),
        ("General", "General"),
    )
    
    RECIPIENT_TYPES = (
    ('All Students', 'All Students'),
    ('All Teachers', 'All Teachers'),
    ('All Parents', 'All Parents'),
    ('Class 10', 'Class 10'),
    ('Class 9', 'Class 9'),
    ('Class 8', 'Class 8'),
    ('Class 7', 'Class 7'),
    ('Class 6', 'Class 6'),
    ('Class 5', 'Class 5'),
    ('Class 4', 'Class 4'),
    ('Class 3', 'Class 3'),
    ('Class 2', 'Class 2'),
    ('Class 1', 'Class 1'),
    ('UKG', 'UKG'),
    ('LKG', 'LKG'),
    ('Nursery', 'Nursery'),
    ('Specific Students', 'Specific Students'),
    ('Specific Teachers', 'Specific Teachers'),
    ('Specific Parents', 'Specific Parents'),
    )

    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    
    recipient = models.CharField(
        max_length=50,choices=RECIPIENT_TYPES
    )
    
    title = models.CharField(max_length=255)
    message = models.TextField()
    notification_type = models.CharField(
        max_length=20,
        choices=NOTIFICATION_TYPES
    )

    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.title} → {self.recipient}"
