# apps/teachers/views.py
from rest_framework.views import APIView
from rest_framework import generics, permissions, serializers, status,viewsets
from rest_framework.generics import ListAPIView
from apps.users.models import CustomUser
from rest_framework.response import Response
from .models import TeacherProfile,Designation
from .serializers import TeacherLoginSerializer, TeacherRegisterSerializer, TeacherListSerializer, AdminCreateTeacherSerializer,DesignationSerializer
from django.contrib.auth import get_user_model
from .models import TeacherProfile
from .serializers import TeacherProfileSerializer, TeacherProfileUpdateSerializer
from rest_framework.permissions import IsAuthenticated
from datetime import date

User = get_user_model()

class TeacherMyProfileView(generics.RetrieveAPIView):
    serializer_class = TeacherProfileSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return TeacherProfile.objects.select_related("user").get(
            user=self.request.user
        )

class TeacherProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        teacher = request.user.teacher_profile
        serializer = TeacherProfileSerializer(teacher)
        return Response(serializer.data)

class TeacherDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({
            "message":"Dashboard working",
            "total_classes_today": 0,
            "total_assignments": 0,
        })

class TeacherUpdateProfileView(generics.UpdateAPIView):
    serializer_class = TeacherProfileUpdateSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return TeacherProfile.objects.get(user=self.request.user)

class AdminCreateDesignationView(generics.ListCreateAPIView):
    queryset = Designation.objects.all()
    serializer_class = DesignationSerializer
    
    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class AdminCreateTeacherView(generics.CreateAPIView):
    serializer_class = AdminCreateTeacherSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        teacher = serializer.save()

        return Response(
            {
                "message": "Teacher created successfully",
                "teacher_id": teacher.id,
                "full_name": teacher.user.full_name,
                "email": teacher.user.email,
                "phone": teacher.user.phone,
                
            },
            status=status.HTTP_201_CREATED
        )

class TeacherListView(ListAPIView):
    queryset = TeacherProfile.objects.select_related("user")
    serializer_class = TeacherListSerializer
    permission_classes = []
    authentication_classes = []


class TeacherRegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = TeacherRegisterSerializer
    permission_classes = []  
    authentication_classes = [] 


from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import TeacherLoginSerializer

class TeacherLoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = TeacherLoginSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data['user']

            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'email': user.email,
                    'full_name': user.full_name,
                    'role': user.role
                }
            })
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
#attendance 
# from rest_framework.permissions import IsAuthenticated
# from rest_framework.generics import ListAPIView
# from .models import Attendance
# from .serializers import MarkAttendanceSerializer
# from .serializers import AttendanceHistorySerializer

# class MarkAttendanceView(generics.CreateAPIView):
#     serializer_class = MarkAttendanceSerializer
#     permission_classes = [permissions.IsAuthenticated]

#     def get_serializer_context(self):
#         return {'request': self.request}


# #attendace checkout  
# from .serializers import AttendanceCheckoutSerializer
# from django.utils import timezone

# class AttendanceCheckoutView(generics.UpdateAPIView):
#     serializer_class = AttendanceCheckoutSerializer
#     permission_classes = [permissions.IsAuthenticated]

#     def get_object(self):
#         today = timezone.now().date()
#         try:
#             return Attendance.objects.get(teacher=self.request.user, date=today)
#         except Attendance.DoesNotExist:
#             raise serializers.ValidationError("No check-in found for today.")

#     def put(self, request, *args, **kwargs):
#         attendance = self.get_object()
#         serializer = self.get_serializer(attendance, data=request.data, partial=True)
#         serializer.is_valid(raise_exception=True)
#         serializer.save()
#         return Response({"message": "Check-out marked successfully."}, status=status.HTTP_200_OK)


#Attendace History
# from .models import Attendance, Leave
# from datetime import timedelta
# from .serializers import TeacherDailyStatusSerializer
# from itertools import chain

# class AttendanceHistoryView(APIView):
#     permission_classes = [IsAuthenticated]

#     def get(self, request):
#         user = request.user

#         # Get all Attendance & Leave records for the logged-in teacher
#         attendance = Attendance.objects.filter(teacher=user)
#         leaves = Leave.objects.filter(teacher=user)

