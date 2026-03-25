// Data Model
class AdmissionStatusData {
  final String admissionNumber;
  final String studentName;
  final String classApplied;
  final String status;
  final String statusUpdatedOn;
  final String remarks;

  AdmissionStatusData({
    required this.admissionNumber,
    required this.studentName,
    required this.classApplied,
    required this.status,
    required this.statusUpdatedOn,
    required this.remarks,
  });
}