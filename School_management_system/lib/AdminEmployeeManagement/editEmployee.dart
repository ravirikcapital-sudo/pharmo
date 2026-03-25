// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:school/customWidgets/button.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
// import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
// import 'package:school/customWidgets/inputField.dart' show AppTextFieldBuilder;
// import 'package:school/customWidgets/snackBar.dart';
// import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart';

// class AddEditEmployeePage extends StatefulWidget {
//   final Employee? employee;
//   final Function(Employee) onSave;

//   AddEditEmployeePage({
//     this.employee,
//     required this.onSave,
//   });

//   @override
//   _AddEditEmployeePageState createState() => _AddEditEmployeePageState();
// }

// class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _nameController;
//   late TextEditingController _roleController;
//   late TextEditingController _departmentController;
//   late TextEditingController _phoneController;
//   late TextEditingController _emailController;
//   late TextEditingController _genderController;
//   late TextEditingController _joiningDateController;
//   late TextEditingController _salaryController;

//   late String _employeeId;
//   bool _isLoading = false;

//   final List<String> _genders = ['Male', 'Female', 'Other'];

//   final List<String> _subjects = [
//     'Mathematics',
//     'English',
//     'Science',
//     'Commerce',
//     'Other'
//   ];

//   final List<String> _teacherRoles = [
//     'Teacher',
//     'Head Teacher',
//     'Vice Principal',
//     'Principal',
//     'Other'
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _employeeId = widget.employee?.id ?? '';

//     _nameController = TextEditingController(text: widget.employee?.name ?? '');
//     _roleController = TextEditingController(text: widget.employee?.role ?? '');
//     _departmentController =
//         TextEditingController(text: widget.employee?.department ?? '');
//     _phoneController =
//         TextEditingController(text: widget.employee?.phone ?? '');
//     _emailController =
//         TextEditingController(text: widget.employee?.email ?? '');
//     _genderController =
//         TextEditingController(text: widget.employee?.gender ?? '');
//     _joiningDateController =
//         TextEditingController(text: widget.employee?.joiningDate ?? '');
//     _salaryController =
//         TextEditingController(text: widget.employee?.salary ?? '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isEditing = widget.employee != null;

//     return Scaffold(
//       appBar: AppBarCustom(),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppThemeColor.primaryGradient,
//         ),
//         child: SafeArea(
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               padding: AppThemeResponsiveness.getScreenPadding(context),
//               child: Column(
//                 children: [
//                   _buildEmployeeIdCard(),

//                   AppTextFieldBuilder.build(
//                     context: context,
//                     controller: _nameController,
//                     label: 'Full Name',
//                     icon: Icons.person,
//                     validator: (v) =>
//                         v!.isEmpty ? 'Name is required' : null,
//                   ),

//                   _buildDropdownField(
//                     controller: _roleController,
//                     label: 'Role',
//                     icon: Icons.work,
//                     items: _teacherRoles,
//                     validator: (v) =>
//                         v == null ? 'Role is required' : null,
//                   ),

//                   _buildDropdownField(
//                     controller: _departmentController,
//                     label: 'Department',
//                     icon: Icons.school,
//                     items: _subjects,
//                     validator: (v) =>
//                         v == null ? 'Department is required' : null,
//                   ),

//                   _buildDropdownField(
//                     controller: _genderController,
//                     label: 'Gender',
//                     icon: Icons.people,
//                     items: _genders,
//                     validator: (v) =>
//                         v == null ? 'Gender is required' : null,
//                   ),

//                   _buildDateField(),

//                   AppTextFieldBuilder.build(
//                     context: context,
//                     controller: _salaryController,
//                     label: 'Salary',
//                     icon: Icons.currency_rupee,
//                     keyboardType: TextInputType.number,
//                     validator: (v) =>
//                         v!.isEmpty ? 'Salary is required' : null,
//                   ),

//                   AppTextFieldBuilder.build(
//                     context: context,
//                     controller: _phoneController,
//                     label: 'Phone',
//                     icon: Icons.phone,
//                     keyboardType: TextInputType.phone,
//                     validator: (v) =>
//                         v!.length < 10 ? 'Invalid phone number' : null,
//                   ),

//                   AppTextFieldBuilder.build(
//                     context: context,
//                     controller: _emailController,
//                     label: 'Email',
//                     icon: Icons.email,
//                     validator: (v) =>
//                         !v!.contains('@') ? 'Invalid email' : null,
//                   ),

//                   SizedBox(height: 24),

