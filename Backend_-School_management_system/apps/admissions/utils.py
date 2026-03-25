# admissions/utils.py

from reportlab.pdfgen import canvas
from io import BytesIO
from django.http import HttpResponse

def generate_receipt(application):
    buffer = BytesIO()
    p = canvas.Canvas(buffer)

    p.setFont("Helvetica-Bold", 16)
    p.drawString(200, 800, "Royal Public School")
    p.setFont("Helvetica", 12)
    p.drawString(200, 780, "Admission Receipt")

    p.setFont("Helvetica", 10)
    y = 740
    line_gap = 20

    fields = [
        ("Application ID", application.id),
        ("Student Name", application.full_name),
        ("Class Applied", application.class_applied),
        ("Admission Date", application.admission_date.strftime('%d-%m-%Y')),
        ("Paid", "Yes" if application.is_paid else "No"),
        ("Submitted", "Yes" if application.is_submitted else "No"),
        ("Submitted At", application.submitted_at.strftime('%d-%m-%Y %H:%M') if application.submitted_at else "N/A"),
    ]

    for label, value in fields:
        p.drawString(80, y, f"{label}: {value}")
        y -= line_gap

    p.showPage()
    p.save()
    buffer.seek(0)
    return buffer


# admissions/utils.py

from django.core.mail import EmailMessage

def email_receipt(application):
    pdf_buffer = generate_receipt(application)
    email = EmailMessage(
        subject='Your Admission Receipt - Royal Public School',
        body='Dear {},\n\nThank you for your application. Please find the attached receipt.'.format(application.full_name),
        from_email='admissions@royalschool.com',
        to=[application.email],
    )
    email.attach(f"receipt_{application.id}.pdf", pdf_buffer.getvalue(), 'application/pdf')
    email.send()




from io import BytesIO
from django.core.files.base import ContentFile
from django.core.mail import EmailMessage
from django.template.loader import render_to_string
from xhtml2pdf import pisa
import os

def generate_pdf_receipt(application):
    html = render_to_string("admissions/receipt_template.html", {'app': application})
    result = BytesIO()
    pisa_status = pisa.CreatePDF(html, dest=result)
    
    if pisa_status.err:
        return None

    pdf_path = f'media/receipts/receipt_{application.id}.pdf'
    with open(pdf_path, 'wb') as f:
        f.write(result.getvalue())
    return pdf_path

def send_receipt_email(application, pdf_path):
    email = EmailMessage(
        subject="Admission Receipt - Royal Public School",
        body="Attached is your admission receipt.",
        to=[application.email],
    )
    if pdf_path and os.path.exists(pdf_path):
        with open(pdf_path, 'rb') as f:
            email.attach(f"receipt_{application.id}.pdf", f.read(), 'application/pdf')
    email.send()
