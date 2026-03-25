// File: lib/model/dashboard/profileAdminModel.dart

class AdminProfile {
  final String name;
  final String email;
  final String phone;
  final String adminId;
  final String role;
  final String designation;
  final String experience;
  final String qualification;
  final String address;
  final String joinDate;
  final List<String> permissions;
  final List<String> managedSections;
  final int totalUsers;
  final int activeStudents;
  final int totalFaculty;
  final int totalStaff;
  final String systemUptime;
  final String profileImageUrl;

  AdminProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.adminId,
    required this.role,
    required this.designation,
    required this.experience,
    required this.qualification,
    required this.address,
    required this.joinDate,
    required this.permissions,
    required this.managedSections,
    required this.totalUsers,
    required this.activeStudents,
    required this.totalFaculty,
    required this.totalStaff,
    required this.systemUptime,
    required this.profileImageUrl,
  });

  // Factory constructor for creating AdminProfile from JSON
  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      name: json['name'] ?? '',
      email: json['ademail'] ?? json['email'] ?? '',  // Handle both ademail and email fields
      phone: json['phone'] ?? '',
      adminId: (json['adminId'] ?? '').toString(),  // Convert to string if number
      role: json['role'] ?? '',
      designation: json['designation'] ?? '',
      experience: json['experience'] ?? '',
      qualification: json['qualification'] ?? '',
      address: json['address'] ?? '',
      joinDate: json['joinDate'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
      managedSections: List<String>.from(json['managedSections'] ?? []),
      totalUsers: json['totalUsers'] ?? 0,
      activeStudents: json['activeStudents'] ?? 0,
      totalFaculty: json['totalFaculty'] ?? 0,
      totalStaff: json['totalStaff'] ?? 0,
      systemUptime: json['systemUptime'] ?? '0%',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  // Method to convert AdminProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'adminId': adminId,
      'role': role,
      'designation': designation,
      'experience': experience,
      'qualification': qualification,
      'address': address,
      'joinDate': joinDate,
      'permissions': permissions,
      'managedSections': managedSections,
      'totalUsers': totalUsers,
      'activeStudents': activeStudents,
      'totalFaculty': totalFaculty,
      'totalStaff': totalStaff,
      'systemUptime': systemUptime,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Copy with method for creating modified copies
  AdminProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? adminId,
    String? role,
    String? designation,
    String? experience,
    String? qualification,
    String? address,
    String? joinDate,
    List<String>? permissions,
    List<String>? managedSections,
    int? totalUsers,
    int? activeStudents,
    int? totalFaculty,
    int? totalStaff,
    String? systemUptime,
    String? profileImageUrl,
  }) {
    return AdminProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      adminId: adminId ?? this.adminId,
      role: role ?? this.role,
      designation: designation ?? this.designation,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      address: address ?? this.address,
      joinDate: joinDate ?? this.joinDate,
      permissions: permissions ?? this.permissions,
      managedSections: managedSections ?? this.managedSections,
      totalUsers: totalUsers ?? this.totalUsers,
      activeStudents: activeStudents ?? this.activeStudents,
      totalFaculty: totalFaculty ?? this.totalFaculty,
      totalStaff: totalStaff ?? this.totalStaff,
      systemUptime: systemUptime ?? this.systemUptime,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  String toString() {
    return 'AdminProfile(name: $name, email: $email, adminId: $adminId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdminProfile &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.adminId == adminId &&
        other.role == role &&
        other.designation == designation &&
        other.experience == experience &&
        other.qualification == qualification &&
        other.address == address &&
        other.joinDate == joinDate &&
        other.totalUsers == totalUsers &&
        other.activeStudents == activeStudents &&
        other.totalFaculty == totalFaculty &&
        other.totalStaff == totalStaff &&
        other.systemUptime == systemUptime &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    email.hashCode ^
    phone.hashCode ^
    adminId.hashCode ^
    role.hashCode ^
    designation.hashCode ^
    experience.hashCode ^
    qualification.hashCode ^
    address.hashCode ^
    joinDate.hashCode ^
    totalUsers.hashCode ^
    activeStudents.hashCode ^
    totalFaculty.hashCode ^
    totalStaff.hashCode ^
    systemUptime.hashCode ^
    profileImageUrl.hashCode;
  }
}


