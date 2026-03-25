import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/teacherDashboardModel/salaryModelTeacher.dart';
import 'package:school/teacherDashboardPages/downloadSalarySLip.dart';

class SalaryManagementScreenTeacher extends StatefulWidget {
  @override
  _SalaryManagementScreenTeacherState createState() => _SalaryManagementScreenTeacherState();
}

class _SalaryManagementScreenTeacherState extends State<SalaryManagementScreenTeacher>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final salarySlipService = SalarySlipPDFService(
    config: SalarySlipConfig(
      schoolName: 'Your School Name',
      schoolAddress: '123 Education Street, City, State - 123456',
      contactEmail: 'hr@yourschool.com',
      contactPhone: '+91-1234567890',
      primaryColor: Colors.blue,
      secondaryColor: Colors.green,
    ),
  );

  final List<SalaryRecord> _salaryRecords = [
    SalaryRecord(
      id: '001',
      month: 'March',
      year: '2024',
      basicSalary: 35000.0,
      hra: 14000.0,
      da: 3500.0,
      ta: 2000.0,
      medicalAllowance: 1500.0,
      pf: 4200.0,
      tds: 2800.0,
      otherDeductions: 500.0,
      paymentDate: DateTime(2024, 4, 1),
      status: 'paid',
      slipNumber: 'SAL2024001',
      workingDays: 22,
      totalWorkingDays: 22,
      overtime: 0.0,
    ),
    SalaryRecord(
      id: '002',
      month: 'February',
      year: '2024',
      basicSalary: 35000.0,
      hra: 14000.0,
      da: 3500.0,
      ta: 2000.0,
      medicalAllowance: 1500.0,
      pf: 4200.0,
      tds: 2800.0,
      otherDeductions: 500.0,
      paymentDate: DateTime(2024, 3, 1),
      status: 'paid',
      slipNumber: 'SAL2024002',
      workingDays: 20,
      totalWorkingDays: 20,
      overtime: 0.0,
    ),
    SalaryRecord(
      id: '003',
      month: 'April',
      year: '2024',
      basicSalary: 35000.0,
      hra: 14000.0,
      da: 3500.0,
      ta: 2000.0,
      medicalAllowance: 1500.0,
      pf: 4200.0,
      tds: 2800.0,
      otherDeductions: 500.0,
      paymentDate: null,
      status: 'processing',
      slipNumber: '',
      workingDays: 22,
      totalWorkingDays: 22,
      overtime: 0.0,
    ),
    SalaryRecord(
      id: '004',
      month: 'May',
      year: '2024',
      basicSalary: 35000.0,
      hra: 14000.0,
      da: 3500.0,
      ta: 2000.0,
      medicalAllowance: 1500.0,
      pf: 4200.0,
      tds: 2800.0,
      otherDeductions: 500.0,
      paymentDate: null,
      status: 'pending',
      slipNumber: '',
      workingDays: 0,
      totalWorkingDays: 23,
      overtime: 0.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Salary Management',
                  icon: Icons.account_balance,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.circular(
                        AppThemeResponsiveness.getCardBorderRadius(context),
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
                        CustomTabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'Salary History'),
                            Tab(text: 'Payment Status'),
                            Tab(text: 'Summary'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildSalaryHistoryTab(),
                              _buildPaymentStatusTab(),
                              _buildSummaryTab(),
                            ],
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
    );
  }

  Widget _buildSalaryHistoryTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 1200;

        if (isDesktop) {
          return _buildResponsiveGrid(crossAxisCount: 3);
        } else if (isTablet) {
          return _buildResponsiveGrid(crossAxisCount: 2);
        } else {
          return _buildSalaryList();
        }
      },
    );
  }

  Widget _buildResponsiveGrid({required int crossAxisCount}) {
    return GridView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppThemeResponsiveness.getDefaultSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDefaultSpacing(context),
        childAspectRatio: 0.8,
      ),
      itemCount: _salaryRecords.length,
      itemBuilder: (context, index) => _buildSalaryCard(_salaryRecords[index], isGrid: true),
    );
  }

  Widget _buildSalaryList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: _salaryRecords.length,
      itemBuilder: (context, index) => _buildSalaryCard(_salaryRecords[index]),
    );
  }

  Widget _buildPaymentStatusTab() {
    final pendingSalaries = _salaryRecords.where((r) => r.status != 'paid').toList();
    final paidSalaries = _salaryRecords.where((r) => r.status == 'paid').toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentSummaryCard(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          if (pendingSalaries.isNotEmpty) ...[
            _buildSectionHeader('Pending Payments', Colors.orange[700]!),
            ...pendingSalaries.map((record) => _buildSalaryCard(record)).toList(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          ],
          _buildSectionHeader('Completed Payments', Colors.green[700]!),
          ...paidSalaries.map((record) => _buildSalaryCard(record)).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYearlySummaryCard(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildDeductionsSummaryCard(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildAllowancesSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      child: Text(
        title,
        style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(color: color),
      ),
    );
  }

  Widget _buildSalaryCard(SalaryRecord record, {bool isGrid = false}) {
    final statusColor = _getStatusColor(record.status);
    final statusIcon = _getStatusIcon(record.status);
    final netSalary = record.calculateNetSalary();

    return Container(
      margin: isGrid
          ? EdgeInsets.zero
          : EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Padding(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSalaryCardHeader(record, statusColor, statusIcon),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildSalaryCardDetails(record, netSalary),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildSalaryCardActions(record, isGrid),
            if (record.slipNumber.isNotEmpty) ...[
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildSlipInfo(record),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryCardHeader(SalaryRecord record, Color statusColor, IconData statusIcon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${record.month} ${record.year}',
            style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getSmallSpacing(context),
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: 14),
              SizedBox(width: 4),
              Text(
                record.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryCardDetails(SalaryRecord record, double netSalary) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.work, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              'Working Days: ${record.workingDays}/${record.totalWorkingDays}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
            ),
          ],
        ),
        if (record.paymentDate != null) ...[
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.payment, size: 16, color: Colors.green),
              SizedBox(width: 4),
              Text(
                'Paid: ${_formatDate(record.paymentDate!)}',
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gross: ₹${record.calculateGrossSalary().toStringAsFixed(2)}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
            ),
            Text(
              'Deductions: ₹${record.calculateTotalDeductions().toStringAsFixed(2)}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalaryCardActions(SalaryRecord record, bool isGrid) {
    final netSalary = record.calculateNetSalary();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '₹${netSalary.toStringAsFixed(2)}',
          style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
            color: AppThemeColor.primaryBlue,
            fontSize: isGrid ? 16 : 18,
          ),
        ),
        Row(
          children: [
            if (record.status == 'paid') ...[
              IconButton(
                onPressed: () => _downloadSalarySlip(record),
                icon: Icon(Icons.download, color: AppThemeColor.primaryBlue),
                tooltip: 'Download Salary Slip',
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
            IconButton(
              onPressed: () => _showSalaryDetailsDialog(record),
              icon: Icon(Icons.info_outline, color: AppThemeColor.primaryBlue),
              tooltip: 'View Details',
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlipInfo(SalaryRecord record) {
    return Text(
      'Slip: ${record.slipNumber}',
      style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    final totalPaid = _salaryRecords
        .where((r) => r.status == 'paid')
        .fold(0.0, (sum, r) => sum + r.calculateNetSalary());
    final totalPending = _salaryRecords
        .where((r) => r.status != 'paid')
        .fold(0.0, (sum, r) => sum + r.calculateNetSalary());

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.primaryBlue,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Column(
        children: [
          Text(
            'Payment Summary',
            style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Total Paid', totalPaid, Colors.green),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getSmallSpacing(context)),
              ),
              Expanded(
                child: _buildSummaryItem('Pending', totalPending, Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearlySummaryCard() {
    final currentYear = DateTime.now().year.toString();
    final yearlyRecords = _salaryRecords.where((r) => r.year == currentYear).toList();
    final totalEarned = yearlyRecords
        .where((r) => r.status == 'paid')
        .fold(0.0, (sum, r) => sum + r.calculateNetSalary());

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Column(
        children: [
          Text(
            'Yearly Summary ($currentYear)',
            style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            '₹${totalEarned.toStringAsFixed(2)}',
            style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Text(
            'Total Earned',
            style: AppThemeResponsiveness.getStatTitleStyle(context).copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionsSummaryCard() {
    final totalDeductions = _salaryRecords
        .where((r) => r.status == 'paid')
        .fold(0.0, (sum, r) => sum + r.calculateTotalDeductions());

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Column(
        children: [
          Text(
            'Total Deductions',
            style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            '₹${totalDeductions.toStringAsFixed(2)}',
            style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllowancesSummaryCard() {
    final totalAllowances = _salaryRecords
        .where((r) => r.status == 'paid')
        .fold(0.0, (sum, r) => sum + r.calculateTotalAllowances());

    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Column(
        children: [
          Text(
            'Total Allowances',
            style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            '₹${totalAllowances.toStringAsFixed(2)}',
            style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppThemeResponsiveness.getStatTitleStyle(context).copyWith(
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid': return Colors.green;
      case 'processing': return Colors.blue;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'paid': return Icons.check_circle;
      case 'processing': return Icons.sync;
      case 'pending': return Icons.schedule;
      default: return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showSalaryDetailsDialog(SalaryRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
        ),
        title: Text('Salary Details - ${record.month} ${record.year}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailsSection('Earnings', [
                'Basic Salary: ₹${record.basicSalary.toStringAsFixed(2)}',
                'HRA: ₹${record.hra.toStringAsFixed(2)}',
                'DA: ₹${record.da.toStringAsFixed(2)}',
                'TA: ₹${record.ta.toStringAsFixed(2)}',
                'Medical Allowance: ₹${record.medicalAllowance.toStringAsFixed(2)}',
                'Overtime: ₹${record.overtime.toStringAsFixed(2)}',
              ]),
              SizedBox(height: 16),
              _buildDetailsSection('Deductions', [
                'PF: ₹${record.pf.toStringAsFixed(2)}',
                'TDS: ₹${record.tds.toStringAsFixed(2)}',
                'Other Deductions: ₹${record.otherDeductions.toStringAsFixed(2)}',
              ]),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppThemeColor.blue50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gross Salary:', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('₹${record.calculateGrossSalary().toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Deductions:', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('₹${record.calculateTotalDeductions().toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Net Salary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('₹${record.calculateNetSalary().toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          if (record.status == 'paid')
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadSalarySlip(record);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
              child: Text('Download Slip', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(left: 16, bottom: 4),
          child: Text(item),
        )).toList(),
      ],
    );
  }

  void _downloadSalarySlip(SalaryRecord record) {
    final teacherInfo = TeacherInfo(
      name: 'Teacher Name',
      employeeId: 'EMP001',
      department: 'Mathematics',
      designation: 'Senior Teacher',
      joinDate: DateTime(2020, 1, 15),
      bankAccount: '1234567890',
      panNumber: 'ABCDE1234F',
    );

    salarySlipService.downloadSalarySlip(
      context: context,
      record: record,
      teacherInfo: teacherInfo,
      onLoadingStart: () => setState(() => _isLoading = true),
      onLoadingEnd: () => setState(() => _isLoading = false),
      onError: _showError,
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}