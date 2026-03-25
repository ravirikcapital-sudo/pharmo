// import 'package:flutter/material.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/model/dashboard/userRequestModel.dart';

// class UserRequestsPage extends StatefulWidget {
//   const UserRequestsPage({Key? key}) : super(key: key);

//   @override
//   State<UserRequestsPage> createState() => _UserRequestsPageState();
// }

// class _UserRequestsPageState extends State<UserRequestsPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   List<UserRequest> userRequests = [
//     UserRequest(
//       id: '1',
//       email: 'simrdeep@example.com',
//       approvalStatus: 'Approval Application is Pending',
//       requestedRole: 'Academic Officer',
//     ),
//     UserRequest(
//       id: '2',
//       email: 'john.doe@example.com',
//       approvalStatus: 'Approved',
//       requestedRole: 'Teacher',
//     ),
//     UserRequest(
//       id: '3',
//       email: 'jane.smith@example.com',
//       approvalStatus: 'Declined',
//       requestedRole: 'Student',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: AppThemeColor.slideAnimationDuration,
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Colors.green;
//       case 'declined':
//         return Colors.red;
//       default:
//         return Colors.orange;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               _buildContentArea(context),

//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: AppThemeResponsiveness.getScreenPadding(context),
//       child: Text(
//         'USER REQUESTS',
//         style: AppThemeResponsiveness.getFontStyle(context),
//       ),
//     );
//   }

