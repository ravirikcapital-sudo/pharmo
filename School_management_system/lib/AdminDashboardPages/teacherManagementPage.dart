import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:school/services/api_services.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/AdminDashboardPages/addTeacher.dart';

class TeacherManagementPage extends StatefulWidget {
  const TeacherManagementPage({super.key});

  @override
  State<TeacherManagementPage> createState() => _TeacherManagementPageState();
}

class _TeacherManagementPageState extends State<TeacherManagementPage> {
  List<dynamic> teachers = [];
  List<dynamic> filteredTeachers = [];
  bool isLoading = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
    searchController.addListener(_filterTeachers);
  }

  Future<void> _loadTeachers() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final response = await ApiService().getTeachers();

      if (response.success && response.data != null) {
        teachers = List.from(response.data!);
        filteredTeachers = List.from(teachers);
      } else {
        throw Exception(response.message ?? 'Failed to load teachers');
      }
    } catch (e) {
      debugPrint("Error loading teachers: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load teachers: $e'), backgroundColor: Colors.red),
        );
      }
    }

    if (mounted) setState(() => isLoading = false);
  }

  void _filterTeachers() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      filteredTeachers = teachers.where((teacher) {
        final name = (teacher['full_name'] ?? teacher['name'] ?? '').toString().toLowerCase();
        final email = (teacher['email'] ?? '').toString().toLowerCase();
        final phone = (teacher['phone'] ?? '').toString().toLowerCase();
        return query.isEmpty ||
            name.contains(query) ||
            email.contains(query) ||
            phone.contains(query);
      }).toList();
    });
  }

  void _showAddTeacherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  AddTeacherScreen()),
    ).then((result) {
      if (result == true) {
        _loadTeachers(); // Refresh list after adding
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              HeaderSection(title: 'Teacher Management', icon: Icons.school_rounded),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                  vertical: 8,
                ),
                child: Text('${teachers.length} Teachers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
              ),
              Padding(
                padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, email or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => searchController.clear())
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.people_rounded, size: 50, color: Colors.blue),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Teachers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            Text(teachers.length.toString(),
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadTeachers,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredTeachers.isEmpty
                          ? const Center(child: Text('No teachers found', style: TextStyle(fontSize: 18, color: Colors.grey)))
                          : ListView.builder(
                              padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                              itemCount: filteredTeachers.length,
                              itemBuilder: (context, index) {
                                final teacher = filteredTeachers[index];
                                final name = teacher['full_name'] ?? teacher['name'] ?? 'Unknown';
                                final email = teacher['email'] ?? '';
                                final phone = teacher['phone'] ?? '';
                                final profilePic = teacher['profile_picture'] ?? '';

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.blue.shade100,
                                      backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
                                      child: profilePic.isEmpty
                                          ? Text(name.isNotEmpty ? name[0].toUpperCase() : 'T',
                                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20))
                                          : null,
                                    ),
                                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [if (email.isNotEmpty) Text(email), if (phone.isNotEmpty) Text(phone)],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTeacherScreen,
        icon: const Icon(Icons.person_add),
        label: const Text('Add New Teacher'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}



// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:school/services/api_services.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/customWidgets/pagesMainHeading.dart';
// import 'package:school/AdminDashboardPages/addTeacher.dart';

// class TeacherManagementPage extends StatefulWidget {
//   const TeacherManagementPage({super.key});

//   @override
//   State<TeacherManagementPage> createState() => _TeacherManagementPageState();
// }

// class _TeacherManagementPageState extends State<TeacherManagementPage> {
//   List<dynamic> teachers = [];
//   List<dynamic> filteredTeachers = [];
//   bool isLoading = false;

//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadTeachers();
//     searchController.addListener(_filterTeachers);
//   }

//   Future<void> _loadTeachers() async {
//     if (!mounted) return;
//     setState(() => isLoading = true);

//     try {
//       final response = await ApiService().getTeachers();

//       if (response.success && response.data != null) {
//         teachers = List.from(response.data!);
//         filteredTeachers = List.from(teachers);
//       } else {
//         throw Exception(response.message ?? 'Failed to load teachers');
//       }
//     } catch (e) {
//       debugPrint("Error loading teachers: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load teachers: $e'), backgroundColor: Colors.red),
//         );
//       }
//     }

//     if (mounted) setState(() => isLoading = false);
//   }

//   void _filterTeachers() {
//     final query = searchController.text.toLowerCase().trim();
//     setState(() {
//       filteredTeachers = teachers.where((teacher) {
//         final name = (teacher['full_name'] ?? teacher['name'] ?? '').toString().toLowerCase();
//         final email = (teacher['email'] ?? '').toString().toLowerCase();
//         final phone = (teacher['phone'] ?? '').toString().toLowerCase();
//         return query.isEmpty ||
//             name.contains(query) ||
//             email.contains(query) ||
//             phone.contains(query);
//       }).toList();
//     });
//   }

//   void _showAddTeacherScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) =>  AddTeacherScreen()),
//     ).then((result) {
//       if (result == true) {
//         _loadTeachers(); // Refresh list after adding
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(),
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
//         child: SafeArea(
//           child: Column(
//             children: [
//               HeaderSection(title: 'Teacher Management', icon: Icons.school_rounded),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
//                   vertical: 8,
//                 ),
//                 child: Text('${teachers.length} Teachers',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
//                 child: TextField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search by name, email or phone...',
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: searchController.text.isNotEmpty
//                         ? IconButton(icon: const Icon(Icons.clear), onPressed: () => searchController.clear())
//                         : null,
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.people_rounded, size: 50, color: Colors.blue),
//                         const SizedBox(width: 20),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Total Teachers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                             Text(teachers.length.toString(),
//                                 style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: RefreshIndicator(
//                   onRefresh: _loadTeachers,
//                   child: isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : filteredTeachers.isEmpty
//                           ? const Center(child: Text('No teachers found', style: TextStyle(fontSize: 18, color: Colors.grey)))
//                           : ListView.builder(
//                               padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
//                               itemCount: filteredTeachers.length,
//                               itemBuilder: (context, index) {
//                                 final teacher = filteredTeachers[index];
//                                 final name = teacher['full_name'] ?? teacher['name'] ?? 'Unknown';
//                                 final email = teacher['email'] ?? '';
//                                 final phone = teacher['phone'] ?? '';
//                                 final profilePic = teacher['profile_picture'] ?? '';

//                                 return Card(
//                                   margin: const EdgeInsets.only(bottom: 12),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   child: ListTile(
//                                     leading: CircleAvatar(
//                                       radius: 28,
//                                       backgroundColor: Colors.blue.shade100,
//                                       backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
//                                       child: profilePic.isEmpty
//                                           ? Text(name.isNotEmpty ? name[0].toUpperCase() : 'T',
//                                               style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20))
//                                           : null,
//                                     ),
//                                     title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                                     subtitle: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [if (email.isNotEmpty) Text(email), if (phone.isNotEmpty) Text(phone)],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _showAddTeacherScreen,
//         icon: const Icon(Icons.person_add),
//         label: const Text('Add New Teacher'),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }

