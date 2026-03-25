from django.contrib import admin
from .models import StudentProfile

@admin.register(StudentProfile)
class StudentProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'created_at']
    search_fields = ['user__email', 'user__full_name']
    autocomplete_fields = ["class_enrolled"]


# Assignment admin registrations
from .models import Assignment, AssignmentAttachment, AssignmentSubmission, SubmissionAttachment


@admin.register(Assignment)
class AssignmentAdmin(admin.ModelAdmin):
    list_display = ('assignment_id', 'title', 'type', 'status', 'class_assigned', 'instructor', 'assigned_date', 'due_date')
    list_filter = ('status', 'type', 'class_assigned')
    search_fields = ('assignment_id', 'title', 'description', 'instructor')


@admin.register(AssignmentAttachment)
class AssignmentAttachmentAdmin(admin.ModelAdmin):
    list_display = ('assignment', 'file', 'uploaded_at')


@admin.register(AssignmentSubmission)
class AssignmentSubmissionAdmin(admin.ModelAdmin):
    list_display = ('assignment', 'student', 'status', 'grade', 'submitted_at')
    list_filter = ('status',)
    search_fields = ('assignment__title', 'student__user__full_name')


@admin.register(SubmissionAttachment)
class SubmissionAttachmentAdmin(admin.ModelAdmin):
    list_display = ('submission', 'file', 'uploaded_at')
