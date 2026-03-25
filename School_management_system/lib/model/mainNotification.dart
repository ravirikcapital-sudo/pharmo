import 'package:flutter/material.dart';

class NotificationItem {
  final int? id;
  final String? recipient;
  final String title;
  final String message;
  final String? time;
  final IconData icon;
  final String? notificationType;
  bool isRead;
  final DateTime? createdAt;
  final int? userId;

  NotificationItem({
    this.id,
    this.recipient,
    required this.title,
    required this.message,
    this.time,
    required this.icon,
    this.notificationType,
    this.isRead = false,
    this.createdAt,
    this.userId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      recipient: json['recipient'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      notificationType: json['notification_type'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
      userId: json['user'],
      icon: _getIconFromType(json['notification_type']),
      time: json['created_at'] != null 
          ? _formatTimestamp(DateTime.parse(json['created_at']))
          : 'Just now',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'recipient': recipient,
      'title': title,
      'message': message,
      'notification_type': notificationType,
      'is_read': isRead,
      if (userId != null) 'user': userId,
    };
  }

  static IconData _getIconFromType(String? type) {
    switch (type) {
      case 'Academic':
        return Icons.school;
      case 'Admission':
        return Icons.person_add;
      case 'Attendance':
        return Icons.fact_check;
      case 'Fees':
        return Icons.payment;
      case 'General':
      default:
        return Icons.notifications;
    }
  }

  static String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Notification types matching backend
class NotificationTypes {
  static const String admission = 'Admission';
  static const String attendance = 'Attendance';
  static const String academic = 'Academic';
  static const String fees = 'Fees';
  static const String general = 'General';

  static List<String> get all => [
        admission,
        attendance,
        academic,
        fees,
        general,
      ];
}

// Recipient types matching backend
class RecipientTypes {
  static const String allStudents = 'All Students';
  static const String allTeachers = 'All Teachers';
  static const String allParents = 'All Parents';
  static const String class10 = 'Class 10';
  static const String class9 = 'Class 9';
  static const String class8 = 'Class 8';
  static const String class7 = 'Class 7';
  static const String class6 = 'Class 6';
  static const String class5 = 'Class 5';
  static const String class4 = 'Class 4';
  static const String class3 = 'Class 3';
  static const String class2 = 'Class 2';
  static const String class1 = 'Class 1';
  static const String ukg = 'UKG';
  static const String lkg = 'LKG';
  static const String nursery = 'Nursery';
  static const String specificStudents = 'Specific Students';
  static const String specificTeachers = 'Specific Teachers';
  static const String specificParents = 'Specific Parents';

  static List<String> get all => [
        allStudents,
        allTeachers,
        allParents,
        class10,
        class9,
        class8,
        class7,
        class6,
        class5,
        class4,
        class3,
        class2,
        class1,
        ukg,
        lkg,
        nursery,
        specificStudents,
        specificTeachers,
        specificParents,
      ];
}