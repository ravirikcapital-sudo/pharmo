import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/dashboard/adminDashboardModel/feeManagementAdmin.dart';

class FeeManagementPage extends StatefulWidget {
  @override
  _FeeManagementPageState createState() => _FeeManagementPageState();
}

class _FeeManagementPageState extends State<FeeManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Status filter for payment status tab
  String _selectedStatus = 'All'; // All, Paid, Due, Late

  // Monthly fee tracking
  String _selectedMonth = DateTime.now().month.toString();
  String _selectedYear = DateTime.now().year.toString();

  // Available months and years for dropdown
  List<String> _months = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
  ];

  List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  List<String> _years = ['2023', '2024', '2025', '2026'];

  // Sample Data with monthly information
  List<FeeSlip> feeSlips = [
    FeeSlip(
      id: 'FEE001',
      studentId: 'STU001',
      studentName: 'John Doe',
      className: 'Class 10-A',
      totalAmount: 5000.0,
      paidAmount: 5000.0,
      dueAmount: 0.0,
      status: 'Paid',
      dueDate: DateTime(2024, 12, 15),
      paidDate: DateTime(2024, 12, 10),
      month: 12,
      year: 2024,
      feeItems: [
        FeeItem(name: 'Tuition Fee', amount: 3000.0, type: 'tuition'),
        FeeItem(name: 'Transport Fee', amount: 1500.0, type: 'transport'),
        FeeItem(name: 'Library Fee', amount: 500.0, type: 'library'),
      ],
    ),
    FeeSlip(
      id: 'FEE002',
      studentId: 'STU002',
      studentName: 'Jane Smith',
      className: 'Class 9-B',
      totalAmount: 4800.0,
      paidAmount: 2400.0,
      dueAmount: 2400.0,
      status: 'Due',
      dueDate: DateTime(2024, 12, 20),
      month: 12,
      year: 2024,
      feeItems: [
        FeeItem(name: 'Tuition Fee', amount: 2800.0, type: 'tuition'),
        FeeItem(name: 'Transport Fee', amount: 1500.0, type: 'transport'),
        FeeItem(name: 'Activity Fee', amount: 500.0, type: 'activity'),
      ],
    ),
    FeeSlip(
      id: 'FEE003',
      studentId: 'STU003',
      studentName: 'Mike Johnson',
      className: 'Class 8-A',
      totalAmount: 4500.0,
      paidAmount: 0.0,
      dueAmount: 4500.0,
      status: 'Late',
      dueDate: DateTime(2024, 11, 25),
      month: 11,
      year: 2024,
      feeItems: [
        FeeItem(name: 'Tuition Fee', amount: 3000.0, type: 'tuition'),
        FeeItem(name: 'Lab Fee', amount: 1000.0, type: 'lab'),
        FeeItem(name: 'Sports Fee', amount: 500.0, type: 'sports'),
      ],
    ),
    FeeSlip(
      id: 'FEE004',
      studentId: 'STU004',
      studentName: 'Sarah Wilson',
      className: 'Class 11-A',
      totalAmount: 5200.0,
      paidAmount: 5200.0,
      dueAmount: 0.0,
      status: 'Paid',
      dueDate: DateTime(2025, 1, 15),
      paidDate: DateTime(2025, 1, 10),
      month: 1,
      year: 2025,
      feeItems: [
        FeeItem(name: 'Tuition Fee', amount: 3500.0, type: 'tuition'),
        FeeItem(name: 'Transport Fee', amount: 1200.0, type: 'transport'),
        FeeItem(name: 'Library Fee', amount: 500.0, type: 'library'),
      ],
    ),
  ];

  List<Discount> discounts = [
    Discount(
      id: 'DIS001',
      name: 'Sibling Discount',
      type: 'percentage',
      value: 10.0,
      description: '10% discount for siblings',
      isActive: true,
    ),
    Discount(
      id: 'DIS002',
      name: 'Merit Scholarship',
      type: 'percentage',
      value: 25.0,
      description: '25% scholarship for merit students',
      isActive: true,
    ),
    Discount(
      id: 'DIS003',
      name: 'Early Payment',
      type: 'fixed',
      value: 200.0,
      description: 'Rs. 200 off for early payment',
      isActive: true,
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

  // Get filtered fee slips based on selected status and month/year
  List<FeeSlip> _getFilteredFeeSlips() {
    return feeSlips.where((feeSlip) {
      bool statusMatch = _selectedStatus == 'All' || feeSlip.status == _selectedStatus;
      bool monthMatch = feeSlip.month == int.parse(_selectedMonth);
      bool yearMatch = feeSlip.year == int.parse(_selectedYear);
      return statusMatch && monthMatch && yearMatch;
    }).toList();
  }

  // Get counts for current month/year
  Map<String, int> _getStatusCounts() {
    final filteredSlips = feeSlips.where((feeSlip) {
      return feeSlip.month == int.parse(_selectedMonth) &&
          feeSlip.year == int.parse(_selectedYear);
    }).toList();

    return {
      'Paid': filteredSlips.where((f) => f.status == 'Paid').length,
      'Due': filteredSlips.where((f) => f.status == 'Due').length,
      'Late': filteredSlips.where((f) => f.status == 'Late').length,
    };
  }

  // Fee Slip Methods
  void _generateFeeSlip() {
    _showFeeSlipDialog();
  }

  void _editFeeSlip(FeeSlip feeSlip) {
    _showFeeSlipDialog(feeSlip: feeSlip);
  }

  void _showFeeSlipDialog({FeeSlip? feeSlip}) {
    final isEditing = feeSlip != null;
    final studentNameController = TextEditingController(text: feeSlip?.studentName ?? '');
    final classNameController = TextEditingController(text: feeSlip?.className ?? '');
    final totalAmountController = TextEditingController(text: feeSlip?.totalAmount.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Fee Slip' : 'Generate Fee Slip'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Student Name', studentNameController, Icons.person),
                SizedBox(height: AppThemeColor.smallSpacing),
                _buildTextField('Class', classNameController, Icons.class_),
                SizedBox(height: AppThemeColor.smallSpacing),
                _buildTextField('Total Amount', totalAmountController, Icons.currency_rupee),
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
                // Add fee slip logic here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
              child: Text(
                isEditing ? 'Update' : 'Generate',
                style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  // Discount Methods
  void _addDiscount() {
    _showDiscountDialog();
  }

  void _editDiscount(Discount discount) {
    _showDiscountDialog(discount: discount);
  }

  void _showDiscountDialog({Discount? discount}) {
    final isEditing = discount != null;
    final nameController = TextEditingController(text: discount?.name ?? '');
    final valueController = TextEditingController(text: discount?.value.toString() ?? '');
    final descriptionController = TextEditingController(text: discount?.description ?? '');
    String selectedType = discount?.type ?? 'percentage';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Discount' : 'Add Discount'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Discount Name', nameController, Icons.local_offer),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        prefixIcon: Icon(Icons.type_specimen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                        ),
                      ),
                      items: ['percentage', 'fixed'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type == 'percentage' ? 'Percentage (%)' : 'Fixed Amount (₹)'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    _buildTextField('Value', valueController, Icons.numbers),
                    SizedBox(height: AppThemeColor.smallSpacing),
                    _buildTextField('Description', descriptionController, Icons.description),
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
                    // Add discount logic here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppThemeColor.primaryBlue),
                  child: Text(
                    isEditing ? 'Update' : 'Add',
                    style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
          borderSide: BorderSide(
            color: AppThemeColor.primaryBlue,
            width: AppThemeColor.focusedBorderWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildClickableStatusCard(String status, int count, Color color, IconData icon) {
    bool isSelected = _selectedStatus == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Card(
        elevation: isSelected ? 6 : 3,
        color: isSelected ? color.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected ? BorderSide(color: color, width: 2) : BorderSide.none,
        ),
        child: Container(
          padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(height: 8),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.black87,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthYearSelector() {
    return Container(
      padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: InputDecoration(
                labelText: 'Month',
                prefixIcon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                ),
              ),
              items: _months.map((month) {
                int monthIndex = int.parse(month) - 1;
                return DropdownMenuItem(
                  value: month,
                  child: Text(_monthNames[monthIndex]),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value!;
                });
              },
            ),
          ),
          SizedBox(width: AppThemeColor.smallSpacing),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedYear,
              decoration: InputDecoration(
                labelText: 'Year',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppThemeColor.inputBorderRadius),
                ),
              ),
              items: _years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeSlipsTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fee Slips (${feeSlips.length})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _generateFeeSlip,
                icon: Icon(Icons.add),
                label: Text('Generate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColor.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
            itemCount: feeSlips.length,
            itemBuilder: (context, index) {
              final feeSlip = feeSlips[index];
              return Card(
                margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: feeSlip.status == 'Paid'
                        ? Colors.green
                        : feeSlip.status == 'Due'
                        ? Colors.orange
                        : Colors.red,
                    child: Icon(Icons.receipt, color: Colors.white),
                  ),
                  title: Text(
                    feeSlip.studentName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class: ${feeSlip.className}'),
                      Text('Month: ${_monthNames[feeSlip.month - 1]} ${feeSlip.year}'),
                      Text('Total: ₹${feeSlip.totalAmount}'),
                      Text('Paid: ₹${feeSlip.paidAmount}'),
                      Text('Due: ₹${feeSlip.dueAmount}'),
                      Row(
                        children: [
                          Text('Status: '),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: feeSlip.status == 'Paid'
                                  ? Colors.green.shade100
                                  : feeSlip.status == 'Due'
                                  ? Colors.orange.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              feeSlip.status,
                              style: TextStyle(
                                color: feeSlip.status == 'Paid'
                                    ? Colors.green.shade800
                                    : feeSlip.status == 'Due'
                                    ? Colors.orange.shade800
                                    : Colors.red.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => _editFeeSlip(feeSlip),
                    icon: Icon(Icons.edit, color: AppThemeColor.primaryBlue),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                      child: Column(
                        children: feeSlip.feeItems.map((item) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name),
                              Text('₹${item.amount}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusTab() {
    final statusCounts = _getStatusCounts();
    final filteredFeeSlips = _getFilteredFeeSlips();
    int monthIndex = int.parse(_selectedMonth) - 1;

    return Column(
      children: [
        // Month/Year Selector
        _buildMonthYearSelector(),

        // Current Month/Year Display
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
          child: Text(
            'Fees for ${_monthNames[monthIndex]} $_selectedYear',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemeColor.white,
            ),
          ),
        ),

        SizedBox(height: AppThemeColor.smallSpacing),

        // Clickable Summary Cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
          child: Row(
            children: [
              Expanded(
                child: _buildClickableStatusCard(
                  'Paid',
                  statusCounts['Paid']!,
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              SizedBox(width: AppThemeColor.smallSpacing),
              Expanded(
                child: _buildClickableStatusCard(
                  'Due',
                  statusCounts['Due']!,
                  Colors.orange,
                  Icons.schedule,
                ),
              ),
              SizedBox(width: AppThemeColor.smallSpacing),
              Expanded(
                child: _buildClickableStatusCard(
                  'Late',
                  statusCounts['Late']!,
                  Colors.red,
                  Icons.warning,
                ),
              ),
            ],
          ),
        ),

        // Show All Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedStatus = 'All';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedStatus == 'All' ? AppThemeColor.primaryBlue : Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: Text('Show All'),
          ),
        ),

        SizedBox(height: AppThemeColor.smallSpacing),

        // Payment Status List
        Expanded(
          child: filteredFeeSlips.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No fee slips found for ${_monthNames[monthIndex]} $_selectedYear',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                if (_selectedStatus != 'All') ...[
                  SizedBox(height: 8),
                  Text(
                    'Status: $_selectedStatus',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ],
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
            itemCount: filteredFeeSlips.length,
            itemBuilder: (context, index) {
              final feeSlip = filteredFeeSlips[index];
              return Card(
                margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: feeSlip.status == 'Paid'
                        ? Colors.green
                        : feeSlip.status == 'Due'
                        ? Colors.orange
                        : Colors.red,
                    child: Text(
                      feeSlip.status[0],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(feeSlip.studentName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class: ${feeSlip.className}'),
                      Text('₹${feeSlip.dueAmount} remaining'),
                      Text('Due Date: ${feeSlip.dueDate.day}/${feeSlip.dueDate.month}/${feeSlip.dueDate.year}'),
                    ],
                  ),
                  trailing: Text(
                    feeSlip.status,
                    style: TextStyle(
                      color: feeSlip.status == 'Paid'
                          ? Colors.green
                          : feeSlip.status == 'Due'
                          ? Colors.orange
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountsTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(AppThemeColor.defaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discounts & Scholarships',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addDiscount,
                icon: Icon(Icons.add),
                label: Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColor.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppThemeColor.defaultSpacing),
            itemCount: discounts.length,
            itemBuilder: (context, index) {
              final discount = discounts[index];
              return Card(
                margin: EdgeInsets.only(bottom: AppThemeColor.smallSpacing),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(AppThemeColor.mediumSpacing),
                  leading: CircleAvatar(
                    backgroundColor: AppThemeColor.primaryBlue,
                    child: Icon(Icons.local_offer, color: Colors.white),
                  ),
                  title: Text(
                    discount.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Value: ${discount.type == 'percentage' ? '${discount.value}%' : '₹${discount.value}'}'),
                      Text(discount.description),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: discount.isActive ? Colors.green.shade100 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          discount.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: discount.isActive ? Colors.green.shade800 : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _editDiscount(discount),
                        icon: Icon(Icons.edit, color: AppThemeColor.primaryBlue),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              HeaderSection(
                title: 'Fee Management',
                icon: Icons.payment,
              ),

              // Tab Bar
              CustomTabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Fee Slips'),
                  Tab(text: 'Status'),
                  Tab(text: 'Discounts'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFeeSlipsTab(),
                    _buildPaymentStatusTab(),
                    _buildDiscountsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


