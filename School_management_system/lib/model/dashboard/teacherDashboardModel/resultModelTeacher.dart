import 'dart:math';

class Subject {
  final String id;
  final String name;
  final String code;
  final int maxMarks;
  final int passingMarks;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.maxMarks,
    required this.passingMarks,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      maxMarks: json['maxMarks'],
      passingMarks: json['passingMarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'maxMarks': maxMarks,
      'passingMarks': passingMarks,
    };
  }
}

class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String className;
  final String? imageUrl;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
    this.imageUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      rollNumber: json['rollNumber'],
      className: json['className'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rollNumber': rollNumber,
      'className': className,
      'imageUrl': imageUrl,
    };
  }
}

class ExamResult {
  final String id;
  final String studentId;
  final String subjectId;
  final String examId;
  final double marksObtained;
  final double maxMarks;
  final String grade;
  final String? remarks;
  final DateTime dateEntered;
  final String enteredBy;

  ExamResult({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.examId,
    required this.marksObtained,
    required this.maxMarks,
    required this.grade,
    this.remarks,
    required this.dateEntered,
    required this.enteredBy,
  });

  double get percentage => (marksObtained / maxMarks) * 100;

  bool get isPassed => marksObtained >= (maxMarks * 0.33); // 33% passing criteria

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'],
      studentId: json['studentId'],
      subjectId: json['subjectId'],
      examId: json['examId'],
      marksObtained: json['marksObtained'].toDouble(),
      maxMarks: json['maxMarks'].toDouble(),
      grade: json['grade'],
      remarks: json['remarks'],
      dateEntered: DateTime.parse(json['dateEntered']),
      enteredBy: json['enteredBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'examId': examId,
      'marksObtained': marksObtained,
      'maxMarks': maxMarks,
      'grade': grade,
      'remarks': remarks,
      'dateEntered': dateEntered.toIso8601String(),
      'enteredBy': enteredBy,
    };
  }
}

class Exam {
  final String id;
  final String name;
  final String type; // 'unit_test', 'mid_term', 'final', 'practical'
  final DateTime examDate;
  final String className;
  final bool isActive;

  Exam({
    required this.id,
    required this.name,
    required this.type,
    required this.examDate,
    required this.className,
    required this.isActive,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      examDate: DateTime.parse(json['examDate']),
      className: json['className'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'examDate': examDate.toIso8601String(),
      'className': className,
      'isActive': isActive,
    };
  }
}

class StudentResultSummary {
  final Student student;
  final List<ExamResult> results;
  final double totalMarksObtained;
  final double totalMaxMarks;
  final double percentage;
  final String overallGrade;
  final int subjectsPassed;
  final int totalSubjects;

  StudentResultSummary({
    required this.student,
    required this.results,
    required this.totalMarksObtained,
    required this.totalMaxMarks,
    required this.percentage,
    required this.overallGrade,
    required this.subjectsPassed,
    required this.totalSubjects,
  });
}

class ResultService {
  static final ResultService _instance = ResultService._internal();
  factory ResultService() => _instance;
  ResultService._internal();

  List<Student> _students = [];
  List<Subject> _subjects = [];
  List<Exam> _exams = [];
  List<ExamResult> _results = [];
  List<String> _classes = []; // Added classes list

  void initializeSampleData() {
    // Initialize classes
    _classes = [
      'Class 10-A',
      'Class 10-B',
      'Class 10-C',
      'Class 11-A',
      'Class 11-B',
      'Class 12-A',
      'Class 12-B',
    ];

    // Initialize subjects
    _subjects = [
      Subject(id: 'sub1', name: 'Mathematics', code: 'MATH', maxMarks: 100, passingMarks: 33),
      Subject(id: 'sub2', name: 'Physics', code: 'PHY', maxMarks: 100, passingMarks: 33),
      Subject(id: 'sub3', name: 'Chemistry', code: 'CHEM', maxMarks: 100, passingMarks: 33),
      Subject(id: 'sub4', name: 'English', code: 'ENG', maxMarks: 100, passingMarks: 33),
      Subject(id: 'sub5', name: 'Biology', code: 'BIO', maxMarks: 100, passingMarks: 33),
    ];

    // Initialize students
    _students = [
      Student(id: 'std1', name: 'Alice Johnson', rollNumber: '001', className: 'Class 10-A'),
      Student(id: 'std2', name: 'Bob Smith', rollNumber: '002', className: 'Class 10-A'),
      Student(id: 'std3', name: 'Charlie Brown', rollNumber: '003', className: 'Class 10-A'),
      Student(id: 'std4', name: 'Diana Prince', rollNumber: '004', className: 'Class 10-A'),
      Student(id: 'std5', name: 'Edward Wilson', rollNumber: '005', className: 'Class 10-A'),
    ];

    // Initialize exams
    _exams = [
      Exam(
        id: 'exam1',
        name: 'Unit Test 1',
        type: 'unit_test',
        examDate: DateTime.now().subtract(const Duration(days: 30)),
        className: 'Class 10-A',
        isActive: true,
      ),
      Exam(
        id: 'exam2',
        name: 'Mid Term Exam',
        type: 'mid_term',
        examDate: DateTime.now().subtract(const Duration(days: 15)),
        className: 'Class 10-A',
        isActive: true,
      ),
      Exam(
        id: 'exam3',
        name: 'Final Exam',
        type: 'final',
        examDate: DateTime.now().add(const Duration(days: 30)),
        className: 'Class 10-A',
        isActive: true,
      ),
    ];

    // Initialize some sample results
    _generateSampleResults();
  }

