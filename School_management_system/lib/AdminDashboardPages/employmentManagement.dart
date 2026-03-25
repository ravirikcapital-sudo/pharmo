// import 'package:flutter/material.dart';
// import 'package:school/AdminEmployeeManagement/editEmployee.dart';
// import 'package:school/AdminEmployeeManagement/teacherDetails.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/customWidgets/pagesMainHeading.dart';
// import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart';

// // Main Teacher Management Page
// class EmployeeManagementPage extends StatefulWidget {
//   @override
//   _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
// }

// class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
//   List<Employee> employees = [
//     Employee(
//       id: 'TCH001',
//       name: 'Sarah Johnson',
//       role: 'Mathematics Teacher',
//       department: 'Mathematics',
//       phone: '+91 9876543210',
//       email: 'sarah.johnson@school.edu',
//     ),
//     Employee(
//       id: 'TCH002',
//       name: 'Michael Davis',
//       role: 'English Teacher',
//       department: 'English',
//       phone: '+91 9876543211',
//       email: 'michael.davis@school.edu',
//     ),
//     Employee(
//       id: 'TCH003',
//       name: 'Emily Rodriguez',
//       role: 'Science Teacher',
//       department: 'Science',
//       phone: '+91 9876543212',
//       email: 'emily.rodriguez@school.edu',
//     ),
//     Employee(
//       id: 'TCH004',
//       name: 'David Wilson',
//       role: 'Physical Education Teacher',
//       department: 'Physical Education',
//       phone: '+91 9876543213',
//       email: 'david.wilson@school.edu',
//     ),
//     Employee(
//       id: 'TCH005',
//       name: 'Lisa Chen',
//       role: 'Art Teacher',
//       department: 'Arts',
//       phone: '+91 9876543214',
//       email: 'lisa.chen@school.edu',
//     ),
//   ];

//   List<Employee> filteredEmployees = [];
//   TextEditingController searchController = TextEditingController();
//   String selectedDepartmentFilter = 'All';

//   @override
//   void initState() {
//     super.initState();
//     filteredEmployees = employees;
//     searchController.addListener(_filterEmployees);
//   }

//   void _filterEmployees() {
//     setState(() {
//       filteredEmployees = employees.where((employee) {
//         bool matchesSearch = employee.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
//             employee.id.toLowerCase().contains(searchController.text.toLowerCase()) ||
//             employee.email.toLowerCase().contains(searchController.text.toLowerCase()) ||
//             employee.role.toLowerCase().contains(searchController.text.toLowerCase()) ||
//             employee.department.toLowerCase().contains(searchController.text.toLowerCase());

//         bool matchesDepartment = selectedDepartmentFilter == 'All' ||
//             employee.department == selectedDepartmentFilter;

//         return matchesSearch && matchesDepartment;
//       }).toList();
//     });
//   }

//   List<String> get availableDepartments {
//     Set<String> departments = employees.map((e) => e.department).toSet();
//     return ['All', ...departments.toList()..sort()];
//   }

//   String _generateEmployeeId() {
//     int nextId = employees.length + 1;
//     return 'TCH${nextId.toString().padLeft(3, '0')}';
//   }

//   void _addEmployee(Employee employee) {
//     setState(() {
//       employees.add(employee);
//       _filterEmployees();
//     });
//   }

//   void _updateEmployee(int index, Employee employee) {
//     setState(() {
//       int originalIndex = employees.indexWhere((e) => e.id == filteredEmployees[index].id);
//       employees[originalIndex] = employee;
//       _filterEmployees();
//     });
//   }

//   void _deleteEmployee(int index) {
//     setState(() {
//       int originalIndex = employees.indexWhere((e) => e.id == filteredEmployees[index].id);
//       employees.removeAt(originalIndex);
//       _filterEmployees();
//     });
//   }

//   // Get responsive cross axis count based on screen width
//   int _getResponsiveCrossAxisCount(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth > 1400) return 5;
//     if (screenWidth > 1200) return 4;
//     if (screenWidth > 900) return 3;
//     if (screenWidth > 600) return 2;
//     return 1;
//   }