#         # Build a dict of all leave dates for quick lookup
#         leave_dict = {
#             leave.from_date + timedelta(days=i): leave
#             for leave in leaves
#             for i in range((leave.to_date - leave.from_date).days + 1)
#         }

#         status_list = []

#         # Get all unique dates from both attendance and leave records
#         all_dates = set(att.date for att in attendance) | set(leave_dict.keys())

#         for date in sorted(all_dates, reverse=True):
#             if date in leave_dict:
#                 leave = leave_dict[date]
#                 status_list.append({
#                     "date": date,
#                     "type": "Leave",
#                     "status": leave.get_leave_type_display(),
#                     "reason": leave.reason,
#                     "check_in_time": None,
#                     "check_out_time": None,
#                 })
#             else:
#                 att = attendance.filter(date=date).first()
#                 if att:  # Safety check
#                     status_list.append({
#                         "date": date,
#                         "type": "Attendance",
#                         "status": att.status,
#                         "reason": att.reason,
#                         "check_in_time": att.check_in_time.time() if att.check_in_time else None,
#                         "check_out_time": att.check_out_time.time() if att.check_out_time else None,
#                     })

#         serializer = TeacherDailyStatusSerializer(status_list, many=True)
#         return Response(serializer.data)

   
# #Attendace leave
# from .serializers import LeaveCreateSerializer, SubstituteTeacherSerializer

# class LeaveCreateView(generics.CreateAPIView):
#     serializer_class = LeaveCreateSerializer
#     permission_classes = [permissions.IsAuthenticated]

#     def get_serializer_context(self):
#         return {'request': self.request}

# class SubstituteTeacherListView(generics.ListAPIView):
#     serializer_class = SubstituteTeacherSerializer
#     permission_classes = [permissions.IsAuthenticated]

#     def get_queryset(self):
#         return CustomUser.objects.filter(role='teacher').exclude(id=self.request.user.id)



#Assign ClassRoom
# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework import status
# from django.shortcuts import get_object_or_404
# from .models import ClassRoom
# from .serializers import ClassRoomSerializer
# from apps.students.models import StudentProfile
# from apps.students.serializers import StudentProfileSerializer


# class ClassRoomListCreateView(APIView):
#     def get(self, request):
#         classes = ClassRoom.objects.all()
#         serializer = ClassRoomSerializer(classes, many=True)
#         return Response({"success": True, "data": serializer.data}, status=status.HTTP_200_OK)

#     def post(self, request):
#         serializer = ClassRoomSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({"success": True, "message": "Class created successfully", "data": serializer.data}, status=status.HTTP_201_CREATED)
#         return Response({"success": False, "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# class ClassRoomDetailView(APIView):
#     def get_object(self, pk):
#         return get_object_or_404(ClassRoom, pk=pk)

#     def get(self, request, pk):
#         classroom = self.get_object(pk)
#         serializer = ClassRoomSerializer(classroom)
#         return Response({"success": True, "data": serializer.data}, status=status.HTTP_200_OK)

#     def patch(self, request, pk):
#         classroom = self.get_object(pk)
#         serializer = ClassRoomSerializer(classroom, data=request.data, partial=True)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({"success": True, "message": "Class updated successfully", "data": serializer.data}, status=status.HTTP_200_OK)
#         return Response({"success": False, "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

#     def delete(self, request, pk):
#         classroom = self.get_object(pk)
#         classroom.delete()
#         return Response({"success": True, "message": "Class deleted successfully"}, status=status.HTTP_204_NO_CONTENT)


# class ClassRoomStudentsView(APIView):
#     def get(self, request, class_id):
#         classroom = get_object_or_404(ClassRoom, id=class_id)
#         students = classroom.students.all()  # uses related_name
#         serializer = StudentProfileSerializer(students, many=True)
#         return Response({"success": True, "data": serializer.data}, status=status.HTTP_200_OK)
    
# Add student to classroom
# from .serializers import StudentCreateSerializer
# class AddStudentToClassroomView(APIView):
#     def post(self, request, classroom_id):
#         classroom = get_object_or_404(ClassRoom, id=classroom_id)
#         serializer = StudentCreateSerializer(
#             data=request.data,
#             context={"classroom": classroom}   #  pass it here
#         )
#         if serializer.is_valid():
#             student = serializer.save()
#             return Response(StudentProfileSerializer(student).data, status=201)
#         return Response(serializer.errors, status=400)
    

