import 'package:flutter/material.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/adminDashboardModel/salaryManagementModel.dart';


class SalaryManagementPage extends StatefulWidget {
  @override
  State<SalaryManagementPage> createState() => _SalaryManagementPageState();
}

class _SalaryManagementPageState extends State<SalaryManagementPage>
    with TickerProviderStateMixin {

  String selectedFilter = 'All';
  String selectedMonth = 'Current Month';
  String selectedDepartment = 'All Departments';
  bool showPaidOnly = false;
  bool showPendingOnly = false;

  final List<String> months = [
    'Current Month',
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> departments = [
    'All Departments',
    'Teaching Staff',
    'Administrative',
    'Support Staff',
    'Management',
    'Maintenance'
  ];

  // Mock data for demonstration
  final List<StaffSalaryData> staffSalaryData = [
    StaffSalaryData(
      id: '001',
      name: 'John Smith',
      designation: 'Mathematics Teacher',
      department: 'Teaching Staff',
      baseSalary: 45000,
      allowances: 8000,
      deductions: 2500,
      netSalary: 50500,
      isPaid: true,
      paymentDate: DateTime.now().subtract(Duration(days: 5)),
      employeeId: 'EMP001',
    ),
    StaffSalaryData(
      id: '002',
      name: 'Sarah Johnson',
      designation: 'Vice Principal',
      department: 'Administrative',
      baseSalary: 65000,
      allowances: 12000,
      deductions: 3500,
      netSalary: 73500,
      isPaid: true,
      paymentDate: DateTime.now().subtract(Duration(days: 3)),
      employeeId: 'EMP002',
    ),
    StaffSalaryData(
      id: '003',
      name: 'Michael Brown',
      designation: 'Science Teacher',
      department: 'Teaching Staff',
      baseSalary: 42000,
      allowances: 7500,
      deductions: 2200,
      netSalary: 47300,
      isPaid: false,
      paymentDate: null,
      employeeId: 'EMP003',
    ),
    StaffSalaryData(
      id: '004',
      name: 'Emily Davis',
      designation: 'Librarian',
      department: 'Support Staff',
      baseSalary: 32000,
      allowances: 5000,
      deductions: 1800,
      netSalary: 35200,
      isPaid: false,
      paymentDate: null,
      employeeId: 'EMP004',
    ),
    StaffSalaryData(
      id: '005',
      name: 'David Wilson',
      designation: 'Physical Education Teacher',
      department: 'Teaching Staff',
      baseSalary: 38000,
      allowances: 6500,
      deductions: 2000,
      netSalary: 42500,
      isPaid: true,
      paymentDate: DateTime.now().subtract(Duration(days: 1)),
      employeeId: 'EMP005',
    ),
  ];

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
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
              vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(
                  title: 'Salary Management',
                  icon: Icons.payment,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildQuickStatsSection(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),
                _buildFilterSection(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildQuickActionsSection(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildSalaryListSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBulkPaymentDialog(),
        backgroundColor: AppThemeColor.primaryBlue,
        icon: Icon(Icons.payment_rounded),
        label: Text('Bulk Payment'),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return SizedBox(
      height: AppThemeResponsiveness.isSmallPhone(context) ? 140 : 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          QuickStatCard(
            title: 'Total Staff',
            value: '${staffSalaryData.length}',
            icon: Icons.people_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.shade50,
            onTap: ()=>{},
          ),
          QuickStatCard(
            title: 'Paid This Month',
            value: '${staffSalaryData.where((s) => s.isPaid).length}',
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            iconBackgroundColor: Colors.green.shade50,
            onTap: ()=>{},
          ),
          QuickStatCard(
            title: 'Pending Payments',
            value: '${staffSalaryData.where((s) => !s.isPaid).length}',
            icon: Icons.pending_rounded,
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.orange.shade50,
            onTap: ()=>{},
          ),
          QuickStatCard(
            title: 'Total Payroll',
            value: '₹${_calculateTotalPayroll()}',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.shade50,
            onTap: ()=>{},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppThemeColor.black,
            ),
          ),
          SizedBox(height: 16),
          // Changed from Row to Column to avoid pixel overflow
          Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedMonth,
                decoration: InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: months.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          // Changed from Row to Column for checkboxes
          Column(
            children: [
              CheckboxListTile(
                title: Text('Show Paid Only'),
                value: showPaidOnly,
                onChanged: (value) {
                  setState(() {
                    showPaidOnly = value!;
                    if (showPaidOnly) showPendingOnly = false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: Text('Show Pending Only'),
                value: showPendingOnly,
                onChanged: (value) {
                  setState(() {
                    showPendingOnly = value!;
                    if (showPendingOnly) showPaidOnly = false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppThemeColor.black,
            ),
          ),
          SizedBox(height: 16),
          // Changed from Row to Column to avoid pixel overflow
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showGeneratePayslipDialog(),
                  icon: Icon(Icons.receipt_rounded),
                  label: Text('Generate Payslips'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showSalaryReportDialog(),
                  icon: Icon(Icons.analytics_rounded),
                  label: Text('Salary Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Changed from Row to Column to avoid pixel overflow
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showExportDataDialog(),
                  icon: Icon(Icons.download_rounded),
                  label: Text('Export Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showSalarySettingsDialog(),
                  icon: Icon(Icons.settings_rounded),
                  label: Text('Salary Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryListSection() {
    List<StaffSalaryData> filteredData = _getFilteredData();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Staff Salary Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColor.black87,
                  ),
                ),
                Text(
                  '${filteredData.length} staff members',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppThemeColor.black,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredData.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildSalaryCard(filteredData[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(StaffSalaryData staff) {
    return InkWell(
      onTap: () => _showSalaryDetailsDialog(staff),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: staff.isPaid ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    staff.isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                    color: staff.isPaid ? Colors.green : Colors.orange,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColor.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${staff.designation} • ${staff.department}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppThemeColor.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: staff.isPaid ? Colors.green.shade100 : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    staff.isPaid ? 'Paid' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: staff.isPaid ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Changed to Column layout for better space utilization
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net Salary: ₹${staff.netSalary.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    if (!staff.isPaid)
                      ElevatedButton(
                        onPressed: () => _processPayment(staff),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(80, 32),
                        ),
                        child: Text('Pay Now'),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                if (staff.isPaid && staff.paymentDate != null)
                  Text(
                    'Paid: ${_formatDate(staff.paymentDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<StaffSalaryData> _getFilteredData() {
    List<StaffSalaryData> filtered = List.from(staffSalaryData);

    if (selectedDepartment != 'All Departments') {
      filtered = filtered.where((staff) => staff.department == selectedDepartment).toList();
    }

    if (showPaidOnly) {
      filtered = filtered.where((staff) => staff.isPaid).toList();
    } else if (showPendingOnly) {
      filtered = filtered.where((staff) => !staff.isPaid).toList();
    }

    return filtered;
  }

  String _calculateTotalPayroll() {
    double total = staffSalaryData.fold(0, (sum, staff) => sum + staff.netSalary);
    return total.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _processPayment(StaffSalaryData staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Process Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to process payment for:'),
            SizedBox(height: 8),
            Text('Name: ${staff.name}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Net Salary: ₹${staff.netSalary.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                staff.isPaid = true;
                staff.paymentDate = DateTime.now();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment processed successfully')),
              );
            },
            child: Text('Process Payment'),
          ),
        ],
      ),
    );
  }

  void _showSalaryDetailsDialog(StaffSalaryData staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salary Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Employee ID', staff.employeeId),
              _buildDetailRow('Name', staff.name),
              _buildDetailRow('Designation', staff.designation),
              _buildDetailRow('Department', staff.department),
              Divider(),
              _buildDetailRow('Base Salary', '₹${staff.baseSalary.toStringAsFixed(0)}'),
              _buildDetailRow('Allowances', '₹${staff.allowances.toStringAsFixed(0)}'),
              _buildDetailRow('Deductions', '₹${staff.deductions.toStringAsFixed(0)}'),
              Divider(),
              _buildDetailRow('Net Salary', '₹${staff.netSalary.toStringAsFixed(0)}', isHighlighted: true),
              _buildDetailRow('Status', staff.isPaid ? 'Paid' : 'Pending'),
              if (staff.isPaid && staff.paymentDate != null)
                _buildDetailRow('Payment Date', _formatDate(staff.paymentDate!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (!staff.isPaid)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _processPayment(staff);
              },
              child: Text('Process Payment'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppThemeColor.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.green : AppThemeColor.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBulkPaymentDialog() {
    List<StaffSalaryData> pendingPayments = staffSalaryData.where((s) => !s.isPaid).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulk Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Process payments for all pending staff?'),
            SizedBox(height: 16),
            Text('${pendingPayments.length} pending payments'),
            Text('Total Amount: ₹${pendingPayments.fold(0.0, (sum, staff) => sum + staff.netSalary).toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var staff in pendingPayments) {
                  staff.isPaid = true;
                  staff.paymentDate = DateTime.now();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All payments processed successfully')),
              );
            },
            child: Text('Process All'),
          ),
        ],
      ),
    );
  }

  void _showGeneratePayslipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generate Payslips'),
        content: Text('Generate payslips for all staff members?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payslips generated successfully')),
              );
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showSalaryReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salary Report'),
        content: Text('Generate comprehensive salary report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Salary report generated successfully')),
              );
            },
            child: Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Export to Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data exported to Excel')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Export to PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data exported to PDF')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSalarySettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salary Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Salary Structure'),
              subtitle: Text('Configure salary components'),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Payment Schedule'),
              subtitle: Text('Set payment dates'),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Tax Settings'),
              subtitle: Text('Configure tax calculations'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}