import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';


class SystemHealthScreen extends StatefulWidget {
  @override
  _SystemHealthScreenState createState() => _SystemHealthScreenState();
}

class _SystemHealthScreenState extends State<SystemHealthScreen>
    with TickerProviderStateMixin {

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                    _buildOverallStatus(),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    _buildSystemMetrics(),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    _buildServicesStatus(),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Hero(
          tag: 'health_icon',
          child: Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getResponsiveSize(context, 20, 24, 28)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              size: AppThemeResponsiveness.getResponsiveIconSize(context, 45),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        Text(
          'System Health',
          style: AppThemeResponsiveness.getHeadlineTextStyle(context).copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getResponsiveSize(context, 16, 20, 24),
            vertical: AppThemeResponsiveness.getResponsiveSize(context, 8, 10, 12),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 20)),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            'Real-time system monitoring',
            style: AppThemeResponsiveness.getSubTitleTextStyle(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallStatus() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
            gradient: LinearGradient(
              colors: [Colors.green[50]!, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: AppThemeResponsiveness.getResponsiveIconSize(context, 24),
                    ),
                  ),
                  SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Status',
                          style: AppThemeResponsiveness.getTitleTextStyle(context),
                        ),
                        Text(
                          'All systems operational',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemMetrics() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Padding(
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Metrics',
                style: AppThemeResponsiveness.getTitleTextStyle(context).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildMetricItem('CPU Usage', '23%', Colors.green, 0.23),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildMetricItem('Memory Usage', '67%', Colors.orange, 0.67),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildMetricItem('Storage', '45%', Colors.blue, 0.45),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildMetricItem('Network', '12%', Colors.green, 0.12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, Color color, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildServicesStatus() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Padding(
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services Status',
                style: AppThemeResponsiveness.getTitleTextStyle(context).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildServiceItem('Database', 'Online', Icons.storage_rounded, Colors.green),
              _buildServiceItem('Authentication', 'Online', Icons.security_rounded, Colors.green),
              _buildServiceItem('File Storage', 'Online', Icons.cloud_rounded, Colors.green),
              _buildServiceItem('Email Service', 'Warning', Icons.email_rounded, Colors.orange),
              _buildServiceItem('Backup System', 'Online', Icons.backup_rounded, Colors.green),
              _buildServiceItem('API Gateway', 'Online', Icons.api_rounded, Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(String service, String status, IconData icon, Color statusColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: statusColor,
              size: AppThemeResponsiveness.getResponsiveIconSize(context, 20),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Text(
              service,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}