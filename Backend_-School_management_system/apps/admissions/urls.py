from django.urls import path
from .views import (
    PendingAdmissionListAPIView,
    ConvertAdmissionToStudentAPIView,
    AdmissionStepOneView,
    ParentGuardianDetailsView,
    ContactAddressView,
    DocumentUploadView,
    AdmissionMarkPaidView,
    AdmissionSubmitView,
    DownloadReceiptView,
    PreviewReceiptView,
    confirm_payment,
    NewApplicantListCreateAPIView,
    NewApplicantRetrieveAPIView,
    NewApplicantDetailAPIView,
)

urlpatterns = [
    # Step 1
    path("start/", AdmissionStepOneView.as_view(), name="admission_start"),

    # Step 2
    path("<int:application_id>/parent-details/", ParentGuardianDetailsView.as_view(), name="parent_details"),

    # Step 3
    path("<int:application_id>/contact-address/", ContactAddressView.as_view(), name="contact_address"),

    # Step 4
    path("<int:application_id>/upload-documents/", DocumentUploadView.as_view(), name="upload_documents"),

    # Payment (Flutter uses: /<id>/pay/)
    path("<int:pk>/pay/", AdmissionMarkPaidView.as_view(), name="pay"),

    # Final Submit
    path("<int:pk>/submit/", AdmissionSubmitView.as_view(), name="submit"),

    # Receipt
    path("<int:application_id>/download-receipt/", DownloadReceiptView.as_view(), name="download_receipt"),
    path("<int:application_id>/preview-receipt/", PreviewReceiptView.as_view(), name="preview_receipt"),

    # Confirm Payment with transaction id
    path("mark-paid/", confirm_payment, name="confirm_payment"),
    
    path("new-applicants/", NewApplicantListCreateAPIView.as_view(), name="new_applicant_list_create"),
    path("new-applicants/<int:pk>/", NewApplicantRetrieveAPIView.as_view(), name="new_applicant_detail"),
     path(
        "pending-admissions/",
        PendingAdmissionListAPIView.as_view(),
        name="pending-admissions",
    ),

    # View single admission
    path(
        "pending-admissions/<int:pk>/",
        NewApplicantDetailAPIView.as_view(),
        name="pending-admission-detail",
    ),

    # Convert approved admission → student
    path(
        "convert-to-student/<int:pk>/",
        ConvertAdmissionToStudentAPIView.as_view(),
        name="convert-admission-to-student",
    ),
]
