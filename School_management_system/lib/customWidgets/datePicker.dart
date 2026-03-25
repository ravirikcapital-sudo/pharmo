import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class AppDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final bool enabled;
  final VoidCallback? onTap;
  final String dateFormat; // 'dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd'
  final String? defaultDate; // Set default date in string format

  const AppDatePicker({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.enabled = true,
    this.onTap,
    this.dateFormat = 'dd/MM/yyyy',
    this.defaultDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set default date if provided and controller is empty
    if (defaultDate != null && controller.text.isEmpty) {
      controller.text = defaultDate!;
    }

    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
        color: enabled ? null : Colors.grey[600],
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        prefixIcon: Icon(
          Icons.calendar_today,
          color: enabled ? Colors.grey[600] : Colors.grey[400],
          size: AppThemeResponsiveness.getIconSize(context),
        ),
        hintText: hintText ?? 'Select $label',
        hintStyle: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: AppThemeColor.blue600,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onTap: enabled ? () => _selectDate(context) : onTap,
      validator: validator,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Call custom onTap if provided
    if (onTap != null) {
      onTap!();
      return;
    }

    final DateTime currentDate = DateTime.now();
    final DateTime defaultFirstDate = firstDate ?? DateTime(1950);
    final DateTime defaultLastDate = lastDate ?? currentDate;

    // Parse existing date from controller or use initialDate
    DateTime defaultInitialDate = initialDate ?? currentDate;
    if (controller.text.isNotEmpty) {
      try {
        defaultInitialDate = _parseDate(controller.text);
      } catch (e) {
        // If parsing fails, use initialDate or current date
        defaultInitialDate = initialDate ?? currentDate;
      }
    }

    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _getValidInitialDate(
          defaultInitialDate,
          defaultFirstDate,
          defaultLastDate,
        ),
        firstDate: defaultFirstDate,
        lastDate: defaultLastDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppThemeColor.blue600,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        controller.text = _formatDate(pickedDate);
      }
    } catch (e) {
      // Handle any errors during date selection
      debugPrint('Error selecting date: $e');
    }
  }

  DateTime _getValidInitialDate(
      DateTime initialDate,
      DateTime firstDate,
      DateTime lastDate,
      ) {
    if (initialDate.isBefore(firstDate)) {
      return firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      return lastDate;
    }
    return initialDate;
  }

  DateTime _parseDate(String dateString) {
    switch (dateFormat.toLowerCase()) {
      case 'mm/dd/yyyy':
        final parts = dateString.split('/');
        return DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
      case 'yyyy-mm-dd':
        final parts = dateString.split('-');
        return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      case 'dd-mm-yyyy':
        final parts = dateString.split('-');
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      case 'dd/mm/yyyy':
      default:
        final parts = dateString.split('/');
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    }
  }

  String _formatDate(DateTime date) {
    switch (dateFormat.toLowerCase()) {
      case 'mm/dd/yyyy':
        return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
      case 'yyyy-mm-dd':
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      case 'dd-mm-yyyy':
        return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
      case 'dd/mm/yyyy':
      default:
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  // Static method to create common date picker configurations
  static AppDatePicker dateOfBirth({
    required TextEditingController controller,
    String? Function(String?)? validator,
    String? defaultDate,
  }) {
    return AppDatePicker(
      controller: controller,
      label: 'Date of Birth',
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please select date of birth';
        }
        return null;
      },
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      defaultDate: defaultDate,
    );
  }

  static AppDatePicker admissionDate({
    required TextEditingController controller,
    String? Function(String?)? validator,
    String? defaultDate,
  }) {
    return AppDatePicker(
      controller: controller,
      label: 'Admission Date',
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please select admission date';
        }
        return null;
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      defaultDate: defaultDate,
    );
  }

  static AppDatePicker genericDate({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String dateFormat = 'dd/MM/yyyy',
    String? defaultDate,
  }) {
    return AppDatePicker(
      controller: controller,
      label: label,
      validator: validator,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      defaultDate: defaultDate,
    );
  }
}