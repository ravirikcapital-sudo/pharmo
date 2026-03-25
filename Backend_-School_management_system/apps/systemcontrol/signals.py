from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.signals import user_logged_in
from rest_framework.authtoken.models import Token
from apps.users.models import CustomUser
from .models import UserLoginActivity


@receiver(user_logged_in)
def track_user_login(sender, request, user, **kwargs):
    """
    Signal receiver to track user login activity.
    Triggered whenever a user successfully logs in.
    """
    role = getattr(user, "role", "unknown")
    UserLoginActivity.objects.create(user=user, role=role)


@receiver(post_save, sender=Token)
def track_token_creation(sender, instance, created, **kwargs):
    """
    Alternative tracking for API token authentication.
    Triggered when an auth token is created (during login).
    """
    if created:
        user = instance.user
        role = getattr(user, "role", "unknown")
        UserLoginActivity.objects.create(user=user, role=role)