//                   _buildActionButtons(isEditing),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeIdCard() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(12),
//       margin: EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: AppThemeColor.blue50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         _employeeId.isEmpty ? 'Auto Generated ID' : _employeeId,
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildDateField() {
//     return TextFormField(
//       controller: _joiningDateController,
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: 'Joining Date',
//         prefixIcon: Icon(Icons.date_range),
//       ),
//       validator: (v) =>
//           v!.isEmpty ? 'Joining date is required' : null,
//       onTap: () async {
//         final date = await showDatePicker(
//           context: context,
//           firstDate: DateTime(2000),
//           lastDate: DateTime.now(),
//           initialDate: DateTime.now(),
//         );
//         if (date != null) {
//           _joiningDateController.text =
//               DateFormat('yyyy-MM-dd').format(date);
//         }
//       },
//     );
//   }

//   Widget _buildDropdownField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required List<String> items,
//     String? Function(String?)? validator,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: controller.text.isEmpty ? null : controller.text,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//       ),
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//       onChanged: (val) => controller.text = val ?? '',
//     );
//   }

//   Widget _buildActionButtons(bool isEditing) {
//     return Column(
//       children: [
//         PrimaryButton(
//           title: isEditing ? 'Update Employee' : 'Save Employee',
//           isLoading: _isLoading,
//           onPressed: _saveEmployee,
//         ),
//         SecondaryButton(
//           title: 'Cancel',
//           color: Colors.grey,
//           onPressed: () => Navigator.pop(context),
//         ),
//       ],
//     );
//   }

//   void _saveEmployee() {
//     if (!_formKey.currentState!.validate()) return;

//     final employee = Employee(
//       id: _employeeId.isEmpty
//           ? DateTime.now().millisecondsSinceEpoch.toString()
//           : _employeeId,
//       name: _nameController.text.trim(),
//       email: _emailController.text.trim(),
//       department: _departmentController.text.trim(),
//       salary: _salaryController.text.trim(),
//       role: _roleController.text.trim(),
//       gender: _genderController.text.trim(),
//       joiningDate: _joiningDateController.text.trim(),
//       phone: _phoneController.text.trim(), isActive: true,
//     );

//     widget.onSave(employee);

//     Navigator.pop(context);

//     AppSnackBar.show(
//       context,
//       message: widget.employee != null
//           ? 'Employee Updated Successfully'
//           : 'Employee Added Successfully',
//       backgroundColor: Colors.green,
//       icon: Icons.check,
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _roleController.dispose();
//     _departmentController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _genderController.dispose();
//     _joiningDateController.dispose();
//     _salaryController.dispose();
//     super.dispose();
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart';
import 'package:school/services/api_services.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee? employee;

  const EditEmployeePage({Key? key, this.employee}) : super(key: key);

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final departmentController = TextEditingController();
  final salaryController = TextEditingController();
  final joiningDateController = TextEditingController();

  String? selectedRole;
  String? selectedGender;
  DateTime? joiningDate;

  bool saving = false;

  final Map<String, String> roles = {
    'admin': 'Admin',
    'academic_officer': 'Academic Officer',
    'staff': 'Staff',
  };

  final Map<String, String> genders = {
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
  };

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      final emp = widget.employee!;
      nameController.text = emp.name;
      emailController.text = emp.email;
      departmentController.text = emp.department;
      salaryController.text = emp.salary;
      selectedRole = emp.role;
      selectedGender = emp.gender;

      if (emp.joiningDate.isNotEmpty) {
        joiningDate = DateTime.parse(emp.joiningDate);
        joiningDateController.text =
            DateFormat('dd-MM-yyyy').format(joiningDate!);
      }
    }
  }

  Future<void> saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    if (joiningDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select joining date")),
      );
      return;
    }

    setState(() => saving = true);

    final payload = {
      "name_write": nameController.text.trim(),
      "email_write": emailController.text.trim(),
      "department": departmentController.text.trim(),
      "salary": salaryController.text.trim(),
      "role": selectedRole,
      "gender": selectedGender,
      "joining_date": DateFormat('yyyy-MM-dd').format(joiningDate!),
    };

    late ApiResponse response;

    if (widget.employee == null) {
      response = await ApiService().createEmployee(payload);
    } else {
      response = await ApiService().updateEmployee(
        widget.employee!.id, // 🔥 SAFE, NEVER NULL
        payload,
      );
    }

    setState(() => saving = false);

    if (response.success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Save failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? "Add Employee" : "Edit Employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(v)) {
                    return "Invalid email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: salaryController,
                decoration: const InputDecoration(labelText: "Salary"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (double.tryParse(v) == null) return "Invalid number";
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: "Role"),
                items: roles.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedRole = v),
                validator: (v) => v == null ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: genders.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedGender = v),
                validator: (v) => v == null ? "Required" : null,
              ),
              TextFormField(
                controller: joiningDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Joining Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: joiningDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      joiningDate = date;
                      joiningDateController.text =
                          DateFormat('dd-MM-yyyy').format(date);
                    });
                  }
                },
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saving ? null : saveEmployee,
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
