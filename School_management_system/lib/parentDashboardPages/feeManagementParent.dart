import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class FeePaymentParentPage extends StatefulWidget {
  @override
  _FeePaymentParentPageState createState() => _FeePaymentParentPageState();
}

class _FeePaymentParentPageState extends State<FeePaymentParentPage> {
  // Sample data - replace with actual data from your backend
  final List<PaymentRecord> paymentHistory = [
    PaymentRecord(
      month: 'November 2024',
      amount: 5000.0,
      status: PaymentStatus.paid,
      dueDate: DateTime(2024, 11, 15),
      paidDate: DateTime(2024, 11, 10),
    ),
    PaymentRecord(
      month: 'December 2024',
      amount: 5000.0,
      status: PaymentStatus.pending,
      dueDate: DateTime(2024, 12, 15),
    ),
    PaymentRecord(
      month: 'January 2025',
      amount: 5000.0,
      status: PaymentStatus.overdue,
      dueDate: DateTime(2025, 1, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SingleChildScrollView(
          padding: AppThemeResponsiveness.getScreenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Summary Card
              _buildPaymentSummaryCard(),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

              // Quick Actions
              _buildQuickActionsCard(),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

              // Payment History
              Text(
                'Payment History',
                style: AppThemeResponsiveness.getSectionTitleStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

              // Payment Records
              ...paymentHistory.map((record) => _buildPaymentCard(record)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    final pendingAmount = paymentHistory
        .where((record) => record.status != PaymentStatus.paid)
        .fold(0.0, (sum, record) => sum + record.amount);

    final lastPayment = paymentHistory
        .where((record) => record.status == PaymentStatus.paid)
        .isNotEmpty
        ? paymentHistory.where((record) => record.status == PaymentStatus.paid).last
        : null;

    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeColor.blue200,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppThemeColor.blue600,
                  size: AppThemeResponsiveness.getHeaderIconSize(context),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  'Payment Summary',
                  style: AppThemeResponsiveness.getTitleTextStyle(context).copyWith(
                    color: AppThemeColor.blue600,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

            // Responsive layout for pending and last payment
            AppThemeResponsiveness.isSmallPhone(context)
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentSummaryItem(
                  'Pending Amount',
                  '₹${pendingAmount.toStringAsFixed(0)}',
                  context,
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                _buildPaymentSummaryItem(
                  'Last Payment',
                  lastPayment != null
                      ? '₹${lastPayment.amount.toStringAsFixed(0)}'
                      : 'No payments',
                  context,
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentSummaryItem(
                  'Pending Amount',
                  '₹${pendingAmount.toStringAsFixed(0)}',
                  context,
                ),
                _buildPaymentSummaryItem(
                  'Last Payment',
                  lastPayment != null
                      ? '₹${lastPayment.amount.toStringAsFixed(0)}'
                      : 'No payments',
                  context,
                  isAlignedRight: true,
                ),
              ],
            ),

            if (lastPayment != null) ...[
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Paid on: ${_formatDate(lastPayment.paidDate!)}',
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12.0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryItem(String title, String amount, BuildContext context, {bool isAlignedRight = false}) {
    return Column(
      crossAxisAlignment: isAlignedRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppThemeResponsiveness.getSubHeadingStyle(context),
        ),
        SizedBox(height: 4.0),
        Text(
          amount,
          style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 24.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18.0),
                color: AppThemeColor.blue800,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            // Responsive action buttons layout
            AppThemeResponsiveness.isSmallPhone(context)
                ? Column(
              children: [
                _buildActionButton(
                  'Make Payment',
                  Icons.payment,
                  AppThemeColor.primaryBlue,
                      () => _showPaymentDialog(),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildActionButton(
                  'Download Receipt',
                  Icons.download,
                  AppThemeColor.primaryIndigo,
                      () => _downloadReceipt(),
                ),
              ],
            )
                : Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Make Payment',
                    Icons.payment,
                    AppThemeColor.primaryBlue,
                        () => _showPaymentDialog(),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                Expanded(
                  child: _buildActionButton(
                    'Download Receipt',
                    Icons.download,
                    AppThemeColor.primaryIndigo,
                        () => _downloadReceipt(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppThemeColor.white,
        padding: EdgeInsets.symmetric(
          vertical: AppThemeResponsiveness.getResponsiveHeight(context, 0.02),
          horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
        elevation: AppThemeResponsiveness.getButtonElevation(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppThemeResponsiveness.getIconSize(context)),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12.0),
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(PaymentRecord record) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      margin: AppThemeResponsiveness.getHistoryCardMargin(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with month and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    record.month,
                    style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                      fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16.0),
                      color: AppThemeColor.blue800,
                    ),
                  ),
                ),
                _buildStatusChip(record.status),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

            // Amount and date section
            AppThemeResponsiveness.isSmallPhone(context)
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentDetailItem(
                  'Amount',
                  '₹${record.amount.toStringAsFixed(0)}',
                  context,
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildPaymentDetailItem(
                  record.status == PaymentStatus.paid ? 'Paid Date' : 'Due Date',
                  _formatDate(record.status == PaymentStatus.paid
                      ? record.paidDate!
                      : record.dueDate),
                  context,
                  isOverdue: record.status == PaymentStatus.overdue,
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentDetailItem(
                  'Amount',
                  '₹${record.amount.toStringAsFixed(0)}',
                  context,
                ),
                _buildPaymentDetailItem(
                  record.status == PaymentStatus.paid ? 'Paid Date' : 'Due Date',
                  _formatDate(record.status == PaymentStatus.paid
                      ? record.paidDate!
                      : record.dueDate),
                  context,
                  isAlignedRight: true,
                  isOverdue: record.status == PaymentStatus.overdue,
                ),
              ],
            ),

            // Action buttons
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            if (record.status != PaymentStatus.paid) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _payNow(record),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: record.status == PaymentStatus.overdue
                        ? Colors.red
                        : AppThemeColor.primaryBlue,
                    foregroundColor: AppThemeColor.white,
                    padding: EdgeInsets.symmetric(
                      vertical: AppThemeResponsiveness.getResponsiveHeight(context, 0.015),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    elevation: AppThemeResponsiveness.getButtonElevation(context),
                  ),
                  child: Text(
                    'Pay Now',
                    style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                      fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16.0),
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _downloadReceiptForRecord(record),
                  icon: Icon(
                    Icons.download,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  ),
                  label: Text(
                    'Download Receipt',
                    style: TextStyle(
                      fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppThemeColor.primaryBlue,
                    side: BorderSide(color: AppThemeColor.primaryBlue),
                    padding: EdgeInsets.symmetric(
                      vertical: AppThemeResponsiveness.getResponsiveHeight(context, 0.015),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailItem(String title, String value, BuildContext context, {bool isAlignedRight = false, bool isOverdue = false}) {
    return Column(
      crossAxisAlignment: isAlignedRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12.0),
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18.0),
            fontWeight: FontWeight.bold,
            color: isOverdue ? Colors.red : AppThemeColor.blue800,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(PaymentStatus status) {
    Color color;
    String text;

    switch (status) {
      case PaymentStatus.paid:
        color = Colors.green;
        text = 'Paid';
        break;
      case PaymentStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case PaymentStatus.overdue:
        color = Colors.red;
        text = 'Overdue';
        break;
    }

    return Container(
      padding: AppThemeResponsiveness.getStatusBadgePadding(context),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 20.0)),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
          ),
          title: Text(
            'Make Payment',
            style: AppThemeResponsiveness.getDialogTitleStyle(context),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select payment method:',
                style: AppThemeResponsiveness.getDialogContentStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              _buildPaymentMethodTile('Credit/Debit Card', Icons.credit_card, 'Card'),
              _buildPaymentMethodTile('Net Banking', Icons.account_balance, 'Net Banking'),
              _buildPaymentMethodTile('UPI', Icons.phone_android, 'UPI'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodTile(String title, IconData icon, String method) {
    return ListTile(
      leading: Icon(
        icon,
        size: AppThemeResponsiveness.getIconSize(context),
        color: AppThemeColor.primaryBlue,
      ),
      title: Text(
        title,
        style: AppThemeResponsiveness.getBodyTextStyle(context),
      ),
      onTap: () {
        Navigator.pop(context);
        _processPayment(method);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
      ),
    );
  }

  void _processPayment(String method) {
    // Implement payment processing logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Processing payment via $method...',
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(color: Colors.white),
        ),
        backgroundColor: AppThemeColor.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }

  void _payNow(PaymentRecord record) {
    // Implement specific payment for a record
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Processing payment for ${record.month}...',
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(color: Colors.white),
        ),
        backgroundColor: AppThemeColor.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }

  void _downloadReceipt() {
    // Implement receipt download logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading latest receipt...',
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(color: Colors.white),
        ),
        backgroundColor: AppThemeColor.primaryIndigo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }

  void _downloadReceiptForRecord(PaymentRecord record) {
    // Implement specific receipt download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading receipt for ${record.month}...',
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(color: Colors.white),
        ),
        backgroundColor: AppThemeColor.primaryIndigo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }
}

// Data Models
enum PaymentStatus { paid, pending, overdue }

class PaymentRecord {
  final String month;
  final double amount;
  final PaymentStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;

  PaymentRecord({
    required this.month,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
  });
}