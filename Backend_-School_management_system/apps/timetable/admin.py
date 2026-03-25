from django.contrib import admin

# Register your models here.
from .models import Timetable, StudentTimetable

@admin.register(Timetable)
class TimetableAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'created_at')
    search_fields = ('title',)
    ordering = ('-created_at',)
    
    
@admin.register(StudentTimetable)
class StudentTimetableAdmin(admin.ModelAdmin):
    list_display = ('id', 'class_enrolled', 'timetable_title', 'created_at')
    search_fields = ('timetable_title', 'class_enrolled__name')
    ordering = ('-created_at',)