from django.db import models
from django.db.models import Sum
from django.utils import timezone

from apps.students.models import StudentProfile
from apps.schoolclassesmanage.models import SchoolClass
from apps.academics.models import Subject


class Exam(models.Model):
    EXAM_TYPE_CHOICES = [
        ("Unit Test", "Unit Test"),
        ("Midterm", "Midterm"),
        ("Final", "Final"),
        ("Quarterly", "Quarterly"),
    ]

    name = models.CharField(max_length=100,blank=True)
    exam_type = models.CharField(max_length=50, choices=EXAM_TYPE_CHOICES)
    school_class = models.ForeignKey(
        SchoolClass,
        on_delete=models.CASCADE,
        related_name="exams"
    )
    exam_date = models.DateField()
    is_published = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-exam_date"]

    def __str__(self):
        return f"{self.name} - {self.school_class.name}"


class StudentExamResult(models.Model):
    student = models.ForeignKey(
        StudentProfile,
        on_delete=models.CASCADE,
        related_name="exam_results"
    )
    exam = models.ForeignKey(
        Exam,
        on_delete=models.CASCADE,
        related_name="results"
    )
    subject = models.ForeignKey(
        Subject,
        on_delete=models.CASCADE
    )

    marks_obtained = models.DecimalField(max_digits=5, decimal_places=2)
    total_marks = models.DecimalField(max_digits=5, decimal_places=2)

    percentage = models.DecimalField(max_digits=5, decimal_places=2, blank=True)
    grade = models.CharField(max_length=2, blank=True)

    class Meta:
        unique_together = ("student", "exam", "subject")

    def save(self, *args, **kwargs):
        if self.total_marks > 0:
            self.percentage = (self.marks_obtained / self.total_marks) * 100

            if self.percentage >= 90:
                self.grade = "A+"
            elif self.percentage >= 80:
                self.grade = "A"
            elif self.percentage >= 70:
                self.grade = "B"
            elif self.percentage >= 60:
                self.grade = "C"
            else:
                self.grade = "F"

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.student.user.full_name} - {self.exam.name}"
