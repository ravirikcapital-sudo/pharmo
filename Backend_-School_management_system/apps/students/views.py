from urllib.parse import unquote
from rest_framework import generics, permissions, status,viewsets
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import StudentProfile
from .serializers import (
    StudentRegisterSerializer,
    StudentProfileSerializer,
    StudentSerializer,
)

class StudentViewSet(viewsets.ModelViewSet):

    queryset = StudentProfile.objects.select_related("user").all()
    # permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.action == "create":
            return StudentRegisterSerializer
        if self.action in ["list", "retrieve"]:
            return StudentSerializer
        return StudentProfileSerializer



class StudentsByClassView(APIView):
    def get(self, request):
        class_name = request.query_params.get("class")
        if not class_name:
            return Response({"error": "class required"}, status=400)

        decoded = unquote(class_name)
        students = StudentProfile.objects.filter(
            class_enrolled=decoded
        ).select_related("user")

        return Response(StudentSerializer(students, many=True).data)


from rest_framework.permissions import IsAuthenticated
from rest_framework import generics, status
from .serializers import AssignmentSerializer, AssignmentCreateSerializer, AssignmentSubmissionSerializer, AssignmentSubmissionCreateSerializer
from apps.schoolclassesmanage.models import SchoolClass


class AssignmentListCreateView(generics.ListCreateAPIView):
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return AssignmentCreateSerializer
        return AssignmentSerializer

    def get_queryset(self):
        qs = Assignment.objects.select_related('class_assigned', 'created_by').prefetch_related('attachments')
        user = self.request.user
        if getattr(user, 'role', '') == 'student':
            student_profile = getattr(user, 'student_profile', None)
            if student_profile and student_profile.class_enrolled:
                qs = qs.filter(class_assigned=student_profile.class_enrolled)
        # filter by status query param
        status_param = self.request.query_params.get('status')
        if status_param:
            if status_param.lower() != 'all':
                qs = qs.filter(status__iexact=status_param)
        return qs.order_by('-created_at')

    def perform_create(self, serializer):
        user = self.request.user
        if getattr(user, 'role', '') not in ['teacher', 'admin', 'academic_officer']:
            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied('Only staff/teachers can create assignments')
        serializer.save(created_by=user)


class AssignmentSubmitView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        try:
            assignment = Assignment.objects.get(pk=pk)
        except Assignment.DoesNotExist:
            return Response({'error': 'Assignment not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = AssignmentSubmissionCreateSerializer(data=request.data, context={'request': request, 'assignment': assignment})
        serializer.is_valid(raise_exception=True)
        submission = serializer.save()
        out = AssignmentSubmissionSerializer(submission, context={'request': request})
        return Response(out.data, status=status.HTTP_201_CREATED)


class AssignmentSubmissionsListView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = AssignmentSubmissionSerializer

    def get_queryset(self):
        assignment_id = self.kwargs.get('pk')
        qs = AssignmentSubmission.objects.filter(assignment__pk=assignment_id).select_related('student__user')
        # Only staff/teacher or creator can view
        user = self.request.user
        if getattr(user, 'role', '') in ['teacher', 'admin', 'academic_officer']:
            return qs
        # students can view their own submission
        student_profile = getattr(user, 'student_profile', None)
        if student_profile:
            return qs.filter(student=student_profile)
        return qs.none()