//   Widget _buildContentArea(BuildContext context) {
//     return Expanded(
//       child: Container(
//         constraints: BoxConstraints(maxWidth: AppThemeResponsiveness.getMaxWidth(context)),
//         margin: EdgeInsets.only(
//           top: AppThemeResponsiveness.getSmallSpacing(context),
//           left: AppThemeResponsiveness.getMediumSpacing(context),
//           right: AppThemeResponsiveness.getMediumSpacing(context),
//           bottom: AppThemeResponsiveness.getMediumSpacing(context), // Added bottom margin
//         ),
//         decoration: BoxDecoration(
//           color: AppThemeColor.white,
//           borderRadius: BorderRadius.circular(AppThemeResponsiveness.getExtraLargeSpacing(context)), // Full border radius
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: _buildRequestsList(context),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRequestsList(BuildContext context) {
//     return ListView.builder(
//       padding: AppThemeResponsiveness.getScreenPadding(context),
//       itemCount: userRequests.length,
//       itemBuilder: (context, index) => _buildUserRequestCard(context, index),
//     );
//   }

//   Widget _buildUserRequestCard(BuildContext context, int index) {
//     final request = userRequests[index];

//     return Container(
//       margin: AppThemeResponsiveness.getHistoryCardMargin(context),
//       decoration: BoxDecoration(
//         color:  AppThemeColor.white,
//         borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: AppThemeResponsiveness.getCardElevation(context),
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: AppThemeResponsiveness.getCardPadding(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildRequestInfo(context, index, request),
//             SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
//             _buildStatusBadge(context, request),
//             SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
//             _buildActionButtons(context, index),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRequestInfo(BuildContext context, int index, UserRequest request) {
//     return Row(
//       children: [
//         _buildRequestNumber(context, index),
//         SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
//         Expanded(child: _buildRequestDetails(context, request)),
//       ],
//     );
//   }

//   Widget _buildRequestNumber(BuildContext context, int index) {
//     final iconSize = AppThemeResponsiveness.getIconSize(context);

//     return Container(
//       width: iconSize * 1.5,
//       height: iconSize * 1.5,
//       decoration: BoxDecoration(
//         gradient: AppThemeColor.primaryGradient,
//         borderRadius: BorderRadius.circular(iconSize * 0.75),
//       ),
//       child: Center(
//         child: Text(
//           '${index + 1}',
//           style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
//             fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRequestDetails(BuildContext context, UserRequest request) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Email: ${request.email}',
//           style: AppThemeResponsiveness.getHeadingStyle(context),
//         ),
//         SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
//         Text(
//           'Requested role: ${request.requestedRole}',
//           style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
//             color: AppThemeColor.blue600,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusBadge(BuildContext context, UserRequest request) {
//     return Container(
//       padding: AppThemeResponsiveness.getStatusBadgePadding(context),
//       decoration: BoxDecoration(
//         color: _getStatusColor(request.approvalStatus).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: _getStatusColor(request.approvalStatus),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         request.approvalStatus,
//         style: TextStyle(
//           color: _getStatusColor(request.approvalStatus),
//           fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, int index) {
//     if (AppThemeResponsiveness.isMobile(context)) {
//       return _buildMobileActionButtons(context, index);
//     }
//     return _buildDesktopActionButtons(context, index);
//   }

//   Widget _buildMobileActionButtons(BuildContext context, int index) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(child: _buildApproveButton(context, index)),
//             SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
//             Expanded(child: _buildModifyButton(context, index)),
//           ],
//         ),
//         SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
//         SizedBox(
//           width: double.infinity,
//           child: _buildDeclineButton(context, index),
//         ),
//       ],
//     );
//   }

//   Widget _buildDesktopActionButtons(BuildContext context, int index) {
//     return Row(
//       children: [
//         Expanded(child: _buildApproveButton(context, index)),
//         SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
//         Expanded(child: _buildModifyButton(context, index)),
//         SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
//         Expanded(child: _buildDeclineButton(context, index)),
//       ],
//     );
//   }

//   Widget _buildApproveButton(BuildContext context, int index) {
//     return ElevatedButton(
//       onPressed: () => _handleApprove(index),
//       style: _getButtonStyle(context, Colors.green),
//       child: Text(
//         'Approve',
//         style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
//       ),
//     );
//   }

//   Widget _buildModifyButton(BuildContext context, int index) {
//     return ElevatedButton(
//       onPressed: () => _showModifyDialog(index),
//       style: _getButtonStyle(context, AppThemeColor.blue600),
//       child: Text(
//         'Modify',
//         style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
//       ),
//     );
//   }

//   Widget _buildDeclineButton(BuildContext context, int index) {
//     return ElevatedButton(
//       onPressed: () => _handleDecline(index),
//       style: _getButtonStyle(context, Colors.red),
//       child: Text(
//         'Decline',
//         style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
//       ),
//     );
//   }

//   ButtonStyle _getButtonStyle(BuildContext context, Color backgroundColor) {
//     return ElevatedButton.styleFrom(
//       backgroundColor: backgroundColor,
//       foregroundColor: AppThemeColor.white,
//       elevation: AppThemeResponsiveness.getButtonElevation(context),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
//       ),
//       minimumSize: Size(double.infinity, AppThemeResponsiveness.getButtonHeight(context) * 0.8),
//     );
//   }

//   void _handleApprove(int index) {
//     setState(() {
//       userRequests[index].approvalStatus = 'Approved';
//     });
//     _showSuccessSnackBar('Request approved successfully');
//   }

//   void _handleDecline(int index) {
//     setState(() {
//       userRequests[index].approvalStatus = 'Declined';
//     });
//     _showErrorSnackBar('Request declined');
//   }

//   void _showModifyDialog(int index) {
//     final roleController = TextEditingController(text: userRequests[index].requestedRole);

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//         ),
//         child: Container(
//           width: AppThemeResponsiveness.getDialogWidth(context),
//           padding: AppThemeResponsiveness.getScreenPadding(context),
//           decoration: BoxDecoration(
//             gradient: AppThemeColor.primaryGradient,
//             borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildDialogTitle(context),
//               SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
//               _buildDialogTextField(context, roleController),
//               SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
//               _buildDialogActions(context, index, roleController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDialogTitle(BuildContext context) {
//     return Text(
//       'Modify Request',
//       style: AppThemeResponsiveness.getFontStyle(context).copyWith(
//         fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize! * 1.25,
//       ),
//     );
//   }

//   Widget _buildDialogTextField(BuildContext context, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       style: TextStyle(
//         color: AppThemeColor.white,
//         fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
//       ),
//       decoration: InputDecoration(
//         labelText: 'Requested Role',
//         labelStyle: TextStyle(
//           color: AppThemeColor.white70,
//           fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
//           borderSide: const BorderSide(color: AppThemeColor.white70),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
//           borderSide: BorderSide(
//             color: AppThemeColor.white,
//             width: AppThemeResponsiveness.getFocusedBorderWidth(context),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDialogActions(BuildContext context, int index, TextEditingController controller) {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppThemeColor.white.withOpacity(0.2),
//               foregroundColor: AppThemeColor.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
//               ),
//               side: const BorderSide(color: AppThemeColor.white70),
//               minimumSize: Size(double.infinity, AppThemeResponsiveness.getButtonHeight(context) * 0.8),
//             ),
//             child: Text(
//               'Cancel',
//               style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
//             ),
//           ),
//         ),
//         SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () => _handleModifySave(context, index, controller),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppThemeColor.white,
//               foregroundColor: AppThemeColor.primaryBlue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
//               ),
//               minimumSize: Size(double.infinity, AppThemeResponsiveness.getButtonHeight(context) * 0.8),
//             ),
//             child: Text(
//               'Save',
//               style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _handleModifySave(BuildContext context, int index, TextEditingController controller) {
//     final newRole = controller.text.trim();

//     if (newRole.isEmpty) {
//       _showErrorSnackBar('Please enter a valid role');
//       return;
//     }

//     setState(() {
//       userRequests[index].requestedRole = newRole;
//       userRequests[index].approvalStatus = 'Approved';
//     });

//     Navigator.pop(context);
//     _showSuccessSnackBar('Request modified and approved successfully');
//   }

//   void _showSuccessSnackBar(String message) {
//     _showSnackBar(message, Colors.green);
//   }

//   void _showErrorSnackBar(String message) {
//     _showSnackBar(message, Colors.red);
//   }

//   void _showSnackBar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
//         ),
//         margin: AppThemeResponsiveness.getScreenPadding(context),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/dashboard/userRequestModel.dart';
import 'package:school/services/api_services.dart';

class UserRequestsPage extends StatefulWidget {
  const UserRequestsPage({Key? key}) : super(key: key);

  @override
  State<UserRequestsPage> createState() => _UserRequestsPageState();
}

class _UserRequestsPageState extends State<UserRequestsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<UserRequest> userRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserRequests();
  }

  Future<void> _loadUserRequests() async {
    final data = await ApiService.fetchUserRequests();
    setState(() {
      print("----------setState");
      userRequests = data;
      isLoading = false;
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppThemeColor.slideAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [_buildHeader(context), _buildContentArea(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Text(
        'USER REQUESTS',
        style: AppThemeResponsiveness.getFontStyle(context),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context),
        ),
        margin: EdgeInsets.only(
          top: AppThemeResponsiveness.getSmallSpacing(context),
          left: AppThemeResponsiveness.getMediumSpacing(context),
          right: AppThemeResponsiveness.getMediumSpacing(context),
          bottom: AppThemeResponsiveness.getMediumSpacing(context),
        ),
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getExtraLargeSpacing(context),
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildRequestsList(context),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userRequests.isEmpty) {
      return const Center(child: Text('No user requests found'));
    }

    return ListView.builder(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      itemCount: userRequests.length,
      itemBuilder: (context, index) => _buildUserRequestCard(context, index),
    );
  }

  Widget _buildUserRequestCard(BuildContext context, int index) {
    final request = userRequests[index];

    return Container(
      margin: AppThemeResponsiveness.getHistoryCardMargin(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequestInfo(context, index, request),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildStatusBadge(context, request),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildActionButtons(context, index),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestInfo(
    BuildContext context,
    int index,
    UserRequest request,
  ) {
    return Row(
      children: [
        _buildRequestNumber(context, index),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(child: _buildRequestDetails(context, request)),
      ],
    );
  }

  Widget _buildRequestNumber(BuildContext context, int index) {
    final iconSize = AppThemeResponsiveness.getIconSize(context);

    return Container(
      width: iconSize * 1.5,
      height: iconSize * 1.5,
      decoration: BoxDecoration(
        gradient: AppThemeColor.primaryGradient,
        borderRadius: BorderRadius.circular(iconSize * 0.75),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildRequestDetails(BuildContext context, UserRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email: ${request.email}',
          style: AppThemeResponsiveness.getHeadingStyle(context),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
        Text(
          'Requested role: ${request.requestedRole}',
          style: AppThemeResponsiveness.getSubHeadingStyle(
            context,
          ).copyWith(color: AppThemeColor.blue600),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, UserRequest request) {
    return Container(
      padding: AppThemeResponsiveness.getStatusBadgePadding(context),
      decoration: BoxDecoration(
        color: _getStatusColor(request.approvalStatus).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(request.approvalStatus)),
      ),
      child: Text(
        request.approvalStatus,
        style: TextStyle(color: _getStatusColor(request.approvalStatus)),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(child: _buildApproveButton(context, index)),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(child: _buildModifyButton(context, index)),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(child: _buildDeclineButton(context, index)),
      ],
    );
  }

  Widget _buildApproveButton(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () async {
        await ApiService.approveUser(userRequests[index].id);
        setState(() {
          userRequests[index].approvalStatus = 'Approved';
        });
        _showSuccessSnackBar('Request approved successfully');
      },
      style: _getButtonStyle(context, Colors.green),
      child: const Text('Approve'),
    );
  }

  Widget _buildModifyButton(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () => _showModifyDialog(index),
      style: _getButtonStyle(context, AppThemeColor.blue600),
      child: const Text('Modify'),
    );
  }

  Widget _buildDeclineButton(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () async {
        await ApiService.declineUser(userRequests[index].id);
        setState(() {
          userRequests.removeAt(index);
        });
        _showErrorSnackBar('Request declined');
      },
      style: _getButtonStyle(context, Colors.red),
      child: const Text('Decline'),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context, Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
    );
  }

  void _showModifyDialog(int index) {
    final controller = TextEditingController(
      text: userRequests[index].requestedRole,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modify Request'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.modifyUserRole(
                userRequests[index].id,
                controller.text,
              );
              setState(() {
                userRequests[index].requestedRole = controller.text;
                userRequests[index].approvalStatus = 'Approved';
              });
              Navigator.pop(context);
              _showSuccessSnackBar('Updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String msg) => _showSnackBar(msg, Colors.green);

  void _showErrorSnackBar(String msg) => _showSnackBar(msg, Colors.red);

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
