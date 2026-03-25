import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class ModernDrawerSection {
  final String title;
  final List<ModernDrawerItem> items;

  ModernDrawerSection({required this.title, required this.items});
}

class ModernDrawerItem {
  final IconData icon;
  final String title;
  final String? route;
  final String? badge;
  final VoidCallback? onTap;
  final bool isDestructive;

  ModernDrawerItem({
    required this.icon,
    required this.title,
    this.route,
    this.badge,
    this.onTap,
    this.isDestructive = false,
  });
}

class ModernDrawer extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final String headerSubtitle;
  final List<ModernDrawerSection> sections;

  const ModernDrawer({
    Key? key,
    required this.headerIcon,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Drawer(
      width: _getDrawerWidth(context),
      child: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppThemeResponsiveness.getDefaultSpacing(context),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...sections.map((section) => _buildDrawerSection(context, section)).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getDrawerWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      return screenWidth * 0.25; // 25% of screen width for large desktops
    } else if (screenWidth > 768) {
      return screenWidth * 0.32; // 32% of screen width for tablets/small desktops
    } else {
      return screenWidth * 0.85; // 85% of screen width for mobile
    }
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Container(
      height: _getHeaderHeight(context),
      width: double.infinity,
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 3,
              child: Hero(
                tag: 'drawer_profile_avatar',
                child: Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: isDesktop ? 3 : 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: _getAvatarRadius(context),
                    backgroundColor: Colors.white,
                    child: Icon(
                      headerIcon,
                      size: _getAvatarRadius(context) * 1.2,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Flexible(
              flex: 2,
              child: Text(
                headerTitle,
                style: _getHeaderTitleStyle(context),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
            Flexible(
              flex: 1,
              child: Text(
                headerSubtitle,
                style: _getHeaderSubtitleStyle(context),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getHeaderHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1024) {
      return screenHeight * 0.30; // 30% of screen height for desktop
    } else if (screenWidth > 768) {
      return screenHeight * 0.28; // 28% of screen height for tablet
    } else {
      return AppThemeResponsiveness.getDrawerHeaderHeight(context);
    }
  }

  double _getAvatarRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1024) {
      return 35.0; // Larger avatar for desktop
    } else if (screenWidth > 768) {
      return 30.0; // Medium avatar for tablet
    } else {
      return AppThemeResponsiveness.getDrawerAvatarRadius(context);
    }
  }

  TextStyle _getHeaderTitleStyle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseStyle = AppThemeResponsiveness.getHeadingTextStyle(context).copyWith(color: Colors.white);

    if (screenWidth > 1024) {
      return baseStyle.copyWith(fontSize: baseStyle.fontSize! * 1.1);
    } else if (screenWidth > 768) {
      return baseStyle.copyWith(fontSize: baseStyle.fontSize! * 1.05);
    }
    return baseStyle;
  }

  TextStyle _getHeaderSubtitleStyle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseStyle = AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(color: Colors.white70);

    if (screenWidth > 1024) {
      return baseStyle.copyWith(fontSize: baseStyle.fontSize! * 1.05);
    }
    return baseStyle;
  }

  Widget _buildDrawerSection(BuildContext context, ModernDrawerSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
            vertical: AppThemeResponsiveness.getSmallSpacing(context),
          ),
          child: Text(
            section.title,
            style: _getSectionTitleStyle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ...section.items.map((item) => _buildDrawerItem(context, item)).toList(),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 1.5),
      ],
    );
  }

  TextStyle _getSectionTitleStyle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseStyle = AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade600,
      letterSpacing: 0.5,
    );

    if (screenWidth > 1024) {
      return baseStyle.copyWith(fontSize: baseStyle.fontSize! * 1.1);
    }
    return baseStyle;
  }

  Widget _buildDrawerItem(BuildContext context, ModernDrawerItem item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context) * 1.2,
        vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          onTap: item.onTap ?? () {
            if (item.route != null) {
              Navigator.pushNamed(context, item.route!);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getSmallSpacing(context),
              vertical: isDesktop ? 12.0 : 8.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                  decoration: BoxDecoration(
                    color: item.isDestructive ? Colors.red.shade50 : Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isDestructive ? Colors.red.shade600 : Colors.indigo.shade600,
                    size: _getIconSize(context),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Expanded(
                  child: Text(
                    item.title,
                    style: _getItemTitleStyle(context, item.isDestructive),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.badge != null) ...[
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                      vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    child: Text(
                      item.badge!,
                      style: _getBadgeStyle(context),
                    ),
                  ),
                ] else ...[
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: _getIconSize(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1024) {
      return 22.0; // Larger icons for desktop
    } else if (screenWidth > 768) {
      return 20.0; // Medium icons for tablet
    } else {
      return AppThemeResponsiveness.getIconSize(context);
    }
  }

  TextStyle _getItemTitleStyle(BuildContext context, bool isDestructive) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseStyle = AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
      fontWeight: FontWeight.w500,
      color: isDestructive ? Colors.red.shade700 : Colors.grey.shade800,
    );

    if (screenWidth > 1024) {
      return baseStyle.copyWith(fontSize: baseStyle.fontSize! * 1.05);
    }
    return baseStyle;
  }

  TextStyle _getBadgeStyle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseStyle = AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    if (screenWidth > 1024) {
      return baseStyle.copyWith(fontSize: baseStyle.fontSize! * 1.05);
    }
    return baseStyle;
  }
}