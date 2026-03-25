import 'package:flutter/material.dart';
import 'package:school/AdminStudentManagement/studentListTile.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/dashboard/classInfo.dart';
import 'package:school/services/api_services.dart';

class ClassManagementPage extends StatefulWidget {
  @override
  _ClassManagementPageState createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  List<ClassInfo> classes = [];
  List<ClassInfo> filteredClasses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClasses();
    searchController.addListener(_filterClasses);
  }

  Future<void> _fetchClasses() async {
    final ApiResponse<List<dynamic>> response = await ApiService().getClasses();

    print("response:--- ${response.data}");
    print("response success:--- ${response.success}");
    if (response.success && response.data != null) {
      setState(() {
        classes = response.data!
            .map<ClassInfo>((e) => ClassInfo.fromJson(e))
            .toList();
        filteredClasses = List.from(classes);
      });

      print("CLASSES LOADED => ${classes.length}");
    } else {
      print("API ERROR => ${response.message}");
    }
  }

  void _filterClasses() {
    setState(() {
      filteredClasses = classes.where((c) {
        final query = searchController.text.toLowerCase();
        return c.name.toLowerCase().contains(query) ||
            c.teacher.toLowerCase().contains(query) ||
            c.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToStudentList(ClassInfo classInfo) {
    print("CLICKED CLASS ID => ${classInfo.id}");
    print("CLICKED CLASS ID => ${classInfo.name}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListPage(className: classInfo.name),
      ),
    );
  }

  void _addNewClass() {
    _showClassDialog();
  }

  void _editClass(ClassInfo classInfo) {
    _showClassDialog(classInfo: classInfo);
  }

  void _removeClass(int classId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          title: Text(
            'Confirm Delete',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          content: Text(
            'Are you sure you want to remove this class? This will also remove all students in this class.',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppThemeColor.primaryBlue,
                  fontSize: AppThemeResponsiveness.getButtonTextStyle(
                    context,
                  ).fontSize,
                ),
              ),
            ),
            SizedBox(
              height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
              child: ElevatedButton(
                onPressed: () async {
                  final response = await ApiService().deleteClass(classId);

                  if (response.success) {
                    setState(() {
                      classes.removeWhere((c) => c.id == classId);
                      _filterClasses();
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Class removed successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response.message ?? 'Failed to delete class',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppThemeResponsiveness.getButtonBorderRadius(context),
                    ),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: AppThemeResponsiveness.getButtonTextStyle(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClassDialog({ClassInfo? classInfo}) {
    final isEditing = classInfo != null;
    final nameController = TextEditingController(text: classInfo?.name ?? '');
    final teacherController = TextEditingController(
      text: classInfo?.teacher ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          title: Text(
            isEditing ? 'Edit Class' : 'Add New Class',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController),
                SizedBox(
                  height: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                TextField(controller: teacherController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            SizedBox(
              height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      teacherController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final payload = {
                    "name": nameController.text,
                    // "teacher": teacherController.text,
                  };

                  if (isEditing) {
                    /// ===== UPDATE =====
                    final response = await ApiService().updateClass(
                      id: classInfo!.id,
                      name: nameController.text,
                    );

                    if (response.success && response.data != null) {
                      final updatedClass = ClassInfo.fromJson(response.data!);

                      setState(() {
                        final index = classes.indexWhere(
                          (c) => c.id == classInfo.id,
                        );
                        classes[index] = updatedClass;
                        _filterClasses();
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Class updated successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    /// ===== CREATE =====
                    final response = await ApiService().createClass(
                      name: nameController.text,
                    );

                    if (response.success && response.data != null) {
                      final newClass = ClassInfo.fromJson(response.data!);

                      setState(() {
                        classes.add(newClass);
                        _filterClasses();
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Class added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
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
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              bottom: AppThemeResponsiveness.getDashboardVerticalPadding(
                context,
              ),
              left: AppThemeResponsiveness.getSmallSpacing(context),
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal:
                          AppThemeResponsiveness.getDashboardHorizontalPadding(
                            context,
                          ),
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          AppThemeResponsiveness.getCardBorderRadius(context),
                        ),
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
                    child: Column(
                      children: [
                        // Search Section
                        _buildSearchSection(context),

                        // Classes Header
                        _buildClassesHeader(context),

                        // Classes List/Grid
                        Expanded(child: _buildClassesGrid(context)),
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

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(
            context,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Flexible(
              child: Text(
                'Class Management',
                style: AppThemeResponsiveness.getSectionTitleStyle(context)
                    .copyWith(
                      fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                        context,
                        AppThemeResponsiveness.getSectionTitleStyle(
                              context,
                            ).fontSize! +
                            4,
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

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: AppThemeResponsiveness.getBodyTextStyle(context),
        decoration: InputDecoration(
          hintText: 'Search by class no, teacher, or ID',
          hintStyle: AppThemeResponsiveness.getInputHintStyle(context),
          prefixIcon: Icon(
            Icons.search,
            color: AppThemeColor.primaryBlue,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getInputBorderRadius(context),
            ),
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
    );
  }

  Widget _buildClassesHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Classes (${filteredClasses.length})",
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          Icon(Icons.class_, color: AppThemeColor.primaryBlue),
        ],
      ),
    );
  }

  Widget _buildClassesList(BuildContext context) {
    if (filteredClasses.isEmpty) {
      return Center(child: Text("No classes found"));
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      itemCount: filteredClasses.length,
      itemBuilder: (_, index) {
        final c = filteredClasses[index];
        return _buildClassCard(context, c);
      },
    );
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
            'No classes found',
            style: AppThemeResponsiveness.getHeadingStyle(
              context,
            ).copyWith(color: Colors.grey.shade600),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Try adjusting your search terms',
            style: AppThemeResponsiveness.getSubHeadingStyle(
              context,
            ).copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesGrid(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(
        AppThemeResponsiveness.getDefaultSpacing(context),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppThemeResponsiveness.getGridCrossAxisCount(context),
        crossAxisSpacing:
            AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(
          context,
        ),
        childAspectRatio:
            AppThemeResponsiveness.getGridChildAspectRatio(context) * 0.85,
      ),
      itemCount: filteredClasses.length,
      itemBuilder: (context, index) {
        return _buildClassGridCard(context, filteredClasses[index]);
      },
    );
  }

  Widget _buildClassesListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(
        AppThemeResponsiveness.getDefaultSpacing(context),
      ),
      itemCount: filteredClasses.length,
      itemBuilder: (context, index) {
        return _buildClassCard(context, filteredClasses[index]);
      },
    );
  }

  Widget _buildClassGridCard(BuildContext context, ClassInfo classInfo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        gradient: LinearGradient(
          colors: [
            AppThemeColor.primaryBlue.withOpacity(0.8),
            AppThemeColor.primaryBlue.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToStudentList(classInfo),
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            AppThemeResponsiveness.getGridItemPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      classInfo.name,
                      style:
                          AppThemeResponsiveness.getGridItemTitleStyle(
                            context,
                          ).copyWith(
                            color: AppThemeColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildClassPopupMenu(context, classInfo),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Teacher: ${classInfo.teacher}',
                style: AppThemeResponsiveness.getGridItemSubtitleStyle(
                  context,
                ).copyWith(color: AppThemeColor.white.withOpacity(0.9)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: AppThemeResponsiveness.getSmallSpacing(context) / 2,
              ),
              Text(
                'Students: ${classInfo.totalStudents}',
                style: AppThemeResponsiveness.getGridItemSubtitleStyle(
                  context,
                ).copyWith(color: AppThemeColor.white.withOpacity(0.9)),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppThemeColor.white,
                  size: AppThemeResponsiveness.getIconSize(context) * 0.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassInfo classInfo) {
    return Card(
      margin: EdgeInsets.only(
        bottom: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.class_, color: AppThemeColor.primaryBlue),
        title: Text(classInfo.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Teacher: ${classInfo.teacher}"),
            Text("Students: ${classInfo.totalStudents}"),
            Text("Code: ${classInfo.code}"),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToStudentList(classInfo),
      ),
    );
  }

  Widget _buildClassPopupMenu(BuildContext context, ClassInfo classInfo) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppThemeColor.white,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          _editClass(classInfo);
        } else if (value == 'delete') {
          _removeClass(classInfo.id);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Edit',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Delete',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _addNewClass,
      backgroundColor: AppThemeColor.primaryBlue,
      foregroundColor: AppThemeColor.white,
      elevation: AppThemeResponsiveness.getButtonElevation(context),
      icon: Icon(Icons.add, size: AppThemeResponsiveness.getIconSize(context)),
      label: Text(
        'Add Class',
        style: AppThemeResponsiveness.getButtonTextStyle(
          context,
        ).copyWith(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getButtonBorderRadius(context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
