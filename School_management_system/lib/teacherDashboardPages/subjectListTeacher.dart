import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class SubjectInfo {
  final String id;
  final String name;
  final String teacher;
  final String code;
  final int credits;
  final String description;

  SubjectInfo({
    required this.id,
    required this.name,
    required this.teacher,
    required this.code,
    required this.credits,
    required this.description,
  });
}

class SubjectManagementPage extends StatefulWidget {
  @override
  _SubjectManagementPageState createState() => _SubjectManagementPageState();
}

class _SubjectManagementPageState extends State<SubjectManagementPage> {
  List<SubjectInfo> subjects = [
    SubjectInfo(
      id: 'SUB001',
      name: 'Mathematics',
      teacher: 'Dr. Smith',
      code: 'MATH101',
      credits: 4,
      description: 'Basic maths concepts and problem solving',
    ),
    SubjectInfo(
      id: 'SUB002',
      name: 'English Literature',
      teacher: 'Ms. Johnson',
      code: 'ENG101',
      credits: 3,
      description: 'Language skills and literary analysis',
    ),
    SubjectInfo(
      id: 'SUB003',
      name: 'Physics',
      teacher: 'Mr. Wilson',
      code: 'PHY101',
      credits: 4,
      description: 'Fundamental principles of physics',
    ),
    SubjectInfo(
      id: 'SUB004',
      name: 'Chemistry',
      teacher: 'Dr. Brown',
      code: 'CHEM101',
      credits: 4,
      description: 'Basic chemistry and laboratory work',
    ),
    SubjectInfo(
      id: 'SUB005',
      name: 'History',
      teacher: 'Mrs. Davis',
      code: 'HIST101',
      credits: 3,
      description: 'World history and civilizations',
    ),
  ];

  List<SubjectInfo> filteredSubjects = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSubjects = subjects;
    searchController.addListener(_filterSubjects);
  }

  void _filterSubjects() {
    setState(() {
      filteredSubjects = subjects.where((subject) {
        return subject.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
            subject.teacher.toLowerCase().contains(searchController.text.toLowerCase()) ||
            subject.code.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  void _addNewSubject() {
    _showSubjectDialog();
  }

  void _editSubject(SubjectInfo subject) {
    _showSubjectDialog(subject: subject);
  }

  void _removeSubject(String subjectId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to remove this subject?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  subjects.removeWhere((s) => s.id == subjectId);
                  _filterSubjects();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Subject removed successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showSubjectDialog({SubjectInfo? subject}) {
    final isEditing = subject != null;
    final nameController = TextEditingController(text: subject?.name ?? '');
    final teacherController = TextEditingController(text: subject?.teacher ?? '');
    final codeController = TextEditingController(text: subject?.code ?? '');
    final creditsController = TextEditingController(text: subject?.credits.toString() ?? '');
    final descriptionController = TextEditingController(text: subject?.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Subject' : 'Add New Subject'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: teacherController,
                  decoration: InputDecoration(
                    labelText: 'Teacher',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Subject Code',
                    prefixIcon: Icon(Icons.code),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: creditsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Credits',
                    prefixIcon: Icon(Icons.star),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && teacherController.text.isNotEmpty) {
                  final newSubject = SubjectInfo(
                    id: isEditing ? subject!.id : 'SUB${(subjects.length + 1).toString().padLeft(3, '0')}',
                    name: nameController.text,
                    teacher: teacherController.text,
                    code: codeController.text,
                    credits: int.tryParse(creditsController.text) ?? 3,
                    description: descriptionController.text,
                  );

                  setState(() {
                    if (isEditing) {
                      int index = subjects.indexWhere((s) => s.id == subject!.id);
                      subjects[index] = newSubject;
                    } else {
                      subjects.add(newSubject);
                    }
                    _filterSubjects();
                  });
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Subject updated!' : 'Subject added!'),
                    ),
                  );
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardVerticalPadding(context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book, color: AppThemeColor.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Subject Management',
                        style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Search
                        Container(
                          margin: EdgeInsets.all(16),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search subjects...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: AppThemeColor.blue50,
                            ),
                          ),
                        ),

                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subjects (${filteredSubjects.length})',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemeColor.primaryBlue,
                                ),
                              ),
                              Icon(Icons.book, color: AppThemeColor.primaryBlue),
                            ],
                          ),
                        ),

                        // Subject List
                        Expanded(
                          child: filteredSubjects.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No subjects found', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          )
                              : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: filteredSubjects.length,
                            itemBuilder: (context, index) {
                              final subject = filteredSubjects[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppThemeColor.primaryBlue.withOpacity(0.8),
                                      AppThemeColor.primaryBlue.withOpacity(0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppThemeColor.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.book, color: AppThemeColor.white),
                                  ),
                                  title: Text(
                                    subject.name,
                                    style: TextStyle(
                                      color: AppThemeColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        'Teacher: ${subject.teacher}',
                                        style: TextStyle(color: AppThemeColor.white.withOpacity(0.9)),
                                      ),
                                      Text(
                                        'Code: ${subject.code} | Credits: ${subject.credits}',
                                        style: TextStyle(color: AppThemeColor.white.withOpacity(0.9)),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        subject.description,
                                        style: TextStyle(color: AppThemeColor.white.withOpacity(0.8)),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert, color: AppThemeColor.white),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editSubject(subject);
                                      } else if (value == 'delete') {
                                        _removeSubject(subject.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: AppThemeColor.primaryBlue),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewSubject,
        backgroundColor: AppThemeColor.primaryBlue,
        foregroundColor: AppThemeColor.white,
        icon: Icon(Icons.add),
        label: Text('Add Subject'),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}