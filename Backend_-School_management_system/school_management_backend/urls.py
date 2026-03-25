"""
URL configuration for school_management_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/users/', include('apps.users.urls')),
    path('api/admissions/', include('apps.admissions.urls')),
    path('api/admins/', include('apps.admins.urls')),
    path('api/academics/', include('apps.academics.urls')),
    path('api/classes/', include('apps.schoolclassesmanage.urls')),
    path('api/students/', include('apps.students.urls')),
    path('api/teachers/', include('apps.teachers.urls')),
    path('api/parents/', include('apps.parents.urls')),
    path('api/employees/', include('apps.employees.urls')),
    path('api/dashboards/', include('apps.dashboards.urls')),
    path('api/facilities/',include('apps.facilities.urls')),
    path('api/reports/',include('apps.reports.urls')),
    path('api/notifications/',include('apps.notifications.urls')),
    path('api/system/',include('apps.systemcontrol.urls')),
    path('api/attendence/', include('apps.attendence.urls')),
    path('api/exams/', include('apps.exams.urls')),
    path('api/timetable/',include('apps.timetable.urls')),
    path('api/fees/',include('apps.fees.urls')),
    path('api/salary/',include('apps.salary.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