#adding timetable for teacher
# from .models import Timetable
# from .serializers import TimetableSerializer

# class TimetableListCreateView(generics.ListCreateAPIView):
#     queryset = Timetable.objects.all()
#     serializer_class = TimetableSerializer
    

# # Timetable For Students

# from rest_framework import generics
# from .models import StudentTimetable
# from .serializers import StudentTimetableSerializer

# # Create API
# class StudentTimetableUpdateView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = StudentTimetable.objects.all()
#     serializer_class = StudentTimetableSerializer
#     lookup_field = "pk"


# class StudentTimetableListCreateView(generics.ListCreateAPIView):
#     queryset = StudentTimetable.objects.all()
#     serializer_class = StudentTimetableSerializer
    
    
#Result Entry

# from apps.students.models import StudentProfile
# from .models import ExamResult
# from .serializers import StudentInfoSerializer, ExamResultSerializer, ExamStatisticsSerializer
# from django.db import transaction
# from collections import defaultdict


# # Student List #
# class StudentListForMarks(APIView):
#     """
#     Get all students for a specific class + section
#     """
#     def get(self, request):
#         class_enrolled = request.query_params.get("class_enrolled")
#         section = request.query_params.get("section")

#         print("DEBUG -> raw class_enrolled:", class_enrolled)
#         print("DEBUG -> raw section:", section)

#         try:
#             class_enrolled = int(class_enrolled)
#         except (TypeError, ValueError):
#             class_enrolled = None

#         if section:
#             section = section.strip()

#         students = StudentProfile.objects.filter(
#             class_enrolled=str(class_enrolled),   # string এ convert
#             section__iexact=str(section)          # case insensitive exact match
#         ).order_by("roll_number")

#         print("DEBUG -> queryset count:", students.count())
#         print("DEBUG -> queryset SQL:", students.query)

#         serializer = StudentInfoSerializer(students, many=True)
#         return Response(serializer.data, status=200)
    

# # Entry #
# class SaveExamMarks(APIView):
#     def post(self, request, *args, **kwargs):
#         exam = request.data.get("exam")
#         subject = request.data.get("subject")
#         class_name = request.data.get("class") or request.data.get("class_name")
#         section = request.data.get("section")

#         marks_data = request.data.get("marks")

#         if not marks_data:
#             marks_data = [{
#                 "student_id": request.data.get("student"),
#                 "marks": request.data.get("marks_obtained"),
#                 "max_marks": request.data.get("max_marks", 100),
#             }]

#         saved_results = []
#         for mark in marks_data:
#             student_id = mark["student_id"]
#             marks_obtained = mark["marks"]
#             max_marks = mark.get("max_marks", 100)

#             result, created = ExamResult.objects.update_or_create(
#                 exam=exam,
#                 subject=subject,
#                 class_name=class_name,
#                 section=section,
#                 student_id=student_id,
#                 defaults={
#                     "marks_obtained": marks_obtained,
#                     "max_marks": max_marks,
#                 },
#             )
#             saved_results.append(result)

#         serializer = ExamResultSerializer(saved_results, many=True)
#         return Response({"message": "Marks saved successfully", "data": serializer.data})


# # Result #
# class ExamResultsView(APIView):
#     """
#     Retrieve results of students for a specific exam, class & section
#     """
#     def get(self, request):
#         exam = request.query_params.get("exam")
#         class_name = request.query_params.get("class")
#         section = request.query_params.get("section")

#         if not (exam and class_name and section):
#             return Response({"error": "Exam, class and section required"}, status=400)

#         results = ExamResult.objects.filter(
#             exam=exam,
#             class_name=class_name,
#             section=section
#         ).select_related("student_user").order_by("student_roll_number")

#         # Serializer বাদ দিয়ে manual data বানালাম
#         data = []
#         for r in results:
#             data.append({
#                 "student_id": r.student.id,
#                 "roll_number": r.student.roll_number,
#                 "student_name": r.student.user.get_full_name(),
#                 "marks_obtained": r.marks_obtained,
#                 "max_marks": r.max_marks,
#                 "percentage": round((r.marks_obtained / r.max_marks) * 100, 2) if r.max_marks else 0,
#             })

