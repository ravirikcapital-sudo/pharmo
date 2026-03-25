// Fee Data Model
class FeeRecord {
  final String id;
  final String description;
  final double amount;
  final DateTime dueDate;
  late final DateTime? paidDate;
  late final String status; // 'paid', 'pending', 'overdue'
  late final String receiptNumber;
  final String academicYear;
  final String term;

  FeeRecord({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    required this.receiptNumber,
    required this.academicYear,
    required this.term,
  });
}

