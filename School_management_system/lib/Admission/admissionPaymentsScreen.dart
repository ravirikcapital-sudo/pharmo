import 'package:flutter/material.dart';
import 'package:school/Admission/feeStructure.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/admissionCustomWidgets/feeCommonDataModel.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/services/admission_api.dart';

class AdmissionPaymentsScreen extends StatefulWidget {
  final double? totalAmount; // Add this parameter to receive the total amount

  const AdmissionPaymentsScreen({super.key, this.totalAmount});

  @override
  State<AdmissionPaymentsScreen> createState() =>
      _AdmissionPaymentsScreenState();
}

class _AdmissionPaymentsScreenState extends State<AdmissionPaymentsScreen> {
  String selectedPaymentMethod = '';
  double currentTotalAmount = 0.0; // Track current total amount

  @override
  void initState() {
    super.initState();
    // Initialize with passed amount or default to 0
    currentTotalAmount = widget.totalAmount ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: AppThemeResponsiveness.getMaxWidth(context),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        AppThemeResponsiveness.getDashboardHorizontalPadding(
                          context,
                        ),
                    vertical:
                        AppThemeResponsiveness.getDashboardVerticalPadding(
                          context,
                        ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: AppThemeResponsiveness.getLargeSpacing(context),
                      ),

                      // Title Section with responsive spacing and text
                      HeaderSection(title: 'Choose Method'),
                      SizedBox(
                        height: AppThemeResponsiveness.getLargeSpacing(context),
                      ),

                      // Payment Options Card with responsive layout
                      _buildPaymentOptionsCard(),

                      SizedBox(
                        height: AppThemeResponsiveness.getExtraLargeSpacing(
                          context,
                        ),
                      ),

                      // Amount Display Card with responsive design
                      _buildAmountDisplayCard(),

                      SizedBox(
                        height: AppThemeResponsiveness.getExtraLargeSpacing(
                          context,
                        ),
                      ),

                      // Navigation Buttons with responsive sizing
                      _buildNavigationButtons(),

                      SizedBox(
                        height: AppThemeResponsiveness.getDefaultSpacing(
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionsCard() {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(
          AppThemeResponsiveness.getActivityItemPadding(context),
        ),
        child: Column(
          children: [
            // UPI Payment Option
            _buildPaymentOption(
              icon: Icons.account_balance_wallet,
              title: 'UPI Payment',
              subtitle: 'Pay using Google Pay, PhonePe, Paytm, etc.',
              paymentMethod: 'UPI',
              onTap: () => _handleUPIPayment(),
            ),

            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            // Card Payment Option
            _buildPaymentOption(
              icon: Icons.credit_card,
              title: 'Card Payment',
              subtitle: 'Pay using Debit/Credit Card',
              paymentMethod: 'CARD',
              onTap: () => _handleCardPayment(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDisplayCard() {
    return GestureDetector(
      onTap: _navigateToFacilities,
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
        ),
        color: AppThemeColor.white.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(
            AppThemeResponsiveness.getActivityItemPadding(context),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
            border: Border.all(color: AppThemeColor.white.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                'Total Amount',
                style: AppThemeResponsiveness.getSubHeadingStyle(
                  context,
                ).copyWith(
                  color: AppThemeColor.white70,
                  fontSize: AppThemeResponsiveness.getTabFontSize(context),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                '₹ ${currentTotalAmount.toStringAsFixed(0)}', // Use dynamic amount
                style: AppThemeResponsiveness.getFontStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                currentTotalAmount > 0
                    ? 'Selected Facilities Fee'
                    : 'Tap to select facilities',
                style: AppThemeResponsiveness.getCaptionTextStyle(
                  context,
                ).copyWith(color: AppThemeColor.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFacilities() async {
    List<Facility> facilityObjects =
        FacilitiesData.getFacilities()
            .map((facilityData) => Facility.fromCommonModel(facilityData))
            .toList();

    // Navigate and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FacilitiesListPage(
              facilities: facilityObjects,
              initialTotalAmount: currentTotalAmount, // Pass current amount
            ),
      ),
    );

    // Update total amount if result is returned
    if (result != null && result is double) {
      setState(() {
        currentTotalAmount = result;
      });
    }
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String paymentMethod,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedPaymentMethod == paymentMethod;

    // Responsive padding and sizing
    double containerPadding = AppThemeResponsiveness.getDefaultSpacing(context);
    double iconContainerPadding =
        AppThemeResponsiveness.getDashboardVerticalPadding(context);
    double iconSize = AppThemeResponsiveness.getDashboardVerticalPadding(
      context,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethod;
        });
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppThemeColor.blue50.withOpacity(0.3)
                  : AppThemeColor.greyl.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          border: Border.all(
            color:
                isSelected
                    ? AppThemeColor.blue600
                    : Colors.grey.withOpacity(0.3),
            width:
                isSelected
                    ? AppThemeResponsiveness.getFocusedBorderWidth(context)
                    : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(iconContainerPadding),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppThemeColor.blue600.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getInputBorderRadius(context),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppThemeColor.blue600 : Colors.grey[600],
                size: iconSize,
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppThemeResponsiveness.getHeadingStyle(
                      context,
                    ).copyWith(
                      color:
                          isSelected ? AppThemeColor.blue600 : Colors.grey[800],
                      fontSize:
                          AppThemeResponsiveness.isSmallPhone(context)
                              ? 14.0
                              : AppThemeResponsiveness.isMediumPhone(context)
                              ? 15.0
                              : AppThemeResponsiveness.isLargePhone(context)
                              ? 16.0
                              : AppThemeResponsiveness.isTablet(context)
                              ? 18.0
                              : 20.0,
                    ),
                  ),
                  SizedBox(
                    height: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                  ),
                  Text(
                    subtitle,
                    style: AppThemeResponsiveness.getSubHeadingStyle(
                      context,
                    ).copyWith(
                      fontSize:
                          AppThemeResponsiveness.isSmallPhone(context)
                              ? 11.0
                              : AppThemeResponsiveness.isMediumPhone(context)
                              ? 12.0
                              : AppThemeResponsiveness.isLargePhone(context)
                              ? 13.0
                              : AppThemeResponsiveness.isTablet(context)
                              ? 14.0
                              : 15.0,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppThemeColor.blue600 : Colors.grey[400],
              size: iconSize * 0.9,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    // Disable payment if amount is 0
    bool canProceed =
        selectedPaymentMethod.isNotEmpty && currentTotalAmount > 0;

    // Responsive button layout - stack vertically on small phones
    if (AppThemeResponsiveness.isSmallPhone(context)) {
      return Column(
        children: [
          PrimaryButton(
            title: 'Proceed to Pay',
            onPressed:
                canProceed
                    ? () {
                      if (selectedPaymentMethod == 'UPI') {
                        _handleUPIPayment();
                      } else if (selectedPaymentMethod == 'CARD') {
                        _handleCardPayment();
                      }
                    }
                    : null,
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SecondaryButton(
            title: 'Back',
            icon: Icon(Icons.arrow_back_rounded, color: AppThemeColor.blue600),
            color: AppThemeColor.blue600,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }

    // Horizontal layout for larger screens
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            title: 'Back',
            icon: Icon(Icons.arrow_back_rounded, color: AppThemeColor.blue600),
            color: AppThemeColor.blue600,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: PrimaryButton(
            title: 'Proceed to Pay',
            onPressed:
                canProceed
                    ? () {
                      if (selectedPaymentMethod == 'UPI') {
                        _handleUPIPayment();
                      } else if (selectedPaymentMethod == 'CARD') {
                        _handleCardPayment();
                      }
                    }
                    : null,
          ),
        ),
      ],
    );
  }

  void _handleUPIPayment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUPIBottomSheet(),
    );
  }

  void _handleCardPayment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCardBottomSheet(),
    );
  }

  Widget _buildUPIBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
        ),
      ),
      padding: EdgeInsets.all(
        AppThemeResponsiveness.getActivityItemPadding(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar with responsive width
          Container(
            width:
                AppThemeResponsiveness.isSmallPhone(context)
                    ? 30
                    : AppThemeResponsiveness.isMobile(context)
                    ? 40
                    : 50,
            height: 4,
            decoration: BoxDecoration(
              color: AppThemeColor.greyl,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          Text(
            'Choose UPI App',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildUPIOption(
            'Google Pay',
            Icons.account_balance_wallet,
            AppThemeColor.blue600,
          ),
          _buildUPIOption(
            'PhonePe',
            Icons.phone_android,
            AppThemeColor.primaryIndigo,
          ),
          _buildUPIOption(
            'Paytm',
            Icons.account_balance,
            AppThemeColor.primaryBlue,
          ),
          _buildUPIOption('Other UPI Apps', Icons.more_horiz, Colors.grey),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        ],
      ),
    );
  }

  Widget _buildUPIOption(String name, IconData icon, Color color) {
    double iconRadius = AppThemeResponsiveness.getActivityIconSize(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getQuickStatsPadding(context),
          vertical: AppThemeResponsiveness.getSmallSpacing(context),
        ),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: iconRadius,
          child: Icon(icon, color: color, size: iconRadius * 0.8),
        ),
        title: Text(
          name,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w500,
            fontSize: AppThemeResponsiveness.getTabFontSize(context),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppThemeResponsiveness.getIconSize(context) * 0.6,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.pop(context);
          _processPayment('UPI', name);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBottomSheet() {
    // Responsive height calculation
    double sheetHeight =
        AppThemeResponsiveness.isSmallPhone(context)
            ? AppThemeResponsiveness.getScreenHeight(context) * 0.8
            : AppThemeResponsiveness.isMobile(context)
            ? AppThemeResponsiveness.getScreenHeight(context) * 0.7
            : AppThemeResponsiveness.getScreenHeight(context) * 0.6;

    return Container(
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
        ),
      ),
      padding: EdgeInsets.all(
        AppThemeResponsiveness.getActivityIconSize(context),
      ),
      height: sheetHeight,
      child: Column(
        children: [
          // Handle bar
          Container(
            width:
                AppThemeResponsiveness.isSmallPhone(context)
                    ? 30
                    : AppThemeResponsiveness.isMobile(context)
                    ? 40
                    : 50,
            height: 4,
            decoration: BoxDecoration(
              color: AppThemeColor.greyd,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          Text(
            'Card Details',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(
            height: AppThemeResponsiveness.getExtraLargeSpacing(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Card Number Field
                  _buildCardInputField(
                    label: 'Card Number',
                    hint: '1234 5678 9012 3456',
                    icon: Icons.credit_card,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(
                    height: AppThemeResponsiveness.getMediumSpacing(context),
                  ),

                  // Expiry and CVV Row - Stack on small phones
                  AppThemeResponsiveness.isSmallPhone(context)
                      ? Column(
                        children: [
                          _buildCardInputField(
                            label: 'Expiry Date',
                            hint: 'MM/YY',
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: AppThemeResponsiveness.getMediumSpacing(
                              context,
                            ),
                          ),
                          _buildCardInputField(
                            label: 'CVV',
                            hint: '123',
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          Expanded(
                            child: _buildCardInputField(
                              label: 'Expiry Date',
                              hint: 'MM/YY',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            width: AppThemeResponsiveness.getMediumSpacing(
                              context,
                            ),
                          ),
                          Expanded(
                            child: _buildCardInputField(
                              label: 'CVV',
                              hint: '123',
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),

                  SizedBox(
                    height: AppThemeResponsiveness.getMediumSpacing(context),
                  ),

                  // Cardholder Name Field
                  _buildCardInputField(
                    label: 'Cardholder Name',
                    hint: 'John Doe',
                    icon: Icons.person,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

          // Pay Button using PrimaryButton with dynamic amount
          PrimaryButton(
            title: 'Pay ₹${currentTotalAmount.toStringAsFixed(0)}',
            onPressed: () {
              Navigator.pop(context);
              _processPayment('Card', 'Credit/Debit Card');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardInputField({
    required String label,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      style: AppThemeResponsiveness.getBodyTextStyle(context),
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: AppThemeColor.blue600,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        prefixIcon:
            icon != null
                ? Icon(icon, size: AppThemeResponsiveness.getIconSize(context))
                : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
          vertical: AppThemeResponsiveness.getMediumSpacing(context),
        ),
      ),
    );
  }

  void _processPayment(String method, String provider) {
    // Show loading dialog with responsive sizing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getCardBorderRadius(context),
              ),
            ),
            contentPadding: EdgeInsets.all(
              AppThemeResponsiveness.getDashboardCardPadding(context),
            ),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width:
                      AppThemeResponsiveness.isSmallPhone(context)
                          ? 20.0
                          : 24.0,
                  height:
                      AppThemeResponsiveness.isSmallPhone(context)
                          ? 20.0
                          : 24.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppThemeColor.blue600,
                    ),
                    strokeWidth: 2.5,
                  ),
                ),
                SizedBox(
                  width: AppThemeResponsiveness.getDefaultSpacing(context),
                ),
                Flexible(
                  child: Text(
                    'Processing payment...',
                    style: AppThemeResponsiveness.getBodyTextStyle(context),
                  ),
                ),
              ],
            ),
          ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Show success dialog with responsive design
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.getCardBorderRadius(context),
                ),
              ),
              contentPadding: EdgeInsets.all(
                AppThemeResponsiveness.getActivityItemPadding(context),
              ),
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: AppThemeResponsiveness.getLogoSize(context) * 3.5,
              ),
              title: Text(
                'Payment Successful!',
                style: AppThemeResponsiveness.getRecentTitleStyle(
                  context,
                ).copyWith(color: Colors.green),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your admission fee has been successfully paid using $provider.',
                    style: AppThemeResponsiveness.getBodyTextStyle(
                      context,
                    ).copyWith(
                      fontSize: AppThemeResponsiveness.getTabFontSize(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: AppThemeResponsiveness.getMediumSpacing(context),
                  ),
                  Container(
                    padding: AppThemeResponsiveness.getCardPadding(context),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppThemeResponsiveness.getInputBorderRadius(context),
                      ),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transaction ID:',
                              style: AppThemeResponsiveness.getCaptionTextStyle(
                                context,
                              ).copyWith(
                                fontSize:
                                    AppThemeResponsiveness.getHistoryTimeFontSize(
                                      context,
                                    ),
                              ),
                            ),
                            Text(
                              'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              style: AppThemeResponsiveness.getBodyTextStyle(
                                context,
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    AppThemeResponsiveness.getHistoryTimeFontSize(
                                      context,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppThemeResponsiveness.getSmallSpacing(
                            context,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount Paid:',
                              style: AppThemeResponsiveness.getCaptionTextStyle(
                                context,
                              ).copyWith(
                                fontSize:
                                    AppThemeResponsiveness.getHistoryTimeFontSize(
                                      context,
                                    ),
                              ),
                            ),
                            Text(
                              '₹ ${currentTotalAmount.toStringAsFixed(0)}', // Use dynamic amount
                              style: AppThemeResponsiveness.getBodyTextStyle(
                                context,
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                                fontSize: AppThemeResponsiveness.getTabFontSize(
                                  context,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppThemeResponsiveness.getSmallSpacing(
                            context,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date & Time:',
                              style: AppThemeResponsiveness.getCaptionTextStyle(
                                context,
                              ).copyWith(
                                fontSize:
                                    AppThemeResponsiveness.getHistoryTimeFontSize(
                                      context,
                                    ),
                              ),
                            ),
                            Text(
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                              style: AppThemeResponsiveness.getBodyTextStyle(
                                context,
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    AppThemeResponsiveness.getHistoryTimeFontSize(
                                      context,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                PrimaryButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.of(context).pop(); // Close success dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                ),
                SizedBox(
                  height: AppThemeResponsiveness.getSmallSpacing(context),
                ),
                SecondaryButton(
                  title: 'Download Receipt',
                  icon: Icon(
                    Icons.download,
                    color: Colors.green,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                  ),
                  color: Colors.green,
                  onPressed: () {
                    _downloadReceipt();
                  },
                ),
              ],
            ),
      );
    });
  }

  void _downloadReceipt() {
    AppSnackBar.show(
      context,
      message: 'Payment receipt downloaded successfully!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }
}
