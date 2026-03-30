// import 'package:flutter/material.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/model/dashboard/userRequestModel.dart';
// import 'package:school/services/api_services.dart';

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

//   List<UserRequest> userRequests = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadUserRequests();
//   }

//   Future<void> _loadUserRequests() async {
//     final data = await ApiService.fetchUserRequests();
//     setState(() {
//       print("----------setState");
//       userRequests = data;
//       isLoading = false;
//     });
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: AppThemeColor.slideAnimationDuration,
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: Curves.easeOutCubic,
//           ),
//         );

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
//         decoration: const BoxDecoration(
//           gradient: AppThemeColor.primaryGradient,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [_buildHeader(context), _buildContentArea(context)],
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
//         constraints: BoxConstraints(
//           maxWidth: AppThemeResponsiveness.getMaxWidth(context),
//         ),
//         margin: EdgeInsets.only(
//           top: AppThemeResponsiveness.getSmallSpacing(context),
//           left: AppThemeResponsiveness.getMediumSpacing(context),
//           right: AppThemeResponsiveness.getMediumSpacing(context),
//           bottom: AppThemeResponsiveness.getMediumSpacing(context),
//         ),
//         decoration: BoxDecoration(
//           color: AppThemeColor.white,
//           borderRadius: BorderRadius.circular(
//             AppThemeResponsiveness.getExtraLargeSpacing(context),
//           ),
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
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (userRequests.isEmpty) {
//       return const Center(child: Text('No user requests found'));
//     }

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
//         color: AppThemeColor.white,
//         borderRadius: BorderRadius.circular(
//           AppThemeResponsiveness.getCardBorderRadius(context),
//         ),
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

//   Widget _buildRequestInfo(
//     BuildContext context,
//     int index,
//     UserRequest request,
//   ) {
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
//           style: AppThemeResponsiveness.getSubHeadingStyle(
//             context,
//           ).copyWith(color: AppThemeColor.blue600),
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
//         border: Border.all(color: _getStatusColor(request.approvalStatus)),
//       ),
//       child: Text(
//         request.approvalStatus,
//         style: TextStyle(color: _getStatusColor(request.approvalStatus)),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, int index) {
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
//       onPressed: () async {
//         await ApiService.approveUser(userRequests[index].id);
//         setState(() {
//           userRequests[index].approvalStatus = 'Approved';
//         });
//         _showSuccessSnackBar('Request approved successfully');
//       },
//       style: _getButtonStyle(context, Colors.green),
//       child: const Text('Approve'),
//     );
//   }

//   Widget _buildModifyButton(BuildContext context, int index) {
//     return ElevatedButton(
//       onPressed: () => _showModifyDialog(index),
//       style: _getButtonStyle(context, AppThemeColor.blue600),
//       child: const Text('Modify'),
//     );
//   }

//   Widget _buildDeclineButton(BuildContext context, int index) {
//     return ElevatedButton(
//       onPressed: () async {
//         await ApiService.declineUser(userRequests[index].id);
//         setState(() {
//           userRequests.removeAt(index);
//         });
//         _showErrorSnackBar('Request declined');
//       },
//       style: _getButtonStyle(context, Colors.red),
//       child: const Text('Decline'),
//     );
//   }

//   ButtonStyle _getButtonStyle(BuildContext context, Color color) {
//     return ElevatedButton.styleFrom(
//       backgroundColor: color,
//       foregroundColor: Colors.white,
//     );
//   }

//   void _showModifyDialog(int index) {
//     final controller = TextEditingController(
//       text: userRequests[index].requestedRole,
//     );

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Modify Request'),
//         content: TextField(controller: controller),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await ApiService.modifyUserRole(
//                 userRequests[index].id,
//                 controller.text,
//               );
//               setState(() {
//                 userRequests[index].requestedRole = controller.text;
//                 userRequests[index].approvalStatus = 'Approved';
//               });
//               Navigator.pop(context);
//               _showSuccessSnackBar('Updated successfully');
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String msg) => _showSnackBar(msg, Colors.green);

//   void _showErrorSnackBar(String msg) => _showSnackBar(msg, Colors.red);

//   void _showSnackBar(String msg, Color color) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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

  int totalRequests = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserRequests();
  }

  /// 🔥 LOAD DATA
  Future<void> _loadUserRequests() async {
    final data = await ApiService.fetchUserRequests();

    setState(() {
      userRequests = data;              
      totalRequests = data.length;     
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'USER REQUESTS',
            style: AppThemeResponsiveness.getFontStyle(context),
          ),

        
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+$totalRequests',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
      BuildContext context, int index, UserRequest request) {
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
          style: AppThemeResponsiveness.getButtonTextStyle(context),
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
        SizedBox(height: 4),
        Text(
          'Requested role: ${request.requestedRole}',
          style: AppThemeResponsiveness.getSubHeadingStyle(context)
              .copyWith(color: AppThemeColor.blue600),
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
        SizedBox(width: 8),
        Expanded(child: _buildModifyButton(context, index)),
        SizedBox(width: 8),
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
        _showSnackBar('Approved', Colors.green);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text('Approve'),
    );
  }

  Widget _buildModifyButton(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () => _showModifyDialog(index),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: const Text('Modify'),
    );
  }

  Widget _buildDeclineButton(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () async {
        await ApiService.declineUser(userRequests[index].id);
        setState(() {
          userRequests.removeAt(index);
          totalRequests = userRequests.length; // 🔥 update count
        });
        _showSnackBar('Declined', Colors.red);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('Decline'),
    );
  }

  void _showModifyDialog(int index) {
    final controller =
        TextEditingController(text: userRequests[index].requestedRole);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modify Request'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await ApiService.modifyUserRole(
                  userRequests[index].id, controller.text);
              setState(() {
                userRequests[index].requestedRole = controller.text;
              });
              Navigator.pop(context);
              _showSnackBar('Updated', Colors.green);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}