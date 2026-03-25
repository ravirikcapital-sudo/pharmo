import 'package:flutter/material.dart';
import 'package:school/AdminStudentManagement/idCreation.dart';
import 'package:school/AdminStudentManagement/studentModel.dart';
import 'package:school/StudentDashboardPages/attendanceStudent.dart';
import 'package:school/StudentDashboardPages/feeManagementStudent/feeManagementStudent.dart';
import 'package:school/StudentDashboardPages/subjectAndMarks.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDetailsPage extends StatefulWidget {
  final Student student;

  const StudentDetailsPage({Key? key, required this.student}) : super(key: key);

  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  // State variables
  bool _isEditing = false;
  bool _isSaving = false;
  late Student _editableStudent;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    _editableStudent = widget.student;
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // MARK: - Controller Management
  void _initializeControllers() {
    _nameController = TextEditingController(text: _editableStudent.name);
    _emailController = TextEditingController(text: _editableStudent.email);
    _phoneController = TextEditingController(text: _editableStudent.phone);
    _addressController = TextEditingController(text: _editableStudent.address);
    _classController = TextEditingController(text: _editableStudent.className);
  }

  void _disposeControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _classController.dispose();
  }

  // MARK: - Helper Methods
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // MARK: - External Actions
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(launchUri);
    } catch (e) {
      _showErrorSnackBar('Could not launch phone call to $phoneNumber');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(launchUri);
    } catch (e) {
      _showErrorSnackBar('Could not launch email to $email');
    }
  }

  Future<void> _sendWhatsAppMessage(String phoneNumber) async {
    // Remove any non-numeric characters from phone number
    String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Add country code if not present (adjust according to your country)
    // For India: uncomment the line below
    // if (!cleanPhoneNumber.startsWith('+91') && !cleanPhoneNumber.startsWith('91')) {
    //   cleanPhoneNumber = '91$cleanPhoneNumber';
    // }

    // Try multiple WhatsApp URL formats
    List<String> whatsappUrls = [
      'whatsapp://send?phone=$cleanPhoneNumber',
      'https://wa.me/$cleanPhoneNumber',
      'https://api.whatsapp.com/send?phone=$cleanPhoneNumber'
    ];

    bool launched = false;

    for (String url in whatsappUrls) {
      try {
        final Uri whatsappUri = Uri.parse(url);

        // Try to launch without canLaunchUrl check first
        if (await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
          launched = true;
          break;
        }
      } catch (e) {
        // Continue to next URL format
        continue;
      }
    }

    // If none of the URLs worked, show error
    if (!launched) {
      _showErrorSnackBar('WhatsApp is not available on this device');
    }
  }

  // NEW: SMS messaging functionality
  Future<void> _sendSMSMessage(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        _showErrorSnackBar('Could not open SMS app');
      }
    } catch (e) {
      _showErrorSnackBar('Could not launch SMS to $phoneNumber');
    }
  }

  // MARK: - UI Feedback
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // MARK: - Edit Operations
  Future<void> _toggleEdit() async {
    if (_isEditing) {
      await _saveChanges();
    } else {
      _enterEditMode();
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _editableStudent = Student(
        id: _editableStudent.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        className: _classController.text,
        dateOfBirth: _editableStudent.dateOfBirth,
        admissionStatus: _editableStudent.admissionStatus,
      );
      _isEditing = false;
      _isSaving = false;
    });

    _showSuccessSnackBar('Student information updated successfully');
  }

  void _enterEditMode() {
    setState(() => _isEditing = true);
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _initializeControllers(); // Reset controllers to original values
    });
  }

  // MARK: - Navigation Methods
  void _navigateToAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentAttendanceReport()),
    );
  }

  void _navigateToFee() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeeManagementScreenStudent()),
    );
  }

  void _navigateToMarks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubjectsMarksScreen()),
    );
  }

  void _navigateToIdCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentIdCreationPage(student: _editableStudent),
      ),
    );
  }

  // MARK: - Widget Builders - Common Components
  Widget _buildDetailCard(
      BuildContext context,
      String title,
      String value,
      IconData icon, {
        Widget? trailing,
      }) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppThemeResponsiveness.getInputLabelStyle(context).copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Text(
                    value,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableDetailCard(
      BuildContext context,
      String title,
      TextEditingController controller,
      IconData icon,
      ) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppThemeResponsiveness.getInputLabelStyle(context).copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  TextField(
                    controller: controller,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppThemeResponsiveness.getInputBorderRadius(context),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                        vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Widget for phone number with multiple action buttons
  Widget _buildPhoneDetailCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        child: Row(
          children: [
            Icon(
              Icons.phone,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    style: AppThemeResponsiveness.getInputLabelStyle(context).copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Text(
                    _editableStudent.phone,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons for phone
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.green),
                  onPressed: () => _makePhoneCall(_editableStudent.phone),
                  tooltip: 'Call',
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.blue),
                  onPressed: () => _sendSMSMessage(_editableStudent.phone),
                  tooltip: 'Send SMS',
                ),
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.green),
                  onPressed: () => _sendWhatsAppMessage(_editableStudent.phone),
                  tooltip: 'WhatsApp',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - Widget Builders - Main Sections
  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Flexible(
              child: Text(
                _isEditing ? 'Edit Student Details' : 'Student Details',
                style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                    context,
                    AppThemeResponsiveness.getSectionTitleStyle(context).fontSize! + 4,
                  ),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context) * 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppThemeResponsiveness.getLargeSpacing(context)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
            gradient: LinearGradient(
              colors: [
                AppThemeColor.primaryBlue,
                AppThemeColor.primaryBlue.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: AppThemeResponsiveness.getResponsiveSize(context, 35, 45, 55),
                backgroundColor: Colors.white,
                child: Text(
                  _editableStudent.name.substring(0, 1).toUpperCase(),
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 32),
                    fontWeight: FontWeight.bold,
                    color: AppThemeColor.primaryBlue,
                  ),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              Text(
                _editableStudent.name,
                style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                _editableStudent.className,
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildStatusBadge(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getMediumSpacing(context),
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(_editableStudent.admissionStatus).withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(
          color: _getStatusColor(_editableStudent.admissionStatus),
          width: AppThemeResponsiveness.getFocusedBorderWidth(context),
        ),
      ),
      child: Text(
        _editableStudent.admissionStatus,
        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Information',
                style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                  color: AppThemeColor.primaryBlue,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              ..._buildDetailFields(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailFields(BuildContext context) {
    return [
      // Student ID (non-editable)
      _buildDetailCard(context, 'Student ID', _editableStudent.id, Icons.badge),

      // Email
      _isEditing
          ? _buildEditableDetailCard(context, 'Email Address', _emailController, Icons.email)
          : _buildDetailCard(
        context,
        'Email Address',
        _editableStudent.email,
        Icons.email,
        trailing: IconButton(
          icon: Icon(Icons.email_outlined, color: AppThemeColor.primaryBlue),
          onPressed: () => _sendEmail(_editableStudent.email),
          tooltip: 'Send Email',
        ),
      ),

      // Phone - Updated with multiple action buttons
      _isEditing
          ? _buildEditableDetailCard(context, 'Phone Number', _phoneController, Icons.phone)
          : _buildPhoneDetailCard(context),

      // Date of Birth (non-editable)
      _buildDetailCard(
        context,
        'Date of Birth',
        _formatDate(_editableStudent.dateOfBirth),
        Icons.cake,
      ),

      // Age (calculated, non-editable)
      _buildDetailCard(
        context,
        'Age',
        '${_calculateAge(_editableStudent.dateOfBirth)} years old',
        Icons.person,
      ),

      // Class
      _isEditing
          ? _buildEditableDetailCard(context, 'Class', _classController, Icons.school)
          : _buildDetailCard(context, 'Class', _editableStudent.className, Icons.school),

      // Address
      _isEditing
          ? _buildEditableDetailCard(context, 'Address', _addressController, Icons.location_on)
          : _buildDetailCard(
        context,
        'Address',
        _editableStudent.address.isEmpty ? 'Not provided' : _editableStudent.address,
        Icons.location_on,
      ),
    ];
  }

  // MARK: - Button Creation Methods
  Widget _createEditSaveButton(BuildContext context) {
    return PrimaryButton(
      title: _isEditing ? 'Save Changes' : 'Edit Student',
      onPressed: _toggleEdit,
      isLoading: _isSaving,
      color: _isEditing ? Colors.green : AppThemeColor.primaryBlue,
      icon: Icon(
        _isEditing ? Icons.save : Icons.edit,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createCancelButton(BuildContext context) {
    return SecondaryButton(
      title: 'Cancel',
      onPressed: _cancelEdit,
      color: Colors.orange,
      icon: Icon(
        Icons.cancel,
        color: Colors.orange,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createAttendanceButton(BuildContext context, {Color? color}) {
    return PrimaryButton(
      title: 'Attendance',
      onPressed: _navigateToAttendance,
      color: color ?? Colors.green,
      icon: Icon(
        Icons.calendar_today,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createFeeButton(BuildContext context) {
    return PrimaryButton(
      title: 'Fee Paid',
      onPressed: _navigateToFee,
      color: Colors.orange,
      icon: Icon(
        Icons.account_balance_wallet,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createMarksButton(BuildContext context) {
    return PrimaryButton(
      title: 'Marks and Grades',
      onPressed: _navigateToMarks,
      color: Colors.red,
      icon: Icon(
        Icons.school,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createIdCreationButton(BuildContext context) {
    return PrimaryButton(
      title: 'Create ID',
      onPressed: _navigateToIdCreation,
      color: Colors.orange,
      icon: Icon(
        Icons.create_new_folder_outlined,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  // NEW: WhatsApp button
  Widget _createWhatsAppButton(BuildContext context) {
    return PrimaryButton(
      title: 'WhatsApp',
      onPressed: () => _sendWhatsAppMessage(_editableStudent.phone),
      color: Colors.green,
      icon: Icon(
        Icons.chat,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  // NEW: SMS button
  Widget _createSMSButton(BuildContext context) {
    return PrimaryButton(
      title: 'Message',
      onPressed: () => _sendSMSMessage(_editableStudent.phone),
      color: Colors.blue,
      icon: Icon(
        Icons.message,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createBackButton(BuildContext context) {
    return SecondaryButton(
      title: 'Back to List',
      onPressed: () => Navigator.pop(context),
      color: AppThemeColor.primaryBlue,
      icon: Icon(
        Icons.arrow_back,
        color: AppThemeColor.primaryBlue,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  // MARK: - Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
      ),
      child: AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)
          ? _buildDesktopActionButtons(context)
          : _buildMobileActionButtons(context),
    );
  }

  // Updated desktop action buttons with WhatsApp and SMS
  Widget _buildDesktopActionButtons(BuildContext context) {
    if (_isEditing) {
      return Column(
        children: [
          // First row: Edit/Save and Cancel
          Row(
            children: [
              Expanded(child: _createEditSaveButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createCancelButton(context)),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

          // Second row: Other action buttons
          Row(
            children: [
              Expanded(child: _createAttendanceButton(context, color: Colors.purple)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createFeeButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createMarksButton(context)),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

          // Third row: Communication and other buttons
          Row(
            children: [
              Expanded(child: _createWhatsAppButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createSMSButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createIdCreationButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createBackButton(context)),
            ],
          ),
        ],
      );
    } else {
      // When not editing, show all buttons in three rows
      return Column(
        children: [
          // First row: Edit, Attendance, Fee buttons
          Row(
            children: [
              Expanded(child: _createEditSaveButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createAttendanceButton(context, color: Colors.purple)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createFeeButton(context)),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

          // Second row: Marks, WhatsApp, SMS buttons
          Row(
            children: [
              Expanded(child: _createMarksButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createWhatsAppButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createSMSButton(context)),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

          // Third row: Create ID, Back buttons
          Row(
            children: [
              Expanded(child: _createIdCreationButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createBackButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: Container()), // Empty space for symmetry
            ],
          ),
        ],
      );
    }
  }

  // Updated mobile action buttons with WhatsApp and SMS
  Widget _buildMobileActionButtons(BuildContext context) {
    return Column(
      children: [
        // Edit/Save Button
        _createEditSaveButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Cancel Button (only shown when editing)
        if (_isEditing) ...[
          _createCancelButton(context),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        ],

        // Attendance Button
        _createAttendanceButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Fee Button
        _createFeeButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Marks Button
        _createMarksButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // WhatsApp Button
        _createWhatsAppButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // SMS Button
        _createSMSButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Create ID Button
        _createIdCreationButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Back Button
        _createBackButton(context),
      ],
    );
  }

  // MARK: - Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              left: AppThemeResponsiveness.getSmallSpacing(context),
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                _buildProfileCard(context),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildDetailsSection(context),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}