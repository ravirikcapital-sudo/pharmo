// import 'package:flutter/material.dart';
// import 'package:school/AdminDashboardPages/assignmentTeacher.dart';
// import 'package:school/CommonLogic/tabBar.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/customWidgets/pagesMainHeading.dart';
// import 'package:school/model/dashboard/classSection.dart';
// import 'package:school/model/admission/teacherModel.dart';

// // Main Page
// class ClassSectionManagementPage extends StatefulWidget {
//   const ClassSectionManagementPage({Key? key}) : super(key: key);

//   @override
//   State<ClassSectionManagementPage> createState() => _ClassSectionManagementPageState();
// }

// class _ClassSectionManagementPageState extends State<ClassSectionManagementPage>
//     with TickerProviderStateMixin {

//   late TabController _tabController;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   // Sample Data
//   List<Teacher> teachers = [
//     Teacher(
//       id: 'T001',
//       name: 'Dr. Sarah Johnson',
//       email: 'sarah.johnson@school.edu',
//       phone: '+1-555-0101',
//       subject: 'Mathematics',
//       qualification: 'Ph.D. Mathematics',
//     ),
//     Teacher(
//       id: 'T002',
//       name: 'Prof. Michael Chen',
//       email: 'michael.chen@school.edu',
//       phone: '+1-555-0102',
//       subject: 'Physics',
//       qualification: 'M.Sc. Physics',
//     ),
//     Teacher(
//       id: 'T003',
//       name: 'Ms. Emily Davis',
//       email: 'emily.davis@school.edu',
//       phone: '+1-555-0103',
//       subject: 'English',
//       qualification: 'M.A. English Literature',
//     ),
//     Teacher(
//       id: 'T004',
//       name: 'Mr. Robert Wilson',
//       email: 'robert.wilson@school.edu',
//       phone: '+1-555-0104',
//       subject: 'History',
//       qualification: 'M.A. History',
//     ),
//     Teacher(
//       id: 'T005',
//       name: 'Dr. Lisa Anderson',
//       email: 'lisa.anderson@school.edu',
//       phone: '+1-555-0105',
//       subject: 'Chemistry',
//       qualification: 'Ph.D. Chemistry',
//     ),
//   ];

//   List<ClassSection> classSections = [
//     ClassSection(
//       id: 'CS001',
//       className: 'Grade 10',
//       sectionName: 'A',
//       classTeacherId: 'T001',
//       subjectTeacherIds: ['T001', 'T002'],
//       maxStudents: 35,
//       currentStudents: 32,
//       room: 'Room 101',
//       createdAt: DateTime.now().subtract(Duration(days: 30)),
//     ),
//     ClassSection(
//       id: 'CS002',
//       className: 'Grade 10',
//       sectionName: 'B',
//       classTeacherId: 'T003',
//       subjectTeacherIds: ['T003', 'T004'],
//       maxStudents: 35,
//       currentStudents: 28,
//       room: 'Room 102',
//       createdAt: DateTime.now().subtract(Duration(days: 25)),
//     ),
//   ];

//   List<ClassSection> filteredSections = [];
//   TextEditingController searchController = TextEditingController();
//   String selectedClassFilter = 'All';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     filteredSections = classSections;
//     searchController.addListener(_filterSections);
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _animationController.dispose();
//     searchController.dispose();
//     super.dispose();
//   }

//   void _filterSections() {
//     setState(() {
//       filteredSections = classSections.where((section) {
//         bool matchesSearch = section.fullName.toLowerCase().contains(
//           searchController.text.toLowerCase(),
//         ) || section.room.toLowerCase().contains(
//           searchController.text.toLowerCase(),
//         );

//         bool matchesFilter = selectedClassFilter == 'All' ||
//             section.className == selectedClassFilter;

//         return matchesSearch && matchesFilter && section.isActive;
//       }).toList();
//     });
//   }

//   Teacher? _getTeacherById(String teacherId) {
//     try {
//       return teachers.firstWhere((teacher) => teacher.id == teacherId);
//     } catch (e) {
//       return null;
//     }
//   }

//   void _showCreateSectionDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => CreateSectionDialog(
//         onSectionCreated: (section) {
//           setState(() {
//             classSections.add(section);
//             _filterSections();
//           });
//           _showSuccessSnackBar('Section created successfully!');
//         },
//         teachers: teachers,
//       ),
//     );
//   }

