import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/model/dashboard/teacherDashboardModel/resultModelTeacher.dart';


class StudentMarksEntryCard extends StatefulWidget {
  final Student student;
  final Subject subject;
  final Exam exam;
  final ExamResult? existingResult;
  final ValueChanged<ExamResult> onSave;

  const StudentMarksEntryCard({
    Key? key,
    required this.student,
    required this.subject,
    required this.exam,
    this.existingResult,
    required this.onSave,
  }) : super(key: key);

  @override
  State<StudentMarksEntryCard> createState() => _StudentMarksEntryCardState();
}

class _StudentMarksEntryCardState extends State<StudentMarksEntryCard> {
  late TextEditingController _marksController;
  late String _currentGrade;
  late bool _isPassed;

  @override
  void initState() {
    super.initState();
    _marksController = TextEditingController(
        text: widget.existingResult?.marksObtained.toString() ?? '');
    _updateGradeAndPassStatus(widget.existingResult?.marksObtained ?? 0.0);

    _marksController.addListener(_onMarksChanged);
  }

  @override
  void didUpdateWidget(covariant StudentMarksEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.existingResult != oldWidget.existingResult) {
      _marksController.text = widget.existingResult?.marksObtained.toString() ?? '';
      _updateGradeAndPassStatus(widget.existingResult?.marksObtained ?? 0.0);
    }
  }

  @override
  void dispose() {
    _marksController.removeListener(_onMarksChanged);
    _marksController.dispose();
    super.dispose();
  }

  void _onMarksChanged() {
    final marks = double.tryParse(_marksController.text) ?? 0.0;
    _updateGradeAndPassStatus(marks);
  }

  void _updateGradeAndPassStatus(double marks) {
    setState(() {
      _currentGrade = _calculateGrade(marks);
      _isPassed = marks >= (widget.subject.maxMarks * 0.33); // Assuming 33% is passing
    });
  }

  String _calculateGrade(double marks) {
    if (marks >= 90) return 'A+';
    if (marks >= 80) return 'A';
    if (marks >= 70) return 'B+';
    if (marks >= 60) return 'B';
    if (marks >= 50) return 'C+';
    if (marks >= 40) return 'C';
    if (marks >= 33) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)), // Responsive border radius
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)), // Responsive padding
        child: Row(
          children: [
            Expanded(
              flex: AppThemeResponsiveness.isMobile(context) ? 3 : 2, // Adjust flex based on screen size
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.name,
                    style: AppThemeResponsiveness.getDashboardCardTitleStyle(context), // Responsive text style
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Roll No: ${widget.student.rollNumber}',
                    style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context), // Responsive text style
                  ),
                ],
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)), // Responsive spacing
            Expanded(
              flex: AppThemeResponsiveness.isMobile(context) ? 2 : 1, // Adjust flex based on screen size
              child: TextFormField(
                controller: _marksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Marks',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                    vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.8,
                  ), // Responsive content padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)), // Responsive border radius
                  ),
                ),
                onFieldSubmitted: (value) => _saveMarks(),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)), // Responsive spacing
            Expanded(
              flex: 1,
              child: Text(
                _currentGrade,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getGradeColor(_currentGrade),
                  fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize, // Responsive font size
                ),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)), // Responsive spacing
            IconButton(
              icon: Icon(Icons.save, color: AppThemeColor.primaryBlue, size: AppThemeResponsiveness.getIconSize(context) * 0.8), // Responsive icon size
              onPressed: _saveMarks,
            ),
          ],
        ),
      ),
    );
  }

  void _saveMarks() {
    final marks = double.tryParse(_marksController.text);
    if (marks == null || marks < 0 || marks > widget.subject.maxMarks) {
      _showSnackBar('Please enter valid marks (0-${widget.subject.maxMarks})', isError: true);
      return;
    }

    final newResult = ExamResult(
      id: widget.existingResult?.id ??
          '${widget.student.id}_${widget.subject.id}_${widget.exam.id}',
      studentId: widget.student.id,
      subjectId: widget.subject.id,
      examId: widget.exam.id,
      marksObtained: marks,
      maxMarks: widget.subject.maxMarks.toDouble(),
      grade: _calculateGrade(marks),
      dateEntered: DateTime.now(),
      enteredBy: 'Admin', // This could be dynamic based on logged-in user
    );
    widget.onSave(newResult);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.lightGreen;
      case 'C+':
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.amber;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}