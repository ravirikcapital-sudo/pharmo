import 'package:flutter/material.dart';

class AcademicOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final Widget Function() route;
  final String stats;

  AcademicOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.route,
    required this.stats,
  });

  Map<String, dynamic> toJson() {
    return {
      'icon': icon.codePoint,
      'title': title,
      'subtitle': subtitle,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'stats': stats,
    };
  }

  // Note: fromJson cannot fully reconstruct route function
  // You'll need to handle route assignment separately
  static AcademicOption fromJson(Map<String, dynamic> json, Widget Function() routeFunction) {
    return AcademicOption(
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      title: json['title'],
      subtitle: json['subtitle'],
      primaryColor: Color(json['primaryColor']),
      secondaryColor: Color(json['secondaryColor']),
      route: routeFunction,
      stats: json['stats'],
    );
  }
}

class AcademicClass {
  final String id;
  final String className;
  final String section;
  final int capacity;
  final String classTeacher;
  final DateTime createdAt;

  AcademicClass({
    required this.id,
    required this.className,
    required this.section,
    required this.capacity,
    required this.classTeacher,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'section': section,
      'capacity': capacity,
      'classTeacher': classTeacher,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AcademicClass.fromJson(Map<String, dynamic> json) {
    return AcademicClass(
      id: json['id'],
      className: json['className'],
      section: json['section'],
      capacity: json['capacity'],
      classTeacher: json['classTeacher'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}



class TeacherMiniModel {
  final int id;
  final String name;

  TeacherMiniModel({
    required this.id,
    required this.name,
  });

  factory TeacherMiniModel.fromJson(Map<String, dynamic> json) {
    return TeacherMiniModel(
      id: json["id"],
      name: json["name"],
    );
  }
}


class ClassMiniModel {
  final int id;
  final String name;

  ClassMiniModel({
    required this.id,
    required this.name,
  });

  factory ClassMiniModel.fromJson(Map<String, dynamic> json) {
    return ClassMiniModel(
      id: json["id"],
      name: json["name"],
    );
  }
}



class SubjectModel {
  final int? id;
  final String name;
  final String code;
  final String description;

  /// WRITE (SlugRelatedField → class name)
  final List<String> classNames;

  /// READ (Create / Update response)
  final List<String> classes;

  /// DETAIL
  final List<TeacherMiniModel> teachers;
  final List<ClassMiniModel> detailedClasses;

  SubjectModel({
    this.id,
    required this.name,
    required this.code,
    required this.description,
    this.classNames = const [],
    this.classes = const [],
    this.teachers = const [],
    this.detailedClasses = const [],
  });

  /// ✅ CREATE / UPDATE payload
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "code": code,
      "description": description,
      "class_name": classNames,
    };
  }

  /// ✅ LIST serializer
  factory SubjectModel.fromListJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      description: json["description"] ?? "",
    );
  }

  /// ✅ CREATE / UPDATE response
  factory SubjectModel.fromCreateJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      description: json["description"] ?? "",
      classes: List<String>.from(json["classes"] ?? []),
    );
  }

  /// ✅ DETAIL serializer
  factory SubjectModel.fromDetailJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      description: json["description"] ?? "",
      teachers: (json["teachers"] as List? ?? [])
          .map((e) => TeacherMiniModel.fromJson(e))
          .toList(),
      detailedClasses: (json["classes"] as List? ?? [])
          .map((e) => ClassMiniModel.fromJson(e))
          .toList(),
    );
  }
}


class SportGroupModel {
  final int? id;
  final String groupName;
  final String? sportType;
  final String? coachName;
  final int? maxMembers;
  final bool isActive;
  final DateTime? createdAt;

  SportGroupModel({
    this.id,
    required this.groupName,
    this.sportType,
    this.coachName,
    this.maxMembers,
    this.isActive = true,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_name': groupName,
      'sport_type': sportType,
      'coach_name': coachName,
      'max_members': maxMembers,
      'is_active': isActive,
    };
  }

  factory SportGroupModel.fromJson(Map<String, dynamic> json) {
    return SportGroupModel(
      id: json['id'],
      groupName: json['group_name'] ?? '',
      sportType: json['sport_type'],
      coachName: json['coach_name'],
      maxMembers: json['max_members'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class HouseGroupModel {
  final int? id;
  final String houseName;
  final String houseColor;
  final String? houseCaptain;
  final String? viceCaptain;
  final String? houseMotto;
  final bool isActive;
  final DateTime? createdAt;

  HouseGroupModel({
    this.id,
    required this.houseName,
    required this.houseColor,
    this.houseCaptain,
    this.viceCaptain,
    this.houseMotto,
    this.isActive = true,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "house_name": houseName,
      "house_color": houseColor,
      "house_captain": houseCaptain,
      "vice_captain": viceCaptain,
      "house_motto": houseMotto,
      "is_active": isActive,
    };
  }

  factory HouseGroupModel.fromJson(Map<String, dynamic> json) {
    return HouseGroupModel(
      id: json["id"],
      houseName: json["house_name"] ?? '',
      houseColor: json["house_color"] ?? '',
      houseCaptain: json["house_captain"],
      viceCaptain: json["vice_captain"],
      houseMotto: json["house_motto"],
      isActive: json["is_active"] ?? true,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
    );
  }
}

class AcademicDashboardStats {
  final int totalClasses;
  final int totalSubjects;
  final int totalTeachers;
  final int totalSportsGroups;
  final int totalHouseGroups;

  AcademicDashboardStats({
    required this.totalClasses,
    required this.totalSubjects,
    required this.totalTeachers,
    required this.totalSportsGroups,
    required this.totalHouseGroups,
  });

  factory AcademicDashboardStats.fromJson(Map<String, dynamic> json) {
    return AcademicDashboardStats(
      totalClasses: json['total_classes'] ?? 0,
      totalSubjects: json['total_subjects'] ?? 0,
      totalTeachers: json['total_teachers'] ?? 0,
      totalSportsGroups: json['total_sports_groups'] ?? 0,
      totalHouseGroups: json['total_house_groups'] ?? 0,
    );
  }

  int get totalItems => totalClasses + totalSubjects + totalSportsGroups + totalHouseGroups;
}
