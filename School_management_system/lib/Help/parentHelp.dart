import 'package:flutter/material.dart';
import 'package:school/model/parentHelp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class ParentHelpPage extends StatefulWidget {
  @override
  State<ParentHelpPage> createState() => _ParentHelpPageState();
}

class _ParentHelpPageState extends State<ParentHelpPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // FAQ Data
  final List<FAQItem> _allFAQs = [
    FAQItem(
      'How do I check my child\'s grades?',
      'Go to Academic Performance section from the dashboard. You can view detailed grades, test scores, and progress reports for each subject.',
      'Academic',
      Icons.grade_rounded,
    ),
    FAQItem(
      'How to pay school fees online?',
      'Navigate to Fee Management from the main menu. Select the pending fees and choose your preferred payment method (Credit Card, Debit Card, UPI, Net Banking).',
      'Payments',
      Icons.payment_rounded,
    ),
    FAQItem(
      'How can I track my child\'s attendance?',
      'Visit the Attendance Tracking section to view daily, weekly, and monthly attendance reports. You\'ll also receive notifications for absences.',
      'Attendance',
      Icons.calendar_today_rounded,
    ),
    FAQItem(
      'How to communicate with teachers?',
      'Use the Messages section to send direct messages to teachers. You can also schedule parent-teacher meetings through the Events section.',
      'Communication',
      Icons.message_rounded,
    ),
    FAQItem(
      'How do I update my contact information?',
      'Go to Settings > Profile Settings to update your phone number, email address, and emergency contact details.',
      'Profile',
      Icons.person_rounded,
    ),
    FAQItem(
      'How to download report cards?',
      'In the Academic Performance section, select the term/semester and click on "Download Report Card" to get a PDF copy.',
      'Academic',
      Icons.download_rounded,
    ),
    FAQItem(
      'What if I forgot my password?',
      'On the login screen, click "Forgot Password" and enter your registered email or phone number. You\'ll receive reset instructions.',
      'Account',
      Icons.lock_rounded,
    ),
    FAQItem(
      'How to enable push notifications?',
      'Go to Settings > Notification Preferences and enable the types of notifications you want to receive.',
      'Settings',
      Icons.notifications_rounded,
    ),
  ];

  List<FAQItem> get _filteredFAQs {
    if (_searchQuery.isEmpty) return _allFAQs;
    return _allFAQs.where((faq) =>
    faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        faq.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: Column(
          children: [
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                  ),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFAQTab(),
                    _buildContactTab(),
                    _buildTutorialsTab(),
                    _buildTroubleshootingTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search help topics...',
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade600),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear_rounded, color: Colors.grey.shade600),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          )
              : null,
          border: InputBorder.none,
          hintStyle: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        style: AppThemeResponsiveness.getBodyTextStyle(context),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppThemeColor.primaryBlue,
        unselectedLabelColor: Colors.grey.shade600,
        indicator: BoxDecoration(
          color: AppThemeColor.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
        indicatorPadding: EdgeInsets.all(4),
        labelStyle: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          fontSize: 12,
        ),
        tabs: [
          Tab(text: 'FAQ'),
          Tab(text: 'Contact'),
          Tab(text: 'Tutorials'),
          Tab(text: 'Issues'),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    return ListView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      children: [
        if (_searchQuery.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: Colors.blue.shade600),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Expanded(
                  child: Text(
                    'Found ${_filteredFAQs.length} results for "$_searchQuery"',
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ..._filteredFAQs.map((faq) => _buildFAQItem(faq)).toList(),
        if (_filteredFAQs.isEmpty && _searchQuery.isNotEmpty)
          _buildNoResultsWidget(),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(faq.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            faq.icon,
            color: _getCategoryColor(faq.category),
            size: 20,
          ),
        ),
        title: Text(
          faq.question,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getCategoryColor(faq.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            faq.category,
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: _getCategoryColor(faq.category),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Text(
              faq.answer,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return ListView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      children: [
        _buildContactCard(
          'School Office',
          'For general inquiries and administrative support',
          Icons.school_rounded,
          Colors.blue,
          [
            ContactMethod('Phone', '+91 98765 43210', Icons.phone_rounded, () => _makeCall('+919876543210')),
            ContactMethod('Email', 'info@brilliantschool.edu', Icons.email_rounded, () => _sendEmail('info@brilliantschool.edu')),
            ContactMethod('Address', '123 Education Street, Mumbai', Icons.location_on_rounded, () => _openMaps()),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildContactCard(
          'Principal\'s Office',
          'For important matters and policy discussions',
          Icons.person_rounded,
          Colors.purple,
          [
            ContactMethod('Phone', '+91 98765 43211', Icons.phone_rounded, () => _makeCall('+919876543211')),
            ContactMethod('Email', 'principal@brilliantschool.edu', Icons.email_rounded, () => _sendEmail('principal@brilliantschool.edu')),
            ContactMethod('Schedule Meeting', 'Book appointment', Icons.calendar_today_rounded, () => _scheduleAppointment()),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildContactCard(
          'Technical Support',
          'For app issues and technical assistance',
          Icons.support_agent_rounded,
          Colors.green,
          [
            ContactMethod('WhatsApp', '+91 98765 43212', Icons.chat_rounded, () => _openWhatsApp('+919876543212')),
            ContactMethod('Email', 'tech@brilliantschool.edu', Icons.email_rounded, () => _sendEmail('tech@brilliantschool.edu')),
            ContactMethod('Live Chat', 'Chat with support', Icons.forum_rounded, () => _openLiveChat()),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildEmergencyContact(),
      ],
    );
  }

  Widget _buildContactCard(String title, String description, IconData icon, Color color, List<ContactMethod> methods) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          ...methods.map((method) => _buildContactMethod(method)).toList(),
        ],
      ),
    );
  }

  Widget _buildContactMethod(ContactMethod method) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: method.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(method.icon, color: Colors.grey.shade600, size: 20),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.label,
                      style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      method.value,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.emergency_rounded, color: Colors.white, size: 24),
              ),
              SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contact',
                      style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'For urgent matters and emergencies',
                      style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          ElevatedButton(
            onPressed: () => _makeCall('+919876543213'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red.shade600,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_rounded),
                SizedBox(width: 8),
                Text(
                  'Call Emergency: +91 98765 43213',
                  style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialsTab() {
    final tutorials = [
      TutorialItem('Getting Started', 'Learn the basics of using the parent portal', Icons.play_circle_rounded, Colors.blue, 'Basic'),
      TutorialItem('Checking Grades', 'How to view and understand your child\'s academic performance', Icons.grade_rounded, Colors.green, 'Basic'),
      TutorialItem('Fee Payment', 'Step-by-step guide to pay school fees online', Icons.payment_rounded, Colors.orange, 'Basic'),
      TutorialItem('Communication', 'How to message teachers and stay connected', Icons.message_rounded, Colors.purple, 'Intermediate'),
      TutorialItem('Attendance Tracking', 'Monitor your child\'s daily attendance', Icons.calendar_today_rounded, Colors.cyan, 'Basic'),
      TutorialItem('Notifications Setup', 'Customize your notification preferences', Icons.notifications_rounded, Colors.red, 'Advanced'),
    ];

    return ListView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      children: tutorials.map((tutorial) => _buildTutorialItem(tutorial)).toList(),
    );
  }

  Widget _buildTutorialItem(TutorialItem tutorial) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openTutorial(tutorial),
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          child: Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tutorial.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tutorial.icon, color: tutorial.color, size: 24),
                ),
                SizedBox(width: AppThemeResponsiveness.getDefaultSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tutorial.title,
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(tutorial.difficulty).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tutorial.difficulty,
                              style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                                color: _getDifficultyColor(tutorial.difficulty),
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        tutorial.description,
                        style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTroubleshootingTab() {
    final issues = [
      IssueItem('App is running slow', 'Clear app cache and restart', Icons.speed_rounded, Colors.orange, 'Performance'),
      IssueItem('Can\'t login to account', 'Reset password or contact support', Icons.login_rounded, Colors.red, 'Account'),
      IssueItem('Notifications not working', 'Check notification settings', Icons.notifications_off_rounded, Colors.blue, 'Notifications'),
      IssueItem('Payment failed', 'Try different payment method', Icons.payment_rounded, Colors.green, 'Payments'),
      IssueItem('Grades not showing', 'Contact teacher or refresh page', Icons.grade_rounded, Colors.purple, 'Academic'),
      IssueItem('App crashes frequently', 'Update app or reinstall', Icons.bug_report_rounded, Colors.red, 'Technical'),
    ];

    return ListView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      children: [
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
          margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.cyan.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_rounded, color: Colors.blue.shade600),
                  SizedBox(width: 8),
                  Text(
                    'Quick Tips',
                    style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• Try restarting the app if you experience issues\n• Check your internet connection\n• Make sure you have the latest app version\n• Clear app cache if the app is slow',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: Colors.blue.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        ...issues.map((issue) => _buildIssueItem(issue)).toList(),
      ],
    );
  }

  Widget _buildIssueItem(IssueItem issue) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: issue.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(issue.icon, color: issue.color, size: 20),
        ),
        title: Text(
          issue.title,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: issue.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            issue.category,
            style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
              color: issue.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solution:',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  issue.solution,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _contactSupport(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: issue.color),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Contact Support',
                          style: TextStyle(color: issue.color),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _reportIssue(issue),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: issue.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Report Issue',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Completing the _buildNoResultsWidget method
  Widget _buildNoResultsWidget() {
    return Container(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context) * 2),
    child: Column(
    children: [
    Icon(
    Icons.search_off_rounded,
    size: 64,
    color: Colors.grey.shade400,
    ),
    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
    Text(
    'No results found',
    style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
    color: Colors.grey.shade600,
    ),
    ),
    SizedBox(height: 8),
      Text(
        'Try different keywords or contact support',
        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
          color: Colors.grey.shade500,
        ),
      ),
      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
      ElevatedButton(
        onPressed: () => _contactSupport(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColor.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
          ),
        ),
        child: Text(
          'Contact Support',
          style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
            color: Colors.white,
          ),
        ),
      ),
    ],
    ),
    );
  }

  // Helper methods for colors
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Colors.blue;
      case 'payments':
        return Colors.green;
      case 'attendance':
        return Colors.orange;
      case 'communication':
        return Colors.purple;
      case 'profile':
        return Colors.cyan;
      case 'account':
        return Colors.red;
      case 'settings':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'basic':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Action methods
  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showErrorSnackBar('Could not launch phone dialer');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request from Parent Portal',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showErrorSnackBar('Could not launch email client');
    }
  }

  Future<void> _openMaps() async {
    const String address = '123 Education Street, Mumbai';
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'maps.google.com',
      path: '/search/',
      query: 'api=1&query=$address',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackBar('Could not open maps');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
      query: 'text=Hello, I need help with the parent portal',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackBar('Could not open WhatsApp');
    }
  }

  void _scheduleAppointment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Appointment'),
        content: Text('This feature will redirect you to the appointment booking system.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to appointment booking page
              _showInfoSnackBar('Redirecting to appointment booking...');
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _openLiveChat() {
    _showInfoSnackBar('Opening live chat support...');
    // Implement live chat functionality
  }

  void _openTutorial(TutorialItem tutorial) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tutorial.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tutorial.description),
            SizedBox(height: 16),
            Text(
              'This tutorial will guide you through ${tutorial.title.toLowerCase()}.',
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showInfoSnackBar('Starting tutorial: ${tutorial.title}');
              // Implement tutorial navigation
            },
            child: Text('Start Tutorial'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Support',
              style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            ListTile(
              leading: Icon(Icons.phone_rounded, color: AppThemeColor.primaryBlue),
              title: Text('Call Support'),
              subtitle: Text('+91 98765 43212'),
              onTap: () {
                Navigator.pop(context);
                _makeCall('+919876543212');
              },
            ),
            ListTile(
              leading: Icon(Icons.email_rounded, color: AppThemeColor.primaryBlue),
              title: Text('Email Support'),
              subtitle: Text('tech@brilliantschool.edu'),
              onTap: () {
                Navigator.pop(context);
                _sendEmail('tech@brilliantschool.edu');
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_rounded, color: AppThemeColor.primaryBlue),
              title: Text('WhatsApp Support'),
              subtitle: Text('Quick chat support'),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp('+919876543212');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _reportIssue(IssueItem issue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Issue: ${issue.title}'),
            SizedBox(height: 8),
            Text('Category: ${issue.category}'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Describe your specific problem...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showInfoSnackBar('Issue reported successfully');
            },
            child: Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppThemeColor.primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