#         return Response(data, status=200)


# # Statistics #
# class ExamStatisticsView(APIView):
#     """
#     Get overall statistics for a specific exam
#     """

#     def get(self, request):
#         exam = request.query_params.get("exam")

#         if not exam:
#             return Response({"error": "exam required"}, status=status.HTTP_400_BAD_REQUEST)

#         qs = ExamResult.objects.filter(exam=exam)

#         if not qs.exists():
#             return Response({"error": "No data found"}, status=status.HTTP_404_NOT_FOUND)

#         # Calculate each student's total score
#         student_scores = defaultdict(lambda: {"obtained": 0, "max": 0})

#         for r in qs:
#             student_scores[r.student_id]["obtained"] += r.marks_obtained
#             student_scores[r.student_id]["max"] += r.max_marks

#         # Percentage list for each student
#         student_percentages = [
#             (score["obtained"] / score["max"]) * 100
#             for score in student_scores.values() if score["max"] > 0
#         ]

#         total_students = len(student_percentages)
#         average_percentage = round(sum(student_percentages) / total_students, 1) if total_students else 0
#         highest_percentage = round(max(student_percentages), 1) if total_students else 0
#         lowest_percentage = round(min(student_percentages), 1) if total_students else 0

#         # Pass/Fail count (assuming 35% passing mark)
#         students_passed = sum(1 for p in student_percentages if p >= 35)
#         students_failed = total_students - students_passed

#         data = {
#             "total_students": total_students,
#             "average_percentage": average_percentage,
#             "highest_percentage": highest_percentage,
#             "lowest_percentage": lowest_percentage,
#             "students_passed": students_passed,
#             "students_failed": students_failed,
#         }

#         return Response(data, status=status.HTTP_200_OK)
    

#Academic Options - Classroom Creation
# from rest_framework import viewsets
# from .models import AcademicClassRoom
# from .serializers import AcademicClassroomSerializer

# class CreateAcademicClassroomView(generics.CreateAPIView):
#     queryset = AcademicClassRoom.objects.all()
#     serializer_class = AcademicClassroomSerializer


#Academic Subject
# from .models import Subject
# from .serializers import SubjectSerializer
# from rest_framework.permissions import IsAuthenticated

# class SubjectCreateView(generics.CreateAPIView):
#     queryset = Subject.objects.all()
#     serializer_class = SubjectSerializer
#     permission_classes = [IsAuthenticated]

# class SubjectListView(generics.ListAPIView):
#     queryset = Subject.objects.all()
#     serializer_class = SubjectSerializer
#     permission_classes = [IsAuthenticated]

# #Academic Sport Group
# from rest_framework import generics
# from .models import SportGroup
# from .serializers import SportGroupSerializer

# class CreateSportGroupView(generics.CreateAPIView):
#     queryset = SportGroup.objects.all()
#     serializer_class = SportGroupSerializer


# #Academic House Group~
# from .models import HouseGroup
# from .serializers import HouseGroupSerializer

# class CreateHouseGroupView(generics.CreateAPIView):
#     queryset = HouseGroup.objects.all()
#     serializer_class = HouseGroupSerializer


# Add Applicant
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import StudentApplicant
from .serializers import StudentApplicantSerializer

class StudentApplicantCreateView(APIView):
    def post(self, request):
        serializer = StudentApplicantSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"success": True, "data": serializer.data}, status=status.HTTP_201_CREATED)
        return Response({"success": False, "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

class StudentApplicantListView(APIView):
    def get(self, request):
        applicants = StudentApplicant.objects.all()
        serializer = StudentApplicantSerializer(applicants, many=True)
        return Response({"success": True, "data": serializer.data})


#Subject

# from .models import Subject
# from .serializers import SubjectSerializer

# # List all subjects OR create a new one
# class SubjectListCreateView(generics.ListCreateAPIView):
#     queryset = Subject.objects.all()
#     serializer_class = SubjectSerializer

# # Retrieve, update or delete a subject
# class SubjectDetailView(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Subject.objects.all()
#     serializer_class = SubjectSerializer
#     lookup_field = "id" 