import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class UserTypeSelection extends StatefulWidget {
  final String? selectedUserType;
  final Function(String) onUserTypeSelected;
  final bool showError;
  final String? errorMessage;
  final List<Map<String, dynamic>>? customUserTypes;

  const UserTypeSelection({
    Key? key,
    this.selectedUserType,
    required this.onUserTypeSelected,
    this.showError = false,
    this.errorMessage,
    this.customUserTypes,
  }) : super(key: key);

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  late List<Map<String, dynamic>> _userTypes;

  @override
  void initState() {
    super.initState();
    _userTypes = widget.customUserTypes ?? _getDefaultUserTypes();
  }

  List<Map<String, dynamic>> _getDefaultUserTypes() {
    return [
      {
        'value': 'Student',
        'icon': Icons.school_rounded,
        'color': AppThemeColor.primaryBlue
      },
      {
        'value': 'Teacher',
        'icon': Icons.person_rounded,
        'color': AppThemeColor.primaryBlue
      },
      {
        'value': 'Parent',
        'icon': Icons.family_restroom_rounded,
        'color': AppThemeColor.primaryBlue
      },
      {
        'value': 'Admin',
        'icon': Icons.admin_panel_settings_rounded,
        'color': AppThemeColor.primaryBlue600
      },
      {
        'value': 'Academic Officer',
        'icon': Icons.business_center_rounded,
        'color': AppThemeColor.primaryBlue600
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppThemeResponsiveness.isSmallPhone(context) ? 90 : 110,
          child: _buildUserTypeList(),
        ),
        // Show "Please select a role" message below the selection items
        if (widget.selectedUserType == null)
          Padding(
            padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context)),
            child: Text(
              'Please select a role',
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (widget.showError)
          Padding(
            padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context)),
            child: Text(
              widget.errorMessage ?? 'Please select a user type',
              style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                color: Colors.red.shade600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserTypeList() {
    if (AppThemeResponsiveness.isSmallPhone(context)) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _userTypes.asMap().entries.map((entry) {
            int index = entry.key;
            return Padding(
              padding: EdgeInsets.only(
                  right: index < _userTypes.length - 1 ? 8 : 0),
              child: _buildUserTypeItem(index, isCompact: true),
            );
          }).toList(),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _userTypes.length,
      itemBuilder: (context, index) => _buildUserTypeItem(index),
    );
  }

  Widget _buildUserTypeItem(int index, {bool isCompact = false}) {
    final userType = _userTypes[index];
    final isSelected = widget.selectedUserType == userType['value'];

    double itemWidth = AppThemeResponsiveness.isSmallPhone(context)
        ? (isCompact ? 70.0 : 80.0)
        : AppThemeResponsiveness.isMobile(context)
        ? 90.0
        : 100.0;

    double iconSize = AppThemeResponsiveness.getIconSize(context) *
        (isCompact ? 1.0 : 1.2);

    return GestureDetector(
      onTap: () {
        widget.onUserTypeSelected(userType['value']);
        HapticFeedback.lightImpact();
      },
      child: Container(
        margin: EdgeInsets.only(right: isCompact ? 0 : 12),
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getSmallSpacing(context),
          vertical: AppThemeResponsiveness.getSmallSpacing(context) + 4,
        ),
        width: itemWidth,
        decoration: BoxDecoration(
          color: isSelected ? userType['color'] : AppThemeColor.greyl,
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context) + 4,
          ),
          border: Border.all(
            color: isSelected ? userType['color'] : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: userType['color'].withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              userType['icon'],
              color: isSelected ? AppThemeColor.white : Colors.grey.shade600,
              size: iconSize,
            ),
            SizedBox(height: 4),
            Flexible(
              child: Text(
                _getShortUserType(userType['value']),
                style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                  fontSize: isCompact ? 11.0 : 12.5,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppThemeColor.white : Colors.grey.shade600,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getShortUserType(String userType) {
    switch (userType) {
      case 'Academic Officer':
        return AppThemeResponsiveness.isSmallPhone(context)
            ? 'Academic\nOfficer'
            : 'Academic\nOfficer';
      default:
        return userType;
    }
  }
}