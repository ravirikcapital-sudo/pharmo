import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/StudentDashboardPages/feeManagementStudent/downloadReciept.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/studentDashboardModel/feeManagementStudentDashboard.dart';

class FeeManagementScreenStudent extends StatefulWidget {
  @override
  _FeeManagementScreenStudentState createState() => _FeeManagementScreenStudentState();
}

class _FeeManagementScreenStudentState extends State<FeeManagementScreenStudent>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final receiptService = ReceiptPDFService(
    config: ReceiptConfig(
      schoolName: 'Your School Name',
      contactEmail: 'admin@yourschool.com',
      contactPhone: '+91-1234567890',
      primaryColor: Colors.blue,
      secondaryColor: Colors.green,
    ),
  );

  final List<FeeRecord> _feeRecords = [
    FeeRecord(
      id: '001',
      description: 'Tuition Fee - Term 1',
      amount: 15000.0,
      dueDate: DateTime(2024, 4, 15),
      paidDate: DateTime(2024, 4, 10),
      status: 'paid',
      receiptNumber: 'RPS2024001',
      academicYear: '2024-25',
      term: 'Term 1',
    ),
    FeeRecord(
      id: '002',
      description: 'Examination Fee',
      amount: 2500.0,
      dueDate: DateTime(2024, 6, 20),
      paidDate: DateTime(2024, 6, 18),
      status: 'paid',
      receiptNumber: 'RPS2024002',
      academicYear: '2024-25',
      term: 'Term 1',
    ),
    FeeRecord(
      id: '003',
      description: 'Tuition Fee - Term 2',
      amount: 15000.0,
      dueDate: DateTime(2024, 8, 15),
      status: 'pending',
      receiptNumber: '',
      academicYear: '2024-25',
      term: 'Term 2',
    ),
    FeeRecord(
      id: '004',
      description: 'Library Fee',
      amount: 1000.0,
      dueDate: DateTime(2024, 7, 1),
      status: 'overdue',
      receiptNumber: '',
      academicYear: '2024-25',
      term: 'Term 2',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  title: 'Fee Management',
                  icon: Icons.account_balance_wallet,
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
                            Tab(text: 'Fee History'),
                            Tab(text: 'Payment Status'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildFeeHistoryTab(),
                              _buildPaymentStatusTab(),
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

  Widget _buildFeeHistoryTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 1200;

        if (isDesktop) {
          return _buildResponsiveGrid(crossAxisCount: 3);
        } else if (isTablet) {
          return _buildResponsiveGrid(crossAxisCount: 2);
        } else {
          return _buildFeeList();
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
        childAspectRatio: 0.9,
      ),
      itemCount: _feeRecords.length,
      itemBuilder: (context, index) => _buildFeeCard(_feeRecords[index], isGrid: true),
    );
  }

  Widget _buildFeeList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: _feeRecords.length,
      itemBuilder: (context, index) => _buildFeeCard(_feeRecords[index]),
    );
  }

  Widget _buildPaymentStatusTab() {
    final pendingFees = _feeRecords.where((r) => r.status != 'paid').toList();
    final paidFees = _feeRecords.where((r) => r.status == 'paid').toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          if (pendingFees.isNotEmpty) ...[
            _buildSectionHeader('Pending Payments', Colors.red[700]!),
            ...pendingFees.map((record) => _buildFeeCard(record)).toList(),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          ],
          _buildSectionHeader('Completed Payments', Colors.green[700]!),
          ...paidFees.map((record) => _buildFeeCard(record)).toList(),
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

  Widget _buildFeeCard(FeeRecord record, {bool isGrid = false}) {
    final statusColor = _getStatusColor(record.status);
    final statusIcon = _getStatusIcon(record.status);

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
            _buildCardHeader(record, statusColor, statusIcon),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildCardDates(record),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildCardActions(record, isGrid),
            if (record.receiptNumber.isNotEmpty) ...[
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildReceiptInfo(record),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(FeeRecord record, Color statusColor, IconData statusIcon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            record.description,
            style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
            maxLines: 2,
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

  Widget _buildCardDates(FeeRecord record) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              'Due: ${_formatDate(record.dueDate)}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
            ),
          ],
        ),
        if (record.paidDate != null) ...[
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green),
              SizedBox(width: 4),
              Text(
                'Paid: ${_formatDate(record.paidDate!)}',
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCardActions(FeeRecord record, bool isGrid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '₹${record.amount.toStringAsFixed(2)}',
          style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
            color: AppThemeColor.primaryBlue,
            fontSize: isGrid ? 16 : 18,
          ),
        ),
        Row(
          children: [
            if (record.status == 'paid') ...[
              IconButton(
                onPressed: () => _downloadReceipt(record),
                icon: Icon(Icons.download, color: AppThemeColor.primaryBlue),
                tooltip: 'Download Receipt',
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () => _showPaymentDialog(record),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColor.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppThemeResponsiveness.getButtonBorderRadius(context),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildReceiptInfo(FeeRecord record) {
    return Text(
      'Receipt: ${record.receiptNumber}',
      style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalPaid = _feeRecords
        .where((r) => r.status == 'paid')
        .fold(0.0, (sum, r) => sum + r.amount);
    final totalPending = _feeRecords
        .where((r) => r.status != 'paid')
        .fold(0.0, (sum, r) => sum + r.amount);

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
      case 'pending': return Colors.orange;
      case 'overdue': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'paid': return Icons.check_circle;
      case 'pending': return Icons.schedule;
      case 'overdue': return Icons.warning;
      default: return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPaymentDialog(FeeRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
        ),
        title: Text('Payment Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to pay the following fee?'),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
              decoration: BoxDecoration(
                color: AppThemeColor.blue50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.description, style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount:'),
                      Text('₹${record.amount.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppThemeColor.primaryBlue)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Due Date:'),
                      Text(_formatDate(record.dueDate)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processPayment(record);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
            child: Text('Pay Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _processPayment(FeeRecord record) async {
    _showLoadingDialog();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      record.status = 'paid';
      record.paidDate = DateTime.now();
      record.receiptNumber = 'RPS${DateTime.now().millisecondsSinceEpoch}';
    });

    Navigator.of(context).pop();
    _showPaymentSuccessDialog(record);
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppThemeColor.primaryBlue),
            ),
            SizedBox(height: 16),
            Text('Processing Payment...'),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog(FeeRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            SizedBox(height: 16),
            Text('Payment Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 8),
            Text('Your payment has been processed successfully.'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppThemeColor.blue50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Receipt Number:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(record.receiptNumber,
                          style: TextStyle(color: AppThemeColor.primaryBlue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount Paid:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('₹${record.amount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _downloadReceipt(record);
            },
            child: Text('Download Receipt'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
            child: Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _downloadReceipt(FeeRecord record) {
    final studentInfo = StudentInfo(
      name: 'Student Name',
      className: 'Class X',
      rollNumber: '12345',
    );

    receiptService.downloadReceipt(
      context: context,
      record: record,
      studentInfo: studentInfo,
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