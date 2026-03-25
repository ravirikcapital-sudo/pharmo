import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class AcademicResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppThemeResponsiveness.getScreenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section - Responsive
                  _buildHeaderSection(context),

                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                  // Features Grid - Responsive
                  _buildFeaturesGrid(context),

                  SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                  // Recent Activity Section - Responsive
                  _buildRecentActivitySection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getResponsiveSize(context, 12.0, 14.0, 16.0),
            ),
            decoration: BoxDecoration(
              color: AppThemeColor.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getResponsiveRadius(context, 12.0),
              ),
            ),
            child: Icon(
              Icons.school,
              color: AppThemeColor.primaryBlue,
              size: AppThemeResponsiveness.getResponsiveIconSize(context, 32.0),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Results',
                  style: AppThemeResponsiveness.getTitleTextStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  'Manage student academic performance and results',
                  style: AppThemeResponsiveness.getSubHeadingStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: AppThemeResponsiveness.getDashboardGridCrossAxisCount(context),
      crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
      mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
      childAspectRatio: AppThemeResponsiveness.getDashboardGridChildAspectRatio(context),
      children: [
        _buildFeatureCard(
          context,
          icon: Icons.upload_file,
          label: 'Upload Marks',
          subtitle: 'Add & manage student marks',
          color: Colors.blue,
          onTap: () {
            _showUploadMarksDialog(context);
          },
        ),
        _buildFeatureCard(
          context,
          icon: Icons.visibility,
          label: 'View Marks',
          subtitle: 'Check existing marks',
          color: Colors.green,
          onTap: () {
            _showViewMarksDialog(context);
          },
        ),
        _buildFeatureCard(
          context,
          icon: Icons.bar_chart,
          label: 'Performance',
          subtitle: 'Student performance analytics',
          color: Colors.orange,
          onTap: () {
            _showPerformanceDialog(context);
          },
        ),
        _buildFeatureCard(
          context,
          icon: Icons.assessment,
          label: 'Reports',
          subtitle: 'Generate detailed reports',
          color: Colors.purple,
          onTap: () {
            _showReportsDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Recent Activity',
                style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                  color: AppThemeColor.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildActivityItem(
            context,
            'Mathematics marks uploaded for Class 10-A',
            '2 hours ago',
            Icons.upload_file,
            Colors.blue,
          ),
          _buildActivityItem(
            context,
            'Science test results published',
            '1 day ago',
            Icons.published_with_changes,
            Colors.green,
          ),
          _buildActivityItem(
            context,
            'Monthly performance report generated',
            '3 days ago',
            Icons.assessment,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getCardBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: AppThemeResponsiveness.getCardElevation(context),
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: AppThemeResponsiveness.getDashboardCardPadding(context) > 20
              ? EdgeInsets.all(AppThemeResponsiveness.getDashboardCardPadding(context))
              : AppThemeResponsiveness.getCardPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                  AppThemeResponsiveness.getDashboardCardIconPadding(context),
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getResponsiveRadius(context, 16.0),
                  ),
                ),
                child: Icon(
                  icon,
                  size: AppThemeResponsiveness.getDashboardCardIconSize(context),
                  color: color,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
                maxLines: AppThemeResponsiveness.isSmallPhone(context) ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      BuildContext context,
      String title,
      String time,
      IconData icon,
      Color color,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              AppThemeResponsiveness.getActivityIconPadding(context),
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppThemeResponsiveness.getResponsiveRadius(context, 8.0),
              ),
            ),
            child: Icon(
              icon,
              size: AppThemeResponsiveness.getActivityIconSize(context),
              color: color,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppThemeResponsiveness.getRecentTitleStyle(context),
                  maxLines: AppThemeResponsiveness.isSmallPhone(context) ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  time,
                  style: AppThemeResponsiveness.getRecentSubtitleStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadMarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getDialogBorderRadius(context),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.upload_file,
              color: Colors.blue,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                'Upload Marks',
                style: AppThemeResponsiveness.getDialogTitleStyle(context),
              ),
            ),
          ],
        ),
        content: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          child: Text(
            'Upload marks functionality would be implemented here.',
            style: AppThemeResponsiveness.getDialogContentStyle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showViewMarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getDialogBorderRadius(context),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.visibility,
              color: Colors.green,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                'View Marks',
                style: AppThemeResponsiveness.getDialogTitleStyle(context),
              ),
            ),
          ],
        ),
        content: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          child: Text(
            'View marks functionality would be implemented here.',
            style: AppThemeResponsiveness.getDialogContentStyle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPerformanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getDialogBorderRadius(context),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.bar_chart,
              color: Colors.orange,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                'Performance Analytics',
                style: AppThemeResponsiveness.getDialogTitleStyle(context),
              ),
            ),
          ],
        ),
        content: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          child: Text(
            'Performance analytics functionality would be implemented here.',
            style: AppThemeResponsiveness.getDialogContentStyle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getDialogBorderRadius(context),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.assessment,
              color: Colors.purple,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                'Reports',
                style: AppThemeResponsiveness.getDialogTitleStyle(context),
              ),
            ),
          ],
        ),
        content: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          child: Text(
            'Reports functionality would be implemented here.',
            style: AppThemeResponsiveness.getDialogContentStyle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getDialogBorderRadius(context),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.trending_up,
              color: Colors.teal,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                'Analytics',
                style: AppThemeResponsiveness.getDialogTitleStyle(context),
              ),
            ),
          ],
        ),
        content: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          child: Text(
            'Analytics functionality would be implemented here.',
            style: AppThemeResponsiveness.getDialogContentStyle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGradeBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getDialogBorderRadius(context),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.grade,
              color: Colors.indigo,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Text(
                'Grade Book',
                style: AppThemeResponsiveness.getDialogTitleStyle(context),
              ),
            ),
          ],
        ),
        content: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          child: Text(
            'Grade book functionality would be implemented here.',
            style: AppThemeResponsiveness.getDialogContentStyle(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}