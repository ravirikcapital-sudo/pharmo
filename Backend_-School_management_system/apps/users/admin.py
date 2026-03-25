from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser,ParentStudentMapping

@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    model = CustomUser

    list_display = ('email', 'full_name', 'phone', 'role', 'gender', 'is_approved', 'is_active', 'is_staff')
    list_filter = ('role', 'is_active', 'is_staff', 'is_approved')
    search_fields = ('email', 'full_name', 'phone')
    ordering = ('email',)

    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal Info', {'fields': ('full_name', 'phone', 'gender', 'role')}),
        ('Status', {'fields': ('is_approved',)}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important Dates', {'fields': ('last_login',)}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'full_name', 'phone', 'gender', 'role', 'password1', 'password2', 'is_staff', 'is_superuser'),
        }),
    )

    actions = ['approve_users', 'reject_users']

    def approve_users(self, request, queryset):
        queryset.update(is_approved=True)
        self.message_user(request, "Selected users have been approved.")

    def reject_users(self, request, queryset):
        queryset.update(is_active=False, is_approved=False)
        self.message_user(request, "Selected users have been rejected and deactivated.")

    approve_users.short_description = "✅ Approve selected users"
    reject_users.short_description = "❌ Reject selected users"


@admin.register(ParentStudentMapping)
class ParentStudentMappingAdmin(admin.ModelAdmin):
    list_display = ('parent', 'student', 'relationship', 'is_primary_guardian')
    list_filter = ('relationship', 'is_primary_guardian')
    search_fields = ('parent__email', 'student__email')