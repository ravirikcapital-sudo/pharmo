from rest_framework.views import APIView
from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.response import Response
from rest_framework import status

from apps.students.models import StudentProfile
from apps.schoolclassesmanage.models import SchoolClass

from .serializers import (
    AdminClassSerializer,
    AdminStudentListSerializer,
    AdminStudentDetailSerializer,
    AdminProfileSerializer,
)


class AdminDashboardView(APIView):
    def get(self, request):
        return Response({
            "total_students": StudentProfile.objects.count(),
            "active_students": StudentProfile.objects.filter(admission_status="Active").count(),
            "total_classes": SchoolClass.objects.count(),
        })


class AdminClassListView(ListAPIView):
    serializer_class = AdminClassSerializer
    queryset = SchoolClass.objects.all()



class AdminStudentListView(ListAPIView):
    serializer_class = AdminStudentListSerializer

    def get_queryset(self):
        class_id = self.kwargs.get("class_id")

        queryset = StudentProfile.objects.filter(
            class_enrolled_id=class_id
        ).select_related("user", "class_enrolled")

        search = self.request.query_params.get("search")
        status_param = self.request.query_params.get("status")

        if search:
            queryset = queryset.filter(admission_number__icontains=search)

        if status_param == "active":
            queryset = queryset.filter(admission_status="Active")
        elif status_param == "inactive":
            queryset = queryset.filter(admission_status="Inactive")

        return queryset


class AdminStudentDetailView(RetrieveAPIView):
    serializer_class = AdminStudentDetailSerializer
    queryset = StudentProfile.objects.select_related("user", "class_enrolled")



class AdminProfileAPIView(APIView):
    def get(self, request):
        if not request.user.is_authenticated:
            return Response({"user": None})

        serializer = AdminProfileSerializer(
            request.user,
            context={"request": request}
        )
        return Response(serializer.data)

    def put(self, request):
        if not request.user.is_authenticated:
            return Response(
                {"detail": "Login required"},
                status=status.HTTP_401_UNAUTHORIZED
            )

        serializer = AdminProfileSerializer(
            request.user,
            data=request.data,
            partial=True,
            context={"request": request}
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)
