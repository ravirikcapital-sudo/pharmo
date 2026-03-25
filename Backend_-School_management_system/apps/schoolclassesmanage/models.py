from django.db import models

class SchoolClass(models.Model):
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=20, unique=True,editable=False)
    section = models.CharField(max_length=10, blank=True, null=True)
    academic_year = models.CharField(max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)

    
    def save(self, *args, **kwargs):
        if not self.code:
            last_class = SchoolClass.objects.all().order_by('id').last()
            if last_class:
                last_id = int(last_class.code.split('CLASS')[-1])
                new_id = last_id + 1
            else:
                new_id = 1
            self.code = f"CLASS{new_id:04d}"
        super().save(*args, **kwargs)
        
        
    def __str__(self):
        return f"{self.name} ({self.code})"