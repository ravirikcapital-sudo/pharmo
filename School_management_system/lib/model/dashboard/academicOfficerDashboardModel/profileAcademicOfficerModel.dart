class AcademicOfficerProfile {
  final String name;
  final String email;
  final String phone;
  final String employeeId;
  final String department;
  final String designation;
  final String experience;
  final String qualification;
  final String address;
  final String joinDate;
  final List<String> responsibilities;
  final List<String> managedDepartments;
  final int totalFaculty;
  final int activeCourses;
  final int completedProjects;
  final String profileImageUrl;

  AcademicOfficerProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.employeeId,
    required this.department,
    required this.designation,
    required this.experience,
    required this.qualification,
    required this.address,
    required this.joinDate,
    required this.responsibilities,
    required this.managedDepartments,
    required this.totalFaculty,
    required this.activeCourses,
    required this.completedProjects,
    required this.profileImageUrl,
  });

  // Factory constructor for creating from JSON
  factory AcademicOfficerProfile.fromJson(Map<String, dynamic> json) {
    return AcademicOfficerProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      employeeId: json['employeeId'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      experience: json['experience'] ?? '',
      qualification: json['qualification'] ?? '',
      address: json['address'] ?? '',
      joinDate: json['joinDate'] ?? '',
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      managedDepartments: List<String>.from(json['managedDepartments'] ?? []),
      totalFaculty: json['totalFaculty'] ?? 0,
      activeCourses: json['activeCourses'] ?? 0,
      completedProjects: json['completedProjects'] ?? 0,
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'employeeId': employeeId,
      'department': department,
      'designation': designation,
      'experience': experience,
      'qualification': qualification,
      'address': address,
      'joinDate': joinDate,
      'responsibilities': responsibilities,
      'managedDepartments': managedDepartments,
      'totalFaculty': totalFaculty,
      'activeCourses': activeCourses,
      'completedProjects': completedProjects,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Method to create a copy with updated values
  AcademicOfficerProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? employeeId,
    String? department,
    String? designation,
    String? experience,
    String? qualification,
    String? address,
    String? joinDate,
    List<String>? responsibilities,
    List<String>? managedDepartments,
    int? totalFaculty,
    int? activeCourses,
    int? completedProjects,
    String? profileImageUrl,
  }) {
    return AcademicOfficerProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      address: address ?? this.address,
      joinDate: joinDate ?? this.joinDate,
      responsibilities: responsibilities ?? this.responsibilities,
      managedDepartments: managedDepartments ?? this.managedDepartments,
      totalFaculty: totalFaculty ?? this.totalFaculty,
      activeCourses: activeCourses ?? this.activeCourses,
      completedProjects: completedProjects ?? this.completedProjects,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  String toString() {
    return 'AcademicOfficerProfile(name: $name, email: $email, designation: $designation, department: $department)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AcademicOfficerProfile &&
        other.name == name &&
        other.email == email &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ employeeId.hashCode;
  }
}