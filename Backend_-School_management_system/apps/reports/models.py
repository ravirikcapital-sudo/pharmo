from django.db import models
from apps.schoolclassesmanage.models import SchoolClass
from apps.academics.models import Subject
from apps.students.models import StudentProfile


class Assessment(models.Model):
    school_class = models.ForeignKey(
        SchoolClass,
        on_delete=models.CASCADE,
        related_name="assessments"
    )
    subject = models.ForeignKey(
        Subject,
        on_delete=models.CASCADE,
        related_name="assessments"
    )
    title = models.CharField(max_length=100)
    date = models.DateField()

    def __str__(self):
        return f"{self.title} - {self.school_class}"


class AssessmentResult(models.Model):
    assessment = models.ForeignKey(
        Assessment,
        on_delete=models.CASCADE,
        related_name="results"
    )
    student = models.ForeignKey(
        StudentProfile,
        on_delete=models.CASCADE,
        related_name="results"
    )
    marks = models.FloatField()

    def __str__(self):
        return f"{self.student} - {self.marks}"
