from rest_framework.viewsets import ModelViewSet
from .models import SchoolClass
from .serializers import ClassSerializer


class ClassViewSet(ModelViewSet):
    queryset = SchoolClass.objects.all()
    serializer_class = ClassSerializer

