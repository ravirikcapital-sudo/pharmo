# from django.contrib import admin
# from .models import EmployeeProfile

# @admin.register(EmployeeProfile)
# class EmployeeProfileAdmin(admin.ModelAdmin):
#     list_display = ('user', 'role', 'gender')
#     list_filter = ('role', 'gender')
#     search_fields = ('user__full_name', 'user__email', 'role')

from django.contrib import admin
from .models import EmployeeProfile

@admin.register(EmployeeProfile)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'role', 'department', 'is_active')
    list_filter = ('role', 'department', 'is_active')
    search_fields = ('user__full_name', 'user__email')
    
    


