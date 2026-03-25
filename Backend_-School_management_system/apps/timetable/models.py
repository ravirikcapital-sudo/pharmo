from django.db import models
from apps.teachers.models import TeacherProfile
from apps.academics.models import Subject
from apps.schoolclassesmanage.models import SchoolClass

class Timetable(models.Model):
    title = models.CharField(max_length=255)
    teacher = models.ForeignKey(
        TeacherProfile, on_delete=models.CASCADE, limit_choices_to={"role": "teacher"}
    )

    subject = models.ForeignKey(
        Subject, on_delete=models.CASCADE, null=True, blank=True
    )

    TIMESLOT_CHOICES = [
        ("08:00 AM - 09:00 AM", "08:00 AM - 09:00 AM"),
        ("09:00 AM - 10:00 AM", "09:00 AM - 10:00 AM"),
        ("10:00 AM - 11:00 AM", "10:00 AM - 11:00 AM"),
        ("11:00 AM - 12:00 PM", "11:00 AM - 12:00 PM"),
        ("01:00 PM - 02:00 PM", "01:00 PM - 02:00 PM"),
        ("02:00 PM - 03:00 PM", "02:00 PM - 03:00 PM"),
        ("03:00 PM - 04:00 PM", "03:00 PM - 04:00 PM"),
    ]

    DAYS_CHOICES = [
        ("MON", "Monday"),
        ("TUE", "Tuesday"),
        ("WED", "Wednesday"),
        ("THU", "Thursday"),
        ("FRI", "Friday"),
        ("SAT", "Saturday"),
    ]

    school_class = models.ForeignKey(SchoolClass, on_delete=models.CASCADE)
    time_slot = models.CharField(max_length=50, choices=TIMESLOT_CHOICES)
    day = models.CharField(max_length=3, choices=DAYS_CHOICES, default="MON")
    academic_year = models.CharField(max_length=20)
    semester = models.CharField(max_length=20)
    notes = models.TextField(blank=True, null=True)
    document = models.FileField(upload_to="timetable_docs/", blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = (
            "teacher",
            "day",
            "time_slot",
            "academic_year",
            "semester",
        )

    def __str__(self):
        return f"{self.title} - {self.teacher.user.full_name}"

class StudentTimetable(models.Model):
    timetable_title = models.CharField(max_length=255)
    class_enrolled = models.ForeignKey(
        SchoolClass, on_delete=models.CASCADE, related_name="student_timetables"
    )
    academic_year = models.CharField(max_length=50)
    semester = models.CharField(max_length=50)
    additional_notes = models.TextField(blank=True, null=True)
    supporting_documents = models.FileField(
        upload_to="student_timetable_docs/", blank=True, null=True
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.timetable_title} - {self.class_enrolled}"