//   void _showEditSectionDialog(ClassSection section) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => EditSectionDialog(
//         section: section,
//         teachers: teachers,
//         onSectionUpdated: (updatedSection) {
//           setState(() {
//             int index = classSections.indexWhere((s) => s.id == section.id);
//             if (index != -1) {
//               classSections[index] = updatedSection;
//               _filterSections();
//             }
//           });
//           _showSuccessSnackBar('Section updated successfully!');
//         },
//       ),
//     );
//   }

//   void _showTeacherAssignmentDialog(ClassSection section) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => TeacherAssignmentDialog(
//         section: section,
//         teachers: teachers,
//         onAssignmentUpdated: (updatedSection) {
//           setState(() {
//             int index = classSections.indexWhere((s) => s.id == section.id);
//             if (index != -1) {
//               classSections[index] = updatedSection;
//               _filterSections();
//             }
//           });
//           _showSuccessSnackBar('Teachers assigned successfully!');
//         },
//       ),
//     );
//   }

//   void _deleteSection(ClassSection section) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.warning, color: Colors.red.shade600),
//             SizedBox(width: 8),
//             Text('Confirm Delete'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to delete ${section.fullName}?\n\nThis action cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 classSections.removeWhere((s) => s.id == section.id);
//                 _filterSections();
//               });
//               Navigator.pop(context);
//               _showSuccessSnackBar('Section deleted successfully!');
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white),
//             SizedBox(width: 8),
//             Text(message),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(),
//       body: Container(
//         decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
//         child: SafeArea(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Column(
//               children: [
//                 HeaderSection(
//                   title: 'Class Management',
//                   icon: Icons.school,
//                 ),
//                 CustomTabBar(
//                   controller: _tabController,
//                   tabs: const [
//                     Tab(text: 'Section'),
//                     Tab(text: 'Teachers'),
//                   ],
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       _buildSectionsTab(),
//                       _buildTeachersTab(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionsTab() {
//     return Column(
//       children: [
//         SizedBox(height: AppThemeColor.defaultSpacing),
//         _buildSearchAndFilter(),
//         SizedBox(height: AppThemeColor.defaultSpacing),
//         Expanded(child: _buildSectionsList()),
//       ],
//     );
//   }

//   Widget _buildSearchAndFilter() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
//       padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
//       decoration: BoxDecoration(
//         color: AppThemeColor.white,
//         borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           TextField(
//             controller: searchController,
//             decoration: InputDecoration(
//               hintText: 'Search sections...',
//               prefixIcon: Icon(Icons.search, color: AppThemeColor.primaryBlue),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: AppThemeColor.blue50,
//             ),
//           ),
//           SizedBox(height: AppThemeColor.smallSpacing),
//           Row(
//             children: [
//               Text('Filter by class: ', style: TextStyle(fontWeight: FontWeight.bold)),
//               Expanded(
//                 child: DropdownButton<String>(
//                   value: selectedClassFilter,
//                   isExpanded: true,
//                   underline: Container(),
//                   items: ['All', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12']
//                       .map((filter) => DropdownMenuItem(
//                     value: filter,
//                     child: Text(filter),
//                   ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedClassFilter = value!;
//                       _filterSections();
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionsList() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
//       decoration: BoxDecoration(
//         color: AppThemeColor.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(AppThemeColor.cardBorderRadius),
//           topRight: Radius.circular(AppThemeColor.cardBorderRadius),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Sections (${filteredSections.length})',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppThemeColor.primaryBlue,
//                   ),
//                 ),
//                 Icon(Icons.class_, color: AppThemeColor.primaryBlue),
//               ],
//             ),
//           ),
//           Expanded(
//             child: filteredSections.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: AppThemeColor.mediumSpacing),
//               itemCount: filteredSections.length,
//               itemBuilder: (context, index) {
//                 return _buildSectionCard(filteredSections[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionCard(ClassSection section) {
//     final classTeacher = section.classTeacherId != null
//         ? _getTeacherById(section.classTeacherId!)
//         : null;

