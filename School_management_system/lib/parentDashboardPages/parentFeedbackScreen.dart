import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class ParentFeedbackPage extends StatefulWidget {
  @override
  State<ParentFeedbackPage> createState() => _ParentFeedbackPageState();
}

class _ParentFeedbackPageState extends State<ParentFeedbackPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _suggestionController = TextEditingController();

  // Rating variables
  int _teachingQualityRating = 0;
  int _communicationRating = 0;
  int _facilityRating = 0;
  int _overallRating = 0;

  // Selected values
  String _selectedCategory = 'General';
  String _selectedChild = 'Emma Johnson';
  String _selectedPriority = 'Medium';
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General',
    'Teaching Quality',
    'Communication',
    'Facilities',
    'Transport',
    'Cafeteria',
    'Events & Activities',
    'Fee Management',
    'Safety & Security',
    'Other'
  ];

  final List<String> _children = [
    'Emma Johnson',
    'Jake Johnson'
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _suggestionController.dispose();
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
        child: SafeArea(
          child: Column(
            children: [
              _buildTabBar(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGeneralFeedbackTab(),
                    _buildRatingTab(),
                    _buildSuggestionTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppThemeColor.primaryBlue,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          boxShadow: [
            BoxShadow(
              color: AppThemeColor.primaryBlue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppThemeColor.white,
        unselectedLabelColor: AppThemeColor.blue600,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: AppThemeResponsiveness.getTabFontSize(context),
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: AppThemeResponsiveness.getTabFontSize(context),
        ),
        tabs: const [
          Tab(text: 'Feedback'),
          Tab(text: 'Rating'),
          Tab(text: 'Suggestions'),
        ],
      ),
    );
  }

  Widget _buildGeneralFeedbackTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              'Feedback Details',
              Icons.feedback_rounded,
              Colors.blue,
              [
                _buildDropdownField(
                  'Category',
                  _selectedCategory,
                  _categories,
                      (value) => setState(() => _selectedCategory = value!),
                  Icons.category_rounded,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildDropdownField(
                  'Child',
                  _selectedChild,
                  _children,
                      (value) => setState(() => _selectedChild = value!),
                  Icons.child_care_rounded,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildDropdownField(
                  'Priority',
                  _selectedPriority,
                  _priorities,
                      (value) => setState(() => _selectedPriority = value!),
                  Icons.priority_high_rounded,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildTextFormField(
                  controller: _titleController,
                  label: 'Feedback Title',
                  hint: 'Brief title for your feedback',
                  icon: Icons.title_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildTextFormField(
                  controller: _descriptionController,
                  label: 'Detailed Description',
                  hint: 'Please provide detailed feedback...',
                  icon: Icons.description_rounded,
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide feedback details';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
            _buildSectionCard(
              'Privacy Options',
              Icons.privacy_tip_rounded,
              Colors.green,
              [
                _buildSwitchTile(
                  'Submit as Anonymous',
                  'Your identity will not be revealed',
                  _isAnonymous,
                      (value) => setState(() => _isAnonymous = value),
                  Icons.visibility_off_rounded,
                ),
              ],
            ),
            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 2),
            _buildSubmitButton('Submit Feedback'),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Rate School Services',
            Icons.star_rounded,
            Colors.orange,
            [
              Text(
                'Please rate the following aspects of our school:',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5),
              _buildRatingItem(
                'Teaching Quality',
                'Quality of education and teaching methods',
                Icons.school_rounded,
                Colors.blue,
                _teachingQualityRating,
                    (rating) => setState(() => _teachingQualityRating = rating),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              _buildRatingItem(
                'Communication',
                'School-parent communication effectiveness',
                Icons.messenger_outline,
                Colors.green,
                _communicationRating,
                    (rating) => setState(() => _communicationRating = rating),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              _buildRatingItem(
                'Facilities',
                'School infrastructure and facilities',
                Icons.domain_rounded,
                Colors.purple,
                _facilityRating,
                    (rating) => setState(() => _facilityRating = rating),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              _buildRatingItem(
                'Overall Experience',
                'Your overall satisfaction with the school',
                Icons.emoji_emotions_rounded,
                Colors.pink,
                _overallRating,
                    (rating) => setState(() => _overallRating = rating),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 2),
          _buildSubmitButton('Submit Ratings'),
        ],
      ),
    );
  }

  Widget _buildSuggestionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Share Your Suggestions',
            Icons.lightbulb_rounded,
            Colors.amber,
            [
              Text(
                'We value your suggestions for improving our school. Please share your ideas below:',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5),
              _buildTextFormField(
                controller: _suggestionController,
                label: 'Your Suggestions',
                hint: 'Share your ideas for improvement...',
                icon: Icons.lightbulb_outline_rounded,
                maxLines: 8,
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildSectionCard(
            'Suggestion Categories',
            Icons.category_rounded,
            Colors.teal,
            [
              Text(
                'Common areas for suggestions:',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              _buildSuggestionCategories(),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 2),
          _buildSubmitButton('Submit Suggestion'),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: Offset(0, AppThemeResponsiveness.getCardElevation(context) * 0.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                title,
                style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      IconData icon,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppThemeResponsiveness.getDefaultSpacing(context)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            color: Colors.grey.shade50,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: Colors.grey.shade600),
                      SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                      Text(
                        item,
                        style: AppThemeResponsiveness.getBodyTextStyle(context),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
              borderSide: BorderSide(color: AppThemeColor.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
          ),
          style: AppThemeResponsiveness.getBodyTextStyle(context),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
      String title,
      String subtitle,
      bool value,
      ValueChanged<bool> onChanged,
      IconData icon,
      ) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppThemeColor.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      int rating,
      ValueChanged<int> onRatingChanged,
      ) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context) * 0.8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context) * 0.6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => onRatingChanged(index + 1),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: index < rating ? Colors.amber.shade600 : Colors.grey.shade400,
                    size: 32,
                  ),
                ),
              );
            }),
          ),
          if (rating > 0)
            Center(
              child: Text(
                _getRatingText(rating),
                style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                  color: _getRatingColor(rating),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCategories() {
    final categories = [
      {'title': 'Teaching Methods', 'icon': Icons.school_rounded, 'color': Colors.blue},
      {'title': 'Infrastructure', 'icon': Icons.domain_rounded, 'color': Colors.green},
      {'title': 'Technology', 'icon': Icons.computer_rounded, 'color': Colors.purple},
      {'title': 'Extracurricular', 'icon': Icons.sports_rounded, 'color': Colors.orange},
      {'title': 'Safety', 'icon': Icons.security_rounded, 'color': Colors.red},
      {'title': 'Communication', 'icon': Icons.messenger_outline, 'color': Colors.teal},
    ];

    return Wrap(
      spacing: AppThemeResponsiveness.getSmallSpacing(context),
      runSpacing: AppThemeResponsiveness.getSmallSpacing(context),
      children: categories.map((category) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getSmallSpacing(context),
            vertical: AppThemeResponsiveness.getSmallSpacing(context) * 0.6,
          ),
          decoration: BoxDecoration(
            color: (category['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            border: Border.all(color: (category['color'] as Color).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category['icon'] as IconData,
                size: 16,
                color: category['color'] as Color,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) * 0.4),
              Text(
                category['title'] as String,
                style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                  color: category['color'] as Color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton(String text) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColor.primaryBlue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getDefaultSpacing(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              'Submitting...',
              style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                color: Colors.white,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red.shade600;
      case 2:
        return Colors.orange.shade600;
      case 3:
        return Colors.amber.shade600;
      case 4:
        return Colors.lightGreen.shade600;
      case 5:
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  void _submitFeedback() async {
    // Validate based on current tab
    bool isValid = false;

    if (_tabController.index == 0) {
      // General feedback tab
      isValid = _formKey.currentState?.validate() ?? false;
    } else if (_tabController.index == 1) {
      // Rating tab
      isValid = _teachingQualityRating > 0 || _communicationRating > 0 ||
          _facilityRating > 0 || _overallRating > 0;
      if (!isValid) {
        _showSnackBar('Please provide at least one rating', Colors.orange);
        return;
      }
    } else {
      // Suggestion tab
      isValid = _suggestionController.text.trim().isNotEmpty;
      if (!isValid) {
        _showSnackBar('Please enter your suggestion', Colors.orange);
        return;
      }
    }

    if (!isValid) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    // Show success message
    _showSuccessDialog();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade600,
                  size: 48,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
              Text(
                'Thank You!',
                style: AppThemeResponsiveness.getSubtitleTextStyle(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Your feedback has been submitted successfully. We appreciate your input and will review it carefully.',
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Done',
                style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                  color: AppThemeColor.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}