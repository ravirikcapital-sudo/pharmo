# apps/fees/models.py

from django.db import models
from django.utils import timezone


class ClassFeeStructure(models.Model):
    school_class = models.ForeignKey(
        "schoolclassesmanage.SchoolClass",
        on_delete=models.CASCADE,
        blank=True
    )

    tuition_fee = models.DecimalField(max_digits=10, decimal_places=2)
    lab_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    exam_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    other_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    def total_fee(self):
        return (
            self.tuition_fee +
            self.lab_fee +
            self.exam_fee +
            self.other_fee
        )

    def __str__(self):
        return f"{self.classroom} Fee Structure"


class StudentFee(models.Model):

    STATUS_CHOICES = [
        ("Paid", "Paid"),
        ("Partial", "Partial"),
        ("Unpaid", "Unpaid"),
        ("Late", "Late"),
    ]

    student = models.ForeignKey(
        "students.StudentProfile",
        on_delete=models.CASCADE,
        related_name="fees"
    )

    school_class = models.ForeignKey(
        "schoolclassesmanage.SchoolClass",
        on_delete=models.CASCADE,
        blank=True,
        
    )

    month = models.CharField(max_length=20)
    year = models.PositiveIntegerField()

    total_fee = models.DecimalField(max_digits=10, decimal_places=2)
    discount = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    paid_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    due_amount = models.DecimalField(max_digits=10, decimal_places=2)

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="Unpaid"
    )

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("student", "month", "year")

    def save(self, *args, **kwargs):

        final_amount = self.total_fee - self.discount
        self.due_amount = final_amount - self.paid_amount

        if self.due_amount <= 0:
            self.status = "Paid"
        elif self.paid_amount > 0:
            self.status = "Partial"
        else:
            self.status = "Unpaid"

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.student} - {self.month} {self.year}"


class Payment(models.Model):
    student_fee = models.ForeignKey(
        StudentFee,
        on_delete=models.CASCADE,
        related_name="payments"
    )

    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_date = models.DateField(default=timezone.now)
    payment_method = models.CharField(max_length=50)

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

        # Update student fee paid amount
        self.student_fee.paid_amount += self.amount
        self.student_fee.save()

    def __str__(self):
        return f"{self.student_fee.student} Payment"
