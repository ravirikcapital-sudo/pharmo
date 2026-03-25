// File: lib/model/dashboard/teacherDashboardModel/salaryManagementTeacherDashboard.dart
import 'package:flutter/material.dart';

class SalaryRecord {
  final String id;
  final String month;
  final String year;
  final double basicSalary;
  final double hra;
  final double da;
  final double ta;
  final double medicalAllowance;
  final double overtime;
  final double pf;
  final double tds;
  final double otherDeductions;
  final DateTime? paymentDate;
  String status;
  String slipNumber;
  final int workingDays;
  final int totalWorkingDays;

  SalaryRecord({
    required this.id,
    required this.month,
    required this.year,
    required this.basicSalary,
    required this.hra,
    required this.da,
    required this.ta,
    required this.medicalAllowance,
    required this.overtime,
    required this.pf,
    required this.tds,
    required this.otherDeductions,
    this.paymentDate,
    required this.status,
    required this.slipNumber,
    required this.workingDays,
    required this.totalWorkingDays,
  });

  double calculateGrossSalary() {
    return basicSalary + hra + da + ta + medicalAllowance + overtime;
  }

  double calculateTotalDeductions() {
    return pf + tds + otherDeductions;
  }

  double calculateTotalAllowances() {
    return hra + da + ta + medicalAllowance + overtime;
  }

  double calculateNetSalary() {
    return calculateGrossSalary() - calculateTotalDeductions();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'basicSalary': basicSalary,
      'hra': hra,
      'da': da,
      'ta': ta,
      'medicalAllowance': medicalAllowance,
      'overtime': overtime,
      'pf': pf,
      'tds': tds,
      'otherDeductions': otherDeductions,
      'paymentDate': paymentDate?.toIso8601String(),
      'status': status,
      'slipNumber': slipNumber,
      'workingDays': workingDays,
      'totalWorkingDays': totalWorkingDays,
    };
  }

  factory SalaryRecord.fromJson(Map<String, dynamic> json) {
    return SalaryRecord(
      id: json['id'],
      month: json['month'],
      year: json['year'],
      basicSalary: json['basicSalary']?.toDouble() ?? 0.0,
      hra: json['hra']?.toDouble() ?? 0.0,
      da: json['da']?.toDouble() ?? 0.0,
      ta: json['ta']?.toDouble() ?? 0.0,
      medicalAllowance: json['medicalAllowance']?.toDouble() ?? 0.0,
      overtime: json['overtime']?.toDouble() ?? 0.0,
      pf: json['pf']?.toDouble() ?? 0.0,
      tds: json['tds']?.toDouble() ?? 0.0,
      otherDeductions: json['otherDeductions']?.toDouble() ?? 0.0,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'])
          : null,
      status: json['status'],
      slipNumber: json['slipNumber'],
      workingDays: json['workingDays']?.toInt() ?? 0,
      totalWorkingDays: json['totalWorkingDays']?.toInt() ?? 0,
    );
  }
}

class TeacherInfo {
  final String name;
  final String employeeId;
  final String department;
  final String designation;
  final DateTime joinDate;
  final String bankAccount;
  final String panNumber;
  final String? phoneNumber;
  final String? email;
  final String? address;

  TeacherInfo({
    required this.name,
    required this.employeeId,
    required this.department,
    required this.designation,
    required this.joinDate,
    required this.bankAccount,
    required this.panNumber,
    this.phoneNumber,
    this.email,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'employeeId': employeeId,
      'department': department,
      'designation': designation,
      'joinDate': joinDate.toIso8601String(),
      'bankAccount': bankAccount,
      'panNumber': panNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      name: json['name'],
      employeeId: json['employeeId'],
      department: json['department'],
      designation: json['designation'],
      joinDate: DateTime.parse(json['joinDate']),
      bankAccount: json['bankAccount'],
      panNumber: json['panNumber'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }
}

class SalarySlipConfig {
  final String schoolName;
  final String schoolAddress;
  final String contactEmail;
  final String contactPhone;
  final Color primaryColor;
  final Color secondaryColor;
  final String? logoPath;

  SalarySlipConfig({
    required this.schoolName,
    required this.schoolAddress,
    required this.contactEmail,
    required this.contactPhone,
    required this.primaryColor,
    required this.secondaryColor,
    this.logoPath,
  });
}