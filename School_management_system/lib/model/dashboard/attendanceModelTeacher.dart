class AttendanceRecord {
  final String id;
  final DateTime date;
  final String status; // 'present', 'absent', 'late'
  final String? reason;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String studentId;
  final String studentName;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.status,
    this.reason,
    this.checkInTime,
    this.checkOutTime,
    required this.studentId,
    required this.studentName,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      reason: json['reason'],
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      studentId: json['studentId'],
      studentName: json['studentName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status,
      'reason': reason,
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'studentId': studentId,
      'studentName': studentName,
    };
  }
}