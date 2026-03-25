class TeacherProfile {
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
  final List<String> subjects;
  final List<String> classes;
  final int totalStudents;
  final int completedLessons;
  final double attendanceRate;
  final String profileImageUrl;

  TeacherProfile({
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
    required this.subjects,
    required this.classes,
    required this.totalStudents,
    required this.completedLessons,
    required this.attendanceRate,
    required this.profileImageUrl,
  });
}

