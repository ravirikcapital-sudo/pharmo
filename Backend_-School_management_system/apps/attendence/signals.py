from django.db.models.signals import post_save
from django.dispatch import receiver
from datetime import timedelta

from .models import Leave, TeacherAttendance, EmployeeAttendance


@receiver(post_save, sender=Leave)
def apply_leave_to_attendance(sender, instance, created, **kwargs):
    if not instance.approved:
        return

    current = instance.from_date
    while current <= instance.to_date:

        if instance.teacher:
            TeacherAttendance.objects.update_or_create(
                teacher=instance.teacher,
                date=current,
                defaults={
                    "status": "On Leave",
                    "reason": f"{instance.leave_type}: {instance.reason}"
                }
            )

        if instance.employee:
            EmployeeAttendance.objects.update_or_create(
                employee=instance.employee,
                date=current,
                defaults={
                    "status": "On Leave",
                    "reason": f"{instance.leave_type}: {instance.reason}"
                }
            )

        current += timedelta(days=1)
