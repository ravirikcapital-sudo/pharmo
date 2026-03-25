import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/mainChat.dart';

// Chat Selection Page
class MainChat extends StatelessWidget {
  const MainChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Chat Options
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                  ),
                  padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title Section
                      Padding(
                        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                        child: Text(
                          'Select Chat With',
                          style: AppThemeResponsiveness.getFontStyle(context),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                      // Chat Options - Responsive Layout
                      Flexible(
                        child: AppThemeResponsiveness.isTablet(context) || AppThemeResponsiveness.isDesktop(context)
                            ? _buildTabletDesktopLayout(context)
                            : _buildMobileLayout(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildChatOption(
          context: context,
          title: 'Student',
          subtitle: 'Chat with student',
          icon: Icons.person,
          iconColor: Colors.teal,
          userType: 'Student',
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildChatOption(
          context: context,
          title: 'Teacher',
          subtitle: 'Chat with your teachers',
          icon: Icons.school,
          iconColor: Colors.blue,
          userType: 'Teacher',
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildChatOption(
          context: context,
          title: 'Admin',
          subtitle: 'Contact administration',
          icon: Icons.admin_panel_settings,
          iconColor: Colors.green,
          userType: 'Admin',
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildChatOption(
          context: context,
          title: 'Academic Officer',
          subtitle: 'Academic support and guidance',
          icon: Icons.account_balance,
          iconColor: Colors.orange,
          userType: 'Academic Officer',
        ),
      ],
    );
  }

  Widget _buildTabletDesktopLayout(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: AppThemeResponsiveness.isDesktop(context) ? 3 : 2,
      crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
      mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
      childAspectRatio: AppThemeResponsiveness.isDesktop(context) ? 1.2 : 1.0,
      children: [
        _buildChatOption(
          context: context,
          title: 'Teacher',
          subtitle: 'Chat with your teachers',
          icon: Icons.school,
          iconColor: Colors.blue,
          userType: 'Teacher',
        ),
        _buildChatOption(
          context: context,
          title: 'Admin',
          subtitle: 'Contact administration',
          icon: Icons.admin_panel_settings,
          iconColor: Colors.green,
          userType: 'Admin',
        ),
        _buildChatOption(
          context: context,
          title: 'Academic Officer',
          subtitle: 'Academic support and guidance',
          icon: Icons.account_balance,
          iconColor: Colors.orange,
          userType: 'Academic Officer',
        ),
      ],
    );
  }

  Widget _buildChatOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String userType,
  }) {
    return Card(
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(userType: userType),
            ),
          );
        },
        child: Container(
          padding: AppThemeResponsiveness.getCardPadding(context),
          child: AppThemeResponsiveness.isMobile(context)
              ? _buildMobileChatOption(context, title, subtitle, icon, iconColor)
              : _buildTabletChatOption(context, title, subtitle, icon, iconColor),
        ),
      ),
    );
  }

  Widget _buildMobileChatOption(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color iconColor,
      ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: AppThemeResponsiveness.getDashboardCardIconSize(context),
            color: iconColor,
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
              Text(
                subtitle,
                style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: AppThemeResponsiveness.getIconSize(context) * 0.8,
        ),
      ],
    );
  }

  Widget _buildTabletChatOption(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color iconColor,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: AppThemeResponsiveness.getDashboardCardIconSize(context) * 1.2,
            color: iconColor,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        Text(
          title,
          style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Text(
          subtitle,
          style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Chat Page
class ChatPage extends StatefulWidget {
  final String userType;

  const ChatPage({Key? key, required this.userType}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    // Add a welcome message
    messages.add(
      ChatMessage(
        text: 'Hello! How can I help you today?',
        isMe: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate a response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          messages.add(
            ChatMessage(
              text: 'Thank you for your message. I\'ll get back to you soon.',
              isMe: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  IconData _getUserIcon() {
    switch (widget.userType) {
      case 'Teacher':
        return Icons.school;
      case 'Admin':
        return Icons.admin_panel_settings;
      case 'Academic Officer':
        return Icons.account_balance;
      default:
        return Icons.person;
    }
  }

  Color _getUserColor() {
    switch (widget.userType) {
      case 'Teacher':
        return Colors.blue;
      case 'Admin':
        return Colors.green;
      case 'Academic Officer':
        return Colors.orange;
      default:
        return AppThemeColor.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemeColor.primaryBlue,
        toolbarHeight: AppThemeResponsiveness.getAppBarHeight(context),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppThemeColor.white,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: AppThemeResponsiveness.isMobile(context) ? 20 : 24,
              backgroundColor: _getUserColor().withOpacity(0.2),
              child: Icon(
                _getUserIcon(),
                color: _getUserColor(),
                size: AppThemeResponsiveness.getIconSize(context),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userType,
                    style: TextStyle(
                      color: AppThemeColor.white,
                      fontSize: AppThemeResponsiveness.isMobile(context) ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: AppThemeColor.white70,
                      fontSize: AppThemeResponsiveness.isMobile(context) ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add call functionality
            },
            icon: Icon(
              Icons.call,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
          ),
          IconButton(
            onPressed: () {
              // Add more options
            },
            icon: Icon(
              Icons.more_vert,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getIconSize(context),
            ),
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context),
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
            ),

            // Message Input
            Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
              decoration: BoxDecoration(
                color: AppThemeColor.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          AppThemeResponsiveness.getInputBorderRadius(context) * 2.5,
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: AppThemeResponsiveness.getBodyTextStyle(context),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: AppThemeResponsiveness.getCaptionTextStyle(context),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                            vertical: AppThemeResponsiveness.getSmallSpacing(context),
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                  Container(
                    width: AppThemeResponsiveness.getButtonHeight(context),
                    height: AppThemeResponsiveness.getButtonHeight(context),
                    decoration: const BoxDecoration(
                      gradient: AppThemeColor.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(
                        Icons.send,
                        color: AppThemeColor.white,
                        size: AppThemeResponsiveness.getIconSize(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isTabletOrDesktop = AppThemeResponsiveness.isTablet(context) || AppThemeResponsiveness.isDesktop(context);
    final maxWidth = AppThemeResponsiveness.getScreenWidth(context) * (isTabletOrDesktop ? 0.6 : 0.8);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2),
      child: Row(
        mainAxisAlignment:
        message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: AppThemeResponsiveness.isMobile(context) ? 16 : 20,
              backgroundColor: _getUserColor().withOpacity(0.2),
              child: Icon(
                _getUserIcon(),
                color: _getUserColor(),
                size: AppThemeResponsiveness.isMobile(context) ? 16 : 20,
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          ],
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getMediumSpacing(context),
              vertical: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            decoration: BoxDecoration(
              color: message.isMe ? AppThemeColor.primaryBlue : AppThemeColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                bottomLeft: message.isMe
                    ? Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context))
                    : const Radius.circular(4),
                bottomRight: message.isMe
                    ? const Radius.circular(4)
                    : Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: message.isMe ? AppThemeColor.white : Colors.black87,
                    fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: message.isMe
                        ? AppThemeColor.white70
                        : Colors.grey[600],
                    fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
