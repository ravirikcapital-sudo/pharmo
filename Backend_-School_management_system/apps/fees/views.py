# apps/fees/views.py

from rest_framework import generics
from rest_framework.views import APIView
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

from .models import ClassFeeStructure, StudentFee, Payment
from .serializers import (
    ClassFeeStructureSerializer,
    StudentFeeSerializer,
    PaymentSerializer
)

from apps.students.models import StudentProfile


# Fee Structure
class ClassFeeStructureView(generics.ListCreateAPIView):
    queryset = ClassFeeStructure.objects.select_related("school_class")
    serializer_class = ClassFeeStructureSerializer


# Student Fee (Fee Slips)
class StudentFeeListCreateView(generics.ListCreateAPIView):
    queryset = StudentFee.objects.select_related(
        "student__user",
        "school_class",
    )
    serializer_class = StudentFeeSerializer


class StudentFeeDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = StudentFee.objects.all()
    serializer_class = StudentFeeSerializer


# Payments
class PaymentCreateView(generics.CreateAPIView):
    queryset = Payment.objects.all()
    serializer_class = PaymentSerializer


# Monthly Status Summary (Matches Your Video)
class MonthlyFeeStatusView(APIView):

    def get(self, request):

        month = request.GET.get("month")
        year = request.GET.get("year")

        fees = StudentFee.objects.filter(
            month=month,
            year=year
        )

        paid = fees.filter(status="Paid").count()
        partial = fees.filter(status="Partial").count()
        unpaid = fees.filter(status="Unpaid").count()
        late = fees.filter(status="Late").count()

        return Response({
            "month": month,
            "year": year,
            "paid": paid,
            "partial": partial,
            "unpaid": unpaid,
            "late": late,
            "total_records": fees.count()
        })
