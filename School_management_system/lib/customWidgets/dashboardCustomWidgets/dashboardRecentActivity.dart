import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';


class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;

  const ActivityItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getActivityIconPadding(context)),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppThemeResponsiveness.getActivityIconSize(context),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 1.6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
              Text(
                time,
                style: AppThemeResponsiveness.getCaptionTextStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RecentActivityCard extends StatelessWidget {
  final List<ActivityItem> items;

  const RecentActivityCard({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getActivityItemPadding(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isEven) {
            return items[index ~/ 2];
          } else {
            return Divider(
              height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2,
              thickness: 0.8,
            );
          }
        }),
      ),
    );
  }
}
