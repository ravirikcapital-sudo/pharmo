from django.contrib import admin
from .models import EmployeeSalary,TeacherSalary
# Register your models here.


@admin.register(EmployeeSalary)
class EmployeeSalaryAdmin(admin.ModelAdmin):
    list_display = ('id', 'employee', 'month', 'basic_salary','is_paid')
    list_filter = ('is_paid',)
    
    

@admin.register(TeacherSalary)
class TeacherSalaryAdmin(admin.ModelAdmin):
    list_display = ('id', 'teacher', 'month', 'basic_salary','is_paid')
    list_filter = ('is_paid',)