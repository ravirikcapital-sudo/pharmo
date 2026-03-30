import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:school/AdminStudentManagement/studentModel.dart' show Student;
import 'package:school/model/adminProfileModel.dart' show AdminProfile;
import 'package:school/model/admission/teacherModel.dart' show Teacher;
import 'package:school/model/dashboard/classSection.dart' show ClassSection;
import 'package:school/model/dashboard/userRequestModel.dart' show UserRequest;
import 'package:shared_preferences/shared_preferences.dart';

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String message, {
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}

// User model
class User {
  final int id;
  final String email;
  final String fullName;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role,
    };
  }
}

// Token model
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }
}

// ==================== Report Models ====================

// Overview Report Model
class OverviewReport {
  final int totalStudents;
  final int totalTeachers;
  final int totalEmployees;

  OverviewReport({
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalEmployees,
  });

  factory OverviewReport.fromJson(Map<String, dynamic> json) {
    return OverviewReport(
      totalStudents: json['total_students'] ?? 0,
      totalTeachers: json['total_teachers'] ?? 0,
      totalEmployees: json['total_employees'] ?? 0,
    );
  }
}

// Class Strength Model
class ClassStrength {
  final String className;
  final int count;

  ClassStrength({required this.className, required this.count});

  factory ClassStrength.fromJson(Map<String, dynamic> json) {
    return ClassStrength(
      className: json['class_name'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

// Academic Report Model
class AcademicReport {
  final List<ClassStrength> classStrength;

  AcademicReport({required this.classStrength});

  factory AcademicReport.fromJson(Map<String, dynamic> json) {
    var list = json['class_strength'] as List? ?? [];
    List<ClassStrength> classStrengthList = 
        list.map((i) => ClassStrength.fromJson(i as Map<String, dynamic>)).toList();
    
    return AcademicReport(classStrength: classStrengthList);
  }
}

// Salary Info Model
class SalaryInfo {
  final String paid;
  final String unpaid;

  SalaryInfo({required this.paid, required this.unpaid});

  factory SalaryInfo.fromJson(Map<String, dynamic> json) {
    return SalaryInfo(
      paid: json['paid']?.toString() ?? '0.00',
      unpaid: json['unpaid']?.toString() ?? '0.00',
    );
  }
}

// Financial Report Model
class FinancialReport {
  final SalaryInfo employeeSalary;
  final SalaryInfo teacherSalary;
  final String note;

  FinancialReport({
    required this.employeeSalary,
    required this.teacherSalary,
    required this.note,
  });

  factory FinancialReport.fromJson(Map<String, dynamic> json) {
    return FinancialReport(
      employeeSalary: SalaryInfo.fromJson(json['employee_salary'] ?? {}),
      teacherSalary: SalaryInfo.fromJson(json['teacher_salary'] ?? {}),
      note: json['note'] ?? '',
    );
  }
}

// Enrollment Summary Model
class EnrollmentSummary {
  final String className;
  final int count;

  EnrollmentSummary({required this.className, required this.count});

  factory EnrollmentSummary.fromJson(Map<String, dynamic> json) {
    return EnrollmentSummary(
      className: json['class'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

// Enrollment Report Model
class EnrollmentReport {
  final List<EnrollmentSummary> enrollmentSummary;
  final int totalApplications;
  final int submittedApplications;
  final int paidApplications;
  final Map<String, dynamic> genderDistribution;

  EnrollmentReport({
    required this.enrollmentSummary,
    required this.totalApplications,
    required this.submittedApplications,
    required this.paidApplications,
    required this.genderDistribution,
  });

  factory EnrollmentReport.fromJson(Map<String, dynamic> json) {
    var list = json['enrollment_summary'] as List? ?? [];
    List<EnrollmentSummary> summaryList = 
        list.map((i) => EnrollmentSummary.fromJson(i as Map<String, dynamic>)).toList();
    
    return EnrollmentReport(
      enrollmentSummary: summaryList,
      totalApplications: json['total_applications'] ?? 0,
      submittedApplications: json['submitted_applications'] ?? 0,
      paidApplications: json['paid_applications'] ?? 0,
      genderDistribution: json['gender_distribution'] ?? {},
    );
  }
}

// Teacher Summary Model
class TeacherSummary {
  final int totalTeachers;
  final int activeTeachers;
  final int verifiedTeachers;
  final int suspendedTeachers;

  TeacherSummary({
    required this.totalTeachers,
    required this.activeTeachers,
    required this.verifiedTeachers,
    required this.suspendedTeachers,
  });

  factory TeacherSummary.fromJson(Map<String, dynamic> json) {
    return TeacherSummary(
      totalTeachers: json['total_teachers'] ?? 0,
      activeTeachers: json['active_teachers'] ?? 0,
      verifiedTeachers: json['verified_teachers'] ?? 0,
      suspendedTeachers: json['suspended_teachers'] ?? 0,
    );
  }
}

// Salary Summary Model
class SalarySummary {
  final String totalSalaryPaid;
  final String totalSalaryUnpaid;

  SalarySummary({required this.totalSalaryPaid, required this.totalSalaryUnpaid});

  factory SalarySummary.fromJson(Map<String, dynamic> json) {
    return SalarySummary(
      totalSalaryPaid: json['total_salary_paid']?.toString() ?? '0.00',
      totalSalaryUnpaid: json['total_salary_unpaid']?.toString() ?? '0.00',
    );
  }
}

// Teachers Report Model
class TeachersReport {
  final TeacherSummary summary;
  final List<Map<String, dynamic>> subjectWiseTeachers;
  final List<Map<String, dynamic>> designationWiseTeachers;
  final List<Map<String, dynamic>> genderWiseTeachers;
  final SalarySummary salarySummary;
  final List<Map<String, dynamic>> attendanceSummary;

  TeachersReport({
    required this.summary,
    required this.subjectWiseTeachers,
    required this.designationWiseTeachers,
    required this.genderWiseTeachers,
    required this.salarySummary,
    required this.attendanceSummary,
  });

  factory TeachersReport.fromJson(Map<String, dynamic> json) {
    return TeachersReport(
      summary: TeacherSummary.fromJson(json['summary'] ?? {}),
      subjectWiseTeachers: List<Map<String, dynamic>>.from(json['subject_wise_teachers'] ?? []),
      designationWiseTeachers: List<Map<String, dynamic>>.from(json['designation_wise_teachers'] ?? []),
      genderWiseTeachers: List<Map<String, dynamic>>.from(json['gender_wise_teachers'] ?? []),
      salarySummary: SalarySummary.fromJson(json['salary_summary'] ?? {}),
      attendanceSummary: List<Map<String, dynamic>>.from(json['attendance_summary'] ?? []),
    );
  }
}

// Main API Service
class ApiService {
  // TODO: Replace with your actual Django server URL
  static const String _baseUrl =
      'http://127.0.0.1:5000/api'; // For local development
  // static const String _baseUrl = 'https://your-domain.com/api'; // For production

  static const Duration _timeout = Duration(seconds: 30);

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  // Get headers with authentication
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final accessToken = await _getAccessToken();
      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    return headers;
  }

  // Get access token from storage
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Get refresh token from storage
  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Save tokens to storage
  Future<void> _saveTokens(AuthTokens tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, tokens.accessToken);
    await prefs.setString(_refreshTokenKey, tokens.refreshToken);
  }

  // Save user data to storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, json.encode(user.toJson()));
    await prefs.setString('user_role', user.role);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_name', user.fullName);
    await prefs.setInt('user_id', user.id);
  }

  // Clear all stored data
  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove('user_role');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
    await prefs.remove('remember_me');
  }

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      return User.fromJson(userData);
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await _getAccessToken();
    final refreshToken = await _getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  // Refresh access token
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http
          .post(
            Uri.parse('$_baseUrl/users/token/refresh/'),
            headers: await _getHeaders(includeAuth: false),
            body: json.encode({'refresh': refreshToken}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_accessTokenKey, data['access']);
        return true;
      } else {
        // Refresh token is invalid, clear all data
        await _clearStoredData();
        return false;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  // Generic HTTP request method with automatic token refresh
  Future<ApiResponse<T>> _makeRequest<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool includeAuth = true,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      // Build URL
      Uri url = Uri.parse('$_baseUrl$endpoint');
      if (queryParams != null) {
        url = url.replace(queryParameters: queryParams);
      }

      // Prepare headers
      final headers = await _getHeaders(includeAuth: includeAuth);

      // Make request
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers).timeout(_timeout);
          break;
        case 'POST':
          response = await http
              .post(
                url,
                headers: headers,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(_timeout);
          break;
        case 'PUT':
          response = await http
              .put(
                url,
                headers: headers,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(_timeout);
          break;
        case 'PATCH':
          response = await http
              .patch(
                url,
                headers: headers,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(_timeout);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers).timeout(_timeout);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Handle unauthorized response with token refresh
      if (response.statusCode == 401 && includeAuth && retryOnUnauthorized) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          // Retry the request with new token
          return await _makeRequest<T>(
            method,
            endpoint,
            body: body,
            queryParams: queryParams,
            fromJson: fromJson,
            includeAuth: includeAuth,
            retryOnUnauthorized: false, // Prevent infinite retry
          );
        } else {
          // Token refresh failed, clear stored data
          await _clearStoredData();
          return ApiResponse.error(
            'Session expired. Please login again.',
            statusCode: 401,
          );
        }
      }

      // Parse response
      return _parseResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error(
        'Network error. Please check your connection.',
        statusCode: 0,
      );
    } on TimeoutException {
      return ApiResponse.error(
        'Request timeout. Please try again.',
        statusCode: 0,
      );
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e', statusCode: 0);
    }
  }

  // Parse HTTP response
  ApiResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        if (response.body.isEmpty) {
          return ApiResponse.success(null as T, statusCode: statusCode);
        }

        final responseData = json.decode(response.body);

        if (fromJson != null) {
          final data = fromJson(responseData);
          return ApiResponse.success(data, statusCode: statusCode);
        } else {
          return ApiResponse.success(responseData as T, statusCode: statusCode);
        }
      } else {
        // Handle error responses
        String errorMessage = 'Request failed';
        Map<String, dynamic>? errors;

        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);

            if (errorData is Map<String, dynamic>) {
              errors = errorData;

              // Handle different error response formats
              if (errorData.containsKey('detail')) {
                errorMessage = errorData['detail'];
              } else if (errorData.containsKey('non_field_errors')) {
                if (errorData['non_field_errors'] is List &&
                    errorData['non_field_errors'].isNotEmpty) {
                  errorMessage = errorData['non_field_errors'][0];
                }
              } else if (errorData.containsKey('message')) {
                errorMessage = errorData['message'];
              } else if (errorData.containsKey('error')) {
                errorMessage = errorData['error'];
              } else {
                // Extract first error message from field errors
                for (var key in errorData.keys) {
                  var value = errorData[key];
                  if (value is String) {
                    errorMessage = value;
                    break;
                  } else if (value is List && value.isNotEmpty) {
                    errorMessage = value[0].toString();
                    break;
                  }
                }
              }
            }
          } catch (e) {
            errorMessage = response.body;
          }
        }

        return ApiResponse.error(
          errorMessage,
          statusCode: statusCode,
          errors: errors,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: $e',
        statusCode: response.statusCode,
      );
    }
  }

  // AUTHENTICATION METHODS

  // Login
  Future<ApiResponse<User>> login(String email, String password) async {
    final response = await _makeRequest<AuthTokens>(
      'POST',
      '/users/login/',
      body: {'email': email, 'password': password},
      fromJson: (data) => AuthTokens.fromJson(data),
      includeAuth: false,
    );

    if (response.success && response.data != null) {
      await _saveTokens(response.data!);

      // Get user data
      final userResponse = await getCurrentUserFromAPI();
      if (userResponse.success && userResponse.data != null) {
        await _saveUserData(userResponse.data!);
        return ApiResponse.success(
          userResponse.data!,
          message: 'Login successful',
        );
      } else {
        await _clearStoredData();
        return ApiResponse.error('Failed to get user data');
      }
    } else {
      return ApiResponse.error(response.message ?? 'Login failed');
    }
  }

  // Register Academic Officer (specific endpoint)
  Future<ApiResponse<Map<String, dynamic>>> registerAcademicOfficer({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
    required String gender,
    required String role,
    required String dateOfJoining,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/users/signup/academic-officer/',
      body: {
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'gender': gender,
        'role': role,
        'date_of_joining': dateOfJoining,
      },
      fromJson: (data) => data,
      includeAuth: false,
    );
  }

  // Register Admin
  Future<ApiResponse<Map<String, dynamic>>> registerAdmin({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
    required String gender,
    required String role,
    required String dateOfJoining,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/users/signup/admin/',
      body: {
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'gender': gender,
        'role': role,
        'date_of_joining': dateOfJoining,
      },
      fromJson: (data) => data,
      includeAuth: false,
    );
  }

  // Register Teacher
  Future<ApiResponse<Map<String, dynamic>>> registerTeacher({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dateOfBirth,
    required String joiningDate,
    required int subjectId, // Changed from String to int
    String? profilePicture,
    String? qualification,
    int? experienceYears,
    String? experienceDetails,
    int? designationId, // Changed from designation to designationId
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/teachers/register/',
      body: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'gender': gender,
        'dob': dateOfBirth,
        'profile_picture': profilePicture,
        'subject': subjectId, // Send as integer ID
        'joining_date': joiningDate,
        'qualification': qualification ?? '',
        'experience_years': experienceYears,
        'experience_details': experienceDetails ?? '',
        'designation': designationId, // Send as integer ID
      },
      fromJson: (data) => data,
      includeAuth: false,
    );
  }

  // Register Parent
  Future<ApiResponse<Map<String, dynamic>>> registerParent({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
    String? relationship,
    required String childAdmissionNumber,
    required String mobileNumber,
    String? alternateNumber,
    required String address,
    required String city,
    required String state,
    required String zipCode,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/parents/register/',
      body: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'relationship': relationship,
        'child_admission_number': childAdmissionNumber,
        'mobile_number': mobileNumber,
        'alternate_number': alternateNumber ?? '',
        'address': address,
        'city': city,
        'state': state,
        'zip_code': zipCode,
      },
      fromJson: (data) => data,
      includeAuth: false,
    );
  }

  // Register Student
  Future<ApiResponse<Map<String, dynamic>>> registerStudent({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/users/signup/student/',
      body: {
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
      },
      fromJson: (data) => data,
      includeAuth: false,
    );
  }

  // Generic register method (you'll need to add this endpoint to Django)
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
    required String role,
    required String gender,
    required String dateOfJoining,
  }) async {
    // For now, only academic officer registration is available
    if (role == 'academic_officer' || role == 'Academic Officer') {
      return await registerAcademicOfficer(
        email: email,
        fullName: fullName,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        gender: gender,
        role: role,
        dateOfJoining: dateOfJoining,
      );
    } else {
      return ApiResponse.error(
        'Registration for $role is not available through this endpoint',
      );
    }
  }

  // Get current user from API
  Future<ApiResponse<User>> getCurrentUserFromAPI() async {
    return await _makeRequest<User>(
      'GET',
      '/users/me/',
      fromJson: (data) => User.fromJson(data),
    );
  }

  // Logout
  Future<ApiResponse<void>> logout() async {
    final refreshToken = await _getRefreshToken();

    if (refreshToken != null) {
      // Try to logout from server
      await _makeRequest<void>(
        'POST',
        '/users/logout/',
        body: {'refresh': refreshToken},
        retryOnUnauthorized: false,
      );
    }

    // Clear local storage regardless of server response
    await _clearStoredData();
    return ApiResponse.success(null, message: 'Logout successful');
  }

  // Validate token (useful for checking if user is still authenticated)
  Future<ApiResponse<bool>> validateToken() async {
    final response = await getCurrentUserFromAPI();
    return ApiResponse.success(response.success);
  }

  // GENERIC CRUD OPERATIONS

  // Get list of items
  Future<ApiResponse<List<T>>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? queryParams,
  }) async {
    return await _makeRequest<List<T>>(
      'GET',
      endpoint,
      queryParams: queryParams,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => fromJson(item)).toList();
        } else if (data is Map && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((item) => fromJson(item)).toList();
        } else if (data is Map && data.containsKey('data')) {
          final List<dynamic> results = data['data'];
          return results.map((item) => fromJson(item)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      },
    );
  }

  // Get single item
  Future<ApiResponse<T>> getItem<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _makeRequest<T>(
      'GET',
      endpoint,
      fromJson: (data) => fromJson(data),
    );
  }

  // Create item
  Future<ApiResponse<T>> createItem<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _makeRequest<T>(
      'POST',
      endpoint,
      body: data,
      fromJson: (data) => fromJson(data),
    );
  }

  // Update item
  Future<ApiResponse<T>> updateItem<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _makeRequest<T>(
      'PUT',
      endpoint,
      body: data,
      fromJson: (data) => fromJson(data),
    );
  }

  // Partial update item
  Future<ApiResponse<T>> patchItem<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await _makeRequest<T>(
      'PATCH',
      endpoint,
      body: data,
      fromJson: (data) => fromJson(data),
    );
  }

  // Delete item
  Future<ApiResponse<void>> deleteItem(String endpoint) async {
    return await _makeRequest<void>('DELETE', endpoint);
  }

  // SPECIFIC API METHODS FOR YOUR SCHOOL MANAGEMENT SYSTEM

  // Students
  static Future<List<Student>> getStudents(String token) async {
    final response = await http.get(Uri.parse("$_baseUrl/students/"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Student.fromJson(e)).toList();
    }
    throw Exception("Failed to load students");
  }

  Future<ApiResponse<dynamic>> getStudent(int id) async {
    return await getItem('/students/detail/$id/', (data) => data);
  }

  static Future<void> createStudent(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/students/"),
      headers: {
        'Content-Type': 'application/json', // âœ… REQUIRED
      },
      body: json.encode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create student");
    }
  }

  /// âœ… UPDATE STUDENT
  static Future<void> updateStudent(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await http.patch(
      Uri.parse("$_baseUrl/students/$id/"),
      headers: {
        'Content-Type': 'application/json', // âœ… REQUIRED
      },
      body: json.encode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update student");
    }
  }

  /// âœ… DELETE STUDENT
  static Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse("$_baseUrl/students/$id/"));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete student");
    }
  }

  // Teachers
  Future<ApiResponse<List<dynamic>>> getTeachers() async {
    return await getList('/teachers/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getTeacher(int id) async {
    return await getItem('/teachers/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createTeacher(Map<String, dynamic> data) async {
    return await createItem('/teachers/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateTeacher(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await updateItem('/teachers/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteTeacher(int id) async {
    return await deleteItem('/teachers/$id/');
  }

  //create quick teacher

  static Future<bool> quickCreateTeacher({
    required String fullName,
    required String email,
    required String phone,
    required String gender,
    required String dob,
    required String subject,
    required String joiningDate,
    required int designationId,
    String? qualification,
    String? experienceYears,
    String? experienceDetails,

    // ðŸ‘‡ CHANGE HERE
    required Uint8List profileImageBytes,
    required String profileImageName,
  }) async {
    final uri = Uri.parse("$_baseUrl/teachers/create-teacher/");

    final request = http.MultipartRequest("POST", uri);

    request.fields.addAll({
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "gender": gender,
      "dob": dob,
      "subject": subject,
      "joining_date": joiningDate,
      "designation": designationId.toString(),
      "qualification": qualification ?? "",
      "experience_years": experienceYears ?? "0",
      "experience_details": experienceDetails ?? "",
    });

    // âœ… WEB-SAFE IMAGE UPLOAD
    request.files.add(
      http.MultipartFile.fromBytes(
        "profile_picture",
        profileImageBytes,
        filename: profileImageName,
      ),
    );

    final response = await request.send();
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Admissions
  Future<ApiResponse<List<dynamic>>> getAdmissions() async {
    return await getList('/admissions/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getAdmission(int id) async {
    return await getItem('/admissions/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createAdmission(
    Map<String, dynamic> data,
  ) async {
    return await createItem('/admissions/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateAdmission(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await updateItem('/admissions/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteAdmission(int id) async {
    return await deleteItem('/admissions/$id/');
  }

  // Academics
  Future<ApiResponse<List<dynamic>>> getAcademics() async {
    return await getList('/academics/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getAcademic(int id) async {
    return await getItem('/academics/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createAcademic(Map<String, dynamic> data) async {
    return await createItem('/academics/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateAcademic(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await updateItem('/academics/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteAcademic(int id) async {
    return await deleteItem('/academics/$id/');
  }

  // Employees
  Future<ApiResponse<List<dynamic>>> getEmployees() async {
    return await getList('/employees/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getEmployee(int id) async {
    return await getItem('/employees/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createEmployee(Map<String, dynamic> data) async {
    return await createItem('/employees/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateEmployee(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await updateItem('/employees/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteEmployee(int id) async {
    return await deleteItem('/employees/$id/');
  }

  // Dashboards
  Future<ApiResponse<dynamic>> getStudentDashboard() async {
    return await getItem('/dashboards/student/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getTeacherDashboard() async {
    return await getItem('/dashboards/teacher/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getParentDashboard() async {
    return await getItem('/dashboards/parent/', (data) => data);
  }

  // Future<ApiResponse<dynamic>> getAdminDashboard() async {
  //   return await getItem('/dashboards/admin/', (data) => data);
  // }

  Future<ApiResponse<dynamic>> getAcademicOfficerDashboard() async {
    return await getItem('/dashboards/academic-officer/', (data) => data);
  }

  // Utility methods
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<ApiResponse<dynamic>> getAdminDashboard() async {
    return await getItem('/admins/', (data) => data);
  }

  Future<ApiResponse<List<dynamic>>> getClasses() async {
    return await getList<dynamic>('/classes/', (data) => data);
  }

  // CREATE CLASS
  Future<ApiResponse<dynamic>> createClass({required String name}) async {
    return await _makeRequest(
      'POST',
      '/classes/',
      body: {'name': name},
      fromJson: (data) => data,
    );
  }

  // UPDATE CLASS
  Future<ApiResponse<dynamic>> updateClass({
    required int id,
    required String name,
  }) async {
    return await _makeRequest(
      'PATCH', // âœ… PATCH is correct for partial update
      '/classes/$id/',
      body: {'name': name},
      fromJson: (data) => data,
    );
  }

  // DELETE CLASS
  Future<ApiResponse<dynamic>> deleteClass(int id) async {
    return await _makeRequest(
      'DELETE',
      '/classes/$id/',
      fromJson: (data) => data,
    );
  }

  Future<ApiResponse<List<Student>>> getStudentsByClass(
    String className,
  ) async {
    return await _makeRequest<List<Student>>(
      'GET',
      '/students/students/by-class/',
      queryParams: {'class': className},
      fromJson: (data) {
        if (data is List) {
          return data.map((e) => Student.fromJson(e)).toList();
        }
        return [];
      },
    );
  }

  static Future<List<Teacher>> fetchTeachers() async {
    final response = await http.get(Uri.parse("$_baseUrl/teachers/lists/"));
    print("------Stataus ${response.statusCode}");
    print("------Stataus ${response.statusCode == 200}");
    print("------Body ${response}");
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Teacher.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load teachers");
    }
  }

  // ---------------- SECTIONS ----------------
  static Future<List<ClassSection>> fetchSections() async {
    final response = await http.get(Uri.parse("$_baseUrl/classes/"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      print("------List--${data}");
      return ClassSection.fromApiList(data);
    } else {
      throw Exception("Failed to load sections");
    }
  }

  static Future<void> createSection(ClassSection section) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/classes/${section.classId}/"),
    );

    if (response.statusCode != 200) {
      throw Exception("Class not found");
    }

    final Map<String, dynamic> cls = json.decode(response.body);

    final List sections = cls['sections'] ?? [];

    sections.add({
      "section": section.sectionName,
      "current_students": section.currentStudents,
    });

    await http.put(
      Uri.parse("$_baseUrl/classes/${section.classId}/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": cls['name'],
        "room": cls['room'],
        "teachers": cls['teachers'].map((t) => t['id']).toList(),
        "sections": sections,
      }),
    );
  }

  static Future<void> updateSection(ClassSection section) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/classes/${section.classId}/"),
    );

    final Map<String, dynamic> cls = json.decode(response.body);
    final List sections = cls['sections'] ?? [];

    for (final s in sections) {
      if (s['section'] == section.sectionName) {
        s['current_students'] = section.currentStudents;
      }
    }

    await http.put(
      Uri.parse("$_baseUrl/classes/${section.classId}/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": cls['name'],
        "room": cls['room'],
        "teachers": cls['teachers'].map((t) => t['id']).toList(),
        "sections": sections,
      }),
    );
  }

  static Future<void> deleteSection(ClassSection section) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/classes/${section.classId}/"),
    );

    final Map<String, dynamic> cls = json.decode(response.body);
    final List sections = cls['sections'] ?? [];

    sections.removeWhere((s) => s['section'] == section.sectionName);

    await http.put(
      Uri.parse("$_baseUrl/classes/${section.classId}/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": cls['name'],
        "room": cls['room'],
        "teachers": cls['teachers'].map((t) => t['id']).toList(),
        "sections": sections,
      }),
    );
  }

  Future<ApiResponse<int>> getEmployeeCount() async {
    return await _makeRequest<int>(
      'GET',
      '/employees/count/',
      fromJson: (data) => data['count'] ?? 0,
    );
  }

  Future<AdminProfile> getAdminProfile() async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'GET',
      '/admins/profile/',
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return AdminProfile.fromJson({
        'name': response.data!['name'],
        'email': response.data!['email'],
        'phone': response.data!['phone'],
        'adminId': 'ADMIN',
        'role': 'System Administrator',
        'designation': 'Administrator',
        'experience': 'â€”',
        'qualification': 'â€”',
        'address': 'â€”',
        'joinDate': 'â€”',
        'permissions': [],
        'managedSections': [],
        'totalUsers': 0,
        'activeStudents': 0,
        'totalFaculty': 0,
        'totalStaff': 0,
        'systemUptime': '100%',
        'profileImageUrl': '',
      });
    }

    throw Exception('Failed to load admin profile');
  }

  Future<bool> updateAdminProfile(AdminProfile profile) async {
    final response = await _makeRequest(
      'PUT',
      '/admins/profile/',
      body: {
        'name': profile.name,
        'email': profile.email,  // Use ademail field for backend
        'phone': profile.phone,
        'address': profile.address,
        'qualification': profile.qualification,
      },
    );

    return response.success;
  }

  static Future<List<UserRequest>> fetchUserRequests() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/user-requests/'),
      headers: {'Content-Type': 'application/json'},
    );
    print("STATUS: ${response.statusCode == 200}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      print("Status--------------");
      final List data = json.decode(response.body);
      return data.map((e) => UserRequest.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user requests');
    }
  }

  static Future<void> approveUser(int userId) async {
    await http.post(
      Uri.parse('$_baseUrl/users/approve-user/$userId/'),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<void> declineUser(int userId) async {
    await http.post(
      Uri.parse('$_baseUrl/users/decline-user/$userId/'),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<void> modifyUserRole(int userId, String role) async {
    await http.post(
      Uri.parse('$_baseUrl/users/modify-user/$userId/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': role}),
    );
  }

  Future<bool> createDesignation({
    required String title,
    String? description,
    bool isActive = true,
  }) async {
    final response = await _makeRequest(
      'POST',
      '/teachers/designation/',
      body: {'title': title, 'description': description, 'is_active': isActive},
    );

    return response.success;
  }

  // Fetch all subjects (legacy - returns ApiResponse wrapper)
  // Note: Use getSubjects() from Academic Management section instead
  Future<ApiResponse<List<Map<String, dynamic>>>> getSubjectsWithResponse() async {
    return await getList('/subjects/', (data) => data);
  }

  // Fetch all designations
  Future<ApiResponse<List<Map<String, dynamic>>>> getDesignations() async {
    return await getList('/teachers/designations/', (data) => data);
  }

  // ==================== NOTIFICATIONS ====================
  
  // Get all notifications (for admin - fetch without auth to get all)
  Future<ApiResponse<List<Map<String, dynamic>>>> getNotifications() async {
    try {
      // For admin users, make request without auth to get ALL notifications
      final prefs = await SharedPreferences.getInstance();
      final userRole = prefs.getString('user_role');
      
      if (userRole == 'admin' || userRole == 'Admin') {
        // Make request without authentication to bypass user filtering
        return await _makeRequest<List<Map<String, dynamic>>>(
          'GET',
          '/notifications/',
          includeAuth: false,
          fromJson: (data) {
            if (data is List) {
              return data.cast<Map<String, dynamic>>();
            }
            throw Exception('Unexpected response format');
          },
        );
      }
      
      // For non-admin users, use normal authenticated request
      return await getList('/notifications/', (data) => data);
    } catch (e) {
      return ApiResponse.error('Failed to fetch notifications: $e');
    }
  }

  // Get unread notifications count
  // Get unread notifications count
  Future<ApiResponse<int>> getUnreadNotificationsCount() async {
    try {
      // For admin users, make request without auth to get ALL notifications
      final prefs = await SharedPreferences.getInstance();
      final userRole = prefs.getString('user_role');
      
      final includeAuth = !(userRole == 'admin' || userRole == 'Admin');
      
      final response = await _makeRequest('GET', '/notifications/', includeAuth: includeAuth);
      if (response.success && response.data != null) {
        final List notifications = response.data;
        final unreadCount = notifications.where((n) => n['is_read'] == false).length;
        return ApiResponse.success(unreadCount);
      }
      return ApiResponse.error(response.message ?? 'Failed to get notifications');
    } catch (e) {
      return ApiResponse.error('Failed to get notification count: $e');
    }
  }

  // Create/Send a new notification
  Future<ApiResponse<Map<String, dynamic>>> createNotification({
    required String recipient,
    required String title,
    required String message,
    required String notificationType,
  }) async {
    return await _makeRequest(
      'POST',
      '/notifications/',
      body: {
        'recipient': recipient,
        'title': title,
        'message': message,
        'notification_type': notificationType,
        'is_read': false,
      },
    );
  }

  // Mark notification as read
  Future<ApiResponse<Map<String, dynamic>>> markNotificationAsRead(int notificationId) async {
    return await _makeRequest(
      'PATCH',
      '/notifications/$notificationId/',
      body: {'is_read': true},
    );
  }

  // Delete a notification
  Future<ApiResponse<void>> deleteNotification(int notificationId) async {
    final response = await _makeRequest('DELETE', '/notifications/$notificationId/');
    return ApiResponse(
      success: response.success,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  // Get notifications for current user
  Future<ApiResponse<List<Map<String, dynamic>>>> getUserNotifications() async {
    return await getList('/notifications/', (data) => data);
  }

  // ========================== Facilities Management ==========================

  // Get all facilities
  Future<ApiResponse<List<Map<String, dynamic>>>> getFacilities() async {
    return await getList('/facilities/', (data) => data);
  }

  // Create a new facility
  Future<ApiResponse<Map<String, dynamic>>> createFacility({
    required String name,
    required String description,
    required double monthlyFee,
    bool isActive = true,
  }) async {
    return await _makeRequest(
      'POST',
      '/facilities/',
      body: {
        'name': name,
        'description': description,
        'monthly_fee': monthlyFee,
        'is_active': isActive,
      },
    );
  }

  // Update an existing facility
  Future<ApiResponse<Map<String, dynamic>>> updateFacility({
    required int facilityId,
    required String name,
    required String description,
    required double monthlyFee,
    required bool isActive,
  }) async {
    return await _makeRequest(
      'PUT',
      '/facilities/$facilityId/',
      body: {
        'name': name,
        'description': description,
        'monthly_fee': monthlyFee,
        'is_active': isActive,
      },
    );
  }

  // Delete a facility
  Future<ApiResponse<void>> deleteFacility(int facilityId) async {
    final response = await _makeRequest('DELETE', '/facilities/$facilityId/');
    return ApiResponse(
      success: response.success,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  // ========== ACADEMIC MANAGEMENT API METHODS ==========

  // Get Academic Dashboard Stats
  Future<Map<String, dynamic>> getAcademicDashboardStats() async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'GET',
      '/academics/dashboard/',
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load academic dashboard stats');
  }

  // ========== HOUSE GROUPS ==========

  // Get all house groups
  Future<List<Map<String, dynamic>>> getHouseGroups() async {
    final response = await _makeRequest<List<dynamic>>(
      'GET',
      '/academics/houses/',
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.data != null) {
      return response.data!.map((e) => e as Map<String, dynamic>).toList();
    }

    throw Exception(response.message ?? 'Failed to load house groups');
  }

  // Create a house group
  Future<Map<String, dynamic>> createHouseGroup({
    required String houseName,
    required String houseColor,
    String? houseCaptain,
    String? viceCaptain,
    String? houseMotto,
    bool isActive = true,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/academics/houses/',
      body: {
        'house_name': houseName,
        'house_color': houseColor,
        'house_captain': houseCaptain,
        'vice_captain': viceCaptain,
        'house_motto': houseMotto,
        'is_active': isActive,
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create house group');
  }

  // Update a house group
  Future<Map<String, dynamic>> updateHouseGroup({
    required int houseId,
    required String houseName,
    required String houseColor,
    String? houseCaptain,
    String? viceCaptain,
    String? houseMotto,
    bool isActive = true,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'PUT',
      '/academics/houses/$houseId/',
      body: {
        'house_name': houseName,
        'house_color': houseColor,
        'house_captain': houseCaptain,
        'vice_captain': viceCaptain,
        'house_motto': houseMotto,
        'is_active': isActive,
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to update house group');
  }

  // Delete a house group
  Future<bool> deleteHouseGroup(int houseId) async {
    final response = await _makeRequest(
      'DELETE',
      '/academics/houses/$houseId/',
    );

    return response.success;
  }

  // ========== SPORTS GROUPS ==========

  // Get all sports groups
  Future<List<Map<String, dynamic>>> getSportsGroups() async {
    final response = await _makeRequest<List<dynamic>>(
      'GET',
      '/academics/sports/',
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.data != null) {
      return response.data!.map((e) => e as Map<String, dynamic>).toList();
    }

    throw Exception(response.message ?? 'Failed to load sports groups');
  }

  // Create a sports group
  Future<Map<String, dynamic>> createSportsGroup({
    required String groupName,
    String? sportType,
    String? coachName,
    int? maxMembers,
    bool isActive = true,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/academics/sports/',
      body: {
        'group_name': groupName,
        'sport_type': sportType,
        'coach_name': coachName,
        'max_members': maxMembers,
        'is_active': isActive,
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create sports group');
  }

  // Update a sports group
  Future<Map<String, dynamic>> updateSportsGroup({
    required int sportId,
    required String groupName,
    String? sportType,
    String? coachName,
    int? maxMembers,
    bool isActive = true,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'PUT',
      '/academics/sports/$sportId/',
      body: {
        'group_name': groupName,
        'sport_type': sportType,
        'coach_name': coachName,
        'max_members': maxMembers,
        'is_active': isActive,
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to update sports group');
  }

  // Delete a sports group
  Future<bool> deleteSportsGroup(int sportId) async {
    final response = await _makeRequest(
      'DELETE',
      '/academics/sports/$sportId/',
    );

    return response.success;
  }

  // ========== SUBJECTS ==========

  // Get all subjects
  Future<List<Map<String, dynamic>>> getSubjects() async {
    final response = await _makeRequest<List<dynamic>>(
      'GET',
      '/academics/subjects/',
      fromJson: (data) => data as List<dynamic>,
    );

    if (response.success && response.data != null) {
      return response.data!.map((e) => e as Map<String, dynamic>).toList();
    }

    throw Exception(response.message ?? 'Failed to load subjects');
  }

  // Create a subject
  Future<Map<String, dynamic>> createSubject({
    required String name,
    required String code,
    String? description,
    List<String>? classNames,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/academics/subjects/',
      body: {
        'name': name,
        'code': code,
        'description': description ?? '',
        'class_name': classNames ?? [],
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create subject');
  }

  // Get subject details by ID
  Future<Map<String, dynamic>> getSubjectById(int subjectId) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'GET',
      '/academics/subjects/$subjectId/',
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load subject details');
  }

  // Update a subject
  Future<Map<String, dynamic>> updateSubject({
    required int subjectId,
    required String name,
    required String code,
    String? description,
    List<String>? classNames,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'PUT',
      '/academics/subjects/$subjectId/',
      body: {
        'name': name,
        'code': code,
        'description': description ?? '',
        'class_name': classNames ?? [],
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to update subject');
  }

  // Delete a subject
  Future<bool> deleteSubject(int subjectId) async {
    final response = await _makeRequest(
      'DELETE',
      '/academics/subjects/$subjectId/',
    );

    return response.success;
  }

  // ========== CLASSES ==========

  // Create an academic class with full details
  Future<Map<String, dynamic>> createAcademicClass({
    required String className,
    required String section,
    int? capacity,
    String? classTeacher,
  }) async {
    final response = await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/academics/classes/create/',
      body: {
        'class_name': className,
        'section': section,
        'capacity': capacity,
        'class_teacher': classTeacher,
      },
      fromJson: (data) => data,
    );

    if (response.success && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create class');
  }

  // ==================== ATTENDANCE MANAGEMENT ====================

  // ========== STUDENT ATTENDANCE ==========

  /// Mark student attendance
  /// POST: /api/attendence/students/mark/
  Future<ApiResponse<Map<String, dynamic>>> markStudentAttendance({
    required String date,
    required String status, // "present" | "absent" | "leave"
    required int studentId,
    required int schoolClassId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/students/mark/',
      body: {
        'date': date,
        'status': status,
        'student': studentId,
        'school_class': schoolClassId,
      },
    );
  }

  // ========== TEACHER ATTENDANCE ==========

  /// Teacher check-in
  /// POST: /api/attendence/teacher/check-in/
  Future<ApiResponse<Map<String, dynamic>>> teacherCheckIn({
    required String date,
    required String status,
    required String checkInTime,
    String? checkOutTime,
    String reason = "",
    required int teacherId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/teacher/check-in/',
      body: {
        'date': date,
        'status': status,
        'check_in_time': checkInTime,
        'check_out_time': checkOutTime,
        'reason': reason,
        'teacher': teacherId,
      },
    );
  }

  /// Teacher check-out
  /// POST: /api/attendence/teacher/check-out/
  Future<ApiResponse<Map<String, dynamic>>> teacherCheckOut({
    required String date,
    required String status,
    required String checkInTime,
    required String checkOutTime,
    String reason = "",
    required int teacherId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/teacher/check-out/',
      body: {
        'date': date,
        'status': status,
        'check_in_time': checkInTime,
        'check_out_time': checkOutTime,
        'reason': reason,
        'teacher': teacherId,
      },
    );
  }

  /// Apply leave for teacher
  /// POST: /api/attendence/leave/apply/teacher/
  Future<ApiResponse<Map<String, dynamic>>> applyTeacherLeave({
    required String leaveType, // "sick" | "casual" | "earned"
    required String fromDate,
    required String toDate,
    required String reason,
    bool approved = false,
    required int teacherId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/leave/apply/teacher/',
      body: {
        'leave_type': leaveType,
        'from_date': fromDate,
        'to_date': toDate,
        'reason': reason,
        'approved': approved,
        'teacher': teacherId,
      },
    );
  }

  // ========== EMPLOYEE ATTENDANCE ==========

  /// Employee check-in
  /// POST: /api/attendence/employee/check-in/
  Future<ApiResponse<Map<String, dynamic>>> employeeCheckIn({
    required String date,
    required String status,
    required String checkInTime,
    String? checkOutTime,
    String reason = "",
    required int employeeId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/employee/check-in/',
      body: {
        'date': date,
        'status': status,
        'check_in_time': checkInTime,
        'check_out_time': checkOutTime,
        'reason': reason,
        'employee': employeeId,
      },
    );
  }

  /// Employee check-out
  /// POST: /api/attendence/employee/check-out/
  Future<ApiResponse<Map<String, dynamic>>> employeeCheckOut({
    required String date,
    required String status,
    required String checkInTime,
    required String checkOutTime,
    String reason = "",
    required int employeeId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/employee/check-out/',
      body: {
        'date': date,
        'status': status,
        'check_in_time': checkInTime,
        'check_out_time': checkOutTime,
        'reason': reason,
        'employee': employeeId,
      },
    );
  }

  /// Apply leave for employee
  /// POST: /api/attendence/leave/apply/employee/
  Future<ApiResponse<Map<String, dynamic>>> applyEmployeeLeave({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
    bool approved = false,
    required int employeeId,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/attendence/leave/apply/employee/',
      body: {
        'leave_type': leaveType,
        'from_date': fromDate,
        'to_date': toDate,
        'reason': reason,
        'approved': approved,
        'employee': employeeId,
      },
    );
  }

  // ========== ATTENDANCE REPORTS (ADMIN) ==========

  /// Get monthly student attendance report
  /// GET: /api/attendence/monthly/report/students/?month=1&year=2024
  Future<ApiResponse<List<Map<String, dynamic>>>> getStudentMonthlyReport({
    required int month,
    required int year,
  }) async {
    return await getList<Map<String, dynamic>>(
      '/attendence/monthly/report/students/',
      (data) => data,
      queryParams: {
        'month': month.toString(),
        'year': year.toString(),
      },
    );
  }

  /// Get monthly teacher attendance report
  /// GET: /api/attendence/monthly/report/teachers/?month=1&year=2024
  Future<ApiResponse<List<Map<String, dynamic>>>> getTeacherMonthlyReport({
    required int month,
    required int year,
  }) async {
    return await getList<Map<String, dynamic>>(
      '/attendence/monthly/report/teachers/',
      (data) => data,
      queryParams: {
        'month': month.toString(),
        'year': year.toString(),
      },
    );
  }

  // ========== UTILITY METHODS FOR ATTENDANCE ==========

  /// Format date to backend format (YYYY-MM-DD)
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Format time to backend format (HH:MM:SS)
  static String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  /// Get current date in backend format
  static String getCurrentDate() {
    return formatDate(DateTime.now());
  }

  /// Get current time in backend format
  static String getCurrentTime() {
    return formatTime(DateTime.now());
  }

  // ========== SYSTEM CONTROL - LOGIN HISTORY ==========

  /// Get all login history
  /// GET: /api/system/login-history/
  Future<ApiResponse<List<Map<String, dynamic>>>> getAllLoginHistory() async {
    return await getList<Map<String, dynamic>>(
      '/system/login-history/',
      (data) => data,
    );
  }

  /// Get login history for specific user
  /// GET: /api/system/login-history/<user_id>/
  Future<ApiResponse<List<Map<String, dynamic>>>> getUserLoginHistory(int userId) async {
    return await getList<Map<String, dynamic>>(
      '/system/login-history/$userId/',
      (data) => data,
    );
  }

  // ========== SYSTEM CONTROL - ANNOUNCEMENTS ==========

  /// Get all announcements
  /// GET: /api/system/announcements/
  Future<ApiResponse<List<Map<String, dynamic>>>> getAllAnnouncements() async {
    return await getList<Map<String, dynamic>>(
      '/system/announcements/',
      (data) => data,
    );
  }

  /// Get specific announcement by ID
  /// GET: /api/system/announcements/<pk>/
  Future<ApiResponse<Map<String, dynamic>>> getAnnouncement(int id) async {
    return await _makeRequest<Map<String, dynamic>>(
      'GET',
      '/system/announcements/$id/',
      fromJson: (data) => data,
    );
  }

  /// Create new announcement
  /// POST: /api/system/announcements/
  Future<ApiResponse<Map<String, dynamic>>> createAnnouncement({
    required String title,
    required String message,
    int? createdBy,
    required bool isActive,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/system/announcements/',
      body: {
        'title': title,
        'message': message,
        'created_by': createdBy,
        'is_active': isActive,
      },
      fromJson: (data) => data,
    );
  }

  /// Update announcement
  /// PUT: /api/system/announcements/<pk>/
  Future<ApiResponse<Map<String, dynamic>>> updateAnnouncement({
    required int id,
    required String title,
    required String message,
    int? createdBy,
    required bool isActive,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'PUT',
      '/system/announcements/$id/',
      body: {
        'title': title,
        'message': message,
        'created_by': createdBy,
        'is_active': isActive,
      },
      fromJson: (data) => data,
    );
  }

  /// Delete announcement
  /// DELETE: /api/system/announcements/<pk>/
  Future<ApiResponse<void>> deleteAnnouncement(int id) async {
    return await _makeRequest<void>(
      'DELETE',
      '/system/announcements/$id/',
    );
  }

  // ========== SYSTEM CONTROL - SETTINGS ==========

  /// Get system settings (returns list, we take first item)
  /// GET: /api/system/settings/
  Future<ApiResponse<Map<String, dynamic>?>> getSystemSettings() async {
    try {
      final response = await getList<Map<String, dynamic>>(
        '/system/settings/',
        (data) => data,
      );
      
      if (response.success && response.data != null && response.data!.isNotEmpty) {
        return ApiResponse.success(response.data!.first);
      } else if (response.success && response.data != null && response.data!.isEmpty) {
        // Empty list is valid - just no settings configured yet
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to load settings', statusCode: response.statusCode);
      }
    } catch (e) {
      print('Error in getSystemSettings: $e');
      return ApiResponse.error('Error loading settings: $e');
    }
  }

  /// Get specific system setting by ID
  /// GET: /api/system/settings/<pk>/
  Future<ApiResponse<Map<String, dynamic>>> getSystemSetting(int id) async {
    return await _makeRequest<Map<String, dynamic>>(
      'GET',
      '/system/settings/$id/',
      fromJson: (data) => data,
    );
  }

  /// Update system settings
  /// PUT: /api/system/settings/<pk>/
  Future<ApiResponse<Map<String, dynamic>>> updateSystemSettings({
    required int id,
    required bool enableNotifications,
    required String schoolClassName,
    int? capacityPerClass,
    required String currentAcademicYear,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'PUT',
      '/system/settings/$id/',
      body: {
        'enable_notifications': enableNotifications,
        'school_class_name': schoolClassName,
        'capacity_per_class': capacityPerClass,
        'current_academic_year': currentAcademicYear,
      },
      fromJson: (data) => data,
    );
  }

  /// Create system settings (POST)
  /// POST: /api/system/settings/
  Future<ApiResponse<Map<String, dynamic>>> createSystemSettings({
    required bool enableNotifications,
    required String schoolClassName,
    int? capacityPerClass,
    required String currentAcademicYear,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/system/settings/',
      body: {
        'enable_notifications': enableNotifications,
        'school_class_name': schoolClassName,
        'capacity_per_class': capacityPerClass,
        'current_academic_year': currentAcademicYear,
      },
      fromJson: (data) => data,
    );
  }

  // ==================== REPORTS API ====================

  /// Fetch Overview Report
  /// GET /api/reports/overview/
  Future<OverviewReport> fetchOverviewReport() async {
    try {
      final response = await _makeRequest<Map<String, dynamic>>(
        'GET',
        '/reports/overview/',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        return OverviewReport.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to load overview report');
      }
    } catch (e) {
      print('Error fetching overview report: $e');
      throw Exception('Error fetching overview report: $e');
    }
  }

  /// Fetch Academic Report
  /// GET /api/reports/academic/
  Future<AcademicReport> fetchAcademicReport() async {
    try {
      final response = await _makeRequest<Map<String, dynamic>>(
        'GET',
        '/reports/academic/',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        return AcademicReport.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to load academic report');
      }
    } catch (e) {
      print('Error fetching academic report: $e');
      throw Exception('Error fetching academic report: $e');
    }
  }

  /// Fetch Financial Report
  /// GET /api/reports/financial/
  Future<FinancialReport> fetchFinancialReport() async {
    try {
      final response = await _makeRequest<Map<String, dynamic>>(
        'GET',
        '/reports/financial/',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        return FinancialReport.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to load financial report');
      }
    } catch (e) {
      print('Error fetching financial report: $e');
      throw Exception('Error fetching financial report: $e');
    }
  }

  /// Fetch Enrollment Report
  /// GET /api/reports/enrollment/
  Future<EnrollmentReport> fetchEnrollmentReport() async {
    try {
      final response = await _makeRequest<Map<String, dynamic>>(
        'GET',
        '/reports/enrollment/',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        return EnrollmentReport.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to load enrollment report');
      }
    } catch (e) {
      print('Error fetching enrollment report: $e');
      throw Exception('Error fetching enrollment report: $e');
    }
  }

  /// Fetch Teachers Report
  /// GET /api/reports/teachers/
  Future<TeachersReport> fetchTeachersReport() async {
    try {
      final response = await _makeRequest<Map<String, dynamic>>(
        'GET',
        '/reports/teachers/',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        return TeachersReport.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Failed to load teachers report');
      }
    } catch (e) {
      print('Error fetching teachers report: $e');
      throw Exception('Error fetching teachers report: $e');
    }
  }
  // ========== PARENT API ==========

  /// Get Children List
  /// GET: /api/parents/children/
  Future<ApiResponse<List<Map<String, dynamic>>>> getParentChildren() async {
    return await getList<Map<String, dynamic>>(
      '/parents/children/',
          (data) => data as Map<String, dynamic>,
    );
  }

  /// Get Single Child Detail
  /// GET: /api/parents/child/
  Future<ApiResponse<Map<String, dynamic>>> getParentChild() async {
    return await getItem<Map<String, dynamic>>(
      '/parents/child/',
          (data) => data,
    );
  }
}

