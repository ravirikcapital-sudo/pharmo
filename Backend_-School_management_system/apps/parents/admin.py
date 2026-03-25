from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import ParentProfile, Complaint

# admin.py
print("Parent admin loaded 🚀")

@admin.register(ParentProfile)
class ParentProfileAdmin(admin.ModelAdmin):
    pass


@admin.action(description='Mark selected complaints as Resolved')
def make_resolved(modeladmin, request, queryset):
    updated = queryset.update(status='Resolved')
    modeladmin.message_user(request, f"{updated} complaint(s) marked as Resolved.")


@admin.action(description='Mark selected complaints as In Progress')
def make_in_progress(modeladmin, request, queryset):
    updated = queryset.update(status='In Progress')
    modeladmin.message_user(request, f"{updated} complaint(s) marked as In Progress.")


@admin.action(description='Mark selected complaints as Pending')
def make_pending(modeladmin, request, queryset):
    updated = queryset.update(status='Pending')
    modeladmin.message_user(request, f"{updated} complaint(s) marked as Pending.")


@admin.register(Complaint)
class ComplaintAdmin(admin.ModelAdmin):
    list_display = ('complaint_id', 'title', 'status', 'user_type', 'reported_by_name', 'created_at')
    list_filter = ('status', 'user_type', 'category')
    search_fields = ('complaint_id', 'title', 'description', 'reported_by_name')
    readonly_fields = ('complaint_id', 'created_at', 'updated_at')
    actions = [make_resolved, make_in_progress, make_pending]
    ordering = ('-created_at',)
    fieldsets = (
        (None, {
            'fields': ('complaint_id', 'user', 'reported_by_name', 'user_type', 'category', 'title', 'description', 'status')
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at')
        }),
    )