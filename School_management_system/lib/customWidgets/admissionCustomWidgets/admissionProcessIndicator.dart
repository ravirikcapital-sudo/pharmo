import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class ProgressIndicatorBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getVerticalPadding(context),
      child: Row(
        children: List.generate(totalSteps, (index) {
          bool isCompleted = index < currentStep;
          bool isCurrent = index == currentStep - 1;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getSmallSpacing(context) / 4,
              ),
              height: AppThemeResponsiveness.isMobile(context) ? 4 : 6,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppThemeColor.blue600
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  AppThemeResponsiveness.isMobile(context) ? 2 : 3,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
