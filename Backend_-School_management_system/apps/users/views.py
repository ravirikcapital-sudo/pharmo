# apps/users/views.py

from django.shortcuts import get_object_or_404
from rest_framework import generics, permissions
from .models import CustomUser
from .serializers import RegisterUserSerializer, UserSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny, IsAuthenticated
from .models import CustomUser
from .serializers import (
    RegisterUserSerializer,
    LoginSerializer,
    UserApprovalSerializer,
    ChangePasswordSerializer,
)
from rest_framework_simplejwt.tokens import RefreshToken

User = get_user_model()


class RegisterUserView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterUserSerializer
    permission_classes = [permissions.AllowAny]



class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data['email']
        password = serializer.validated_data['password']

        print("Attempting login for:", email, '===', password)  # Debugging line

        user = authenticate(request, email=email, password=password)

        if not user:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

        if not user.is_approved:
            return Response({'message': 'Your account is pending approval.'}, status=status.HTTP_403_FORBIDDEN)

        refresh = RefreshToken.for_user(user)
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': {
                'id': user.id,
                'email': user.email,
                'full_name': user.full_name,
                'role': user.role,
                'is_approved': user.is_approved
            }
        })


class VerificationPendingView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        if request.user.is_approved:
            return Response({"detail": "Account already approved."})
        return Response({"detail": "Your account is pending verification. Please wait for admin approval."}, status=403)


class CurrentUserView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)


class LogoutView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get("refresh")
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({"detail": "Logout successful"})
        except Exception as e:
            return Response({"error": "Invalid token"}, status=400)


class PendingUserRequestsAPIView(APIView):
    # permission_classes = [IsAuthenticated]

    def get(self, request):
        users = CustomUser.objects.filter(
            is_approved=False,
            is_deleted=False
        )

        serializer = UserApprovalSerializer(users, many=True)
        return Response(serializer.data)
    

class ApproveUserAPIView(APIView):
    # permission_classes = [IsAuthenticated]

    def post(self, request, user_id):
        user = get_object_or_404(CustomUser, id=user_id)

        user.is_approved = True
        user.is_active = True
        user.is_verified = True
        user.save()

        return Response({"message": "User approved successfully"})


class ChangePasswordView(APIView):
    """Allow an authenticated user to change their password."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data, context={"request": request})
        serializer.is_valid(raise_exception=True)

        user = request.user
        current_password = serializer.validated_data.get("current_password")
        new_password = serializer.validated_data.get("new_password")

        if not user.check_password(current_password):
            return Response({"current_password": "Wrong password."}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()

        return Response({"detail": "Password changed successfully."}, status=status.HTTP_200_OK)


class DeclineUserAPIView(APIView):
    # permission_classes = [IsAuthenticated]

    def post(self, request, user_id):
        user = get_object_or_404(CustomUser, id=user_id)

        user.is_deleted = True
        user.save()

        return Response({"message": "User declined"})


class ModifyUserRoleAPIView(APIView):
    # permission_classes = [IsAuthenticated]

    def post(self, request, user_id):
        role = request.data.get('role')

        if not role:
            return Response({"error": "Role is required"}, status=status.HTTP_400_BAD_REQUEST)

        user = get_object_or_404(CustomUser, id=user_id)
        user.role = role
        user.save()

        return Response({"message": "Role updated successfully"})