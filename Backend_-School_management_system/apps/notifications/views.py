from rest_framework import generics
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Notification
from .serializers import NotificationSerializer
from django.utils.timesince import timesince
from django.utils import timezone


class NotificationListView(generics.ListCreateAPIView):
    serializer_class = NotificationSerializer

    def get_queryset(self):
        user = self.request.user

        if user.is_anonymous:
            return Notification.objects.all()

        return Notification.objects.filter(recipient=user)


class RecentNoticesView(APIView):
    """
    Returns recent notices in a compact format suitable for the mobile app.
    """
    def get(self, request):
        qs = Notification.objects.all()[:6]
        notices = []
        now = timezone.now()
        icon_map = {
            "Admission": "group",
            "Attendance": "water_drop",
            "Academic": "book",
            "Fees": "credit_card",
            "General": "chat_bubble_exclamation",
        }
        color_map = {
            "Admission": ("orange","light_orange","orange"),
            "Attendance": ("blue","light_blue","red"),
            "Academic": ("teal","light_teal","green"),
            "Fees": ("green","light_green","green"),
            "General": ("purple","light_purple","orange"),
        }
        for n in qs:
            nid = f"n{n.id:03d}"
            itype = n.notification_type or "General"
            icon = icon_map.get(itype, "chat_bubble_exclamation")
            icon_color, icon_bg, status = color_map.get(itype, ("teal","light_teal","green"))
            time_str = timesince(n.created_at, now).split(",")[0] + " ago"
            notices.append({
                "notice_id": nid,
                "icon": icon,
                "icon_color": icon_color,
                "icon_background": icon_bg,
                "title": n.title,
                "timestamp": time_str,
                "status_bar_color": status
            })
        data = {
            "section": "recent_notices",
            "notifications_center": {"total_notices": Notification.objects.count()},
            "notices": notices
        }
        return Response(data)

