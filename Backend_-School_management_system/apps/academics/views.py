from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response

from apps.schoolclassesmanage.models import SchoolClass
from apps.teachers.models import TeacherProfile

from .models import Subject, SportsGroup, HouseGroup
from .serializers import (
    SchoolClassCreateSerializer,
    SubjectCreateUpdateSerializer,
    SubjectDetailSerializer,
    SportsGroupSerializer,
    HouseGroupSerializer,
    AcademicDashboardSerializer,
)


# -------------------------------------------------
# CLASSES (UI SAFE)
# -------------------------------------------------
class SchoolClassCreateAPIView(generics.ListCreateAPIView):
    queryset = SchoolClass.objects.all()
    serializer_class = SchoolClassCreateSerializer

    def create(self, request, *args, **kwargs):
        response = super().create(request, *args, **kwargs)

        school_class = SchoolClass.objects.get(id=response.data["id"])

        return Response(
            {
                "message": "Class created successfully",
                "id": school_class.id,
                "code": school_class.code,
            },
            status=status.HTTP_201_CREATED,
        )

# -------------------------------------------------
# SUBJECTS
# -------------------------------------------------
class SubjectListCreateAPIView(generics.ListCreateAPIView):
    queryset = Subject.objects.all()
    serializer_class = SubjectCreateUpdateSerializer


class SubjectDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Subject.objects.all()
    serializer_class = SubjectDetailSerializer
    lookup_field = "id"


# -------------------------------------------------
# SPORTS GROUPS
# -------------------------------------------------
class SportsGroupListCreateAPIView(generics.ListCreateAPIView):
    queryset = SportsGroup.objects.all()
    serializer_class = SportsGroupSerializer


# -------------------------------------------------
# HOUSE GROUPS
# -------------------------------------------------
class HouseGroupListCreateAPIView(generics.ListCreateAPIView):
    queryset = HouseGroup.objects.all()
    serializer_class = HouseGroupSerializer


# -------------------------------------------------
# DASHBOARD
# -------------------------------------------------
class AcademicDashboardAPIView(APIView):
    def get(self, request):
        data = {
            "total_classes": SchoolClass.objects.count(),
            "total_subjects": Subject.objects.count(),
            "total_teachers": TeacherProfile.objects.count(),
            "total_sports_groups": SportsGroup.objects.count(),
            "total_house_groups": HouseGroup.objects.count(),
        }
        serializer = AcademicDashboardSerializer(data)
        return Response(serializer.data)
