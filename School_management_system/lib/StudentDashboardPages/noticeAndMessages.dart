import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';
import 'package:school/model/studentNoticeAndMessageModel.dart';

class NoticesMessage extends StatefulWidget {
  const NoticesMessage({super.key});

  @override
  State<NoticesMessage> createState() => _NoticesMessageState();
}

class _NoticesMessageState extends State<NoticesMessage> {
  // Sample data - you can replace this with actual data from your backend
  final List<NoticeItem> notices = [
    NoticeItem(
      icon: Icons.water_drop,
      title: 'Holiday Notice: Possible closure tomorrow due to heavy rainfall',
      time: '2 hours ago',
      color: Colors.blue,
      priority: NoticePriority.high,
      description: 'Due to heavy rainfall warnings issued by the meteorological department, the school may remain closed tomorrow. Please stay tuned for further updates.',
    ),
    NoticeItem(
      icon: Icons.people,
      title: 'Parent-Teacher Meeting scheduled for next week',
      time: '1 day ago',
      color: Colors.orange,
      priority: NoticePriority.medium,
      description: 'The Parent-Teacher meeting is scheduled for next week on Saturday. Please confirm your attendance by calling the school office.',
    ),
    NoticeItem(
      icon: Icons.payment,
      title: 'Fee Payment Reminder: Due date approaching',
      time: '3 days ago',
      color: Colors.green,
      priority: NoticePriority.low,
      description: 'This is a friendly reminder that the school fee payment due date is approaching. Please clear your dues to avoid late fees.',
    ),
    NoticeItem(
      icon: Icons.announcement,
      title: 'Annual Sports Day registration now open',
      time: '5 days ago',
      color: Colors.purple,
      priority: NoticePriority.medium,
      description: 'Registration for Annual Sports Day is now open. Students can register for various events through their class teachers.',
    ),
    NoticeItem(
      icon: Icons.book,
      title: 'New Library Books Available',
      time: '1 week ago',
      color: Colors.teal,
      priority: NoticePriority.low,
      description: 'New collection of books has arrived in the school library. Students are encouraged to explore and borrow books.',
    ),
    NoticeItem(
      icon: Icons.health_and_safety,
      title: 'Health Checkup Camp Next Month',
      time: '1 week ago',
      color: Colors.red,
      priority: NoticePriority.medium,
      description: 'A comprehensive health checkup camp will be organized next month for all students. More details will be shared soon.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              left: AppThemeResponsiveness.getSmallSpacing(context),
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Recent Notices',
                  icon: Icons.notifications_active,
                ),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _NoticesHeader(noticesCount: notices.length),
                        Expanded(
                          child: _NoticesLayout(notices: notices),
                        ),
                        _ActionButtons(onMarkAllRead: () => _markAllAsRead(context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _markAllAsRead(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notices marked as read'),
        backgroundColor: AppThemeColor.primaryBlue,
      ),
    );
  }
}

// Extracted Header Widget
class _NoticesHeader extends StatelessWidget {
  final int noticesCount;

