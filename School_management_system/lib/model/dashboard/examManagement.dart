// Models
class ExamSession {
  final String id;
  final String name;
  final String className;
  final String subject;
  final DateTime deadline;
  final bool isLocked;
  final int totalStudents;
  final int marksEntered;
  final DateTime createdAt;

  ExamSession({
    required this.id,
    required this.name,
    required this.className,
    required this.subject,
    required this.deadline,
    this.isLocked = false,
    this.totalStudents = 0,
    this.marksEntered = 0,
    required this.createdAt,
  });

  ExamSession copyWith({
    String? id,
    String? name,
    String? className,
    String? subject,
    DateTime? deadline,
    bool? isLocked,
    int? totalStudents,
    int? marksEntered,
    DateTime? createdAt,
  }) {
    return ExamSession(
      id: id ?? this.id,
      name: name ?? this.name,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      deadline: deadline ?? this.deadline,
      isLocked: isLocked ?? this.isLocked,
      totalStudents: totalStudents ?? this.totalStudents,
      marksEntered: marksEntered ?? this.marksEntered,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get completionPercentage {
    if (totalStudents == 0) return 0.0;
    return (marksEntered / totalStudents) * 100;
  }

  bool get isOverdue {
    return DateTime.now().isAfter(deadline) && !isLocked;
  }
}
