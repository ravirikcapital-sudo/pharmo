from rest_framework import generics
from rest_framework.views import APIView
from rest_framework.response import Response
from django.db.models import Avg, Max, Min, Sum

from .models import Exam, StudentExamResult
from .serializers import ExamSerializer, StudentExamResultSerializer



class ExamListCreateView(generics.ListCreateAPIView):
    queryset = Exam.objects.all()
    serializer_class = ExamSerializer

    def get_queryset(self):
        queryset = Exam.objects.all()
        class_id = self.request.query_params.get("class")

        if class_id:
            queryset = queryset.filter(school_class_id=class_id)

        return queryset


class ExamDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Exam.objects.all()
    serializer_class = ExamSerializer



class StudentExamResultCreateView(generics.ListCreateAPIView):
    serializer_class = StudentExamResultSerializer

    def get_queryset(self):
        queryset = StudentExamResult.objects.all()

        exam_id = self.request.query_params.get("exam")
        student_id = self.request.query_params.get("student")

        if exam_id:
            queryset = queryset.filter(exam_id=exam_id)

        if student_id:
            queryset = queryset.filter(student_id=student_id)

        return queryset



class StudentExamReportView(APIView):

    def get(self, request):
        student_id = request.query_params.get("student")
        exam_id = request.query_params.get("exam")

        results = StudentExamResult.objects.filter(
            student_id=student_id,
            exam_id=exam_id
        )

        serializer = StudentExamResultSerializer(results, many=True)

        total_marks = results.aggregate(total=Sum("marks_obtained"))["total"] or 0
        total_possible = results.aggregate(total=Sum("total_marks"))["total"] or 0

        overall_percentage = 0
        if total_possible > 0:
            overall_percentage = (total_marks / total_possible) * 100

        return Response({
            "results": serializer.data,
            "total_marks": total_marks,
            "total_possible": total_possible,
            "overall_percentage": round(overall_percentage, 2),
        })



class ExamStatisticsView(APIView):

    def get(self, request):
        exam_id = request.query_params.get("exam")

        results = StudentExamResult.objects.filter(exam_id=exam_id)

        total_students = results.values("student").distinct().count()

        avg_marks = results.aggregate(avg=Avg("percentage"))["avg"] or 0
        highest = results.aggregate(max=Max("percentage"))["max"] or 0
        lowest = results.aggregate(min=Min("percentage"))["min"] or 0

        return Response({
            "total_students": total_students,
            "average_percentage": round(avg_marks, 2),
            "highest_percentage": highest,
            "lowest_percentage": lowest,
        })