  const _NoticesHeader({required this.noticesCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppThemeColor.primaryBlue.withOpacity(0.1),
            AppThemeColor.primaryIndigo.withOpacity(0.1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context)),
            decoration: BoxDecoration(
              color: AppThemeColor.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_active,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications Center',
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  'Stay updated with latest announcements',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getMediumSpacing(context),
              vertical: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            decoration: BoxDecoration(
              color: AppThemeColor.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppThemeColor.primaryBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '$noticesCount notices',
              style: TextStyle(
                color: AppThemeColor.primaryBlue,
                fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted Layout Widget that handles responsive layouts
class _NoticesLayout extends StatelessWidget {
  final List<NoticeItem> notices;

  const _NoticesLayout({required this.notices});

  @override
  Widget build(BuildContext context) {
    if (AppThemeResponsiveness.isDesktop(context)) {
      return _buildDesktopLayout(context);
    } else if (AppThemeResponsiveness.isTablet(context)) {
      return _buildTabletLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Row(
        children: notices.map((notice) {
          return Container(
            width: 320, // Fixed width for desktop cards
            margin: EdgeInsets.only(
              right: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
            ),
            child: _NoticeCard(
              notice: notice,
              isDesktop: true,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: 1.2,
      ),
      itemCount: notices.length,
      itemBuilder: (context, index) {
        return _NoticeCard(
          notice: notices[index],
          isDesktop: false,
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: notices.length,
      separatorBuilder: (context, index) => SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
      itemBuilder: (context, index) {
        return _NoticeCard(
          notice: notices[index],
          isDesktop: false,
        );
      },
    );
  }
}

// In the _NoticeCard widget, modify the height property:

class _NoticeCard extends StatelessWidget {
  final NoticeItem notice;
  final bool isDesktop;

  const _NoticeCard({
    required this.notice,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppThemeResponsiveness.isMobile(context);

    return Container(
      height: isDesktop ? 280 : null, // Increased from 200 to 280
      decoration: BoxDecoration(
        color: isMobile ? Colors.grey.shade50 : AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        border: Border.all(
          color: notice.priority == NoticePriority.high
              ? Colors.red.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: notice.priority == NoticePriority.high ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isMobile ? 0.03 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showNoticeDetails(context, notice),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        child: Padding(
          padding: EdgeInsets.all(
              isMobile
                  ? AppThemeResponsiveness.getMediumSpacing(context)
                  : AppThemeResponsiveness.getGridItemPadding(context)
          ),
          child: isMobile && !isDesktop
              ? _buildMobileCardContent(context)
              : _buildDesktopCardContent(context),
        ),
      ),
    );
  }

// ... rest of the widget code remains the same

  Widget _buildMobileCardContent(BuildContext context) {
    return Row(
      children: [
        _NoticeIcon(notice: notice),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: _NoticeContent(notice: notice),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        _PriorityIndicator(priority: notice.priority),
      ],
    );
  }

  Widget _buildDesktopCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _NoticeIcon(notice: notice),
            const Spacer(),
            _PriorityBadge(priority: notice.priority),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title,
                style: AppThemeResponsiveness.getGridItemTitleStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.6,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Expanded(
                    child: Text(
                      notice.time,
                      style: AppThemeResponsiveness.getGridItemSubtitleStyle(context),
                      overflow: TextOverflow.ellipsis,
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

  void _showNoticeDetails(BuildContext context, NoticeItem notice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NoticeDetailsSheet(notice: notice),
    );
  }
}

// Extracted reusable components
class _NoticeIcon extends StatelessWidget {
  final NoticeItem notice;

  const _NoticeIcon({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
      decoration: BoxDecoration(
        color: notice.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        notice.icon,
        color: notice.color,
        size: AppThemeResponsiveness.getDashboardCardIconSize(context),
      ),
    );
  }
}

class _NoticeContent extends StatelessWidget {
  final NoticeItem notice;

  const _NoticeContent({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notice.title,
          style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(
              context,
              AppThemeResponsiveness.getDashboardCardTitleStyle(context).fontSize!,
            ),
            height: 1.3,
          ),
          maxLines: AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context) ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: AppThemeResponsiveness.getIconSize(context) * 0.7,
              color: Colors.grey.shade500,
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            Expanded(
              child: Text(
                notice.time,
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriorityIndicator extends StatelessWidget {
  final NoticePriority priority;

  const _PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color = _getPriorityColor(priority);

    return Container(
      width: AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context) ? 6 : 8,
      height: AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context) ? 35 : 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Color _getPriorityColor(NoticePriority priority) {
    switch (priority) {
      case NoticePriority.high:
        return Colors.red;
      case NoticePriority.medium:
        return Colors.orange;
      case NoticePriority.low:
        return Colors.green;
    }
  }
}

class _PriorityBadge extends StatelessWidget {
  final NoticePriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color = _getPriorityColor(priority);
    String text = _getPriorityText(priority);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context),
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppThemeColor.white,
          fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(NoticePriority priority) {
    switch (priority) {
      case NoticePriority.high:
        return Colors.red;
      case NoticePriority.medium:
        return Colors.orange;
      case NoticePriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(NoticePriority priority) {
    switch (priority) {
      case NoticePriority.high:
        return 'High';
      case NoticePriority.medium:
        return 'Medium';
      case NoticePriority.low:
        return 'Low';
    }
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onMarkAllRead;

  const _ActionButtons({required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: PrimaryButton(
        title: 'Mark All Read',
        icon: Icon(
          Icons.done_all,
          color: Colors.white,
          size: AppThemeResponsiveness.getIconSize(context) * 0.8,
        ),
        onPressed: onMarkAllRead,
      ),
    );
  }
}

class _NoticeDetailsSheet extends StatelessWidget {
  final NoticeItem notice;

  const _NoticeDetailsSheet({required this.notice});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = AppThemeResponsiveness.isMobile(context) && AppThemeResponsiveness.isSmallPhone(context)
        ? screenHeight * 0.8
        : screenHeight * 0.7;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context)),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      _NoticeIcon(notice: notice),
                      SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice.title,
                              style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
                              ),
                            ),
                            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                            _PriorityBadge(priority: notice.priority),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                  // Time info
                  Container(
                    padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
                    decoration: BoxDecoration(
                      color: AppThemeColor.blue50,
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppThemeColor.primaryBlue,
                          size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                        ),
                        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                        Text(
                          'Posted ${notice.time}',
                          style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                            color: AppThemeColor.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),

                  // Notice details
                  Text(
                    'Notice Details',
                    style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                      fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 16),
                    ),
                  ),

                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      notice.description,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        height: 1.6,
                        fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                          context,
                          AppThemeResponsiveness.getBodyTextStyle(context).fontSize!,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          title: 'Close',
                          color: Colors.grey.shade600,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey.shade600,
                            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                      Expanded(
                        child: PrimaryButton(
                          title: 'Share',
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _shareNotice(context, notice);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareNotice(BuildContext context, NoticeItem notice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing notice: ${notice.title}'),
        backgroundColor: AppThemeColor.primaryBlue,
      ),
    );
  }
}