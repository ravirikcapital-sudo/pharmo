from django.shortcuts import render

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import redirect
class RoleBasedDashboardRedirectView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        role = user.role

        if role == 'teacher':
            return redirect('teacher-dashboard')  # name from urls of teacher app
        elif role == 'student':
            return redirect('student-dashboard')
        elif role == 'parent':
            return redirect('parent-dashboard')
        elif role == 'admin':
            return redirect('admin-dashboard')
        elif role == 'academic_officer':
            return redirect('academic-officer-dashboard')
        else:
            return Response({'error': 'Invalid role'}, status=400)