class Student {
  final int id;
  final String name;
  final String email;
  final bool enrolled;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      enrolled: json['enrolled'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'enrolled': enrolled,
  };
}
