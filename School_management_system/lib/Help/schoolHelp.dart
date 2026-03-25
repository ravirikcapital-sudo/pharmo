import 'package:flutter/material.dart';
import 'package:school/model/schoolHelp.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolHelpPage extends StatefulWidget {
  @override
  State<SchoolHelpPage> createState() => _SchoolHelpPageState();
}

class _SchoolHelpPageState extends State<SchoolHelpPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // FAQ Data
  final List<HelpItem> _allHelp = [
    HelpItem(
      'How to register for admission?',
      'Visit the school office with required documents or apply online through our admission portal.',
      'Admission',
      Icons.school,
    ),
    HelpItem(
      'What are the school timings?',
      'School hours: 8:00 AM to 3:00 PM (Monday to Friday). Saturday: 8:00 AM to 12:00 PM.',
      'General',
      Icons.schedule,
    ),
    HelpItem(
      'How to pay school fees?',
      'Pay fees online through our website, mobile app, or visit the accounts office.',
      'Fees',
      Icons.payment,
    ),
    HelpItem(
      'What documents are required for admission?',
      'Birth certificate, previous school records, passport photos, and address proof.',
      'Admission',
      Icons.document_scanner,
    ),
    HelpItem(
      'How to contact teachers?',
      'Use the school diary, call the office, or email teachers directly.',
      'Communication',
      Icons.contact_mail,
    ),
    HelpItem(
      'What is the uniform policy?',
      'Students must wear prescribed school uniform. Details available in student handbook.',
      'Rules',
      Icons.checkroom,
    ),
  ];

  List<HelpItem> get _filteredHelp {
    if (_searchQuery.isEmpty) return _allHelp;
    return _allHelp.where((help) =>
    help.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        help.answer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        help.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Help'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            _buildSearchBar(),
            _buildQuickActions(),
            Expanded(child: _buildHelpList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
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
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildQuickAction('Call School', Icons.phone, Colors.green, () => _makeCall('+919876543210')),
          SizedBox(width: 12),
          _buildQuickAction('Email', Icons.email, Colors.blue, () => _sendEmail('info@school.edu')),
          SizedBox(width: 12),
          _buildQuickAction('Location', Icons.location_on, Colors.red, () => _openMaps()),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (_searchQuery.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              'Found ${_filteredHelp.length} results for "$_searchQuery"',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        ..._filteredHelp.map((help) => _buildHelpItem(help)).toList(),
        if (_filteredHelp.isEmpty && _searchQuery.isNotEmpty)
          _buildNoResults(),
        SizedBox(height: 20),
        _buildContactInfo(),
      ],
    );
  }

  Widget _buildHelpItem(HelpItem help) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(help.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            help.icon,
            color: _getCategoryColor(help.category),
            size: 20,
          ),
        ),
        title: Text(
          help.question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getCategoryColor(help.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            help.category,
            style: TextStyle(
              color: _getCategoryColor(help.category),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              help.answer,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try different keywords or contact us',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _makeCall('+919876543210'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Contact School'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'School Contact Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildContactRow(Icons.phone, 'Phone', '+91 98765 43210', () => _makeCall('+919876543210')),
          _buildContactRow(Icons.email, 'Email', 'info@school.edu', () => _sendEmail('info@school.edu')),
          _buildContactRow(Icons.location_on, 'Address', '123 School Street, City', () => _openMaps()),
          _buildContactRow(Icons.access_time, 'Office Hours', '9:00 AM - 5:00 PM', null),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Spacer(),
            if (onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'admission':
        return Colors.blue;
      case 'fees':
        return Colors.green;
      case 'general':
        return Colors.orange;
      case 'communication':
        return Colors.purple;
      case 'rules':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage('Could not make call');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=School Help Request',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage('Could not open email');
    }
  }

  Future<void> _openMaps() async {
    const String address = '123 School Street, City';
    final Uri uri = Uri(
      scheme: 'https',
      host: 'maps.google.com',
      path: '/search/',
      query: 'api=1&query=$address',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage('Could not open maps');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

