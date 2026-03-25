import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> with TickerProviderStateMixin {
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'German', 'code': 'de'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppThemeColor.slideAnimationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          )
              : AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _buildResponsiveLayout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppThemeResponsiveness.isDesktop(context)) {
          return _buildDesktopLayout(context);
        } else if (AppThemeResponsiveness.isTablet(context)) {
          return _buildTabletLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Column(
        children: [
          _buildSettingsCard(context),
          SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppThemeResponsiveness.getMaxWidth(context) * 0.8,
          ),
          child: Column(
            children: [
              _buildSettingsCard(context),
              SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppThemeResponsiveness.getMaxWidth(context) * 0.6,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildThemeSection(context),
                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                    _buildLanguageSection(context),
                  ],
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getExtraLargeSpacing(context)),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildAboutSection(context),
                    SizedBox(height: AppThemeResponsiveness.getLargeSpacing(context)),
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
        vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Text(
              'Settings',
              style: AppThemeResponsiveness.getSectionTitleStyle(context),
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context)),
            decoration: BoxDecoration(
              color: AppThemeColor.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            child: Icon(
              Icons.settings,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Column(
        children: [
          _buildThemeSection(context),
          if (!AppThemeResponsiveness.isDesktop(context)) ...[
            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
            _buildLanguageSection(context),
            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
            _buildAboutSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Appearance'),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildThemeCard(context),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Language'),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildLanguageCard(context),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'About'),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          _buildAboutCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
        color: isDarkMode ? AppThemeColor.white : AppThemeColor.primaryBlue,
        fontSize: AppThemeResponsiveness.isDesktop(context)
            ? AppThemeResponsiveness.getHeadingStyle(context).fontSize! * 1.2
            : AppThemeResponsiveness.getHeadingStyle(context).fontSize,
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : AppThemeColor.white,
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context)),
                  decoration: BoxDecoration(
                    gradient: AppThemeColor.primaryGradient,
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                  ),
                  child: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: AppThemeColor.white,
                    size: AppThemeResponsiveness.getQuickStatsIconSize(context),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme Mode',
                        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                          color: isDarkMode ? AppThemeColor.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                      Text(
                        isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                          color: isDarkMode ? AppThemeColor.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: AppThemeColor.buttonAnimationDuration,
                  child: Transform.scale(
                    scale: AppThemeResponsiveness.isMobile(context) ? 0.9 : 1.0,
                    child: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                      activeColor: AppThemeColor.primaryBlue,
                      activeTrackColor: AppThemeColor.blue200,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildThemePreviewSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreviewSection(BuildContext context) {
    if (AppThemeResponsiveness.isSmallPhone(context)) {
      return Column(
        children: [
          _buildThemePreview(context, false, 'Light'),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          _buildThemePreview(context, true, 'Dark'),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildThemePreview(context, false, 'Light'),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: _buildThemePreview(context, true, 'Dark'),
          ),
        ],
      );
    }
  }

  Widget _buildThemePreview(BuildContext context, bool isDark, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDarkMode = isDark;
        });
      },
      child: AnimatedContainer(
        duration: AppThemeColor.buttonAnimationDuration,
        padding: AppThemeResponsiveness.getCardPadding(context).copyWith(
          top: AppThemeResponsiveness.getSmallSpacing(context),
          bottom: AppThemeResponsiveness.getSmallSpacing(context),
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : AppThemeColor.blue50,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          border: Border.all(
            color: isDarkMode == isDark ? AppThemeColor.primaryBlue : Colors.transparent,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: AppThemeResponsiveness.getQuickStatsIconSize(context),
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)])
                    : AppThemeColor.primaryGradient,
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context) / 2),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              label,
              style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppThemeColor.white : AppThemeColor.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : AppThemeColor.white,
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context)),
                  decoration: BoxDecoration(
                    gradient: AppThemeColor.primaryGradient,
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                  ),
                  child: Icon(
                    Icons.language,
                    color: AppThemeColor.white,
                    size: AppThemeResponsiveness.getQuickStatsIconSize(context),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Language',
                        style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                          color: isDarkMode ? AppThemeColor.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
                      Text(
                        selectedLanguage,
                        style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                          color: isDarkMode ? AppThemeColor.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDarkMode ? AppThemeColor.white70 : Colors.grey[600],
                  size: AppThemeResponsiveness.getIconSize(context),
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildLanguageOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptions(BuildContext context) {
    if (AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppThemeResponsiveness.isDesktop(context) ? 3 : 2,
          crossAxisSpacing: AppThemeResponsiveness.getSmallSpacing(context),
          mainAxisSpacing: AppThemeResponsiveness.getSmallSpacing(context),
          childAspectRatio: 3.5,
        ),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return _buildLanguageOption(context, languages[index]['name']!);
        },
      );
    } else {
      return Column(
        children: languages
            .map((language) => _buildLanguageOption(context, language['name']!))
            .toList(),
      );
    }
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    bool isSelected = selectedLanguage == language;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
      child: AnimatedContainer(
        duration: AppThemeColor.buttonAnimationDuration,
        margin: EdgeInsets.symmetric(
          vertical: AppThemeResponsiveness.isMobile(context)
              ? AppThemeResponsiveness.getSmallSpacing(context) * 0.4
              : 0,
        ),
        padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsPadding(context) * 0.8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? AppThemeColor.primaryBlue.withOpacity(0.3) : AppThemeColor.blue50)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          border: Border.all(
            color: isSelected ? AppThemeColor.primaryBlue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                language,
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppThemeColor.primaryBlue
                      : (isDarkMode ? AppThemeColor.white : Colors.black87),
                ),
                textAlign: AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)
                    ? TextAlign.center
                    : TextAlign.start,
              ),
            ),
            if (isSelected && AppThemeResponsiveness.isMobile(context))
              Icon(
                Icons.check_circle,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      color: isDarkMode ? const Color(0xFF2A2A2A) : AppThemeColor.white,
      child: Column(
        children: [
          _buildAboutItem(context, Icons.info_outline, 'App Version', '1.0.0'),
          _buildAboutItem(context, Icons.privacy_tip_outlined, 'Privacy Policy', ''),
          _buildAboutItem(context, Icons.description_outlined, 'Terms of Service', ''),
          _buildAboutItem(context, Icons.help_outline, 'Help & Support', ''),
        ],
      ),
    );
  }

  Widget _buildAboutItem(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: AppThemeResponsiveness.getCardPadding(context).copyWith(
        top: AppThemeResponsiveness.getSmallSpacing(context),
        bottom: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      leading: Container(
        padding: EdgeInsets.all(AppThemeResponsiveness.getQuickStatsIconPadding(context)),
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
        child: Icon(
          icon,
          color: AppThemeColor.white,
          size: AppThemeResponsiveness.getQuickStatsIconSize(context),
        ),
      ),
      title: Text(
        title,
        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          fontWeight: FontWeight.w500,
          color: isDarkMode ? AppThemeColor.white : Colors.black87,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Padding(
        padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
        child: Text(
          subtitle,
          style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
            color: isDarkMode ? AppThemeColor.white70 : Colors.grey[600],
          ),
        ),
      )
          : null,
      trailing: subtitle.isEmpty
          ? Icon(
        Icons.keyboard_arrow_right,
        color: isDarkMode ? AppThemeColor.white70 : Colors.grey[600],
        size: AppThemeResponsiveness.getIconSize(context) * 0.8,
      )
          : null,
      onTap: subtitle.isEmpty ? () {} : null,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppThemeResponsiveness.getMediumSpacing(context),
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school_rounded,
            color: Colors.white.withOpacity(0.6),
            size: AppThemeResponsiveness.getIconSize(context) * 1.2,
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            '© 2024 School Management System',
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.5),
          Text(
            'Empowering Education Through Technology',
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: Colors.white.withOpacity(0.5),
              fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize! * 0.9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}