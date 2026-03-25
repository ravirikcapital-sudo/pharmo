from django.contrib import admin
from .models import Assessment, AssessmentResult


@admin.register(Assessment)
class AssessmentAdmin(admin.ModelAdmin):
    list_display = (
        "title",
        "school_class",
        "subject",
        "date",
    )
    list_filter = (
        "school_class",
        "subject",
        "date",
    )
    search_fields = (
        "title",
        "school_class__name",
        "subject__name",
    )
    ordering = ("-date",)


@admin.register(AssessmentResult)
class AssessmentResultAdmin(admin.ModelAdmin):
    list_display = (
        "assessment",
        "student",
        "marks",
    )
    list_filter = (
        "assessment__school_class",
        "assessment__subject",
    )
    search_fields = (
        "student__user__full_name",
        "assessment__title",
    )
    
