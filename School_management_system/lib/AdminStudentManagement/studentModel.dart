class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String className;
  final String admissionStatus;
  final DateTime dateOfBirth;
  final String address;

  // ✅ ADD THESE
  final String section;
  final String rollNumber;
  final String admissionNumber;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.className,
    required this.admissionStatus,
    required this.dateOfBirth,
    required this.address,

    // ✅ ADD THESE
    this.section = '',
    this.rollNumber = '',
    this.admissionNumber = '',
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['mobile_number'] ?? json['phone'] ?? json['mobile'] ?? '',
      className: json['class_name'] ?? json['class_enrolled'] ?? '',
      admissionStatus: json['admission_status'] ?? json['status'] ?? 'Active',

      dateOfBirth:
          json['date_of_birth'] != null
              ? DateTime.parse(json['date_of_birth'])
              : json['dob'] != null
              ? DateTime.parse(json['dob'])
              : DateTime(2000, 1, 1),

      address: json['address'] ?? '',

      // ✅ MAP THESE
      section: json['section'] ?? '',
      rollNumber: json['roll_number'] ?? json['rollNumber'] ?? '',
      admissionNumber:
          json['admission_number'] ?? json['admissionNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson(String className) {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'class_name': className,
      'admission_status': admissionStatus,
      'dob': dateOfBirth.toIso8601String(),
      'address': address,

      // ✅ INCLUDE THESE
      'section': section,
      'roll_number': rollNumber,
      'admission_number': admissionNumber,
    };
  }
}