//   // Get responsive card width
//   double _getCardWidth(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final crossAxisCount = _getResponsiveCrossAxisCount(context);
//     final availableWidth = screenWidth - 64; // padding
//     final cardWidth = (availableWidth / crossAxisCount) - 16; // spacing
//     return cardWidth.clamp(280.0, 320.0); // min-max width
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppThemeColor.primaryGradient,
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.only(
//               top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
//               bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
//               left: AppThemeResponsiveness.getSmallSpacing(context),
//               right: AppThemeResponsiveness.getSmallSpacing(context),
//             ),
//             child: Column(
//               children: [
//                 HeaderSection(
//                   title: 'Employee Management',
//                   icon: Icons.group,
//                 ),
//                 Expanded(
//                   child: Container(
//                     constraints: BoxConstraints(
//                       maxWidth: AppThemeResponsiveness.getMaxWidth(context),
//                     ),
//                     margin: EdgeInsets.symmetric(
//                       horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppThemeColor.white,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           spreadRadius: 2,
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         // Search and Filter Section
//                         _buildSearchSection(context),

//                         // Employees Header
//                         _buildEmployeesHeader(context),

//                         // Employees List/Grid
//                         Expanded(
//                           child: _buildEmployeesList(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: _buildFloatingActionButton(context),
//     );
//   }

//   Widget _buildSearchSection(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
//       padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
//       decoration: BoxDecoration(
//         color: AppThemeColor.blue50,
//         borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           TextField(
//             controller: searchController,
//             style: AppThemeResponsiveness.getBodyTextStyle(context),
//             decoration: InputDecoration(
//               hintText: 'Name, ID, email, role, department',
//               hintStyle: AppThemeResponsiveness.getInputHintStyle(context),
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: AppThemeColor.primaryBlue,
//                 size: AppThemeResponsiveness.getIconSize(context),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: AppThemeColor.white,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
//                 vertical: AppThemeResponsiveness.getMediumSpacing(context),
//               ),
//             ),
//           ),
//           SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
//           Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Text(
//                   'Filter by subject: ',
//                   style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppThemeColor.blue800,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppThemeResponsiveness.getSmallSpacing(context),
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppThemeColor.white,
//                     borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
//                     border: Border.all(
//                       color: AppThemeColor.blue200,
//                       width: 1,
//                     ),
//                   ),
//                   child: DropdownButton<String>(
//                     value: selectedDepartmentFilter,
//                     isExpanded: true,
//                     underline: Container(),
//                     style: AppThemeResponsiveness.getBodyTextStyle(context),
//                     items: availableDepartments.map((department) {
//                       return DropdownMenuItem(
//                         value: department,
//                         child: Text(
//                           department,
//                           style: AppThemeResponsiveness.getBodyTextStyle(context),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedDepartmentFilter = value!;
//                         _filterEmployees();
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmployeesHeader(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
//         vertical: AppThemeResponsiveness.getMediumSpacing(context),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Teachers (${filteredEmployees.length})',
//             style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
//               color: AppThemeColor.primaryBlue,
//               fontSize: AppThemeResponsiveness.getResponsiveFontSize(
//                 context,
//                 AppThemeResponsiveness.getHeadingStyle(context).fontSize! + 4,
//               ),
//             ),
//           ),
//           Icon(
//             Icons.school,
//             color: AppThemeColor.primaryBlue,
//             size: AppThemeResponsiveness.getIconSize(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmployeesList(BuildContext context) {
//     if (filteredEmployees.isEmpty) {
//       return _buildEmptyState(context);
//     }

//     return AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)
//         ? _buildEmployeesGrid(context)
//         : _buildEmployeesListView(context);
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.search_off,
//             size: AppThemeResponsiveness.getEmptyStateIconSize(context),
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
//           Text(
//             'No teachers found',
//             style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
//               color: Colors.grey.shade600,
//             ),
//           ),
//           SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
//           Text(
//             'Try adjusting your search or filter',
//             style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmployeesGrid(BuildContext context) {
//     final crossAxisCount = _getResponsiveCrossAxisCount(context);
//     final cardWidth = _getCardWidth(context);

//     return GridView.builder(
//       padding: EdgeInsets.all(16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: cardWidth / 280, // Fixed height ratio
//       ),
//       itemCount: filteredEmployees.length,
//       itemBuilder: (context, index) {
//         return _buildEmployeeGridCard(context, filteredEmployees[index], index);
//       },
//     );
//   }

//   Widget _buildEmployeesListView(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
//       itemCount: filteredEmployees.length,
//       itemBuilder: (context, index) {
//         return _buildEmployeeCard(context, filteredEmployees[index], index);
//       },
//     );
//   }

//   Widget _buildEmployeeGridCard(BuildContext context, Employee employee, int index) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppThemeColor.blue50,
//             AppThemeColor.white,
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             spreadRadius: 1,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TeacherDetailsPage(teacher: employee),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with avatar and menu
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: AppThemeColor.primaryBlue,
//                     radius: 20,
//                     child: Text(
//                       employee.name.substring(0, 1).toUpperCase(),
//                       style: TextStyle(
//                         color: AppThemeColor.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   _buildEmployeePopupMenu(context, employee, index),
//                 ],
//               ),
//               SizedBox(height: 12),

//               // Name
//               Text(
//                 employee.name,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               SizedBox(height: 4),

//               // ID
//               Text(
//                 'ID: ${employee.id}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               SizedBox(height: 4),

//               // Role
//               Text(
//                 employee.role,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey.shade700,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               SizedBox(height: 4),

//               // Department
//               Text(
//                 employee.department,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: AppThemeColor.primaryBlue,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),

//               Spacer(),

//               // Contact info
//               Row(
//                 children: [
//                   Icon(
//                     Icons.phone,
//                     size: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                   SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       employee.phone,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade700,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 4),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.email,
//                     size: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                   SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       employee.email,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade700,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeCard(BuildContext context, Employee employee, int index) {
//     return Container(
//       margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppThemeColor.blue50,
//             AppThemeColor.white,
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
//         leading: CircleAvatar(
//           backgroundColor: AppThemeColor.primaryBlue,
//           radius: AppThemeResponsiveness.getDashboardCardIconSize(context) * 0.6,
//           child: Text(
//             employee.name.substring(0, 1).toUpperCase(),
//             style: TextStyle(
//               color: AppThemeColor.white,
//               fontWeight: FontWeight.bold,
//               fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
//             ),
//           ),
//         ),
//         title: Text(
//           employee.name,
//           style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
//             Text(
//               'ID: ${employee.id}',
//               style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
//             ),
//             SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
//             Text(
//               '${employee.role} • ${employee.department}',
//               style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
//             ),
//             SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
//             Row(
//               children: [
//                 Icon(
//                   Icons.phone,
//                   size: AppThemeResponsiveness.getIconSize(context) * 0.7,
//                   color: Colors.grey.shade600,
//                 ),
//                 SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
//                 Expanded(
//                   child: Text(
//                     employee.phone,
//                     style: AppThemeResponsiveness.getBodyTextStyle(context),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
//             Row(
//               children: [
//                 Icon(
//                   Icons.email,
//                   size: AppThemeResponsiveness.getIconSize(context) * 0.7,
//                   color: Colors.grey.shade600,
//                 ),
//                 SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
//                 Expanded(
//                   child: Text(
//                     employee.email,
//                     style: AppThemeResponsiveness.getBodyTextStyle(context),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: _buildEmployeePopupMenu(context, employee, index),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TeacherDetailsPage(teacher: employee),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmployeePopupMenu(BuildContext context, Employee employee, int index) {
//     return PopupMenuButton<String>(
//       icon: Icon(
//         Icons.more_vert,
//         color: AppThemeColor.primaryBlue,
//         size: 20,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       onSelected: (value) {
//         if (value == 'update') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddEditEmployeePage(
//                 employee: employee,
//                 employeeIndex: index,
//                 onSave: (updatedEmployee) => _updateEmployee(index, updatedEmployee),
//               ),
//             ),
//           );
//         } else if (value == 'delete') {
//           _showDeleteDialog(index);
//         }
//       },
//       itemBuilder: (BuildContext context) => [
//         PopupMenuItem(
//           value: 'update',
//           child: Row(
//             children: [
//               Icon(
//                 Icons.edit,
//                 color: AppThemeColor.primaryBlue,
//                 size: 16,
//               ),
//               SizedBox(width: 8),
//               Text('Update'),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 'delete',
//           child: Row(
//             children: [
//               Icon(
//                 Icons.delete,
//                 color: Colors.red,
//                 size: 16,
//               ),
//               SizedBox(width: 8),
//               Text('Delete'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFloatingActionButton(BuildContext context) {
//     return FloatingActionButton.extended(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AddEditEmployeePage(
//               employeeId: _generateEmployeeId(),
//               onSave: _addEmployee,
//             ),
//           ),
//         );
//       },
//       backgroundColor: AppThemeColor.primaryBlue,
//       foregroundColor: AppThemeColor.white,
//       elevation: AppThemeResponsiveness.getButtonElevation(context),
//       icon: Icon(
//         Icons.person_add,
//         size: AppThemeResponsiveness.getIconSize(context),
//       ),
//       label: Text(
//         'Add Teacher',
//         style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
//       ),
//     );
//   }

//   void _showDeleteDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//           ),
//           title: Text(
//             'Delete Teacher',
//             style: AppThemeResponsiveness.getHeadingStyle(context),
//           ),
//           content: Text(
//             'Are you sure you want to delete ${filteredEmployees[index].name}?',
//             style: AppThemeResponsiveness.getBodyTextStyle(context),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: AppThemeColor.primaryBlue,
//                   fontSize: AppThemeResponsiveness.getButtonTextStyle(context).fontSize,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
//               child: ElevatedButton(
//                 onPressed: () {
//                   _deleteEmployee(index);
//                   Navigator.of(context).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Teacher deleted successfully!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
//                   ),
//                 ),
//                 child: Text(
//                   'Delete',
//                   style: AppThemeResponsiveness.getButtonTextStyle(context),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:school/AdminEmployeeManagement/editEmployee.dart';
import 'package:school/services/api_services.dart';
import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class EmploymentManagementPage extends StatefulWidget {
  const EmploymentManagementPage({super.key});

  @override
  State<EmploymentManagementPage> createState() =>
      _EmploymentManagementPageState();
}

class _EmploymentManagementPageState extends State<EmploymentManagementPage> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  int employeeCount = 0;
  bool loading = false;
  
  final TextEditingController searchController = TextEditingController();
  String selectedDepartmentFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchEmployeesAndCount();
    searchController.addListener(_filterEmployees);
  }

  List<String> get availableDepartments {
    if (employees.isEmpty) return ['All'];
    Set<String> departments = employees
        .where((e) => e.department.isNotEmpty)
        .map((e) => e.department)
        .toSet();
    return ['All', ...departments.toList()..sort()];
  }

  void _filterEmployees() {
    setState(() {
      filteredEmployees = employees.where((employee) {
        final searchTerm = searchController.text.toLowerCase();
        bool matchesSearch = searchTerm.isEmpty ||
            employee.name.toLowerCase().contains(searchTerm) ||
            employee.id.toString().toLowerCase().contains(searchTerm) ||
            employee.email.toLowerCase().contains(searchTerm) ||
            employee.role.toLowerCase().contains(searchTerm) ||
            employee.phone.toLowerCase().contains(searchTerm) ||
            employee.department.toLowerCase().contains(searchTerm);

        bool matchesDepartment = selectedDepartmentFilter == 'All' ||
            employee.department == selectedDepartmentFilter;

        return matchesSearch && matchesDepartment;
      }).toList();
    });
  }

  Future<void> fetchEmployeesAndCount() async {
    setState(() => loading = true);

    try {
      final empRes = await ApiService().getEmployees();
      final countRes = await ApiService().getEmployeeCount();

      if (empRes.success && empRes.data != null) {
        employees = (empRes.data as List)
            .map((e) => Employee.fromJson(e))
            .toList();
        filteredEmployees = employees;
      }

      if (countRes.success) {
        employeeCount = countRes.data ?? 0;
      }
    } catch (e) {
      debugPrint("ERROR FETCHING EMPLOYEES: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading employees: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => loading = false);
  }

  Future<void> deleteEmployee(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete $name?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService().deleteEmployee(id);
        await fetchEmployeesAndCount();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Employee deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting employee: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  int _getResponsiveCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1400) return 5;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 900) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  double _getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getResponsiveCrossAxisCount(context);
    final availableWidth = screenWidth - 64;
    final cardWidth = (availableWidth / crossAxisCount) - 16;
    return cardWidth.clamp(280.0, 320.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              left: AppThemeResponsiveness.getSmallSpacing(context),
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Teacher Management',
                  icon: Icons.group,
                ),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _buildSearchSection(context),
                        ),
                        SliverToBoxAdapter(
                          child: _buildEmployeesHeader(context),
                        ),
                        _buildEmployeesListSliver(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
            decoration: InputDecoration(
              hintText: 'Name, ID, email, phone, role, department',
              hintStyle: AppThemeResponsiveness.getInputHintStyle(context),
              prefixIcon: Icon(
                Icons.search,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: AppThemeResponsiveness.getIconSize(context),
                      ),
                      onPressed: () {
                        searchController.clear();
                        _filterEmployees();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppThemeColor.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                vertical: AppThemeResponsiveness.getMediumSpacing(context),
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Filter by department: ',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppThemeColor.blue800,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    border: Border.all(
                      color: AppThemeColor.blue200,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedDepartmentFilter,
                    isExpanded: true,
                    underline: Container(),
                    style: AppThemeResponsiveness.getBodyTextStyle(context),
                    items: availableDepartments.map((department) {
                      return DropdownMenuItem(
                        value: department,
                        child: Text(
                          department,
                          style: AppThemeResponsiveness.getBodyTextStyle(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartmentFilter = value!;
                        _filterEmployees();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
        vertical: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loading
                ? 'Loading...'
                : 'Teachers (${filteredEmployees.length})',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: AppThemeColor.primaryBlue,
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                context,
                AppThemeResponsiveness.getHeadingStyle(context).fontSize! + 4,
              ),
            ),
          ),
          Row(
            children: [
              if (!loading)
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppThemeColor.primaryBlue,
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                  onPressed: fetchEmployeesAndCount,
                  tooltip: 'Refresh',
                ),
              Icon(
                Icons.school,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesList(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppThemeColor.primaryBlue),
        ),
      );
    }

    if (filteredEmployees.isEmpty) {
      return _buildEmptyState(context);
    }

    return AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)
        ? _buildEmployeesGrid(context)
        : _buildEmployeesListView(context);
  }

  Widget _buildEmployeesListSliver(BuildContext context) {
    if (loading) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppThemeColor.primaryBlue),
          ),
        ),
      );
    }

    if (filteredEmployees.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(context),
      );
    }

    if (AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)) {
      final crossAxisCount = _getResponsiveCrossAxisCount(context);
      final cardWidth = _getCardWidth(context);

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: cardWidth / 280,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildEmployeeGridCard(context, filteredEmployees[index]);
            },
            childCount: filteredEmployees.length,
          ),
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildEmployeeCard(context, filteredEmployees[index]);
            },
            childCount: filteredEmployees.length,
          ),
        ),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: AppThemeResponsiveness.getEmptyStateIconSize(context),
            color: Colors.grey.shade400,
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            employees.isEmpty ? 'No teachers found' : 'No matching teachers',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            employees.isEmpty
                ? 'Start by adding your first teacher'
                : 'Try adjusting your search or filter',
            style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesGrid(BuildContext context) {
    final crossAxisCount = _getResponsiveCrossAxisCount(context);
    final cardWidth = _getCardWidth(context);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: cardWidth / 280,
      ),
      itemCount: filteredEmployees.length,
      itemBuilder: (context, index) {
        return _buildEmployeeGridCard(context, filteredEmployees[index]);
      },
    );
  }

  Widget _buildEmployeesListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: filteredEmployees.length,
      itemBuilder: (context, index) {
        return _buildEmployeeCard(context, filteredEmployees[index]);
      },
    );
  }



  Widget _buildEmployeeGridCard(BuildContext context, Employee employee) {
    return InkWell(
      onTap: () => _showEmployeeDetailsDialog(context, employee),
      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppThemeColor.blue50,
              AppThemeColor.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: employee.isActive ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        employee.isActive ? Icons.check_circle : Icons.cancel,
                        size: 14,
                        color: employee.isActive ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        employee.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                          color: employee.isActive ? Colors.green.shade700 : Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppThemeColor.primaryBlue,
                    size: AppThemeResponsiveness.getIconSize(context) - 4,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) => _handleMenuAction(value as String, employee),
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            CircleAvatar(
              radius: AppThemeResponsiveness.getIconSize(context) * 1.5,
              backgroundColor: AppThemeColor.primaryBlue,
              child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              employee.name,
              style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                color: AppThemeColor.blue800,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppThemeColor.blue100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                employee.role,
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: AppThemeColor.primaryBlue,
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildInfoRow(
              context,
              Icons.business,
              employee.department,
              AppThemeColor.blue600,
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            _buildInfoRow(
              context,
              Icons.phone,
              employee.phone,
              AppThemeColor.primaryBlue,
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            _buildInfoRow(
              context,
              Icons.email,
              employee.email,
              AppThemeColor.blue700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppThemeResponsiveness.getIconSize(context) - 8,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
              color: AppThemeColor.blue700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppThemeColor.blue50,
            AppThemeColor.white,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEmployeeDetailsDialog(context, employee),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        child: Padding(
          padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppThemeResponsiveness.getIconSize(context) * 1.2,
                backgroundColor: AppThemeColor.primaryBlue,
                child: Text(
                  employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                        color: AppThemeColor.blue800,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: AppThemeResponsiveness.getIconSize(context) - 8,
                          color: AppThemeColor.primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            employee.role,
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: AppThemeColor.primaryBlue,
                              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: AppThemeResponsiveness.getIconSize(context) - 8,
                          color: AppThemeColor.blue600,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            employee.department,
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: AppThemeColor.blue700,
                              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 13),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: AppThemeResponsiveness.getIconSize(context) - 8,
                          color: AppThemeColor.primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            employee.phone,
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: AppThemeColor.blue700,
                              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 13),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: AppThemeResponsiveness.getIconSize(context) - 8,
                          color: AppThemeColor.blue700,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            employee.email,
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: AppThemeColor.blue700,
                              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 13),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: employee.isActive ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          employee.isActive ? Icons.check_circle : Icons.cancel,
                          size: 14,
                          color: employee.isActive ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          employee.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                            color: employee.isActive ? Colors.green.shade700 : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppThemeColor.primaryBlue,
                      size: AppThemeResponsiveness.getIconSize(context),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) => _handleMenuAction(value as String, employee),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Employee emp) async {
    if (action == 'edit') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditEmployeePage(employee: emp)),
      );
      if (result == true) {
        fetchEmployeesAndCount();
      }
    } else if (action == 'delete') {
      deleteEmployee(emp.id as int, emp.name);
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditEmployeePage()),
        );
        if (result == true) {
          fetchEmployeesAndCount();
        }
      },
      icon: Icon(
        Icons.person_add,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      label: Text(
        'Add Teacher',
        style: TextStyle(
          fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppThemeColor.primaryBlue,
      elevation: 6,
    );
  }

  void _showEmployeeDetailsDialog(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppThemeColor.primaryBlue,
              radius: AppThemeResponsiveness.getIconSize(context) * 0.8,
              child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                employee.name,
                style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                  color: AppThemeColor.blue800,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, Icons.badge, 'ID', employee.id.toString()),
              _buildDetailRow(context, Icons.work, 'Role', employee.role),
              _buildDetailRow(context, Icons.business, 'Department', employee.department),
              _buildDetailRow(context, Icons.phone, 'Phone', employee.phone),
              _buildDetailRow(context, Icons.email, 'Email', employee.email),
              _buildDetailRow(context, Icons.attach_money, 'Salary', '\$${employee.salary}'),
              _buildDetailRow(context, Icons.calendar_today, 'Joining Date', employee.joiningDate),
              _buildDetailRow(
                context,
                employee.isActive ? Icons.check_circle : Icons.cancel,
                'Status',
                employee.isActive ? 'Active' : 'Inactive',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppThemeColor.blue600,
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _handleMenuAction('edit', employee);
            },
            icon: const Icon(Icons.edit),
            label: Text(
              'Edit',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColor.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                vertical: AppThemeResponsiveness.getSmallSpacing(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: AppThemeResponsiveness.getIconSize(context) - 4,
            color: AppThemeColor.primaryBlue,
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14),
                    color: AppThemeColor.blue800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
