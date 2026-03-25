// Data Models
class Teacher {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String qualification;
  final bool isAvailable;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.qualification,
    this.isAvailable = true,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'].toString(),
      name: json['full_name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      subject: json['subject'],
      qualification: json['qualification'],
      isAvailable: json['is_available'] ?? true,
    );
  }
  
  Teacher copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? subject,
    String? qualification,
    bool? isAvailable,
  }) {
    return Teacher(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subject: subject ?? this.subject,
      qualification: qualification ?? this.qualification,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
