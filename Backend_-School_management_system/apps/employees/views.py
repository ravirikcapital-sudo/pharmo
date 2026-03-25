
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response


from .models import EmployeeProfile
from .serializers import EmployeeSerializer
from django.contrib.auth import get_user_model
User = get_user_model()


class EmployeeViewSet(viewsets.ModelViewSet):
    serializer_class = EmployeeSerializer


    def get_queryset(self):
        return EmployeeProfile.objects.select_related('user').all()

    @action(detail=False, methods=['get'])
    def count(self, request):
        count = self.get_queryset().count()
        return Response({"count": count})
    


