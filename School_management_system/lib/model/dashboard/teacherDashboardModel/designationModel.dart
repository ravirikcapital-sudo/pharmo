class Designation {
  final int id;
  final String title;
  final String description;
  final bool is_active; // bool, lowercase

  Designation({
    required this.id,
    required this.title,
    required this.description,
    this.is_active = true, 
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      is_active: json['is_active'] ?? true, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "is_active": is_active,
    };
  }
}