//     return Card(
//       margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           gradient: LinearGradient(
//             colors: [Colors.white, AppThemeColor.blue50],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: ExpansionTile(
//           leading: CircleAvatar(
//             backgroundColor: AppThemeColor.primaryBlue,
//             child: Text(
//               section.sectionName,
//               style: TextStyle(
//                 color: AppThemeColor.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           title: Text(
//             section.fullName,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Room: ${section.room}'),
//               Text('Students: ${section.currentStudents}/${section.maxStudents}'),
//               if (classTeacher != null)
//                 Text('Class Teacher: ${classTeacher.name}'),
//             ],
//           ),
//           trailing: PopupMenuButton<String>(
//             onSelected: (value) {
//               switch (value) {
//                 case 'edit':
//                   _showEditSectionDialog(section);
//                   break;
//                 case 'assign':
//                   _showTeacherAssignmentDialog(section);
//                   break;
//                 case 'delete':
//                   _deleteSection(section);
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'edit',
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit, color: AppThemeColor.primaryBlue),
//                     SizedBox(width: 8),
//                     Text('Edit Section'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'assign',
//                 child: Row(
//                   children: [
//                     Icon(Icons.assignment_ind, color: Colors.green),
//                     SizedBox(width: 8),
//                     Text('Assign Teachers'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'delete',
//                 child: Row(
//                   children: [
//                     Icon(Icons.delete, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text('Delete'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           children: [
//             Padding(
//               padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildInfoRow('Max Students', '${section.maxStudents}'),
//                   _buildInfoRow('Current Students', '${section.currentStudents}'),
//                   _buildInfoRow('Room', section.room),
//                   _buildInfoRow('Created',
//                       '${section.createdAt.day}/${section.createdAt.month}/${section.createdAt.year}'),
//                   if (section.subjectTeacherIds.isNotEmpty) ...[
//                     SizedBox(height: AppThemeColor.smallSpacing),
//                     Text(
//                       'Subject Teachers:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     ...section.subjectTeacherIds.map((teacherId) {
//                       final teacher = _getTeacherById(teacherId);
//                       return teacher != null
//                           ? Padding(
//                         padding: EdgeInsets.only(left: 16, top: 4),
//                         child: Text('• ${teacher.name} (${teacher.subject})'),
//                       )
//                           : Container();
//                     }).toList(),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               '$label:',
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTeachersTab() {
//     return Container(
//       margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
//       decoration: BoxDecoration(
//         color: AppThemeColor.white,
//         borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Teachers (${teachers.length})',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppThemeColor.primaryBlue,
//                   ),
//                 ),
//                 Icon(Icons.people, color: AppThemeColor.primaryBlue),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: AppThemeColor.mediumSpacing),
//               itemCount: teachers.length,
//               itemBuilder: (context, index) {
//                 return _buildTeacherCard(teachers[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTeacherCard(Teacher teacher) {
//     final assignedSections = classSections
//         .where((section) =>
//     section.classTeacherId == teacher.id ||
//         section.subjectTeacherIds.contains(teacher.id))
//         .toList();

//     return Card(
//       margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
//         leading: CircleAvatar(
//           backgroundColor: teacher.isAvailable ? AppThemeColor.primaryBlue : Colors.grey,
//           child: Text(
//             teacher.name.substring(0, 1).toUpperCase(),
//             style: TextStyle(
//               color: AppThemeColor.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         title: Text(
//           teacher.name,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Subject: ${teacher.subject}'),
//             Text('Email: ${teacher.email}'),
//             Text('Qualification: ${teacher.qualification}'),
//             if (assignedSections.isNotEmpty)
//               Text('Assigned to: ${assignedSections.map((s) => s.fullName).join(', ')}'),
//           ],
//         ),
//         trailing: Container(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: teacher.isAvailable ? Colors.green.shade100 : Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             teacher.isAvailable ? 'Available' : 'Unavailable',
//             style: TextStyle(
//               color: teacher.isAvailable ? Colors.green.shade800 : Colors.grey.shade800,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.class_,
//             size: 64,
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: AppThemeColor.smallSpacing),
//           Text(
//             'No sections found',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           SizedBox(height: AppThemeColor.smallSpacing),
//           ElevatedButton.icon(
//             onPressed: _showCreateSectionDialog,
//             icon: Icon(Icons.add),
//             label: Text('Create Section'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppThemeColor.primaryBlue,
//               foregroundColor: AppThemeColor.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Create Section Dialog
// class CreateSectionDialog extends StatefulWidget {
//   final Function(ClassSection) onSectionCreated;
//   final List<Teacher> teachers;

