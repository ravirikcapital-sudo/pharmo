import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class WelcomeSection extends StatelessWidget {
  final String name;
  final String classInfo;
  final bool isActive;
  final bool isVerified;
  final bool isSuperUser;
  final IconData icon;
  final String? profileImageUrl; // Add profile image URL
  final PlatformFile? profileImageFile; // Add profile image file

  const WelcomeSection({
    super.key,
    required this.name,
    required this.classInfo,
    this.isActive = true,
    this.isVerified = false,
    this.isSuperUser = false,
    this.icon = Icons.person_rounded,
    this.profileImageUrl,
    this.profileImageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardPadding(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'profile_avatar',
            child: _buildProfileAvatar(context),
          ),
          SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: AppThemeResponsiveness.getWelcomeBackTextStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
                Text(
                  name,
                  style: AppThemeResponsiveness.getWelcomeNameTextStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                _buildTagsSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    // Check if we have a profile image (either file or URL)
    bool hasProfileImage = profileImageFile != null ||
        (profileImageUrl != null && profileImageUrl!.isNotEmpty);

    if (hasProfileImage) {
      // Display profile image
      return Container(
        padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.indigo.shade400, Colors.purple.shade400],
          ),
        ),
        child: CircleAvatar(
          radius: AppThemeResponsiveness.getWelcomeAvatarRadius(context),
          backgroundColor: Colors.white,
          backgroundImage: _getProfileImageProvider(),
          child: _getProfileImageProvider() == null
              ? Icon(
            icon,
            size: AppThemeResponsiveness.getWelcomeAvatarIconSize(context),
            color: Colors.indigo.shade600,
          )
              : null,
        ),
      );
    } else {
      // Display default icon avatar
      return Container(
        padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.indigo.shade400, Colors.purple.shade400],
          ),
        ),
        child: CircleAvatar(
          radius: AppThemeResponsiveness.getWelcomeAvatarRadius(context),
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: AppThemeResponsiveness.getWelcomeAvatarIconSize(context),
            color: Colors.indigo.shade600,
          ),
        ),
      );
    }
  }

  ImageProvider? _getProfileImageProvider() {
    if (profileImageFile != null) {
      // Use file image if available
      return MemoryImage(profileImageFile!.bytes!);
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      // Use network image if URL is available
      return NetworkImage(profileImageUrl!);
    }
    return null;
  }

  Widget _buildTagsSection(BuildContext context) {
    // Check if it's desktop (you can adjust this breakpoint as needed)
    bool isDesktop = MediaQuery.of(context).size.width >= 768;

    List<Widget> tags = [];

    // Always add class info tag first
    tags.add(_buildTag(
      context,
      text: classInfo,
      backgroundColor: Colors.indigo.shade100,
      textColor: Colors.indigo.shade700,
    ));

    // Add status tags
    if (isActive) {
      tags.add(_buildIconTag(
        context,
        icon: Icons.check_circle,
        text: 'Active',
        backgroundColor: Colors.green.shade100,
        iconColor: Colors.green.shade700,
        textColor: Colors.green.shade700,
      ));
    }

    if (isSuperUser) {
      tags.add(_buildIconTag(
        context,
        icon: Icons.shield_rounded,
        text: 'Super User',
        backgroundColor: Colors.red.shade100,
        iconColor: Colors.red.shade700,
        textColor: Colors.red.shade700,
      ));
    }

    // Add verified tag to the same list
    if (isVerified) {
      tags.add(_buildIconTag(
        context,
        icon: Icons.verified_rounded,
        text: 'Verified',
        backgroundColor: Colors.yellow.shade100,
        iconColor: Colors.yellow.shade700,
        textColor: Colors.yellow.shade700,
      ));
    }

    if (isDesktop) {
      // Desktop: Display tags in a row
      return Row(
        children: tags.map((tag) => Padding(
          padding: EdgeInsets.only(right: AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
          child: tag,
        )).toList(),
      );
    } else {
      // Mobile: Display tags in a wrap
      return Wrap(
        spacing: AppThemeResponsiveness.getSmallSpacing(context) * 0.8,
        runSpacing: AppThemeResponsiveness.getSmallSpacing(context) * 0.4,
        children: tags,
      );
    }
  }

  Widget _buildTag(
      BuildContext context, {
        required String text,
        required Color backgroundColor,
        required Color textColor,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context) * 1.2,
        vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
      ),
      child: Text(
        text,
        style: AppThemeResponsiveness.getWelcomeClassTextStyle(context).copyWith(color: textColor),
      ),
    );
  }

  Widget _buildIconTag(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color backgroundColor,
        required Color iconColor,
        required Color textColor,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getSmallSpacing(context) * 1.2,
        vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize! + 2,
            color: iconColor,
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
          Text(
            text,
            style: AppThemeResponsiveness.getWelcomeClassTextStyle(context).copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}