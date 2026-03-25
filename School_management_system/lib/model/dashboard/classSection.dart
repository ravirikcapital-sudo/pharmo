class ClassSection {
  final String id;
  final String classId;
  final String className;
  final String sectionName;
  final String fullName;
  final String room;
  final int currentStudents;
  final int maxStudents;
  final String? classTeacherId;
  final List<String> subjectTeacherIds;
  final bool isActive;

  ClassSection({
    required this.id,
    required this.classId,
    required this.className,
    required this.sectionName,
    required this.fullName,
    required this.room,
    required this.currentStudents,
    required this.classTeacherId,
    required this.subjectTeacherIds,
    this.maxStudents = 35,
    this.isActive = true,
  });

  /// CREATE FLAT SECTIONS FROM CLASS API
  static List<ClassSection> fromApiList(List data) {
    final List<ClassSection> result = [];

    for (final cls in data) {
      final String classId = cls['id'].toString();
      final String className = cls['name'] ?? '';
      final String room = cls['room'] ?? '';
      final List teachers = cls['teachers'] ?? [];
      final List sections = cls['sections'] ?? [];

      for (final sec in sections) {
        final String sectionName = sec['section'] ?? '';

        result.add(
          ClassSection(
            id: "${classId}_$sectionName",
            classId: classId,
            className: className,
            sectionName: sectionName,
            fullName: "$className - $sectionName",
            room: room,
            currentStudents: sec['current_students'] ?? 0,
            classTeacherId:
                teachers.isNotEmpty ? teachers.first['id']?.toString() : null,
            subjectTeacherIds:
                teachers.map((t) => t['id'].toString()).toList(),
          ),
        );
      }
    }
    return result;
  }

  /// USED WHEN UPDATING CLASS
  Map<String, dynamic> toSectionJson() {
    return {
      "section": sectionName,
      "current_students": currentStudents,
    };
  }

  ClassSection copyWith({
    String? id,
    String? classId,
    String? className,
    String? sectionName,
    String? fullName,
    String? room,
    int? currentStudents,
    int? maxStudents,
    String? classTeacherId,
    List<String>? subjectTeacherIds,
    bool? isActive,
  }) {
    return ClassSection(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      sectionName: sectionName ?? this.sectionName,
      fullName: fullName ?? this.fullName,
      room: room ?? this.room,
      currentStudents: currentStudents ?? this.currentStudents,
      maxStudents: maxStudents ?? this.maxStudents,
      classTeacherId: classTeacherId ?? this.classTeacherId,
      subjectTeacherIds: subjectTeacherIds ?? this.subjectTeacherIds,
      isActive: isActive ?? this.isActive,
    );
  }
}
