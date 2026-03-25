import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';


class ClassSchedule {
  final String subject;
  final String time;
  final String room;

  ClassSchedule(this.subject, this.time, this.room);
}

class ClassCard extends StatelessWidget {
  final ClassSchedule classSchedule;

  const ClassCard({Key? key, required this.classSchedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        border: Border.all(
            color: AppThemeColor.blue200,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context)
          ? _buildMobileLayout(context)
          : _buildDesktopTabletLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppThemeResponsiveness.isMobile(context) ? 3 : 4,
              height: AppThemeResponsiveness.isMobile(context) ? 40 : 50,
              decoration: BoxDecoration(
                color: AppThemeColor.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: Text(
                classSchedule.subject,
                style: TextStyle(
                  fontSize: AppThemeResponsiveness.getDashboardCardTitleStyle(context).fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.blue800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        _buildInfoRow(
          context,
          Icons.access_time,
          classSchedule.time,
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        _buildInfoRow(
          context,
          Icons.location_on,
          classSchedule.room,
        ),
      ],
    );
  }

  Widget _buildDesktopTabletLayout(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppThemeResponsiveness.isMobile(context) ? 3 : 4,
          height: AppThemeResponsiveness.isMobile(context) ? 40 : 50,
          decoration: BoxDecoration(
            color: AppThemeColor.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classSchedule.subject,
                style: TextStyle(
                  fontSize: AppThemeResponsiveness.getDashboardCardTitleStyle(context).fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.blue800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      context,
                      Icons.access_time,
                      classSchedule.time,
                    ),
                  ),
                  SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                  Expanded(
                    child: _buildInfoRow(
                      context,
                      Icons.location_on,
                      classSchedule.room,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppThemeResponsiveness.getIconSize(context) * 0.8,
          color: AppThemeColor.blue600,
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).fontSize,
              color: AppThemeColor.blue600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Enhanced Class Card for Grid View
class ClassCardGrid extends StatelessWidget {
  final ClassSchedule classSchedule;

  const ClassCardGrid({Key? key, required this.classSchedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getGridItemPadding(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        border: Border.all(
          color: AppThemeColor.blue200,
          width: AppThemeResponsiveness.getFocusedBorderWidth(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Subject Header
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppThemeColor.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  classSchedule.subject,
                  style: AppThemeResponsiveness.getGridItemTitleStyle(context).copyWith(
                    color: AppThemeColor.blue800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Time and Room Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompactInfoRow(
                context,
                Icons.access_time,
                classSchedule.time,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
              _buildCompactInfoRow(
                context,
                Icons.location_on,
                classSchedule.room,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppThemeResponsiveness.getIconSize(context) * 0.6,
          color: AppThemeColor.blue600,
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.getGridItemSubtitleStyle(context).fontSize! * 0.9,
              color: AppThemeColor.blue600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}