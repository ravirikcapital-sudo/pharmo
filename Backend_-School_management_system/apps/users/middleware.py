# users/middleware.py

from django.shortcuts import redirect
from django.urls import reverse
from django.urls import reverse_lazy

class ApprovalCheckMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
         # Only check logged-in users who are NOT staff/admin
        if request.user.is_authenticated and not request.user.is_staff:
            if not request.user.is_approved:
                allowed_urls = [reverse_lazy('pending-verification')]
                if request.path not in allowed_urls:
                    return redirect('pending-verification')
        # if request.user.is_authenticated and not request.user.is_approved:
        #     allowed_urls = [reverse('pending-verification')]  # whitelist
        #     if request.path not in allowed_urls and not request.user.is_staff:
        #         return redirect('pending-verification')
        return self.get_response(request)
