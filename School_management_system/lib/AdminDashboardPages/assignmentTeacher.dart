// Teacher Assignment Dialog
import 'package:flutter/material.dart';
import 'package:school/model/admission/teacherModel.dart';
import 'package:school/model/dashboard/classSection.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';


class TeacherAssignmentDialog extends StatefulWidget {
  final ClassSection section;
  final List<Teacher> teachers;
  final Function(ClassSection) onAssignmentUpdated;

  const TeacherAssignmentDialog({
    Key? key,
    required this.section,
    required this.teachers,
    required this.onAssignmentUpdated,
  }) : super(key: key);

  @override
  State<TeacherAssignmentDialog> createState() => _TeacherAssignmentDialogState();
}

class _TeacherAssignmentDialogState extends State<TeacherAssignmentDialog> {
  String? selectedClassTeacher;
  List<String> selectedSubjectTeachers = [];

  @override
  void initState() {
    super.initState();
    selectedClassTeacher = widget.section.classTeacherId;
    selectedSubjectTeachers = List.from(widget.section.subjectTeacherIds);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(AppThemeColor.defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Assign Teachers\n${widget.section.fullName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppThemeColor.primaryBlue,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: AppThemeColor.mediumSpacing),

            // Class Teacher Selection
            Text(
              'Class Teacher',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppThemeColor.primaryBlue,
              ),
            ),
            SizedBox(height: AppThemeColor.smallSpacing),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
              ),
              child: Column(
                children: [
                  RadioListTile<String?>(
                    title: Text('No Class Teacher'),
                    value: null,
                    groupValue: selectedClassTeacher,
                    onChanged: (value) {
                      setState(() => selectedClassTeacher = value);
                    },
                    activeColor: AppThemeColor.primaryBlue,
                  ),
                  ...widget.teachers.map((teacher) {
                    return RadioListTile<String>(
                      title: Text(teacher.name),
                      subtitle: Text('${teacher.subject} - ${teacher.qualification}'),
                      value: teacher.id,
                      groupValue: selectedClassTeacher,
                      onChanged: teacher.isAvailable
                          ? (value) {
                        setState(() => selectedClassTeacher = value);
                      }
                          : null,
                      activeColor: AppThemeColor.primaryBlue,
                    );
                  }).toList(),
                ],
              ),
            ),

            SizedBox(height: AppThemeColor.defaultSpacing),

            // Subject Teachers Selection
            Text(
              'Subject Teachers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppThemeColor.primaryBlue,
              ),
            ),
            SizedBox(height: AppThemeColor.smallSpacing),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                ),
                child: ListView(
                  children: widget.teachers.map((teacher) {
                    final isSelected = selectedSubjectTeachers.contains(teacher.id);
                    return CheckboxListTile(
                      title: Text(teacher.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${teacher.subject} - ${teacher.qualification}'),
                          Text(
                            teacher.isAvailable ? 'Available' : 'Not Available',
                            style: TextStyle(
                              color: teacher.isAvailable ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      value: isSelected,
                      onChanged: teacher.isAvailable
                          ? (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedSubjectTeachers.add(teacher.id);
                          } else {
                            selectedSubjectTeachers.remove(teacher.id);
                          }
                        });
                      }
                          : null,
                      activeColor: AppThemeColor.primaryBlue,
                      secondary: CircleAvatar(
                        backgroundColor: teacher.isAvailable
                            ? AppThemeColor.primaryBlue
                            : Colors.grey,
                        child: Text(
                          teacher.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: AppThemeColor.defaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                SizedBox(width: AppThemeColor.smallSpacing),
                ElevatedButton(
                  onPressed: _updateAssignments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeColor.primaryBlue,
                    foregroundColor: AppThemeColor.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Update Assignments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateAssignments() {
    final updatedSection = widget.section.copyWith(
      classTeacherId: selectedClassTeacher,
      subjectTeacherIds: selectedSubjectTeachers, 
    );

    widget.onAssignmentUpdated(updatedSection);
    Navigator.pop(context);
  }
}