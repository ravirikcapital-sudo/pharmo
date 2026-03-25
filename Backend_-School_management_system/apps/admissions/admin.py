from django.contrib import admin
from .models import AdmissionApplication

@admin.register(AdmissionApplication)
class AdmissionAdmin(admin.ModelAdmin):
    list_display = ['full_name', 'class_applied', 'is_paid', 'is_submitted', 'submitted_at']
    readonly_fields = ['submitted_at']