//   const CreateSectionDialog({
//     Key? key,
//     required this.onSectionCreated,
//     required this.teachers,
//   }) : super(key: key);

//   @override
//   State<CreateSectionDialog> createState() => _CreateSectionDialogState();
// }

// class _CreateSectionDialogState extends State<CreateSectionDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _classNameController = TextEditingController();
//   final _sectionNameController = TextEditingController();
//   final _maxStudentsController = TextEditingController();
//   final _roomController = TextEditingController();

//   String? selectedClassTeacher;
//   List<String> selectedSubjectTeachers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.9,
//         height: MediaQuery.of(context).size.height * 0.8,
//         padding: EdgeInsets.all(AppThemeColor.defaultSpacing),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Create New Section',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: AppThemeColor.primaryBlue,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppThemeColor.defaultSpacing),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildTextField(
//                         'Class Name',
//                         _classNameController,
//                         Icons.class_,
//                         'Enter class name (e.g., Grade 10)',
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildTextField(
//                         'Section Name',
//                         _sectionNameController,
//                         Icons.label,
//                         'Enter section (e.g., A, B, C)',
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildTextField(
//                         'Room Number',
//                         _roomController,
//                         Icons.room,
//                         'Enter room number',
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildTextField(
//                         'Max Students',
//                         _maxStudentsController,
//                         Icons.people,
//                         'Enter maximum students',
//                         keyboardType: TextInputType.number,
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildDropdown(
//                         'Class Teacher',
//                         selectedClassTeacher,
//                         widget.teachers.map((t) => DropdownMenuItem(
//                           value: t.id,
//                           child: Container(
//                             constraints: BoxConstraints(
//                               maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit width to 70% of screen
//                             ),
//                             child: Text(
//                               '${t.name} (${t.subject})',
//                               overflow: TextOverflow.ellipsis, // Handle long text
//                               style: TextStyle(
//                                 fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16, // Responsive font size
//                               ),
//                             ),
//                           ),
//                         )).toList(),
//                             (value) => setState(() => selectedClassTeacher = value),
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildMultiSelect(),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: AppThemeColor.defaultSpacing),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('Cancel'),
//                   ),
//                   SizedBox(width: AppThemeColor.smallSpacing),
//                   ElevatedButton(
//                     onPressed: _createSection,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppThemeColor.primaryBlue,
//                       foregroundColor: AppThemeColor.white,
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     child: Text('Create Section'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label,
//       TextEditingController controller,
//       IconData icon,
//       String hint, {
//         TextInputType keyboardType = TextInputType.text,
//       }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon, color: AppThemeColor.primaryBlue),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//           borderSide: BorderSide(
//             color: AppThemeColor.primaryBlue,
//             width: AppThemeColor.focusedBorderWidth,
//           ),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $label';
//         }
//         if (keyboardType == TextInputType.number) {
//           if (int.tryParse(value) == null || int.parse(value) <= 0) {
//             return 'Please enter a valid number';
//           }
//         }
//         return null;
//       },
//     );
//   }

// // Responsive dropdown widget
//   Widget _buildDropdown(
//       String label,
//       String? value,
//       List<DropdownMenuItem<String>> items,
//       Function(String?) onChanged,
//       ) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isSmallScreen = screenWidth < 600;
//     final isMediumScreen = screenWidth >= 600 && screenWidth < 1024;

//     return Container(
//       width: double.infinity,
//       constraints: BoxConstraints(
//         maxWidth: isSmallScreen
//             ? screenWidth * 0.9
//             : isMediumScreen
//             ? screenWidth * 0.7
//             : screenWidth * 0.5,
//       ),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         isExpanded: true, // Important: prevents overflow
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(
//             fontSize: isSmallScreen ? 14 : 16,
//           ),
//           prefixIcon: Icon(
//             Icons.person,
//             color: AppThemeColor.primaryBlue,
//             size: isSmallScreen ? 20 : 24,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//             borderSide: BorderSide(
//               color: AppThemeColor.primaryBlue,
//               width: AppThemeColor.focusedBorderWidth,
//             ),
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: isSmallScreen ? 12 : 16,
//             vertical: isSmallScreen ? 12 : 16,
//           ),
//         ),
//         items: items,
//         onChanged: onChanged,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please select $label';
//           }
//           return null;
//         },
//         // Responsive dropdown styling
//         style: TextStyle(
//           fontSize: isSmallScreen ? 14 : 16,
//           color: Colors.black87,
//         ),
//         icon: Icon(
//           Icons.keyboard_arrow_down,
//           size: isSmallScreen ? 20 : 24,
//         ),
//         // Handle dropdown menu constraints
//         menuMaxHeight: screenHeight * 0.4, // Limit dropdown height
//       ),
//     );
//   }

//   Widget _buildMultiSelect() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Subject Teachers',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//           ),
//           child: Column(
//             children: widget.teachers.map((teacher) {
//               final isSelected = selectedSubjectTeachers.contains(teacher.id);
//               return CheckboxListTile(
//                 title: Text(teacher.name),
//                 subtitle: Text(teacher.subject),
//                 value: isSelected,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value == true) {
//                       selectedSubjectTeachers.add(teacher.id);
//                     } else {
//                       selectedSubjectTeachers.remove(teacher.id);
//                     }
//                   });
//                 },
//                 activeColor: AppThemeColor.primaryBlue,
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   void _createSection() {
//     if (_formKey.currentState!.validate()) {
//       final newSection = ClassSection(
//         id: 'CS${DateTime.now().millisecondsSinceEpoch}',
//         className: _classNameController.text.trim(),
//         sectionName: _sectionNameController.text.trim().toUpperCase(),
//         classTeacherId: selectedClassTeacher,
//         subjectTeacherIds: selectedSubjectTeachers,
//         maxStudents: int.parse(_maxStudentsController.text),
//         room: _roomController.text.trim(),
//         createdAt: DateTime.now(),
//       );

//       widget.onSectionCreated(newSection);
//       Navigator.pop(context);
//     }
//   }
// }

// // Edit Section Dialog
// class EditSectionDialog extends StatefulWidget {
//   final ClassSection section;
//   final List<Teacher> teachers;
//   final Function(ClassSection) onSectionUpdated;

//   const EditSectionDialog({
//     Key? key,
//     required this.section,
//     required this.teachers,
//     required this.onSectionUpdated,
//   }) : super(key: key);

//   @override
//   State<EditSectionDialog> createState() => _EditSectionDialogState();
// }

// class _EditSectionDialogState extends State<EditSectionDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _classNameController;
//   late TextEditingController _sectionNameController;
//   late TextEditingController _maxStudentsController;
//   late TextEditingController _roomController;

//   String? selectedClassTeacher;
//   List<String> selectedSubjectTeachers = [];

//   @override
//   void initState() {
//     super.initState();
//     _classNameController = TextEditingController(text: widget.section.className);
//     _sectionNameController = TextEditingController(text: widget.section.sectionName);
//     _maxStudentsController = TextEditingController(text: widget.section.maxStudents.toString());
//     _roomController = TextEditingController(text: widget.section.room);
//     selectedClassTeacher = widget.section.classTeacherId;
//     selectedSubjectTeachers = List.from(widget.section.subjectTeacherIds);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.9,
//         height: MediaQuery.of(context).size.height * 0.8,
//         padding: EdgeInsets.all(AppThemeColor.defaultSpacing),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Edit Section',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: AppThemeColor.primaryBlue,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppThemeColor.defaultSpacing),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildTextField(
//                         'Class Name',
//                         _classNameController,
//                         Icons.class_,
//                         'Enter class name (e.g., Grade 10)',
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildTextField(
//                         'Section Name',
//                         _sectionNameController,
//                         Icons.label,
//                         'Enter section (e.g., A, B, C)',
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildTextField(
//                         'Room Number',
//                         _roomController,
//                         Icons.room,
//                         'Enter room number',
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildTextField(
//                         'Max Students',
//                         _maxStudentsController,
//                         Icons.people,
//                         'Enter maximum students',
//                         keyboardType: TextInputType.number,
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildDropdown(
//                         'Class Teacher',
//                         selectedClassTeacher,
//                         [
//                           DropdownMenuItem<String>(
//                             value: null,
//                             child: Text('No Class Teacher'),
//                           ),
//                           ...widget.teachers.map((t) => DropdownMenuItem(
//                             value: t.id,
//                             child: Text('${t.name} (${t.subject})'),
//                           )).toList(),
//                         ],
//                             (value) => setState(() => selectedClassTeacher = value),
//                       ),
//                       SizedBox(height: AppThemeColor.mediumSpacing),
//                       _buildMultiSelect(),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: AppThemeColor.defaultSpacing),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('Cancel'),
//                   ),
//                   SizedBox(width: AppThemeColor.smallSpacing),
//                   ElevatedButton(
//                     onPressed: _updateSection,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppThemeColor.primaryBlue,
//                       foregroundColor: AppThemeColor.white,
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     child: Text('Update Section'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label,
//       TextEditingController controller,
//       IconData icon,
//       String hint, {
//         TextInputType keyboardType = TextInputType.text,
//       }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon, color: AppThemeColor.primaryBlue),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//           borderSide: BorderSide(
//             color: AppThemeColor.primaryBlue,
//             width: AppThemeColor.focusedBorderWidth,
//           ),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $label';
//         }
//         if (keyboardType == TextInputType.number) {
//           if (int.tryParse(value) == null || int.parse(value) <= 0) {
//             return 'Please enter a valid number';
//           }
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildDropdown(
//       String label,
//       String? value,
//       List<DropdownMenuItem<String?>> items,
//       Function(String?) onChanged,
//       ) {
//     return DropdownButtonFormField<String?>(
//       value: value,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(Icons.person, color: AppThemeColor.primaryBlue),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//           borderSide: BorderSide(
//             color: AppThemeColor.primaryBlue,
//             width: AppThemeColor.focusedBorderWidth,
//           ),
//         ),
//       ),
//       items: items,
//       onChanged: onChanged,
//     );
//   }

//   Widget _buildMultiSelect() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Subject Teachers',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
//           ),
//           child: Column(
//             children: widget.teachers.map((teacher) {
//               final isSelected = selectedSubjectTeachers.contains(teacher.id);
//               return CheckboxListTile(
//                 title: Text(teacher.name),
//                 subtitle: Text(teacher.subject),
//                 value: isSelected,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value == true) {
//                       selectedSubjectTeachers.add(teacher.id);
//                     } else {
//                       selectedSubjectTeachers.remove(teacher.id);
//                     }
//                   });
//                 },
//                 activeColor: AppThemeColor.primaryBlue,
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   void _updateSection() {
//     if (_formKey.currentState!.validate()) {
//       final updatedSection = widget.section.copyWith(
//         className: _classNameController.text.trim(),
//         sectionName: _sectionNameController.text.trim().toUpperCase(),
//         classTeacherId: selectedClassTeacher,
//         subjectTeacherIds: selectedSubjectTeachers,
//         maxStudents: int.parse(_maxStudentsController.text),
//         room: _roomController.text.trim(),
//       );

//       widget.onSectionUpdated(updatedSection);
//       Navigator.pop(context);
//     }
//   }
// }

  import 'package:flutter/material.dart';
  import 'package:school/CommonLogic/tabBar.dart';
  import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
  import 'package:school/customWidgets/pagesMainHeading.dart';
  import 'package:school/model/dashboard/classSection.dart';
  import 'package:school/model/admission/teacherModel.dart';
  import 'package:school/services/api_services.dart';

  class ClassSectionManagementPage extends StatefulWidget {
  const ClassSectionManagementPage({Key? key}) : super(key: key);

  @override
  State<ClassSectionManagementPage> createState() =>
      _ClassSectionManagementPageState();
}

class _ClassSectionManagementPageState
    extends State<ClassSectionManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<ClassSection> sections = [];
  List<ClassSection> filteredSections = [];
  List<Teacher> teachers = [];

  bool loading = true;
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    searchCtrl.addListener(_filter);
    _loadData();
  }

  Future<void> _loadData() async {
    loading = true;
    setState(() {});
    sections = await ApiService.fetchSections();
    teachers = await ApiService.fetchTeachers();
    filteredSections = sections;
    loading = false;
    setState(() {});
  }

  void _filter() {
    final q = searchCtrl.text.toLowerCase();
    filteredSections = sections.where((s) {
      return s.fullName.toLowerCase().contains(q) ||
          s.room.toLowerCase().contains(q);
    }).toList();
    setState(() {});
  }

  Teacher? _teacherById(String? id) {
    if (id == null) return null;
    try {
      return teachers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Management"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreate(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _tabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _sectionsTab(),
                      _teachersTab(),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
          ),
          labelColor: Colors.white,
          // allowImplicitScrolling: true,
          tabs: const [
            Tab(text: "Section"),
            Tab(text: "Teachers"),
          ],
        ),
      ),
    );
  }

  Widget _sectionsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search sections...",
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredSections.length,
            itemBuilder: (_, i) =>
                _sectionCard(filteredSections[i]),
          ),
        )
      ],
    );
  }

  Widget _sectionCard(ClassSection s) {
    final teacher = _teacherById(s.classTeacherId);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("Room: ${s.room}"),
            Text("Students: ${s.currentStudents}/${s.maxStudents}"),
            Text("Class Teacher: ${teacher?.name ?? "Not Assigned"}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _openEdit(s),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await ApiService.deleteSection(s.id as ClassSection);
                    _loadData();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _teachersTab() {
    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (_, i) {
        final t = teachers[i];
        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(t.name[0]),
            ),
            title: Text(t.name),
            subtitle: Text(t.subject),
            trailing: Chip(
              label: Text(t.isAvailable ? "Available" : "Busy"),
              backgroundColor:
                  t.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
            ),
          ),
        );
      },
    );
  }

  void _openCreate() {
    showDialog(
      context: context,
      builder: (_) => SectionDialog(
        teachers: teachers,
        onSave: (s) async {
          await ApiService.createSection(s);
          Navigator.pop(context);
          _loadData();
        },
      ),
    );
  }

  void _openEdit(ClassSection s) {
    showDialog(
      context: context,
      builder: (_) => SectionDialog(
        section: s,
        teachers: teachers,
        onSave: (updated) async {
          await ApiService.updateSection(updated);
          Navigator.pop(context);
          _loadData();
        },
      ),
    );
  }
}


class SectionDialog extends StatefulWidget {
  final ClassSection? section;
  final List<Teacher> teachers;
  final Function(ClassSection) onSave;

  const SectionDialog({
    Key? key,
    this.section,
    required this.teachers,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SectionDialog> createState() => _SectionDialogState();
}

class _SectionDialogState extends State<SectionDialog> {
  final classCtrl = TextEditingController();
  final sectionCtrl = TextEditingController();
  final roomCtrl = TextEditingController();

  String? teacherId;

  @override
  void initState() {
    super.initState();
    if (widget.section != null) {
      classCtrl.text = widget.section!.className;
      sectionCtrl.text = widget.section!.sectionName;
      roomCtrl.text = widget.section!.room;
      teacherId = widget.section!.classTeacherId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.section == null ? "Create Section" : "Edit Section"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: classCtrl,
              decoration: const InputDecoration(labelText: "Class Name"),
            ),
            TextField(
              controller: sectionCtrl,
              decoration: const InputDecoration(labelText: "Section"),
            ),
            TextField(
              controller: roomCtrl,
              decoration: const InputDecoration(labelText: "Room"),
            ),
            DropdownButtonFormField<String>(
              value: teacherId,
              hint: const Text("Class Teacher"),
              items: widget.teachers
                  .map((t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.name),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => teacherId = v),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final className = classCtrl.text.trim();
            final sectionName = sectionCtrl.text.trim();

            widget.onSave(
              ClassSection(
                id: widget.section?.id ?? "",
                className: className,
                sectionName: sectionName,
                fullName: "$className - $sectionName",
                room: roomCtrl.text.trim(),
                classTeacherId: teacherId,
                subjectTeacherIds: const [],
                currentStudents: widget.section?.currentStudents ?? 0,
                maxStudents: widget.section?.maxStudents ?? 35,
                isActive: true,
                classId: '',
              ),
            );
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}