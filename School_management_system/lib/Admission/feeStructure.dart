import 'package:flutter/material.dart';
import 'package:school/customWidgets/admissionCustomWidgets/feeCommonDataModel.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/button.dart';

class FacilitiesListPage extends StatefulWidget {
  final List<Facility> facilities;
  final double? initialTotalAmount;

  const FacilitiesListPage({
    Key? key,
    required this.facilities,
    this.initialTotalAmount,
  }) : super(key: key);

  @override
  State<FacilitiesListPage> createState() => _FacilitiesListPageState();
}

class _FacilitiesListPageState extends State<FacilitiesListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Map to track selected facilities
  Map<String, bool> selectedFacilities = {};
  double totalAmount = 0.0;
  late double baseAmount; // Store the initial amount separately

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSelections();
    // Store the initial amount separately
    baseAmount = widget.initialTotalAmount ?? 0.0;
    // Initialize total amount with base amount
    totalAmount = baseAmount;

    // Debug print to check facility fees
    print('=== DEBUGGING FACILITIES ===');
    for (var facility in widget.facilities) {
      print('Facility: ${facility.name}, Fees: ${facility.fees}, Active: ${facility.isActive}');
    }
    print('Base Amount: $baseAmount');
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppThemeColor.slideAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  void _initializeSelections() {
    // Initialize all facilities as unselected
    for (var facility in widget.facilities) {
      selectedFacilities[facility.id] = false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateTotalAmount() {
    // Start with base amount
    double facilitiesTotal = 0.0;

    // Add fees from selected facilities
    for (var facility in widget.facilities) {
      if (selectedFacilities[facility.id] == true && facility.isActive) {
        facilitiesTotal += facility.fees;
        print('Added facility: ${facility.name}, Fee: ${facility.fees}, Running Total: $facilitiesTotal');
      }
    }

    // Update total amount
    double newTotal = baseAmount + facilitiesTotal;

    print('=== TOTAL CALCULATION ===');
    print('Base Amount: $baseAmount');
    print('Facilities Total: $facilitiesTotal');
    print('New Total: $newTotal');

    setState(() {
      totalAmount = newTotal;
    });
  }

  void _toggleSelection(String facilityId) {
    setState(() {
      selectedFacilities[facilityId] = !(selectedFacilities[facilityId] ?? false);
    });
    print('Toggled facility $facilityId to ${selectedFacilities[facilityId]}');
    _updateTotalAmount();
  }

  // Return the total amount including base amount and selected facilities
  void _saveAndReturn() {
    print('Saving total amount: $totalAmount');
    Navigator.pop(context, totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildContentArea(context),
              _buildTotalAmountCard(context),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Text(
        'SELECT FACILITIES',
        style: AppThemeResponsiveness.getFontStyle(context),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(maxWidth: AppThemeResponsiveness.getMaxWidth(context)),
        margin: EdgeInsets.only(
          top: AppThemeResponsiveness.getSmallSpacing(context),
          left: AppThemeResponsiveness.getMediumSpacing(context),
          right: AppThemeResponsiveness.getMediumSpacing(context),
        ),
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getExtraLargeSpacing(context)),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildFacilitiesList(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFacilitiesList(BuildContext context) {
    // Filter only active facilities
    final activeFacilities = widget.facilities.where((f) => f.isActive).toList();

    if (activeFacilities.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      itemCount: activeFacilities.length,
      itemBuilder: (context, index) => _buildFacilityListItem(context, activeFacilities[index]),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: AppThemeResponsiveness.getIconSize(context) * 3,
            color: Colors.grey[400],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            'No active facilities available',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Please add facilities in Facilities Management',
            style: AppThemeResponsiveness.getSubHeadingStyle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityListItem(BuildContext context, Facility facility) {
    final isSelected = selectedFacilities[facility.id] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: isSelected ? AppThemeColor.blue600.withOpacity(0.1) : AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        border: Border.all(
          color: isSelected ? AppThemeColor.blue600 : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleSelection(facility.id),
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          child: Padding(
            padding: AppThemeResponsiveness.getCardPadding(context),
            child: Row(
              children: [
                // Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppThemeColor.blue600 : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppThemeColor.blue600 : Colors.grey[400]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check,
                    color: AppThemeColor.white,
                    size: 16,
                  )
                      : null,
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

                // Facility Icon
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
                  decoration: BoxDecoration(
                    gradient: AppThemeColor.primaryGradient,
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getSmallSpacing(context)),
                  ),
                  child: Icon(
                    Icons.business,
                    color: AppThemeColor.white,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),

                // Facility Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.name,
                        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                          color: isSelected ? AppThemeColor.blue600 : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                      Text(
                        facility.description,
                        style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                          color: Colors.grey[600],
                          fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize! * 0.9,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Fee Amount
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                    vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColor.blue600.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppThemeColor.blue600,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                        color: AppThemeColor.blue600,
                      ),
                      Text(
                        '${facility.fees.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppThemeColor.blue600,
                          fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmountCard(BuildContext context) {
    // Calculate selected facilities fees for display
    double selectedFacilitiesFees = 0.0;
    int selectedCount = 0;

    for (var facility in widget.facilities) {
      if (selectedFacilities[facility.id] == true && facility.isActive) {
        selectedFacilitiesFees += facility.fees;
        selectedCount++;
      }
    }

    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        gradient: AppThemeColor.primaryGradient,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Monthly Fees',
                    style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                      color: AppThemeColor.white70,
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                  Text(
                    '$selectedCount facilities selected',
                    style: TextStyle(
                      color: AppThemeColor.white70,
                      fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! * 0.9,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                decoration: BoxDecoration(
                  color: AppThemeColor.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppThemeColor.white70,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      color: AppThemeColor.white,
                      size: AppThemeResponsiveness.getHeadingStyle(context).fontSize,
                    ),
                    Text(
                      '${totalAmount.toStringAsFixed(0)}',
                      style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                        color: AppThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Breakdown (if there's a base amount or selected facilities)
          if (baseAmount > 0 || selectedFacilitiesFees > 0) ...[
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
              decoration: BoxDecoration(
                color: AppThemeColor.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (baseAmount > 0) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base Amount:',
                          style: TextStyle(
                            color: AppThemeColor.white70,
                            fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! * 0.9,
                          ),
                        ),
                        Text(
                          '₹${baseAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppThemeColor.white,
                            fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! * 0.9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Facilities:',
                        style: TextStyle(
                          color: AppThemeColor.white70,
                          fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! * 0.9,
                        ),
                      ),
                      Text(
                        '₹${selectedFacilitiesFees.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppThemeColor.white,
                          fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize! * 0.9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      child: AppThemeResponsiveness.isSmallPhone(context)
          ? Column(
        children: [
          PrimaryButton(
            title: 'Save & Continue',
            onPressed: _saveAndReturn,
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SecondaryButton(
            title: 'Cancel',
            icon: Icon(Icons.close, color: Colors.grey[600]),
            color: Colors.grey[600]!,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: SecondaryButton(
              title: 'Cancel',
              icon: Icon(Icons.close, color: Colors.grey[600]),
              color: Colors.grey[600]!,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: PrimaryButton(
              title: 'Save & Continue',
              onPressed: _saveAndReturn,
            ),
          ),
        ],
      ),
    );
  }
}