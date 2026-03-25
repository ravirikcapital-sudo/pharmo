class StaffSalaryData {
  final String id;
  final String name;
  final String designation;
  final String department;
  final double baseSalary;
  final double allowances;
  final double deductions;
  final double netSalary;
  final String employeeId;
  bool isPaid;
  DateTime? paymentDate;

  StaffSalaryData({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.baseSalary,
    required this.allowances,
    required this.deductions,
    required this.netSalary,
    required this.employeeId,
    required this.isPaid,
    this.paymentDate,
  });
}