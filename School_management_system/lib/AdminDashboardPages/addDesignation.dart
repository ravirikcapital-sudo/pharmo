// import 'package:flutter/material.dart';
// import 'package:school/customWidgets/AddCommonWidgets/addNewHeader.dart';
// import 'package:school/customWidgets/AddCommonWidgets/addSectionHeader.dart';
// import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
// import 'package:school/customWidgets/inputField.dart';
// import 'package:school/customWidgets/button.dart';

// class AddDesignationPage extends StatefulWidget {
//   const AddDesignationPage({Key? key}) : super(key: key);

//   @override
//   State<AddDesignationPage> createState() => _AddDesignationPageState();
// }

// class _AddDesignationPageState extends State<AddDesignationPage> {
//   // Form Controllers
//   final _formKey = GlobalKey<FormState>();
//   final _designationController = TextEditingController();
//   final _resourcesController = TextEditingController();

//   // Loading state
//   bool _isLoading = false;

//   // Focus nodes for better UX
//   final _designationFocus = FocusNode();
//   final _resourcesFocus = FocusNode();

//   @override
//   void dispose() {
//     _designationController.dispose();
//     _resourcesController.dispose();
//     _designationFocus.dispose();
//     _resourcesFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: AppThemeColor.primaryGradient,
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Padding(
//               padding: AppThemeResponsiveness.getScreenPadding(context),
//               child: Column(
//                 children: [
//                   HeaderWidget(titleLabel: 'Designation'),
//                   SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
//                   _buildMainCard(),
//                   SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainCard() {
//     return Container(
//       constraints: BoxConstraints(
//         maxWidth: AppThemeResponsiveness.getMaxWidth(context),
//       ),
//       child: Card(
//         elevation: AppThemeResponsiveness.getCardElevation(context) + 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) + 4),
//         ),
//         shadowColor: Colors.black.withOpacity(0.2),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) + 4),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.white,
//                 Colors.grey[50]!,
//               ],
//             ),
//           ),
//           child: Padding(
//             padding: AppThemeResponsiveness.getCardPadding(context),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SectionHeader(
//                     context: context,
//                     title: 'Position Details',
//                     icon: Icons.badge_outlined,
//                     color: Colors.blue,
//                   ),
//                   SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
//                   AppTextFieldBuilder.build(
//                     context: context,
//                     controller: _designationController,
//                     label: 'Designation Title *',
//                     icon: Icons.badge_outlined,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a designation title';
//                       }
//                       if (value.length < 3) {
//                         return 'Designation must be at least 3 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
//                   SectionHeader(
//                     context: context,
//                     title: 'Required Resources',
//                     icon: Icons.checklist_rounded,
//                     color: Colors.orange,
//                   ),
//                   SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
//                   AppTextFieldBuilder.build(
//                     context: context,
//                     controller: _resourcesController,
//                     label: 'Required Resources & Skills *',
//                     icon: Icons.checklist_rounded,
//                     maxLines: AppThemeResponsiveness.getTextFieldMaxLines(context),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please describe the required resources';
//                       }
//                       if (value.length < 10) {
//                         return 'Please provide more detailed resource information';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
//                   _buildActionButtons(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         PrimaryButton(
//           title: 'Save Designation',
//           icon: Icon(Icons.save_rounded, color: Colors.white),
//           isLoading: _isLoading,
//           onPressed: _saveDesignation,
//         ),
//         SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
//         SecondaryButton(
//           title: 'Cancel',
//           icon: Icon(Icons.close_rounded, color: AppThemeColor.blue600),
//           color: AppThemeColor.blue600,
//           onPressed: () => Navigator.pop(context),
//         )
//       ],
//     );
//   }

//   Future<void> _saveDesignation() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       // Simulate API call
//       await Future.delayed(Duration(seconds: 2));

//       setState(() {
//         _isLoading = false;
//       });

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Container(
//             padding: EdgeInsets.symmetric(vertical: 4),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Icon(
//                     Icons.check_circle_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
//                 Flexible(
//                   child: Text(
//                     'Designation "${_designationController.text}" added successfully!',
//                     style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           backgroundColor: Colors.green[600],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12)),
//           ),
//           margin: AppThemeResponsiveness.getHorizontalPadding(context),
//           elevation: 8,
//         ),
//       );
//       // Navigate back or to next screen
//       Navigator.pop(context);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:school/customWidgets/AddCommonWidgets/addNewHeader.dart';
import 'package:school/customWidgets/AddCommonWidgets/addSectionHeader.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/services/api_services.dart' show ApiService;

class AddDesignationPage extends StatefulWidget {
  const AddDesignationPage({Key? key}) : super(key: key);

  @override
  State<AddDesignationPage> createState() => _AddDesignationPageState();
}

class _AddDesignationPageState extends State<AddDesignationPage> {
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _designationController = TextEditingController();
  final _resourcesController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // is_active checkbox state
  bool _isActive = true;

  @override
  void dispose() {
    _designationController.dispose();
    _resourcesController.dispose();
    super.dispose();
  }

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
            child: Padding(
              padding: AppThemeResponsiveness.getScreenPadding(context),
              child: Column(
                children: [
                  HeaderWidget(titleLabel: 'Designation'),
                  SizedBox(
                    height: AppThemeResponsiveness.getExtraLargeSpacing(context),
                  ),
                  _buildMainCard(),
                  SizedBox(
                    height: AppThemeResponsiveness.getMediumSpacing(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context) + 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context) + 4,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context) + 4,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: AppThemeResponsiveness.getCardPadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(
                    context: context,
                    title: 'Position Details',
                    icon: Icons.badge_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: AppThemeResponsiveness.getMediumSpacing(context),
                  ),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _designationController,
                    label: 'Designation Title *',
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a designation title';
                      }
                      if (value.length < 3) {
                        return 'Designation must be at least 3 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height:
                        AppThemeResponsiveness.getExtraLargeSpacing(context),
                  ),
                  SectionHeader(
                    context: context,
                    title: 'Required Resources',
                    icon: Icons.checklist_rounded,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    height: AppThemeResponsiveness.getMediumSpacing(context),
                  ),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _resourcesController,
                    label: 'Required Resources & Skills *',
                    icon: Icons.checklist_rounded,
                    maxLines:
                        AppThemeResponsiveness.getTextFieldMaxLines(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the required resources';
                      }
                      if (value.length < 10) {
                        return 'Please provide more detailed resource information';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height:
                        AppThemeResponsiveness.getExtraLargeSpacing(context),
                  ),

                  // 🔹 IS ACTIVE CHECKBOX
                  Row(
                    children: [
                      Checkbox(
                        value: _isActive,
                        activeColor: AppThemeColor.blue600,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value ?? true;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Is Active',
                          style: AppThemeResponsiveness
                              .getBodyTextStyle(context)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height:
                        AppThemeResponsiveness.getExtraLargeSpacing(context),
                  ),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          title: 'Save Designation',
          icon: Icon(Icons.save_rounded, color: Colors.white),
          isLoading: _isLoading,
          onPressed: _saveDesignation,
        ),
        SizedBox(
          height: AppThemeResponsiveness.getMediumSpacing(context),
        ),
        SecondaryButton(
          title: 'Cancel',
          icon: Icon(Icons.close_rounded, color: AppThemeColor.blue600),
          color: AppThemeColor.blue600,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Future<void> _saveDesignation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await ApiService().createDesignation(
          title: _designationController.text.trim(),
          description: _resourcesController.text.trim(),
          isActive: _isActive, // ✅ PASSED HERE
        );

        if (!success) {
          throw Exception("Failed to create designation");
        }

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width:
                        AppThemeResponsiveness.getSmallSpacing(context),
                  ),
                  Flexible(
                    child: Text(
                      'Designation "${_designationController.text}" added successfully!',
                      style: AppThemeResponsiveness
                          .getBodyTextStyle(context)
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getResponsiveRadius(context, 12),
              ),
            ),
            margin: AppThemeResponsiveness.getHorizontalPadding(context),
            elevation: 8,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }
}
