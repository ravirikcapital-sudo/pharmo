from django.shortcuts import render
from .models import Timetable,StudentTimetable
from .serializers import TimetableSerializer,StudentTimetableSerializer
from rest_framework import generics

# Create your views here.

class TimetableListCreateView(generics.ListCreateAPIView):
    queryset = Timetable.objects.all()
    serializer_class = TimetableSerializer
    

class StudentTimetableUpdateView(generics.RetrieveUpdateDestroyAPIView):
    queryset = StudentTimetable.objects.all()
    serializer_class = StudentTimetableSerializer
    lookup_field = "pk"


class StudentTimetableListCreateView(generics.ListCreateAPIView):
    queryset = StudentTimetable.objects.all()
    serializer_class = StudentTimetableSerializer