# Register your models here.
from django.contrib import admin
from .models import SchoolClass

@admin.register(SchoolClass)
class ClassAdmin(admin.ModelAdmin):
    list_display = ('name', 'code',"section","created_at")
    search_fields = ('name', 'code')
    ordering = ('-created_at',)

