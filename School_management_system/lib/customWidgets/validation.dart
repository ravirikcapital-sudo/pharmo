class ValidationUtils {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value, {String fieldName = 'name'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }

    if (value.trim().length < 2) {
      return '${fieldName.capitalize()} must be at least 2 characters long';
    }

    if (value.trim().length > 50) {
      return '${fieldName.capitalize()} must be less than 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return '${fieldName.capitalize()} can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // Full name validation
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters long';
    }

    if (value.trim().length > 100) {
      return 'Full name must be less than 100 characters';
    }

    // Check if it contains at least first and last name
    final nameParts = value.trim().split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      return 'Please enter both first and last name';
    }

    // Check for valid characters
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }

    // Check for valid phone number pattern
    final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{10,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (value.length > 128) {
      return 'Password must be less than 128 characters';
    }

    // Check for uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for digit
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for special character (optional but recommended)
    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(value)) {
      return 'Password should contain at least one special character';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Student ID validation
  static String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your student ID';
    }

    if (value.trim().length < 4) {
      return 'Student ID must be at least 4 characters long';
    }

    if (value.trim().length > 20) {
      return 'Student ID must be less than 20 characters';
    }

    // Check for valid student ID pattern (alphanumeric)
    final studentIdRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!studentIdRegex.hasMatch(value.trim())) {
      return 'Student ID can only contain letters and numbers';
    }

    return null;
  }

  // Age validation
  static String? validateAge(String? value, {int minAge = 5, int maxAge = 100}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your age';
    }

    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < minAge) {
      return 'Age must be at least $minAge years';
    }

    if (age > maxAge) {
      return 'Age must be less than $maxAge years';
    }

    return null;
  }

  // Date of birth validation (accepts DateTime object)
  static String? validateDateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Please select your date of birth';
    }

    final now = DateTime.now();

    // Check if date is in the future
    if (value.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    // Calculate age
    final age = now.difference(value).inDays / 365.25; // More accurate with leap years

    // Check if person is too old (more than 120 years)
    if (age > 120) {
      return 'Please enter a valid date of birth';
    }

    // Check if person is too young (less than 5 years for students, 18 for teachers)
    if (age < 5) {
      return 'You must be at least 5 years old';
    }

    return null;
  }

  // Teacher age validation (minimum 18 years)
  static String? validateTeacherDateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Please select your date of birth';
    }

    final now = DateTime.now();

    // Check if date is in the future
    if (value.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    // Calculate age
    final age = now.difference(value).inDays / 365.25;

    // Check if person is too old (more than 120 years)
    if (age > 120) {
      return 'Please enter a valid date of birth';
    }

    // Check if person is too young (minimum 18 years for teachers)
    if (age < 18) {
      return 'Teachers must be at least 18 years old';
    }

    return null;
  }

  // Joining date validation
  static String? validateJoiningDate(DateTime? value) {
    if (value == null) {
      return 'Please select your joining date';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(value.year, value.month, value.day);

    // Check if joining date is too far in the past (more than 50 years)
    final fiftyYearsAgo = today.subtract(Duration(days: 365 * 50));
    if (selectedDate.isBefore(fiftyYearsAgo)) {
      return 'Joining date cannot be more than 50 years ago';
    }

    // Check if joining date is too far in the future (more than 1 year)
    final oneYearFromNow = today.add(Duration(days: 365));
    if (selectedDate.isAfter(oneYearFromNow)) {
      return 'Joining date cannot be more than 1 year in the future';
    }

    return null;
  }

  // Gender validation
  static String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your gender';
    }

    // Define allowed gender values
    final allowedGenders = ['Male', 'Female', 'Other', 'male', 'female', 'other'];

    if (!allowedGenders.contains(value.trim())) {
      return 'Please select a valid gender option';
    }

    return null;
  }

  // Subject validation
  static String? validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a subject';
    }

    // Define allowed subjects (you can expand this list as needed)
    final allowedSubjects = [
      'Mathematics', 'Science', 'English', 'Hindi', 'Social Studies',
      'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Physical Education',
      'Art', 'Music', 'History', 'Geography', 'Economics', 'Political Science',
      'Philosophy', 'Psychology', 'Sociology', 'Literature'
    ];

    if (!allowedSubjects.contains(value.trim())) {
      return 'Please select a valid subject';
    }

    return null;
  }

  // Grade/Class validation
  static String? validateGrade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your grade/class';
    }

    final grade = int.tryParse(value.trim());
    if (grade == null) {
      return 'Please enter a valid grade';
    }

    if (grade < 1 || grade > 12) {
      return 'Grade must be between 1 and 12';
    }

    return null;
  }

  // Required field validation (generic)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional in most cases
    }

    final urlRegex = RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // IMPROVED Role validation
  static String? validateRole(String? value, {List<String>? allowedRoles}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a role';
    }

    // Default allowed roles if not provided
    final defaultAllowedRoles = [
      'Student',
      'Teacher',
      'Admin',
      'Administrator',
      'Principal',
      'Vice Principal',
      'HOD', // Head of Department
      'Coordinator',
      'Staff'
    ];

    final rolesToCheck = allowedRoles ?? defaultAllowedRoles;

    // Check if the selected role is in the allowed list (case-insensitive)
    final normalizedValue = value.trim();
    final isValidRole = rolesToCheck.any(
            (role) => role.toLowerCase() == normalizedValue.toLowerCase()
    );

    if (!isValidRole) {
      return 'Please select a valid role from the available options';
    }

    return null;
  }

  // Role validation with specific roles for different contexts
  static String? validateUserRole(String? value) {
    return validateRole(value, allowedRoles: ['Student', 'Teacher', 'Admin']);
  }

  // Role validation for staff members
  static String? validateStaffRole(String? value) {
    return validateRole(value, allowedRoles: [
      'Teacher',
      'Principal',
      'Vice Principal',
      'HOD',
      'Coordinator',
      'Admin',
      'Librarian',
      'Counselor'
    ]);
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }

    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters long';
    }

    if (value.trim().length > 200) {
      return 'Address must be less than 200 characters';
    }

    return null;
  }

  // Postal/ZIP code validation
  static String? validatePostalCode(String? value, {String country = 'IN'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter postal code';
    }

    switch (country.toUpperCase()) {
      case 'US':
        final usZipRegex = RegExp(r'^\d{5}(-\d{4})?$');
        if (!usZipRegex.hasMatch(value.trim())) {
          return 'Please enter a valid US ZIP code (12345 or 12345-6789)';
        }
        break;
      case 'CA':
        final caPostalRegex = RegExp(r'^[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d$');
        if (!caPostalRegex.hasMatch(value.trim())) {
          return 'Please enter a valid Canadian postal code (A1A 1A1)';
        }
        break;
      case 'IN':
        final inPinRegex = RegExp(r'^\d{6}$');
        if (!inPinRegex.hasMatch(value.trim())) {
          return 'Please enter a valid Indian PIN code (6 digits)';
        }
        break;
      default:
        if (value.trim().length < 3 || value.trim().length > 10) {
          return 'Please enter a valid postal code';
        }
    }

    return null;
  }

  // Employee ID validation (for teachers)
  static String? validateEmployeeId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your employee ID';
    }

    if (value.trim().length < 3) {
      return 'Employee ID must be at least 3 characters long';
    }

    if (value.trim().length > 20) {
      return 'Employee ID must be less than 20 characters';
    }

    // Check for valid employee ID pattern (alphanumeric with optional hyphens and underscores)
    final employeeIdRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!employeeIdRegex.hasMatch(value.trim())) {
      return 'Employee ID can only contain letters, numbers, hyphens, and underscores';
    }

    return null;
  }

  // Qualification validation (for teachers)
  static String? validateQualification(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your qualification';
    }

    if (value.trim().length < 2) {
      return 'Qualification must be at least 2 characters long';
    }

    if (value.trim().length > 100) {
      return 'Qualification must be less than 100 characters';
    }

    return null;
  }

  // Experience validation (for teachers)
  static String? validateExperience(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Experience can be optional for new teachers
    }

    final experience = double.tryParse(value.trim());
    if (experience == null) {
      return 'Please enter a valid experience in years';
    }

    if (experience < 0) {
      return 'Experience cannot be negative';
    }

    if (experience > 50) {
      return 'Experience cannot be more than 50 years';
    }

    return null;
  }

  // Salary validation (for teachers/staff)
  static String? validateSalary(String? value, {double minSalary = 0, double maxSalary = 10000000}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Salary can be optional in some cases
    }

    final salary = double.tryParse(value.trim());
    if (salary == null) {
      return 'Please enter a valid salary amount';
    }

    if (salary < minSalary) {
      return 'Salary must be at least ₹${minSalary.toStringAsFixed(0)}';
    }

    if (salary > maxSalary) {
      return 'Salary cannot exceed ₹${maxSalary.toStringAsFixed(0)}';
    }

    return null;
  }

  // Department validation
  static String? validateDepartment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a department';
    }

    final allowedDepartments = [
      'Science',
      'Mathematics',
      'English',
      'Social Studies',
      'Physical Education',
      'Arts',
      'Computer Science',
      'Administration',
      'Library',
      'Counseling'
    ];

    if (!allowedDepartments.contains(value.trim())) {
      return 'Please select a valid department';
    }

    return null;
  }
}

// Extension to capitalize first letter
extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}