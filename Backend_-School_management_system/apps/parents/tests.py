from django.urls import reverse
from rest_framework.test import APITestCase, APIClient
from apps.users.models import CustomUser, ParentStudentMapping
from apps.schoolclassesmanage.models import SchoolClass
from apps.students.models import StudentProfile
from apps.attendence.models import StudentAttendance
from datetime import date, timedelta


class ParentAPITests(APITestCase):
    def setUp(self):
        self.client = APIClient()
        # Create a school class
        self.school_class = SchoolClass.objects.create(name='Grade 1', academic_year='2025-2026')

        # Parent user
        self.parent = CustomUser.objects.create_user(email='parent@example.com', full_name='Parent One', phone='1234567890', password='pass1234', role='parent')

        # Student user and profile
        self.student_user = CustomUser.objects.create_user(email='student@example.com', full_name='Student One', phone='0987654321', password='pass1234', role='student')
        # Create student profile and set missing virtual "section" attribute used in save()
        self.student_profile = StudentProfile(user=self.student_user, class_enrolled=self.school_class, phone='0987654321')
        # the codebase expects a 'section' attribute in other places; set it before saving
        setattr(self.student_profile, 'section', 'A')
        # Set an initial roll number to skip auto-assignment which expects a 'section' DB field
        self.student_profile.roll_number = 1
        self.student_profile.save()

        # Parent-Student mapping
        ParentStudentMapping.objects.create(parent=self.parent, student=self.student_user, relationship='father', is_primary_guardian=True)

    def test_children_list(self):
        self.client.force_authenticate(user=self.parent)
        url = '/api/parents/children/'
        resp = self.client.get(url)
        self.assertEqual(resp.status_code, 200)
        self.assertIsInstance(resp.data, list)
        self.assertGreaterEqual(len(resp.data), 1)
        # Check expected keys exist
        self.assertIn('name', resp.data[0])
        self.assertIn('email', resp.data[0])

    def test_attendance_summary(self):
        # Create attendance records for 5 days
        base = date.today()
        statuses = ['Present', 'Present', 'Absent', 'Present', 'Absent']
        for i, s in enumerate(statuses):
            StudentAttendance.objects.create(student=self.student_profile, school_class=self.school_class, date=base - timedelta(days=i), status=s)

        self.client.force_authenticate(user=self.parent)
        url = f'/api/parents/children/{self.student_profile.id}/attendance/'
        resp = self.client.get(url)
        self.assertEqual(resp.status_code, 200)
        self.assertEqual(resp.data['total_days'], 5)
        self.assertEqual(resp.data['present_days'], statuses.count('Present'))
        self.assertEqual(resp.data['absent_days'], statuses.count('Absent'))
