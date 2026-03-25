class ClassInfo {
  final int id;
  final String code;
  final String name;
  final String teacher;
  final int totalStudents;

  ClassInfo({
    required this.id,
    required this.code,
    required this.name,
    required this.teacher,
    required this.totalStudents,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      teacher: json['teacher_name'] ?? 'Not Assigned',
      totalStudents: json['total_students'] ?? 0,
    );
  }
}
