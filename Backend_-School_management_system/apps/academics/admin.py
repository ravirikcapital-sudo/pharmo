from django.contrib import admin
from apps.academics.models import Subject,SportsGroup,HouseGroup
# Register your models here.

@admin.register(Subject)
class SubjectAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "code",
        "description",
    )
    list_filter = ("code",)
    search_fields = ("name", "description","code")
    ordering = ("name",) 
    

@admin.register(SportsGroup)
class SportsGroupAdmin(admin.ModelAdmin):
    list_display = (
        "group_name",
        "sport_type",
        "coach_name",
    )
    list_filter = ("sport_type",)
    search_fields = ("group_name", "sport_type","coach_name")
    ordering = ("group_name",)
@admin.register(HouseGroup)
class HouseGroupAdmin(admin.ModelAdmin):
    list_display = (
        "house_name",
        "house_color",
        "house_captain",
    )
    list_filter = ("house_color",)
    search_fields = ("house_name", "house_color","house_captain__full_name")
    ordering = ("house_name",)
    def house_captain(self, obj):
        return obj.house_captain.full_name if obj.house_captain else "N/A"
    