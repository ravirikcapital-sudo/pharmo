from django.contrib import admin
from .models import Facility,ClassRoom


@admin.register(Facility)
class FacilitiesAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'name',
        'monthly_fee',
        'is_active',
        'created_at',
    )

    list_filter = ('is_active',)
    search_fields = ('name', 'description')
    ordering = ('-created_at',)

    list_editable = ('is_active',)
    list_per_page = 20


@admin.register(ClassRoom)
class ClassRoomAdmin(admin.ModelAdmin):
    list_display = (
        "room_number",
        "building",
        "floor",
        "capacity",
        "room_type",
        "school_class",
        "class_teacher",
    )
    list_filter = (
        "class_teacher",
    )
    search_fields = (
        "name__full_name",
    )

