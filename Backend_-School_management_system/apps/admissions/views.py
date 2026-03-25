from rest_framework import status, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from django.utils import timezone
from django.http import FileResponse, HttpResponse
from django.utils.timezone import now
from django.contrib.auth import get_user_model

from rest_framework.decorators import api_view


from .models import AdmissionApplication
from .serializers import (
    AdmissionStep1Serializer,
    ParentGuardianDetailsSerializer,
    ContactAddressSerializer,
    DocumentUploadSerializer,
    NewApplicantSerializer,
    PendingAdmissionListSerializer,
    AdmissionApplicationSerializer
)
from apps.students.models import StudentProfile
from .utils import generate_receipt, generate_pdf_receipt, send_receipt_email

User = get_user_model()


# -------------------------------------------------------------
# STEP 1: CREATE BASE APPLICATION (Basic student information)
# -------------------------------------------------------------
class AdmissionStepOneView(generics.CreateAPIView):
    serializer_class = AdmissionStep1Serializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        instance = serializer.save()
        return Response({"application_id": instance.id}, status=201)


# -------------------------------------------------------------
# STEP 2: SAVE PARENT / GUARDIAN DETAILS
# -------------------------------------------------------------
class ParentGuardianDetailsView(APIView):
    def post(self, request, application_id):
        try:
            application = AdmissionApplication.objects.get(id=application_id)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        serializer = ParentGuardianDetailsSerializer(
            application, data=request.data, partial=True
        )

        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Parent/Guardian details saved"}, status=200)

        return Response(serializer.errors, status=400)


# -------------------------------------------------------------
# STEP 3: SAVE CONTACT + ADDRESS DETAILS
# -------------------------------------------------------------
class ContactAddressView(APIView):
    def post(self, request, application_id):
        try:
            application = AdmissionApplication.objects.get(id=application_id)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        serializer = ContactAddressSerializer(
            application, data=request.data, partial=True
        )

        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Contact & Address saved"}, status=200)

        return Response(serializer.errors, status=400)


# -------------------------------------------------------------
# STEP 4: UPLOAD DOCUMENTS
# -------------------------------------------------------------
class DocumentUploadView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, application_id):
        try:
            application = AdmissionApplication.objects.get(id=application_id)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        serializer = DocumentUploadSerializer(
            application, data=request.data, partial=True
        )

        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Documents uploaded"}, status=200)

        return Response(serializer.errors, status=400)


# -------------------------------------------------------------
# STEP 5: MARK PAYMENT DONE
# -------------------------------------------------------------
class AdmissionMarkPaidView(APIView):
    def post(self, request, pk):
        try:
            application = AdmissionApplication.objects.get(id=pk)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        application.is_paid = True
        application.transaction_id = request.data.get("transaction_id", "")
        application.payment_date = timezone.now()
        application.save()

        return Response({"status": "paid"}, status=200)


# -------------------------------------------------------------
# STEP 6: FINAL SUBMISSION
# -------------------------------------------------------------
class AdmissionSubmitView(APIView):
    def post(self, request, pk):
        try:
            application = AdmissionApplication.objects.get(id=pk)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        if not application.is_paid:
            return Response({"error": "Payment not completed"}, status=400)

        application.is_submitted = True
        application.submitted_at = timezone.now()
        application.save()

        return Response({"status": "submitted"}, status=200)


# -------------------------------------------------------------
# DOWNLOAD RECEIPT
# -------------------------------------------------------------
class DownloadReceiptView(APIView):
    def get(self, request, application_id):
        try:
            application = AdmissionApplication.objects.get(id=application_id)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        if not application.is_paid:
            return Response({"error": "Payment not completed"}, status=400)

        pdf_buffer = generate_receipt(application)
        return FileResponse(pdf_buffer, as_attachment=True, filename=f"receipt_{application_id}.pdf")


# -------------------------------------------------------------
# PREVIEW RECEIPT
# -------------------------------------------------------------
class PreviewReceiptView(APIView):
    def get(self, request, application_id):
        try:
            application = AdmissionApplication.objects.get(id=application_id)
        except AdmissionApplication.DoesNotExist:
            return Response({"error": "Application not found"}, status=404)

        if not application.is_paid:
            return Response({"error": "Payment not completed"}, status=400)

        pdf_buffer = generate_receipt(application)
        return HttpResponse(pdf_buffer, content_type="application/pdf")


# -------------------------------------------------------------
# PAYMENT CONFIRMATION + EMAIL RECEIPT
# -------------------------------------------------------------
@api_view(["POST"])
def confirm_payment(request):
    application_id = request.data.get("application_id")
    transaction_id = request.data.get("transaction_id")

    if not application_id or not transaction_id:
        return Response({"error": "application_id and transaction_id required"}, status=400)

    try:
        application = AdmissionApplication.objects.get(id=application_id)
    except AdmissionApplication.DoesNotExist:
        return Response({"error": "Application not found"}, status=404)

    if application.is_paid:
        return Response({"message": "Already paid"}, status=200)

    application.is_paid = True
    application.transaction_id = transaction_id
    application.payment_date = now()
    application.save()

    pdf_path = generate_pdf_receipt(application)
    send_receipt_email(application, pdf_path)

    return Response({"message": "Payment confirmed & receipt emailed"}, status=200)


class NewApplicantListCreateAPIView(generics.ListCreateAPIView):
    queryset = AdmissionApplication.objects.all()
    serializer_class = NewApplicantSerializer
    parser_classes = (MultiPartParser, FormParser)
        
class NewApplicantRetrieveAPIView(generics.RetrieveAPIView):
    queryset = AdmissionApplication.objects.all()
    serializer_class = NewApplicantSerializer



class PendingAdmissionListAPIView(generics.ListAPIView):
    serializer_class = PendingAdmissionListSerializer

    def get_queryset(self):
        status_filter = self.request.query_params.get("status", "all")
        qs = AdmissionApplication.objects.all().order_by("-created_at")

        if status_filter != "all":
            qs = qs.filter(status=status_filter)

        return qs


class ConvertAdmissionToStudentAPIView(generics.GenericAPIView):
    queryset = AdmissionApplication.objects.select_related("class_applied")

    def post(self, request, pk):
        admission = self.get_object()

        if admission.status != "approved":
            return Response(
                {"error": "Only approved admissions can be converted"},
                status=status.HTTP_400_BAD_REQUEST
            )

        with transaction.atomic():
            # Create user
            username = admission.full_name.replace(" ", "").lower()
            user = User.objects.create(
                username=f"{username}_{admission.id}",
                full_name=admission.full_name,
            )
            user.set_password("student@123")
            user.save()

            # Create student profile
            student = StudentProfile.objects.create(
                user=user,
                gender=admission.gender,
                dob=admission.dob,
                address=admission.address,
                city=admission.city,
                guardian_name=admission.father_name,
                mobile_number=admission.mobile_number,
                class_enrolled=admission.class_applied.name,
                admission_status="active",
            )

            admission.status = "converted"
            admission.save(update_fields=["status"])

        return Response(
            {
                "message": "Admission converted successfully",
                "student_id": student.id,
                "admission_number": student.admission_number,
                "roll_number": student.roll_number,
            },
            status=status.HTTP_201_CREATED
        )
        

class NewApplicantDetailAPIView(generics.RetrieveAPIView):
    queryset = AdmissionApplication.objects.all()
    serializer_class = NewApplicantSerializer