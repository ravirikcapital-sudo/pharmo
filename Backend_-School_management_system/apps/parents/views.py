from django.shortcuts import render
from rest_framework import generics
from rest_framework.permissions import AllowAny
from .serializers import ParentRegisterSerializer
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import LoginSerializer
from rest_framework.permissions import IsAuthenticated
from apps.students.models import StudentProfile
from .serializers import ParentStudentProfileSerializer
from apps.users.models import ParentStudentMapping
from apps.attendence.models import StudentAttendance
from apps.exams.models import StudentExamResult
from apps.exams.serializers import StudentExamResultSerializer



class ParentLoginView(APIView):
    permission_classes = [AllowAny]
    def get(self, request):
        serializer = LoginSerializer()
        return Response(serializer.data)

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data['user']
        refresh = RefreshToken.for_user(user)

        return Response({
            "message": "Login successful",
            "tokens": {
                "refresh": str(refresh),
                "access": str(refresh.access_token),
            },
            "parent": {
                "id": user.parent_profile.id,
                "full_name": user.full_name,
                "email": user.email,
                "phone": user.phone,
                "relationship": user.parent_profile.relationship,
                "is_verified": user.parent_profile.is_verified
            }
        }, status=status.HTTP_200_OK)

class ParentRegisterView(generics.CreateAPIView):
    serializer_class = ParentRegisterSerializer
    permission_classes = [AllowAny]


from rest_framework.permissions import IsAuthenticated
from apps.students.models import StudentProfile
from apps.users.models import ParentStudentMapping
from .serializers import ParentStudentProfileSerializer, StudentPerformanceRequestSerializer, SelectStudentMonthSerializer
from django.db.models import Sum, F, Avg, Value, FloatField, ExpressionWrapper
from django.db.models.functions import ExtractMonth
from calendar import month_abbr, monthrange
from collections import defaultdict
from datetime import datetime
import math

class ParentChildView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            # Fetch student via ParentStudentMapping table as per admin mapping
            mapping = ParentStudentMapping.objects.filter(parent=request.user).first()
            
            if not mapping:
                return Response({'error': 'No student mapped to this parent account'}, status=status.HTTP_404_NOT_FOUND)

            student_user = mapping.student
            
            # Access the student profile via the OneToOne relation related_name='student_profile'
            try:
                student_profile = student_user.student_profile
            except StudentProfile.DoesNotExist:
                 return Response({'error': 'Student profile not found for the mapped user'}, status=status.HTTP_404_NOT_FOUND)

            serializer = ParentStudentProfileSerializer(student_profile)
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ParentChildrenListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        mappings = ParentStudentMapping.objects.filter(parent=request.user)
        students = []
        for mapping in mappings:
            student_user = mapping.student
            if hasattr(student_user, 'student_profile'):
                students.append(student_user.student_profile)

        serializer = ParentStudentProfileSerializer(students, many=True)
        return Response(serializer.data)


class ParentAttendanceSummaryView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, student_id):
        try:
            student_profile = StudentProfile.objects.get(pk=student_id)
        except StudentProfile.DoesNotExist:
            return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

        # Ensure parent-child relationship
        if not ParentStudentMapping.objects.filter(parent=request.user, student=student_profile.user).exists():
            return Response({'error': 'Access denied'}, status=status.HTTP_403_FORBIDDEN)

        from_date = request.query_params.get('from')
        to_date = request.query_params.get('to')

        qs = StudentAttendance.objects.filter(student=student_profile)
        if from_date:
            qs = qs.filter(date__gte=from_date)
        if to_date:
            qs = qs.filter(date__lte=to_date)

        total_days = qs.count()
        present_days = qs.filter(status='Present').count()
        absent_days = qs.filter(status='Absent').count()
        percentage = round((present_days / total_days) * 100, 2) if total_days else 0.0

        data = {
            'total_days': total_days,
            'present_days': present_days,
            'absent_days': absent_days,
            'percentage': percentage
        }

        return Response(data)


