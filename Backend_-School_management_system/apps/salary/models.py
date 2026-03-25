from django.db import models
from django.utils import timezone


class EmployeeSalary(models.Model):
    employee = models.ForeignKey(
        "employees.EmployeeProfile",
        on_delete=models.CASCADE,
        related_name="salaries"
    )

    month = models.DateField()  # Use first day of month (e.g., 2026-02-01)

    basic_salary = models.DecimalField(max_digits=10, decimal_places=2)
    bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    deduction = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    total_salary = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        blank=True
    )

    is_paid = models.BooleanField(default=False)
    paid_date = models.DateField(null=True, blank=True)

    remark = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("employee", "month")
        ordering = ["-month"]
        indexes = [
            models.Index(fields=["month"]),
            models.Index(fields=["is_paid"]),
        ]

    def save(self, *args, **kwargs):
        self.total_salary = self.basic_salary + self.bonus - self.deduction
        super().save(*args, **kwargs)

    def pay_salary(self):
        if not self.is_paid:
            self.is_paid = True
            self.paid_date = timezone.now().date()
            self.save()

    def __str__(self):
        return f"{self.employee.user.full_name} - {self.month.strftime('%B %Y')}"



class TeacherSalary(models.Model):
    teacher = models.ForeignKey(
        "teachers.TeacherProfile",
        on_delete=models.CASCADE,
        related_name="salaries"
    )

    month = models.DateField()  # Use first day of month

    basic_salary = models.DecimalField(max_digits=10, decimal_places=2)
    bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    deduction = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    total_salary = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        blank=True
    )

    is_paid = models.BooleanField(default=False)
    paid_date = models.DateField(null=True, blank=True)

    remark = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("teacher", "month")
        ordering = ["-month"]
        indexes = [
            models.Index(fields=["month"]),
            models.Index(fields=["is_paid"]),
        ]

    def save(self, *args, **kwargs):
        self.total_salary = self.basic_salary + self.bonus - self.deduction
        super().save(*args, **kwargs)

    def pay_salary(self):
        if not self.is_paid:
            self.is_paid = True
            self.paid_date = timezone.now().date()
            self.save()

    def __str__(self):
        return f"{self.teacher.user.full_name} - {self.month.strftime('%B %Y')}"
