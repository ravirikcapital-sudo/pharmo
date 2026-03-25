// facilities_data.dart
class FacilitiesData {
  static List<dynamic> facilities = [
    // Add your facilities data here
    {
      'id': 1,
      'name': 'Library',
      'description': 'Well-equipped library with books and digital resources',
      'image': 'assets/images/library.jpg',
    },
    {
      'id': 2,
      'name': 'Sports Complex',
      'description': 'Modern sports facilities for various activities',
      'image': 'assets/images/sports.jpg',
    },
    {
      'id': 3,
      'name': 'Computer Lab',
      'description': 'State-of-the-art computer laboratory',
      'image': 'assets/images/computer_lab.jpg',
    },
    // Add more facilities as needed
  ];

  static List<dynamic> getFacilities() {
    return facilities;
  }

  static void updateFacilities(List<dynamic> newFacilities) {
    facilities = newFacilities;
  }
}

class Facility {
  String id;
  String name;
  String description;
  double fees;
  bool isActive;
  DateTime createdAt;
  String? image; // Add image field to match the common model

  Facility({
    required this.id,
    required this.name,
    required this.description,
    required this.fees,
    this.isActive = true,
    required this.createdAt,
    this.image,
  });

  // Factory constructor to create Facility from common data model
  factory Facility.fromCommonModel(dynamic facilityData) {
    return Facility(
      id: facilityData['id'].toString(),
      name: facilityData['name'] ?? '',
      description: facilityData['description'] ?? '',
      fees: (facilityData['fees'] ?? 0.0).toDouble(),
      isActive: facilityData['isActive'] ?? true,
      createdAt: facilityData['createdAt'] != null
          ? DateTime.parse(facilityData['createdAt'])
          : DateTime.now(),
      image: facilityData['image'],
    );
  }

  // Convert Facility to common data model format
  Map<String, dynamic> toCommonModel() {
    return {
      'id': int.tryParse(id) ?? id,
      'name': name,
      'description': description,
      'fees': fees,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'image': image,
    };
  }
}