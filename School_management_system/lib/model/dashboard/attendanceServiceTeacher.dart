import 'package:school/model/dashboard/attendanceModelTeacher.dart';

class AttendanceService {
  static final AttendanceService _instance = AttendanceService._internal();
  factory AttendanceService() => _instance;
  AttendanceService._internal();

  List<AttendanceRecord> _attendanceRecords = [];

  // Initialize with sample data
  void initializeSampleData() {
    final now = DateTime.now();
    _attendanceRecords = [
      AttendanceRecord(
        id: '1',
        date: now.subtract(const Duration(days: 1)),
        status: 'present',
        checkInTime: DateTime(now.year, now.month, now.day - 1, 8, 30),
        checkOutTime: DateTime(now.year, now.month, now.day - 1, 15, 30),
        studentId: 'STD001',
        studentName: 'Current Student',
      ),
      AttendanceRecord(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        status: 'present',
        checkInTime: DateTime(now.year, now.month, now.day - 2, 8, 45),
        checkOutTime: DateTime(now.year, now.month, now.day - 2, 15, 30),
        studentId: 'STD001',
        studentName: 'Current Student',
      ),
      AttendanceRecord(
        id: '3',
        date: now.subtract(const Duration(days: 3)),
        status: 'late',
        reason: 'Traffic jam',
        checkInTime: DateTime(now.year, now.month, now.day - 3, 9, 15),
        checkOutTime: DateTime(now.year, now.month, now.day - 3, 15, 30),
        studentId: 'STD001',
        studentName: 'Current Student',
      ),
      AttendanceRecord(
        id: '4',
        date: now.subtract(const Duration(days: 4)),
        status: 'absent',
        reason: 'Sick leave',
        studentId: 'STD001',
        studentName: 'Current Student',
      ),
    ];
  }

  Future<List<AttendanceRecord>> getAttendanceRecords() async {
    if (_attendanceRecords.isEmpty) {
      initializeSampleData();
    }
    return _attendanceRecords;
  }

  Future<AttendanceRecord?> getTodayAttendance() async {
    final today = DateTime.now();
    final todayRecords = _attendanceRecords.where((record) =>
    record.date.year == today.year &&
        record.date.month == today.month &&
        record.date.day == today.day);

    return todayRecords.isNotEmpty ? todayRecords.first : null;
  }

  Future<bool> markAttendance({
    required String status,
    String? reason,
  }) async {
    try {
      final today = DateTime.now();
      final existingRecord = await getTodayAttendance();

      if (existingRecord != null) {
        // Update existing record
        _attendanceRecords.removeWhere((record) => record.id == existingRecord.id);
      }

      final newRecord = AttendanceRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: today,
        status: status,
        reason: reason,
        checkInTime: status != 'absent' ? today : null,
        studentId: 'STD001',
        studentName: 'Current Student',
      );

      _attendanceRecords.insert(0, newRecord);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markCheckOut() async {
    try {
      final todayRecord = await getTodayAttendance();
      if (todayRecord != null && todayRecord.checkOutTime == null) {
        final updatedRecord = AttendanceRecord(
          id: todayRecord.id,
          date: todayRecord.date,
          status: todayRecord.status,
          reason: todayRecord.reason,
          checkInTime: todayRecord.checkInTime,
          checkOutTime: DateTime.now(),
          studentId: todayRecord.studentId,
          studentName: todayRecord.studentName,
        );

        _attendanceRecords.removeWhere((record) => record.id == todayRecord.id);
        _attendanceRecords.insert(0, updatedRecord);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Map<String, int> getAttendanceStats() {
    final total = _attendanceRecords.length;
    final present = _attendanceRecords.where((r) => r.status == 'present').length;
    final absent = _attendanceRecords.where((r) => r.status == 'absent').length;
    final late = _attendanceRecords.where((r) => r.status == 'late').length;

    return {
      'total': total,
      'present': present,
      'absent': absent,
      'late': late,
      'percentage': total > 0 ? ((present + late) * 100 / total).round() : 0,
    };
  }
}
