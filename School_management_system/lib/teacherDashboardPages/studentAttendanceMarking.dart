import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/appBar.dart';


// Models
class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String className;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
  });
}

class AttendanceRecord {
  final String studentId;
  final String studentName;
  final DateTime date;
  final bool isPresent;
  final String? remarks;

  AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.isPresent,
    this.remarks,
  });
}

// Main Attendance Screen for Taking Attendance
class TeacherMarkAttendancePage extends StatefulWidget {
  @override
  _TeacherMarkAttendancePageState createState() => _TeacherMarkAttendancePageState();
}

class _TeacherMarkAttendancePageState extends State<TeacherMarkAttendancePage> {
  String selectedClass = 'Class 10-A';
  DateTime selectedDate = DateTime.now();
  List<Student> students = [];
  Map<String, bool> attendanceStatus = {};
  Map<String, String> remarks = {};
  bool isLoading = false;
  bool isAttendanceAlreadyTaken = false;

  final List<String> classes = ['Class 10-A', 'Class 10-B', 'Class 11-A', 'Class 11-B'];

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _checkIfAttendanceAlreadyTaken();
  }

  void _loadStudents() {
    // Sample data - replace with your actual data source
    students = [
      Student(id: '1', name: 'Aarav Sharma', rollNumber: '001', className: selectedClass),
      Student(id: '2', name: 'Ananya Patel', rollNumber: '002', className: selectedClass),
      Student(id: '3', name: 'Arjun Singh', rollNumber: '003', className: selectedClass),
      Student(id: '4', name: 'Kavya Reddy', rollNumber: '004', className: selectedClass),
      Student(id: '5', name: 'Rohan Gupta', rollNumber: '005', className: selectedClass),
      Student(id: '6', name: 'Priya Joshi', rollNumber: '006', className: selectedClass),
      Student(id: '7', name: 'Vikram Kumar', rollNumber: '007', className: selectedClass),
      Student(id: '8', name: 'Sneha Agarwal', rollNumber: '008', className: selectedClass),
    ];

    // Initialize attendance status
    for (var student in students) {
      attendanceStatus[student.id] = true; // Default to present
    }
  }

  void _checkIfAttendanceAlreadyTaken() {
    // Check if attendance is already taken for selected date and class
    // This should query your database
    setState(() {
      isAttendanceAlreadyTaken = false; // Sample logic
    });
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
      selectableDayPredicate: (date) => !_isWeekend(date),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _checkIfAttendanceAlreadyTaken();
      });
    }
  }

  void _showPrintDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Print Attendance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select print type:'),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: SecondaryButton(
                  title: 'Print Daily Attendance',
                  color: Colors.blue,
                  icon: Icon(Icons.today, color: Colors.blue),
                  onPressed: () {
                    Navigator.pop(context);
                    _printDailyAttendance();
                  },
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: SecondaryButton(
                  title: 'Print Monthly Attendance',
                  color: Colors.green,
                  icon: Icon(Icons.calendar_month, color: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                    _printMonthlyAttendance();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _printDailyAttendance() {
    // Create attendance records for the selected date
    List<AttendanceRecord> records = [];
    for (var student in students) {
      records.add(AttendanceRecord(
        studentId: student.id,
        studentName: student.name,
        date: selectedDate,
        isPresent: attendanceStatus[student.id] ?? false,
        remarks: remarks[student.id],
      ));
    }

    // Print logic here
    print('Printing Daily Attendance for ${DateFormat('dd/MM/yyyy').format(selectedDate)}');
    print('Class: $selectedClass');
    print('Total Students: ${students.length}');

    int presentCount = 0;
    for (var record in records) {
      print('${record.studentName} (${students.firstWhere((s) => s.id == record.studentId).rollNumber}): ${record.isPresent ? 'Present' : 'Absent'}');
      if (record.isPresent) presentCount++;
    }

    print('Present: $presentCount, Absent: ${students.length - presentCount}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily attendance printed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _printMonthlyAttendance() {
    // Navigate to monthly view or print monthly data
    print('Printing Monthly Attendance for ${DateFormat('MMMM yyyy').format(selectedDate)}');
    print('Class: $selectedClass');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Monthly attendance printed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _submitAttendance() async {
    if (isAttendanceAlreadyTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance already taken for this date!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Create attendance records
      List<AttendanceRecord> records = [];
      for (var student in students) {
        records.add(AttendanceRecord(
          studentId: student.id,
          studentName: student.name,
          date: selectedDate,
          isPresent: attendanceStatus[student.id] ?? false,
          remarks: remarks[student.id],
        ));
      }

      // Save to database (implement your save logic here)
      await _saveAttendanceRecords(records);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back or refresh
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving attendance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveAttendanceRecords(List<AttendanceRecord> records) async {
    // Implement your database save logic here
    await Future.delayed(Duration(seconds: 1)); // Simulate API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Class Selection
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedClass,
                        isExpanded: true,
                        items: classes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue!;
                            _loadStudents();
                            _checkIfAttendanceAlreadyTaken();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Date Selection
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            DateFormat('EEEE, MMM dd, yyyy').format(selectedDate),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  if (isAttendanceAlreadyTaken)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Attendance already taken for this date',
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Student List
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            student.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text('Roll No: ${student.rollNumber}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Present Button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  attendanceStatus[student.id] = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: (attendanceStatus[student.id] ?? false)
                                      ? Colors.green
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: (attendanceStatus[student.id] ?? false)
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Absent Button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  attendanceStatus[student.id] = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: !(attendanceStatus[student.id] ?? false)
                                      ? Colors.red
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    color: !(attendanceStatus[student.id] ?? false)
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SecondaryButton(
                      title: 'Print',
                      color: Colors.blue,
                      icon: Icon(Icons.print, color: Colors.blue),
                      onPressed: _showPrintDialog,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      title: 'Submit Attendance',
                      isLoading: isLoading,
                      onPressed: _submitAttendance,
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
}

// Monthly Attendance View
class TeacherAttendanceViewPage extends StatefulWidget {
  @override
  _TeacherAttendanceViewPageState createState() => _TeacherAttendanceViewPageState();
}

class _TeacherAttendanceViewPageState extends State<TeacherAttendanceViewPage> {
  String selectedClass = 'Class 10-A';
  DateTime selectedMonth = DateTime.now();
  List<Student> students = [];
  Map<String, List<AttendanceRecord>> attendanceData = {};
  List<DateTime> workingDays = [];
  bool isLoading = false;

  final List<String> classes = ['Class 10-A', 'Class 10-B', 'Class 11-A', 'Class 11-B'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _loadStudents();
    _generateWorkingDays();
    _loadAttendanceData();
  }

  void _loadStudents() {
    // Sample data - replace with your actual data source
    students = [
      Student(id: '1', name: 'Aarav Sharma', rollNumber: '001', className: selectedClass),
      Student(id: '2', name: 'Ananya Patel', rollNumber: '002', className: selectedClass),
      Student(id: '3', name: 'Arjun Singh', rollNumber: '003', className: selectedClass),
      Student(id: '4', name: 'Kavya Reddy', rollNumber: '004', className: selectedClass),
      Student(id: '5', name: 'Rohan Gupta', rollNumber: '005', className: selectedClass),
    ];
  }

  void _generateWorkingDays() {
    workingDays.clear();
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, day);
      // Skip weekends
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        workingDays.add(date);
      }
    }
  }

  void _loadAttendanceData() {
    setState(() {
      isLoading = true;
    });

    // Sample data - replace with your actual data source
    attendanceData.clear();
    for (var student in students) {
      attendanceData[student.id] = [];
      for (var day in workingDays) {
        // Generate random attendance for demo
        final isPresent = DateTime.now().millisecondsSinceEpoch % 3 != 0;
        attendanceData[student.id]!.add(
          AttendanceRecord(
            studentId: student.id,
            studentName: student.name,
            date: day,
            isPresent: isPresent,
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && picked != selectedMonth) {
      setState(() {
        selectedMonth = picked;
        _loadData();
      });
    }
  }

  void _printMonthlyReport() {
    // Print monthly attendance report
    print('Monthly Attendance Report');
    print('Class: $selectedClass');
    print('Month: ${DateFormat('MMMM yyyy').format(selectedMonth)}');
    print('Working Days: ${workingDays.length}');
    print('Total Students: ${students.length}');

    for (var student in students) {
      final percentage = _calculateAttendancePercentage(student.id);
      final presentDays = attendanceData[student.id]?.where((record) => record.isPresent).length ?? 0;
      print('${student.name} (${student.rollNumber}): $presentDays/${workingDays.length} days (${percentage.toStringAsFixed(1)}%)');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Monthly report printed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  double _calculateAttendancePercentage(String studentId) {
    final records = attendanceData[studentId] ?? [];
    if (records.isEmpty) return 0.0;

    final presentCount = records.where((record) => record.isPresent).length;
    return (presentCount / records.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Attendance'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printMonthlyReport,
            tooltip: 'Print Monthly Report',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Class Selection
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedClass,
                        isExpanded: true,
                        items: classes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedClass = newValue!;
                            _loadData();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Month Selection
                  GestureDetector(
                    onTap: _selectMonth,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            DateFormat('MMMM yyyy').format(selectedMonth),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Working Days Info
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Working Days: ${workingDays.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        Text(
                          'Total Students: ${students.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Attendance Table
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Student',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...workingDays.map((date) => DataColumn(
                        label: Text(
                          DateFormat('dd').format(date),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      DataColumn(
                        label: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: students.map((student) {
                      final records = attendanceData[student.id] ?? [];
                      final percentage = _calculateAttendancePercentage(student.id);

                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    student.name,
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    student.rollNumber,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ...records.map((record) => DataCell(
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: record.isPresent ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  record.isPresent ? 'P' : 'A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          )),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: percentage >= 75
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: percentage >= 75
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Print Button
            Container(
              padding: EdgeInsets.all(16),
              child: PrimaryButton(
                title: 'Print Monthly Report',
                icon: Icon(Icons.print, color: Colors.white),
                onPressed: _printMonthlyReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}