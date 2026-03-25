// File: lib/model/dashboard/studentProfile.dart

class StudentProfile {
  final String name;
  final String email;
  final String phone;
  final String studentId;
  final String rollNumber;
  final String className;
  final String section;
  final String academicYear;
  final String dateOfBirth;
  final String address;
  final String admissionDate;
  final String parentName;
  final String parentPhone;
  final String emergencyContact;
  final String bloodGroup;
  final String religion;
  final String category;
  final List<String> subjects;
  final String currentGrade;
  final double overallPercentage;
  final double attendance;
  final int totalSubjects;
  final int completedAssignments;
  final int pendingAssignments;
  final String profileImageUrl;

  StudentProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.studentId,
    required this.rollNumber,
    required this.className,
    required this.section,
    required this.academicYear,
    required this.dateOfBirth,
    required this.address,
    required this.admissionDate,
    required this.parentName,
    required this.parentPhone,
    required this.emergencyContact,
    required this.bloodGroup,
    required this.religion,
    required this.category,
    required this.subjects,
    required this.currentGrade,
    required this.overallPercentage,
    required this.attendance,
    required this.totalSubjects,
    required this.completedAssignments,
    required this.pendingAssignments,
    required this.profileImageUrl,
  });

  // Copy constructor for updating profile
  StudentProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? studentId,
    String? rollNumber,
    String? className,
    String? section,
    String? academicYear,
    String? dateOfBirth,
    String? address,
    String? admissionDate,
    String? parentName,
    String? parentPhone,
    String? emergencyContact,
    String? bloodGroup,
    String? religion,
    String? category,
    List<String>? subjects,
    String? currentGrade,
    double? overallPercentage,
    double? attendance,
    int? totalSubjects,
    int? completedAssignments,
    int? pendingAssignments,
    String? profileImageUrl,
  }) {
    return StudentProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      studentId: studentId ?? this.studentId,
      rollNumber: rollNumber ?? this.rollNumber,
      className: className ?? this.className,
      section: section ?? this.section,
      academicYear: academicYear ?? this.academicYear,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      admissionDate: admissionDate ?? this.admissionDate,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      religion: religion ?? this.religion,
      category: category ?? this.category,
      subjects: subjects ?? this.subjects,
      currentGrade: currentGrade ?? this.currentGrade,
      overallPercentage: overallPercentage ?? this.overallPercentage,
      attendance: attendance ?? this.attendance,
      totalSubjects: totalSubjects ?? this.totalSubjects,
      completedAssignments: completedAssignments ?? this.completedAssignments,
      pendingAssignments: pendingAssignments ?? this.pendingAssignments,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'studentId': studentId,
      'rollNumber': rollNumber,
      'className': className,
      'section': section,
      'academicYear': academicYear,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'admissionDate': admissionDate,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'emergencyContact': emergencyContact,
      'bloodGroup': bloodGroup,
      'religion': religion,
      'category': category,
      'subjects': subjects,
      'currentGrade': currentGrade,
      'overallPercentage': overallPercentage,
      'attendance': attendance,
      'totalSubjects': totalSubjects,
      'completedAssignments': completedAssignments,
      'pendingAssignments': pendingAssignments,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Create from JSON
  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      studentId: json['studentId'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      className: json['className'] ?? '',
      section: json['section'] ?? '',
      academicYear: json['academicYear'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      address: json['address'] ?? '',
      admissionDate: json['admissionDate'] ?? '',
      parentName: json['parentName'] ?? '',
      parentPhone: json['parentPhone'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      religion: json['religion'] ?? '',
      category: json['category'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
      currentGrade: json['currentGrade'] ?? '',
      overallPercentage: (json['overallPercentage'] ?? 0.0).toDouble(),
      attendance: (json['attendance'] ?? 0.0).toDouble(),
      totalSubjects: json['totalSubjects'] ?? 0,
      completedAssignments: json['completedAssignments'] ?? 0,
      pendingAssignments: json['pendingAssignments'] ?? 0,
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  @override
  String toString() {
    return 'StudentProfile(name: $name, studentId: $studentId, className: $className, currentGrade: $currentGrade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentProfile &&
        other.name == name &&
        other.studentId == studentId &&
        other.email == email;
  }

  @override
  int get hashCode {
    return name.hashCode ^ studentId.hashCode ^ email.hashCode;
  }
}