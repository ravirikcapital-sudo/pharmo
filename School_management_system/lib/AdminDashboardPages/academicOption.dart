import 'package:flutter/material.dart';
import 'package:school/AcademicManagement/addClass.dart';
import 'package:school/AcademicManagement/addSubject.dart';
import 'package:school/AcademicManagement/houseGroups.dart';
import 'package:school/AcademicManagement/sportsGroups.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/dashboard/adminDashboardModel/academicOptionModel.dart';
import 'package:school/services/api_services.dart';

class AcademicScreen extends StatefulWidget {
  @override
  _AcademicScreenState createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  bool _isLoading = true;
  AcademicDashboardStats? _stats;

  List<AcademicOption> _academicOptions = [];

  @override
  void initState() {
    super.initState();
    _loadAcademicData();
  }

  Future<void> _loadAcademicData() async {
    try {
      final statsData = await ApiService().getAcademicDashboardStats();
      final stats = AcademicDashboardStats.fromJson(statsData);

      setState(() {
        _stats = stats;
        _academicOptions = [
          AcademicOption(
            icon: Icons.class_outlined,
            title: 'Add Class',
            subtitle: '',
            primaryColor: Color(0xFF667EEA),
            secondaryColor: Color(0xFF764BA2),
            route: () => AddClassScreen(),
            stats: '${stats.totalClasses} Classes',
          ),
          AcademicOption(
            icon: Icons.menu_book_outlined,
            title: 'Add Subject',
            subtitle: '',
            primaryColor: Color(0xFF11998E),
            secondaryColor: Color(0xFF38EF7D),
            route: () => AddSubjectScreen(),
            stats: '${stats.totalSubjects} Subjects',
          ),
          AcademicOption(
            icon: Icons.sports_soccer_outlined,
            title: 'Sport Groups',
            subtitle: '',
            primaryColor: Color(0xFFFC466B),
            secondaryColor: Color(0xFF3F5EFB),
            route: () => AddSportGroupScreen(),
            stats: '${stats.totalSportsGroups} Teams',
          ),
          AcademicOption(
            icon: Icons.home_work_outlined,
            title: 'House Groups',
            subtitle: '',
            primaryColor: Color(0xFFFFCE00),
            secondaryColor: Color(0xFFFF9500),
            route: () => AddHouseGroupScreen(),
            stats: '${stats.totalHouseGroups} Houses',
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Use default values on error
        _academicOptions = [
          AcademicOption(
            icon: Icons.class_outlined,
            title: 'Add Class',
            subtitle: '',
            primaryColor: Color(0xFF667EEA),
            secondaryColor: Color(0xFF764BA2),
            route: () => AddClassScreen(),
            stats: '0 Classes',
          ),
          AcademicOption(
            icon: Icons.menu_book_outlined,
            title: 'Add Subject',
            subtitle: '',
            primaryColor: Color(0xFF11998E),
            secondaryColor: Color(0xFF38EF7D),
            route: () => AddSubjectScreen(),
            stats: '0 Subjects',
          ),
          AcademicOption(
            icon: Icons.sports_soccer_outlined,
            title: 'Sport Groups',
            subtitle: '',
            primaryColor: Color(0xFFFC466B),
            secondaryColor: Color(0xFF3F5EFB),
            route: () => AddSportGroupScreen(),
            stats: '0 Teams',
          ),
          AcademicOption(
            icon: Icons.home_work_outlined,
            title: 'House Groups',
            subtitle: '',
            primaryColor: Color(0xFFFFCE00),
            secondaryColor: Color(0xFFFF9500),
            route: () => AddHouseGroupScreen(),
            stats: '0 Houses',
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                  vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
                ),
                child: _buildEnhancedHeader(context),
              ),

              // Main Content with improved design and visible white padding
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: AppThemeResponsiveness.getCardElevation(context),
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: _buildEnhancedContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 1.2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.school_outlined,
                color: Colors.white,
                size: AppThemeResponsiveness.getHeaderIconSize(context),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Academic Management',
                      style: AppThemeResponsiveness.getWelcomeNameTextStyle(context).copyWith(
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                  Text(
                    'Streamline your educational administration',
                    style: AppThemeResponsiveness.getWelcomeBackTextStyle(context).copyWith(
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        // Quick stats row - Made more responsive
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
            vertical: AppThemeResponsiveness.getSmallSpacing(context) * 1.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: _buildStatItem('${_stats?.totalItems ?? 0}', 'Total\nItems', Icons.dashboard_outlined, context),
                ),
                Container(
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                Flexible(
                  child: _buildStatItem('${_stats?.totalClasses ?? 0}', 'Active\nClasses', Icons.class_outlined, context),
                ),
                Container(
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                Flexible(
                  child: _buildStatItem('${_stats?.totalHouseGroups ?? 0}', 'House\nGroups', Icons.home_outlined, context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: AppThemeResponsiveness.getIconSize(context) * 0.9,
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
        Text(
          number,
          style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
            color: Colors.white,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppThemeResponsiveness.getStatTitleStyle(context).copyWith(
            color: Colors.white.withOpacity(0.8),
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEnhancedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Quick Actions',
                  style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getSmallSpacing(context) * 1.2,
                  vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF667EEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                ),
                child: Text(
                  '${_academicOptions.length} Options',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667EEA),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppThemeResponsiveness.getDashboardGridCrossAxisCount(context),
                crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
                mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
                childAspectRatio: AppThemeResponsiveness.isTablet(context) ? 1.1 : 0.9,
              ),
              itemCount: _academicOptions.length,
              itemBuilder: (context, index) {
                return _buildEnhancedOptionCard(_academicOptions[index], context);
              },
            ),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)), // Bottom padding
      ],
    );
  }

  Widget _buildEnhancedOptionCard(AcademicOption option, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
          BoxShadow(
            color: option.primaryColor.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: AppThemeResponsiveness.getCardElevation(context) * 0.6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => option.route()),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon with gradient background - Responsive
                Center(
                  child: Container(
                    padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [option.primaryColor, option.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      boxShadow: [
                        BoxShadow(
                          color: option.primaryColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: AppThemeResponsiveness.getCardElevation(context) * 0.8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      option.icon,
                      size: AppThemeResponsiveness.getDashboardCardIconSize(context),
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 1.2),

                // Title only - No subtitle
                Expanded(
                  child: Center(
                    child: Text(
                      option.title,
                      style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),

                // Stats and arrow - Responsive
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.5,
                        ),
                        decoration: BoxDecoration(
                          color: option.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context) * 0.8),
                        ),
                        child: Text(
                          option.stats,
                          style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: option.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.6),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context) * 0.6),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}