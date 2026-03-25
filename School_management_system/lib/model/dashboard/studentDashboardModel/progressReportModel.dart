
// Data Models
class SemesterResult {
  final String semester;
  final List<SubjectResult> subjects;
  final double overallGPA;
  final double percentage;
  final int rank;
  final int totalStudents;

  SemesterResult({
    required this.semester,
    required this.subjects,
    required this.overallGPA,
    required this.percentage,
    required this.rank,
    required this.totalStudents,
  });
}

class SubjectResult {
  final String name;
  final int marks;
  final String grade;
  final double gpa;

  SubjectResult(this.name, this.marks, this.grade, this.gpa);
}