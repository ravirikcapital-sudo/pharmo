from rest_framework import generics
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Facility,ClassRoom
from .serializers import FacilitySerializer,ClassRoomSerializer
from django.shortcuts import get_object_or_404
from apps.students.serializers import StudentProfileSerializer

class FacilityListCreateView(generics.ListCreateAPIView):
    queryset = Facility.objects.all()
    serializer_class = FacilitySerializer


class FacilityDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Facility.objects.all()
    serializer_class = FacilitySerializer

#Assign ClassRoom
class ClassRoomListCreateView(generics.ListCreateAPIView):
    queryset = ClassRoom.objects.select_related(
        "school_class", "class_teacher__user"
    )
    serializer_class = ClassRoomSerializer


class ClassRoomDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = ClassRoom.objects.select_related(
        "school_class", "class_teacher__user"
    )
    serializer_class = ClassRoomSerializer


class ClassRoomStudentsView(generics.ListAPIView):
    serializer_class = StudentProfileSerializer

    def get_queryset(self):
        classroom = get_object_or_404(
            ClassRoom, id=self.kwargs["class_id"]
        )
        return classroom.school_class.students.select_related("user")