import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class AppTextFieldBuilder {
  static Widget build({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int? maxLength,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none, 
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines ?? 1,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      style: AppThemeResponsiveness.getBodyTextStyle(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        prefixIcon: Icon(
          icon,
          size: AppThemeResponsiveness.getIconSize(context),
          color: Colors.grey[600],
        ),
        suffixIcon: suffixIcon,
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: maxLength != null ? '' : null,
      ),
    );
  }
}
