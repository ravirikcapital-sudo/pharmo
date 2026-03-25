import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart'; // Import the button component

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: AppThemeResponsiveness.getMaxWidth(context)),
              child: Expanded(
                child: _buildScrollableContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
        ),
        child: _buildFormCard(),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardPadding(context)),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSecurityIcon(),
              SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context)),
              _buildTitleSection(),
              SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context) * 2),
              _buildPasswordFields(),
              SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context) * 2),
              _buildChangePasswordButton(),
              SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityIcon() {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue600,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppThemeColor.primaryBlue.withOpacity(0.3),
            blurRadius: AppThemeResponsiveness.isSmallPhone(context) ? 15 : 20,
            spreadRadius: AppThemeResponsiveness.isSmallPhone(context) ? 3 : 5,
          ),
        ],
      ),
      child: Icon(
        Icons.security_rounded,
        size: AppThemeResponsiveness.getDashboardCardIconSize(context),
        color: AppThemeColor.white,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          'Secure Your Account',
          style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.getWelcomeNameTextStyle(context).fontSize,
            color: AppThemeColor.blue800,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Text(
          'Update your password to keep your account safe',
          style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        AppTextFieldBuilder.build(
          context: context,
          controller: _currentPasswordController,
          label: 'Current Password',
          icon: Icons.lock_outline_rounded,
          obscureText: !_isCurrentPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isCurrentPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: AppThemeColor.blue600,
              size: AppThemeResponsiveness.getQuickStatsIconSize(context),
            ),
            onPressed: () => setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter current password' : null,
        ),
        SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context)),
        AppTextFieldBuilder.build(
          context: context,
          controller: _newPasswordController,
          label: 'New Password',
          icon: Icons.lock_rounded,
          obscureText: !_isNewPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isNewPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: AppThemeColor.blue600,
              size: AppThemeResponsiveness.getQuickStatsIconSize(context),
            ),
            onPressed: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
          ),
          validator: _validateNewPassword,
        ),
        SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context)),
        AppTextFieldBuilder.build(
          context: context,
          controller: _confirmPasswordController,
          label: 'Confirm New Password',
          icon: Icons.lock_clock_rounded,
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: AppThemeColor.blue600,
              size: AppThemeResponsiveness.getQuickStatsIconSize(context),
            ),
            onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          ),
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return PrimaryButton(
      title: 'Change Password',
      onPressed: _changePassword,
      isLoading: _isLoading,
      icon: Icon(
        Icons.security_rounded,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  String? _validateNewPassword(String? value) {
    if (value!.isEmpty) return 'Please enter new password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Please confirm new password';
    if (value != _newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: AppThemeResponsiveness.getDialogWidth(context)),
            padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardPadding(context)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.green.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: AppThemeResponsiveness.isSmallPhone(context) ? 15 : 20,
                        spreadRadius: AppThemeResponsiveness.isSmallPhone(context) ? 3 : 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: AppThemeResponsiveness.getDashboardCardIconSize(context),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context)),
                Text(
                  'Password Changed!',
                  style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getWelcomeBackTextStyle(context).fontSize! * 1.4,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColor.blue800,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getQuickStatsIconPadding(context)),
                Text(
                  'Your password has been successfully updated. Your account is now more secure.',
                  textAlign: TextAlign.center,
                  style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(height: 1.5),
                ),
                SizedBox(height: AppThemeResponsiveness.getQuickStatsSpacing(context)),
                // Using PrimaryButton in the success dialog as well
                PrimaryButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}