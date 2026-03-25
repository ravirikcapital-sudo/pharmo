import 'package:school/model/dashboard/teacherDashboardModel/designationModel.dart' show Designation;

class Teacher {
  final int id;

  // User fields
  final String fullName;
  final String email;
  final String phone;

  // Teacher profile fields
  final String gender;
  final DateTime? dob;
  final String subject;
  final DateTime joiningDate;

  final Designation? designation;

  final String? qualification;
  final int experienceYears;
  final String? experienceDetails;

  final String? profilePicture;


  Teacher({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.subject,
    required this.joiningDate,

    this.dob,
    this.designation,
    this.qualification,
    this.experienceYears = 0,
    this.experienceDetails,
    this.profilePicture,
  });

  // ---------- FROM JSON ----------
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      fullName: json['user']['full_name'],
      email: json['user']['email'],
      phone: json['user']['phone'],

      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      subject: json['subject'],
      joiningDate: DateTime.parse(json['joining_date']),

      designation: json['designation'] != null
          ? Designation.fromJson(json['designation'])
          : null,

      qualification: json['qualification'],
      experienceYears: json['experience_years'] ?? 0,
      experienceDetails: json['experience_details'],

      profilePicture: json['profile_picture'],

    );
  }

  // ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "gender": gender,
      "dob": dob?.toIso8601String().split('T').first,
      "subject": subject,
      "joining_date": joiningDate.toIso8601String().split('T').first,
      "designation": designation?.toJson(),
      "qualification": qualification,
      "experience_years": experienceYears,
      "experience_details": experienceDetails,
      "profile_picture": profilePicture,
    };
  }
}
