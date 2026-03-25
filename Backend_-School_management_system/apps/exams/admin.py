from django.contrib import admin
from apps.exams.models import *


@admin.register(Exam)
class ExamAdmin(admin.ModelAdmin):
    list_display = ("name", "exam_type", "school_class", "exam_date", "is_published")
    list_filter = ("exam_type", "school_class", "is_published")
    search_fields = ("name",)
    

@admin.register(StudentExamResult)
class StudentExamResultAdmin(admin.ModelAdmin):
    list_display = ("student", "exam", "subject", "marks_obtained", "total_marks", "percentage", "grade")
    list_filter = ("exam", "subject")
    search_fields = ("student__user__full_name",)
    