class ParentStudentMonthlyAttendanceView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = SelectStudentMonthSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        student_name = serializer.validated_data.get('student_name')
        month_input = serializer.validated_data.get('month')

        # Find students mapped to this parent with name filter
        mapped_student_ids = ParentStudentMapping.objects.filter(parent=request.user).values_list('student', flat=True)
        students = StudentProfile.objects.filter(user__in=mapped_student_ids, user__full_name__icontains=student_name)
        if not students.exists():
            return Response({'error': 'Student not found or not mapped to parent'}, status=status.HTTP_404_NOT_FOUND)
        student = students.filter(user__full_name__iexact=student_name).first() or students.first()

        # Resolve month (accept numeric or full/short name)
        try:
            month_num = int(month_input)
        except (TypeError, ValueError):
            try:
                month_num = datetime.strptime(month_input, '%B').month
            except ValueError:
                try:
                    month_num = datetime.strptime(month_input, '%b').month
                except ValueError:
                    return Response({'error': 'Invalid month'}, status=status.HTTP_400_BAD_REQUEST)

        attendance_qs = StudentAttendance.objects.filter(student=student, date__month=month_num).order_by('date')

        total_days = attendance_qs.count()
        present_days = attendance_qs.filter(status='Present').count()
        absent_days = attendance_qs.filter(status='Absent').count()
        late_days = attendance_qs.filter(status='Late').count()
        percentage = round((present_days / total_days) * 100, 1) if total_days else 0.0

        records = [{'date': a.date.isoformat(), 'status': a.status} for a in attendance_qs]

        # Build full response payload matching frontend contract
        # Determine year for month range (use attendance data if available)
        year = attendance_qs.first().date.year if attendance_qs.exists() else datetime.now().year
        last_day = monthrange(year, month_num)[1]

        # Build daily calendar for days 1..last_day (default to 'present' if no record)
        calendar_days = []
        for day in range(1, last_day + 1):
            rec = attendance_qs.filter(date__day=day).first()
            if rec:
                status = rec.status.lower()
            else:
                status = 'present'
            calendar_days.append({'day': day, 'status': status})

        # Weekly buckets W1..W4
        weeks = [(1, 7), (8, 14), (15, 21), (22, last_day)]
        weekly_points = []
        for i, (start, end) in enumerate(weeks, start=1):
            week_qs = attendance_qs.filter(date__day__gte=start, date__day__lte=end)
            tdays = week_qs.count()
            pdays = week_qs.filter(status='Present').count()
            pct = int(round((pdays / tdays) * 100)) if tdays else 0
            weekly_points.append({'week': f'W{i}', 'percentage': pct})

        # Insights message
        if percentage >= 95:
            insight_msg = 'Excellent attendance! Keep up the great work.'
        elif percentage >= 75:
            insight_msg = 'Good attendance. Keep improving.'
        else:
            insight_msg = 'Attendance needs improvement.'

        payload = {
            'section': 'student_attendance',
            'student_info': {
                'name': student.user.full_name,
                'class': str(student.class_enrolled),
                'roll': f"{student.roll_number:02d}",
                'month': month_input
            },
            'attendance_summary': {
                'total_days': {'value': total_days, 'icon': 'calendar', 'color': 'light_blue'},
                'present_days': {'value': present_days, 'icon': 'checkmark', 'color': 'light_green'},
                'absent_days': {'value': absent_days, 'icon': 'x_mark', 'color': 'light_red'},
                'percentage': {'value': f"{percentage}%", 'icon': 'percentage', 'color': 'light_purple'},
                'late_arrivals': {'value': late_days, 'icon': 'clock', 'color': 'light_orange'},
                'early_departures': {'value': 0, 'icon': 'door', 'color': 'light_teal'}
            },
            'weekly_attendance_trend': {
                'y_axis': {'label': 'Percentage', 'min': 0, 'max': 100, 'increment': 20},
                'data_points': weekly_points
            },
            'daily_attendance': {
                'month': month_input,
                'legend': {
                    'present': {'color': 'green', 'label': 'Present'},
                    'absent': {'color': 'red', 'label': 'Absent'},
                    'late': {'color': 'orange', 'label': 'Late'},
                    'early': {'color': 'blue', 'label': 'Early'}
                },
                'calendar': calendar_days
            },
            'attendance_statistics': {
                'overall_attendance': {'value': f"{percentage}%", 'progress': percentage},
                'insights': {'message': insight_msg}
            }
        }

        return Response(payload)


class ParentExamResultsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, student_id):
        try:
            student_profile = StudentProfile.objects.get(pk=student_id)
        except StudentProfile.DoesNotExist:
            return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

        if not ParentStudentMapping.objects.filter(parent=request.user, student=student_profile.user).exists():
            return Response({'error': 'Access denied'}, status=status.HTTP_403_FORBIDDEN)

        results = StudentExamResult.objects.filter(student=student_profile)
        serializer = StudentExamResultSerializer(results, many=True)
        return Response(serializer.data)


