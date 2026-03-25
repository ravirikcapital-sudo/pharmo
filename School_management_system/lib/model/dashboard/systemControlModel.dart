// User Role Model (For display purposes)
class UserRole1 {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final DateTime lastLogin;

  UserRole1({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.lastLogin,
  });
}

// Login History Model (API)
class LoginHistory {
  final int id;
  final int user;
  final String userName;
  final String email;
  final String role;
  final DateTime loggedInAt;

  LoginHistory({
    required this.id,
    required this.user,
    required this.userName,
    required this.email,
    required this.role,
    required this.loggedInAt,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      id: json['id'],
      user: json['user'],
      userName: json['user_name'],
      email: json['email'],
      role: json['role'],
      loggedInAt: DateTime.parse(json['logged_in_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'user_name': userName,
      'email': email,
      'role': role,
      'logged_in_at': loggedInAt.toIso8601String(),
    };
  }
}

// Announcement Model (API)
class Announcement {
  final int? id;
  final String title;
  final String message;
  final int? createdBy;
  final bool isActive;
  final DateTime? createdDate;

  Announcement({
    this.id,
    required this.title,
    required this.message,
    this.createdBy,
    required this.isActive,
    this.createdDate,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdBy: json['created_by'],
      isActive: json['is_active'] ?? false,
      createdDate: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'message': message,
      'created_by': createdBy,
      'is_active': isActive,
      if (createdDate != null) 'created_at': createdDate!.toIso8601String(),
    };
  }
}

// System Setting Model (API)
class SystemSetting {
  final int? id;
  final bool enableNotifications;
  final String schoolClassName;
  final int? capacityPerClass;
  final String currentAcademicYear;
  final DateTime? updatedAt;

  SystemSetting({
    this.id,
    required this.enableNotifications,
    required this.schoolClassName,
    this.capacityPerClass,
    required this.currentAcademicYear,
    this.updatedAt,
  });

  factory SystemSetting.fromJson(Map<String, dynamic> json) {
    return SystemSetting(
      id: json['id'],
      enableNotifications: json['enable_notifications'] ?? false,
      schoolClassName: json['school_class_name'] ?? '',
      capacityPerClass: json['capacity_per_class'],
      currentAcademicYear: json['current_academic_year'] ?? '',
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'enable_notifications': enableNotifications,
      'school_class_name': schoolClassName,
      'capacity_per_class': capacityPerClass,
      'current_academic_year': currentAcademicYear,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
