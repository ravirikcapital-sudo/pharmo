class Employee {
  final int id; // 🔥 MUST BE INT
  final String name;
  final String role;
  final String department;
  final String phone;
  final String email;
  final String gender;
  final String salary;
  final String joiningDate;
  final bool isActive;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.phone,
    required this.email,
    required this.gender,
    required this.salary,
    required this.joiningDate,
    required this.isActive,
  });

  // ===============================
  // FROM JSON (API → APP)
  // ===============================
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'], // 🔥 INT FROM BACKEND
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      department: json['department'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      salary: json['salary']?.toString() ?? '0',
      joiningDate: json['joining_date'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  // ===============================
  // TO JSON (APP → API)
  // ===============================
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "department": department,
      "gender": gender,
      "salary": salary,
      "joining_date": joiningDate,
      "is_active": isActive,
    };
  }
}