class ParentStudentTimetableView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, student_id):
        try:
            student_profile = StudentProfile.objects.get(pk=student_id)
        except StudentProfile.DoesNotExist:
            return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

        if not ParentStudentMapping.objects.filter(parent=request.user, student=student_profile.user).exists():
            return Response({'error': 'Access denied'}, status=status.HTTP_403_FORBIDDEN)

        # Timetable app may not be enabled in INSTALLED_APPS; import lazily
        try:
            from apps.timetable.models import StudentTimetable
            from apps.timetable.serializers import StudentTimetableSerializer
        except Exception:
            return Response({'error': 'Timetable feature not available'}, status=status.HTTP_501_NOT_IMPLEMENTED)

        timetables = StudentTimetable.objects.filter(
            class_enrolled=student_profile.class_enrolled,
            section=student_profile.section
        )
        serializer = StudentTimetableSerializer(timetables, many=True)
        return Response(serializer.data)


def _get_grade(percentage: float) -> str:
    """Simple grade mapper used in the performance endpoint."""
    if percentage >= 90:
        return "A+"
    if percentage >= 80:
        return "A"
    if percentage >= 75:
        return "B+"
    if percentage >= 70:
        return "B"
    if percentage >= 60:
        return "C"
    return "D"


class ParentStudentPerformanceView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = StudentPerformanceRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        class_name = serializer.validated_data.get('classs')
        name = serializer.validated_data.get('name')
        semister = serializer.validated_data.get('semister', '')

        # Find class by name (flexible partial match)
        from apps.schoolclassesmanage.models import SchoolClass
        school_class = SchoolClass.objects.filter(name__icontains=class_name).first()
        if not school_class:
            return Response({'error': 'Class not found'}, status=status.HTTP_404_NOT_FOUND)

        # Find student by name within the class (prefer exact match)
        students = StudentProfile.objects.filter(class_enrolled=school_class, user__full_name__icontains=name)
        if not students.exists():
            return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)
        student = students.filter(user__full_name__iexact=name).first() or students.first()

        if not student:
            return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

        # Verify parent-child relation
        if not ParentStudentMapping.objects.filter(parent=request.user, student=student.user).exists():
            return Response({'error': 'Access denied'}, status=status.HTTP_403_FORBIDDEN)

        # ther exam results
        results_qs = StudentExamResult.objects.filter(student=student)
        # Optionally filter by semester/exam alias if provided and matches known values
        if semister:
            sem_norm = semister.lower()
            results_qs = results_qs.filter(exam__icontains=sem_norm)

        total_obtained = float(results_qs.aggregate(total=Sum('marks_obtained'))['total'] or 0.0)
        total_max = float(results_qs.aggregate(total=Sum('max_marks'))['total'] or 0.0)

        percentage = round((total_obtained / total_max) * 100, 1) if total_max else 0.0
        grade = _get_grade(percentage)

        # Class rank: compute percentages for classmates using same logic
        classmates = StudentProfile.objects.filter(class_enrolled=student.class_enrolled)
        ranks = []
        for s in classmates:
            s_results = StudentExamResult.objects.filter(student=s)
            s_total_obt = float(s_results.aggregate(total=Sum('marks_obtained'))['total'] or 0.0)
            s_total_max = float(s_results.aggregate(total=Sum('max_marks'))['total'] or 0.0)
            s_pct = round((s_total_obt / s_total_max) * 100, 1) if s_total_max else 0.0
            ranks.append((s.id, s_pct))
        ranks_sorted = sorted(ranks, key=lambda x: x[1], reverse=True)
        rank = next((i + 1 for i, (sid, _) in enumerate(ranks_sorted) if sid == student.id), None)
        class_rank = f"#{rank}" if rank else "#-"

        # Attendance
        attendance_qs = StudentAttendance.objects.filter(student=student)
        total_days = attendance_qs.count()
        present_days = attendance_qs.filter(status='Present').count()
        attendance_pct = round((present_days / total_days) * 100, 1) if total_days else 0.0

        # Subject-wise performance
        subject_agg = defaultdict(lambda: {'obtained': 0.0, 'max': 0})
        for r in results_qs:
            subj_name = str(r.subject.name)
            subject_agg[subj_name]['obtained'] += float(r.marks_obtained)
            subject_agg[subj_name]['max'] += r.max_marks

        subject_list = []
        for subj, data in subject_agg.items():
            pct = round((data['obtained'] / data['max']) * 100, 1) if data['max'] else 0.0
            subject_list.append({
                'subject': subj,
                'marks': f"{int(data['obtained'])}/{int(data['max'])}",
                'percentage': pct,
                'grade': _get_grade(pct),
                'progress': int(round(pct))
            })

        # Monthly progress trend based on created_at
        monthly = results_qs.annotate(month=ExtractMonth('created_at')).values('month').annotate(
            avg_pct=Avg(ExpressionWrapper(F('marks_obtained') * Value(100) / F('max_marks'), output_field=FloatField()))
        ).order_by('month')[:12]

        monthly_points = []
        for m in monthly:
            mm = m.get('month')
            mon = month_abbr[mm] if isinstance(mm, int) else month_abbr[mm]
            monthly_points.append({'month': mon, 'value': int(round(m.get('avg_pct') or 0.0))})

        # Performance distribution (share of each subject in total obtained)
        distribution = []
        for subj, data in subject_agg.items():
            share = round((data['obtained'] / total_obtained) * 100, 1) if total_obtained else 0.0
            distribution.append({'subject': subj, 'percentage': share, 'color': 'light_blue'})

        # Prepare final payload matching the requested structure
        payload = {
            'student_info': {
                'name': student.user.full_name,
                'class': str(student.class_enrolled),
                'roll': str(student.roll_number),
                'semester': semister or ''
            },
            'overall_performance': {
                'total_marks': {'value': f"{int(total_obtained)}/{int(total_max)}", 'icon': 'document', 'color': 'blue'},
                'percentage': {'value': f"{percentage}%", 'icon': 'percentage', 'color': 'light_green'},
                'grade': {'value': grade, 'icon': 'star', 'color': 'orange'},
                'class_rank': {'value': class_rank, 'icon': 'trophy', 'color': 'light_purple'},
                'attendance': {'value': f"{attendance_pct}%", 'icon': 'checkmark', 'color': 'teal'}
            },
            'subject_wise_performance': subject_list,
            'monthly_progress_trend': {
                'title': 'Monthly Progress Trend',
                'chart_type': 'line_chart_with_area_fill',
                'y_axis_label': 'Percentage',
                'x_axis_label': 'Month',
                'data_points': monthly_points
            },
            'performance_distribution': {
                'title': 'Performance Distribution',
                'chart_type': 'donut_chart',
                'segments': distribution
            }
        }

        return Response(payload)


