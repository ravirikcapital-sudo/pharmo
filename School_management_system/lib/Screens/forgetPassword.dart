import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isEmailMethod = true;
  bool _isOtpSent = false;
  bool _isEmailVerified = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: _buildMainCard(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Container(
      width: AppThemeResponsiveness.getMaxWidth(context),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Padding(
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isOtpSent) ...[
                  _buildMethodSelector(context),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                  _buildInputForm(context),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                  _buildSendButton(context),
                ] else ...[
                  _buildOtpVerificationSection(context),
                ],
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildHelpSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Choose Recovery Method',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: AppThemeColor.blue600,
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        Row(
          children: [
            Expanded(
              child: _buildMethodCard(
                context,
                title: 'Email',
                subtitle: 'Send reset link via email',
                icon: Icons.email,
                isSelected: _isEmailMethod,
                onTap: () => setState(() => _isEmailMethod = true),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: _buildMethodCard(
                context,
                title: 'SMS',
                subtitle: 'Send OTP via SMS',
                icon: Icons.sms,
                isSelected: !_isEmailMethod,
                onTap: () => setState(() => _isEmailMethod = false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppThemeResponsiveness.getCardPadding(context) * 0.8,
        decoration: BoxDecoration(
          color: isSelected ? AppThemeColor.blue600.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          border: Border.all(
            color: isSelected ? AppThemeColor.blue600 : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: AppThemeResponsiveness.getIconSize(context),
              color: isSelected ? AppThemeColor.blue600 : Colors.grey[600],
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              title,
              style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppThemeColor.blue600 : Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: AppThemeResponsiveness.getCaptionTextStyle(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isEmailMethod ? 'Email Address' : 'Phone Number',
          style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            color: AppThemeColor.blue600,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        // Using custom AppTextFieldBuilder
        AppTextFieldBuilder.build(
          context: context,
          controller: _isEmailMethod ? _emailController : _phoneController,
          label: _isEmailMethod
              ? 'Enter your registered email'
              : 'Enter your registered phone number',
          icon: _isEmailMethod ? Icons.email_outlined : Icons.phone_outlined,
          keyboardType: _isEmailMethod ? TextInputType.emailAddress : TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _isEmailMethod
                  ? 'Please enter your email address'
                  : 'Please enter your phone number';
            }
            if (_isEmailMethod && !value.contains('@')) {
              return 'Please enter a valid email address';
            }
            if (!_isEmailMethod && value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.blue[600],
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  _isEmailMethod
                      ? 'We\'ll send a password reset link to your email'
                      : 'We\'ll send a 6-digit OTP to your phone',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(BuildContext context) {
    // Using custom PrimaryButton
    return PrimaryButton(
      title: _isEmailMethod ? 'Send Reset Link' : 'Send OTP',
      icon: Icon(
        _isEmailMethod ? Icons.send : Icons.sms,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
      onPressed: _sendResetRequest,
      isLoading: _isLoading,
    );
  }

  Widget _buildOtpVerificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              _isEmailMethod ? 'Email Sent!' : 'OTP Sent!',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                color: Colors.green[600],
              ),
            ),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          padding: AppThemeResponsiveness.getCardPadding(context),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEmailMethod ? 'Check Your Email' : 'Enter the OTP',
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                _isEmailMethod
                    ? 'We\'ve sent a password reset link to ${_emailController.text}. Click the link in the email to reset your password.'
                    : 'We\'ve sent a 6-digit OTP to ${_phoneController.text}. Enter the OTP below to proceed.',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: Colors.green[700],
                  height: 1.4,
                ),
              ),
              if (!_isEmailMethod) ...[
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                // Using custom AppTextFieldBuilder for OTP input
                AppTextFieldBuilder.build(
                  context: context,
                  controller: _otpController,
                  label: 'Enter 6-digit OTP',
                  icon: Icons.security,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                // Using custom PrimaryButton for OTP verification
                PrimaryButton(
                  title: 'Verify OTP',
                  icon: Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  ),
                  onPressed: _verifyOtp,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() {
                _isOtpSent = false;
                _emailController.clear();
                _phoneController.clear();
                _otpController.clear();
              }),
              child: Text(
                'Try Different Method',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: AppThemeColor.blue600,
                ),
              ),
            ),
            TextButton(
              onPressed: _resendCode,
              child: Text(
                'Resend Code',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: AppThemeColor.blue600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: Colors.grey[600],
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Need Help?',
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'If you\'re having trouble resetting your password, please contact our support team.',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          AppThemeResponsiveness.isSmallPhone(context)
              ? Column(
            children: [
              // Using custom SecondaryButton for support actions
              SecondaryButton(
                title: 'Call Support',
                icon: Icon(Icons.phone, size: AppThemeResponsiveness.getIconSize(context) * 0.7),
                color: AppThemeColor.blue600,
                onPressed: _contactSupport,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              SecondaryButton(
                title: 'Email Us',
                icon: Icon(Icons.email, size: AppThemeResponsiveness.getIconSize(context) * 0.7),
                color: AppThemeColor.blue600,
                onPressed: _emailSupport,
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  title: 'Call',
                  icon: Icon(Icons.phone, size: AppThemeResponsiveness.getIconSize(context) * 0.7),
                  color: AppThemeColor.blue600,
                  onPressed: _contactSupport,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: SecondaryButton(
                  title: 'Email Us',
                  icon: Icon(Icons.email, size: AppThemeResponsiveness.getIconSize(context) * 0.7),
                  color: AppThemeColor.blue600,
                  onPressed: _emailSupport,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendResetRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });

      AppSnackBar.show(
        context,
        message: _isEmailMethod
            ? 'Reset link sent to your email!'
            : 'OTP sent to your phone!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      AppSnackBar.show(
        context,
        message: 'OTP verified successfully!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/reset-password');
      });
    } else {
      AppSnackBar.show(
        context,
        message: 'Please enter a valid 6-digit OTP',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  void _resendCode() async {
    AppSnackBar.show(
      context,
      message: _isEmailMethod ? 'Reset link sent again!' : 'OTP sent again!',
      backgroundColor: AppThemeColor.blue600,
      icon: Icons.refresh,
    );
  }

  void _contactSupport() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+1-800-SCHOOL');
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Unable to open phone dialer',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  void _emailSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@school.edu',
      queryParameters: {
        'subject': 'Password Reset Support Request',
        'body': 'Hello Support Team,\n\nI need help with resetting my password. Please assist me.\n\nThank you,',
      },
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Unable to open email app',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }
}