  void _generateSampleResults() {
    final random = Random();
    for (int i = 0; i < _students.length; i++) {
      final student = _students[i];
      for (final subject in _subjects) {
        // Only generate results for first 3 students for first 3 subjects for exam1
        if (i < 3 && _exams.isNotEmpty && _subjects.indexOf(subject) < 3) {
          final marks = 50 + random.nextInt(40); // Random marks between 50-89
          _results.add(ExamResult(
            id: 'result_${student.id}_${subject.id}_${_exams[0].id}',
            studentId: student.id,
            subjectId: subject.id,
            examId: _exams[0].id,
            marksObtained: marks.toDouble(),
            maxMarks: subject.maxMarks.toDouble(),
            grade: _calculateGrade(marks.toDouble()),
            remarks: marks > 80 ? 'Excellent performance' : marks > 60 ? 'Good work' : 'Needs improvement',
            dateEntered: DateTime.now().subtract(Duration(days: random.nextInt(10))),
            enteredBy: 'Teacher',
          ));
        }
      }
    }
  }

  String _calculateGrade(double marks) {
    if (marks >= 90) return 'A+';
    if (marks >= 80) return 'A';
    if (marks >= 70) return 'B+';
    if (marks >= 60) return 'B';
    if (marks >= 50) return 'C+';
    if (marks >= 40) return 'C';
    if (marks >= 33) return 'D';
    return 'F';
  }

  Future<List<Student>> getStudents() async {
    if (_students.isEmpty) initializeSampleData();
    return _students;
  }

  Future<List<Subject>> getSubjects() async {
    if (_subjects.isEmpty) initializeSampleData();
    return _subjects;
  }

  Future<List<Exam>> getExams() async {
    if (_exams.isEmpty) initializeSampleData();
    return _exams;
  }

  // Added getClasses method
  Future<List<String>> getClasses() async {
    if (_classes.isEmpty) initializeSampleData();
    return _classes;
  }

  Future<List<ExamResult>> getResultsByExam(String examId) async {
    return _results.where((result) => result.examId == examId).toList();
  }

  Future<List<ExamResult>> getResultsByStudent(String studentId) async {
    return _results.where((result) => result.studentId == studentId).toList();
  }

  Future<ExamResult?> getResult(String studentId, String subjectId, String examId) async {
    try {
      return _results.firstWhere(
            (result) => result.studentId == studentId &&
            result.subjectId == subjectId &&
            result.examId == examId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveResult(ExamResult result) async {
    try {
      // Remove existing result if any
      _results.removeWhere((r) =>
      r.studentId == result.studentId &&
          r.subjectId == result.subjectId &&
          r.examId == result.examId);

      // Add new result
      _results.add(result);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteResult(String resultId) async {
    try {
      _results.removeWhere((result) => result.id == resultId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<StudentResultSummary> getStudentSummary(String studentId, String examId) async {
    final student = _students.firstWhere((s) => s.id == studentId);
    final results = _results.where((r) => r.studentId == studentId && r.examId == examId).toList();

    final totalMarksObtained = results.fold(0.0, (sum, result) => sum + result.marksObtained);
    final totalMaxMarks = results.fold(0.0, (sum, result) => sum + result.maxMarks);
    final percentage = totalMaxMarks > 0 ? (totalMarksObtained / totalMaxMarks) * 100 : 0.0;

    final overallGrade = _calculateGrade(percentage);
    final subjectsPassed = results.where((r) => r.isPassed).length;

    return StudentResultSummary(
      student: student,
      results: results,
      totalMarksObtained: totalMarksObtained,
      totalMaxMarks: totalMaxMarks,
      percentage: percentage,
      overallGrade: overallGrade,
      subjectsPassed: subjectsPassed,
      totalSubjects: results.length,
    );
  }

  Map<String, dynamic> getClassStatistics(String examId) {
    final examResults = _results.where((r) => r.examId == examId).toList();
    if (examResults.isEmpty) {
      return {
        'totalStudents': 0,
        'averagePercentage': 0.0,
        'highestMarks': 0.0,
        'lowestMarks': 0.0,
        'passedStudents': 0,
        'failedStudents': 0,
      };
    }

    final studentIds = examResults.map((r) => r.studentId).toSet();
    final percentages = <double>[];

    for (final studentId in studentIds) {
      final studentResults = examResults.where((r) => r.studentId == studentId).toList();
      final totalObtained = studentResults.fold(0.0, (sum, r) => sum + r.marksObtained);
      final totalMax = studentResults.fold(0.0, (sum, r) => sum + r.maxMarks);
      if (totalMax > 0) {
        percentages.add((totalObtained / totalMax) * 100);
      }
    }

    final averagePercentage = percentages.isNotEmpty
        ? percentages.reduce((a, b) => a + b) / percentages.length
        : 0.0;
    final highestMarks = percentages.isNotEmpty ? percentages.reduce((a, b) => a > b ? a : b) : 0.0;
    final lowestMarks = percentages.isNotEmpty ? percentages.reduce((a, b) => a < b ? a : b) : 0.0;
    final passedStudents = percentages.where((p) => p >= 33).length;

    return {
      'totalStudents': studentIds.length,
      'averagePercentage': averagePercentage,
      'highestMarks': highestMarks,
      'lowestMarks': lowestMarks,
      'passedStudents': passedStudents,
      'failedStudents': studentIds.length - passedStudents,
    };
  }
}