from rest_framework import generics
from .serializers import ComplaintSerializer, ComplaintCreateSerializer
from apps.parents.models import Complaint


class ComplaintListView(generics.ListCreateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = ComplaintSerializer

    def get_queryset(self):
        qs = Complaint.objects.all()
        status_filter = self.request.query_params.get('status')
        if status_filter and status_filter.lower() != 'all':
            qs = qs.filter(status__iexact=status_filter)
        return qs.order_by('-created_at')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        # Build filter list with active flag
        requested_status = request.query_params.get('status', 'All')
        filters = [
            {"name": "All", "active": requested_status.lower() == 'all'},
            {"name": "Pending", "active": requested_status.lower() == 'pending'},
            {"name": "In Progress", "active": requested_status.lower() == 'in progress'},
            {"name": "Resolved", "active": requested_status.lower() == 'resolved'}
        ]

        # Transform serializer data to match frontend contract
        complaints = []
        for item in serializer.data:
            complaints.append({
                'complaint_id': item.get('complaint_id'),
                'title': item.get('title'),
                'status': item.get('status'),
                'description': item.get('description'),
                'reported_by': item.get('reported_by'),
                'time_ago': item.get('time_ago')
            })

        return Response({
            'section': 'complaint_list',
            'filters': filters,
            'complaints': complaints
        })

    def post(self, request, *args, **kwargs):
        # Accept payload either as flat object or nested under 'data'
        payload = request.data.get('data') if isinstance(request.data, dict) and 'data' in request.data else request.data
        serializer = ComplaintCreateSerializer(data=payload, context={'request': request})
        serializer.is_valid(raise_exception=True)
        complaint = serializer.save()

        out_serializer = ComplaintSerializer(complaint)
        return Response({
            'section': 'submit_complaint',
            'data': out_serializer.data
        }, status=201)


