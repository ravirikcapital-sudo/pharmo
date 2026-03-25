import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/teacherDashboardPages/teacherSalary.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart';

class TeacherDetailsPage extends StatefulWidget {
  final Employee teacher;

  const TeacherDetailsPage({Key? key, required this.teacher}) : super(key: key);

  @override
  State<TeacherDetailsPage> createState() => _TeacherDetailsPageState();
}

class _TeacherDetailsPageState extends State<TeacherDetailsPage> {
  bool isEditing = false;
  bool _isSaving = false;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController departmentController;
  late TextEditingController addressController;
  late TextEditingController emergencyContactController;
  late TextEditingController qualificationController;
  late TextEditingController experienceController;
  late TextEditingController subjectController;
  late Employee currentTeacher;

  // Non-editable fields
  late String joiningDate;
  late String employeeStatus;
  late String salary;

  @override
  void initState() {
    super.initState();
    currentTeacher = widget.teacher;
    nameController = TextEditingController(text: currentTeacher.name);
    phoneController = TextEditingController(text: currentTeacher.phone);
    emailController = TextEditingController(text: currentTeacher.email);
    departmentController = TextEditingController(text: currentTeacher.department);

    // Initialize new controllers with sample data
    addressController = TextEditingController(text: "123 Main Street, City, State - 12345");
    emergencyContactController = TextEditingController(text: "+1 234 567 8900");
    qualificationController = TextEditingController(text: "M.Ed, B.Ed");
    experienceController = TextEditingController(text: "5 years");
    subjectController = TextEditingController(text: "Mathematics, Physics");

    // Non-editable fields
    joiningDate = "January 15, 2020";
    employeeStatus = "Active";
    salary = "₹45,000/month";
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    departmentController.dispose();
    addressController.dispose();
    emergencyContactController.dispose();
    qualificationController.dispose();
    experienceController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  // MARK: - Navigation Methods
  void _navigateToSalary() {
    // Navigate to teacher salary page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalaryManagementScreenTeacher(),
      ),
    );
  }

  // MARK: - External Actions
  Future<void> _makePhoneCall(String phone) async {
    try {
      // Copy phone number to clipboard
      await Clipboard.setData(ClipboardData(text: phone));
      // Launch phone call
      final Uri phoneUri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch phone call';
      }
      // Show confirmation
      AppSnackBar.show(
        context,
        message: 'Phone number $phone copied to clipboard',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error: Could not make phone call',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    try {
      // Copy email to clipboard
      await Clipboard.setData(ClipboardData(text: email));

      // Launch email client
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=Regarding Teacher Information',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch email client';
      }
      // Show confirmation
      AppSnackBar.show(
        context,
        message: 'Email address $email copied to clipboard',
        backgroundColor: Colors.blue,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error: Could not open email client',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  // MARK: - Edit Operations
  Future<void> _toggleEdit() async {
    if (isEditing) {
      await _saveChanges();
    } else {
      _enterEditMode();
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Update the current teacher object with new values
    setState(() {
      // currentTeacher = Employee(
      //   id: currentTeacher.id,
      //   name: nameController.text,
      //   phone: phoneController.text,
      //   email: emailController.text,
      //   department: departmentController.text,
      //   role: currentTeacher.role,
      //    gender: '', salary: '', joiningDate: '', isActive: null,
      // );
      isEditing = false;
      _isSaving = false;
    });

    // Show success message
    AppSnackBar.show(
      context,
      message: 'Teacher details updated successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );

    // Here you would typically also save to your backend/database
    print('Updated teacher: ${currentTeacher.name}');
  }

  void _enterEditMode() {
    setState(() => isEditing = true);
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      // Reset controllers to original values
      nameController.text = currentTeacher.name;
      phoneController.text = currentTeacher.phone;
      emailController.text = currentTeacher.email;
      departmentController.text = currentTeacher.department;
      addressController.text = "123 Main Street, City, State - 12345";
      emergencyContactController.text = "+1 234 567 8900";
      qualificationController.text = "M.Ed, B.Ed";
      experienceController.text = "5 years";
      subjectController.text = "Mathematics, Physics";
    });
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
      IconData icon, {
        int maxLines = 1,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    maxLines: maxLines,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                isEditing ? 'Edit Teacher Details' : 'Teacher Details',
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
                  currentTeacher.name.substring(0, 1).toUpperCase(),
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 32),
                    fontWeight: FontWeight.bold,
                    color: AppThemeColor.primaryBlue,
                  ),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              Text(
                currentTeacher.name,
                style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                currentTeacher.role,
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: AppThemeResponsiveness.getFocusedBorderWidth(context),
                  ),
                ),
                child: Text(
                  currentTeacher.department,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                      vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    child: Text(
                      employeeStatus,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                      ),
                    ),
                  ),
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white.withOpacity(0.8),
                    size: AppThemeResponsiveness.getIconSize(context) * 0.7,
                  ),
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Text(
                    joiningDate,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      child: Column(
        children: [
          // Basic Information
          Card(
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
                    'Basic Information',
                    style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                      color: AppThemeColor.primaryBlue,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  ..._buildBasicFields(context),
                ],
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          // Professional Information
          Card(
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
                    'Professional Information',
                    style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                      color: AppThemeColor.primaryBlue,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  ..._buildProfessionalFields(context),
                ],
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          // Employment Information
          Card(
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
                    'Employment Information',
                    style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                      color: AppThemeColor.primaryBlue,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  ..._buildEmploymentFields(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBasicFields(BuildContext context) {
    return [
      // Teacher ID (non-editable)
      _buildDetailCard(context, 'Teacher ID', currentTeacher.id as String, Icons.badge),

      // Name
      isEditing
          ? _buildEditableDetailCard(context, 'Name', nameController, Icons.person)
          : _buildDetailCard(context, 'Name', currentTeacher.name, Icons.person),

      // Email
      isEditing
          ? _buildEditableDetailCard(context, 'Email Address', emailController, Icons.email)
          : _buildDetailCard(
        context,
        'Email Address',
        currentTeacher.email,
        Icons.email,
        trailing: IconButton(
          icon: Icon(Icons.email_outlined, color: AppThemeColor.primaryBlue),
          onPressed: () => _sendEmail(currentTeacher.email),
          tooltip: 'Send Email',
        ),
      ),

      // Phone
      isEditing
          ? _buildEditableDetailCard(context, 'Phone Number', phoneController, Icons.phone)
          : _buildDetailCard(
        context,
        'Phone Number',
        currentTeacher.phone,
        Icons.phone,
        trailing: IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: () => _makePhoneCall(currentTeacher.phone),
          tooltip: 'Call',
        ),
      ),

      // Address
      isEditing
          ? _buildEditableDetailCard(context, 'Address', addressController, Icons.location_on, maxLines: 2)
          : _buildDetailCard(context, 'Address', addressController.text, Icons.location_on),

      // Emergency Contact
      isEditing
          ? _buildEditableDetailCard(context, 'Emergency Contact', emergencyContactController, Icons.contact_emergency)
          : _buildDetailCard(context, 'Emergency Contact', emergencyContactController.text, Icons.contact_emergency),
    ];
  }

  List<Widget> _buildProfessionalFields(BuildContext context) {
    return [
      // Department
      isEditing
          ? _buildEditableDetailCard(context, 'Department', departmentController, Icons.school)
          : _buildDetailCard(context, 'Department', currentTeacher.department, Icons.school),

      // Role (non-editable)
      _buildDetailCard(context, 'Role', currentTeacher.role, Icons.work),

      // Subjects
      isEditing
          ? _buildEditableDetailCard(context, 'Subjects', subjectController, Icons.subject)
          : _buildDetailCard(context, 'Subjects', subjectController.text, Icons.subject),

      // Qualification
      isEditing
          ? _buildEditableDetailCard(context, 'Qualification', qualificationController, Icons.school_outlined)
          : _buildDetailCard(context, 'Qualification', qualificationController.text, Icons.school_outlined),

      // Experience
      isEditing
          ? _buildEditableDetailCard(context, 'Experience', experienceController, Icons.timeline)
          : _buildDetailCard(context, 'Experience', experienceController.text, Icons.timeline),
    ];
  }

  List<Widget> _buildEmploymentFields(BuildContext context) {
    return [
      // Joining Date (non-editable)
      _buildDetailCard(context, 'Joining Date', joiningDate, Icons.calendar_today),

      // Employee Status (non-editable)
      _buildDetailCard(context, 'Status', employeeStatus, Icons.verified_user),
    ];
  }

  // MARK: - Button Creation Methods
  Widget _createEditSaveButton(BuildContext context) {
    return PrimaryButton(
      title: isEditing ? 'Save Changes' : 'Edit Teacher',
      onPressed: _toggleEdit,
      isLoading: _isSaving,
      color: isEditing ? Colors.green : AppThemeColor.primaryBlue,
      icon: Icon(
        isEditing ? Icons.save : Icons.edit,
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

  Widget _createSalaryButton(BuildContext context) {
    return PrimaryButton(
      title: 'Salary',
      onPressed: _navigateToSalary,
      color: Colors.green,
      icon: Icon(
        Icons.attach_money,
        color: Colors.white,
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      ),
    );
  }

  Widget _createCallButton(BuildContext context) {
    return PrimaryButton(
      title: 'Call',
      onPressed: () => _makePhoneCall(currentTeacher.phone),
      color: Colors.green,
      icon: Icon(
        Icons.phone,
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

  Widget _buildDesktopActionButtons(BuildContext context) {
    if (isEditing) {
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

          // Second row: Salary and Back to List
          Row(
            children: [
              Expanded(child: _createSalaryButton(context)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(child: _createBackButton(context)),
            ],
          ),
        ],
      );
    } else {
      // When not editing, show Edit, Salary, and Back to List in one row
      return Row(
        children: [
          Expanded(child: _createEditSaveButton(context)),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(child: _createSalaryButton(context)),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(child: _createBackButton(context)),
        ],
      );
    }
  }

  Widget _buildMobileActionButtons(BuildContext context) {
    return Column(
      children: [
        // Edit/Save Button
        _createEditSaveButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Cancel Button (only shown when editing)
        if (isEditing) ...[
          _createCancelButton(context),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        ],

        // Salary Button
        _createSalaryButton(context),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

        // Back Button
        _createBackButton(context),
      ],
    );
  }
}