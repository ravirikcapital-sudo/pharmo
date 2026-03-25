// Fee Item Model
class FeeItem {
  final String name;
  final double amount;
  final String type; // 'tuition', 'transport', 'library', etc.

  FeeItem({
    required this.name,
    required this.amount,
    required this.type,
  });
}

// Discount Model
class Discount {
  final String id;
  final String name;
  final String type; // 'percentage', 'fixed'
  final double value;
  final String description;
  final bool isActive;

  Discount({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.description,
    required this.isActive,
  });
}

// Fee Slip Model
class FeeSlip {
  final String id;
  final String studentId;
  final String studentName;
  final String className;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;
  final String status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final int month;
  final int year;
  final List<FeeItem> feeItems;

  FeeSlip({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.className,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.month,
    required this.year,
    required this.feeItems,
  });
}
