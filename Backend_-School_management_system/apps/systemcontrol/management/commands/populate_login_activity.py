from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import timedelta
from apps.users.models import CustomUser
from apps.systemcontrol.models import UserLoginActivity


class Command(BaseCommand):
    help = "Populate test user login activity data for demonstration"

    def handle(self, *args, **options):
        """Create sample login activities for existing users"""

        # Get all existing users
        users = CustomUser.objects.all()

        if not users.exists():
            self.stdout.write(
                self.style.ERROR("No users found. Please create some users first.")
            )
            return

        # Create multiple login entries per user
        created_count = 0
        now = timezone.now()

        for user in users:
            role = getattr(user, "role", "unknown")

            # Create 5 login records for each user at different times
            for i in range(5):
                logged_in_at = now - timedelta(days=i, hours=2 * i)
                activity, created = UserLoginActivity.objects.get_or_create(
                    user=user, role=role, logged_in_at=logged_in_at
                )
                if created:
                    created_count += 1

        self.stdout.write(
            self.style.SUCCESS(
                f"Successfully created {created_count} user login activity records"
            )
        )
