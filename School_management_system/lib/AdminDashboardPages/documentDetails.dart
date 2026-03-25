import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class StudentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const StudentDetailsPage({
    Key? key,
    required this.studentData,
  }) : super(key: key);

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  bool _isLoading = false;
  String _selectedTab = 'details';

  // Sample document data - in real app, this would come from API
  final List<Map<String, dynamic>> _documents = [
    {
      'id': 'DOC001',
      'name': 'Birth Certificate',
      'type': 'PDF',
      'size': '1.2 MB',
      'uploadDate': '2024-01-10',
      'status': 'Verified',
      'required': true,
      'url': 'assets/documents/birth_certificate.pdf',
      'icon': Icons.description,
      'color': Colors.red,
    },
    {
      'id': 'DOC002',
      'name': 'Previous School Certificate',
      'type': 'PDF',
      'size': '850 KB',
      'uploadDate': '2024-01-11',
      'status': 'Pending Review',
      'required': true,
      'url': 'assets/documents/school_certificate.pdf',
      'icon': Icons.school,
      'color': Colors.blue,
    },
    {
      'id': 'DOC003',
      'name': 'Medical Certificate',
      'type': 'PDF',
      'size': '600 KB',
      'uploadDate': '2024-01-12',
      'status': 'Verified',
      'required': true,
      'url': 'assets/documents/medical_certificate.pdf',
      'icon': Icons.medical_services,
      'color': Colors.green,
    },
    {
      'id': 'DOC004',
      'name': 'Passport Photo',
      'type': 'JPG',
      'size': '245 KB',
      'uploadDate': '2024-01-13',
      'status': 'Verified',
      'required': true,
      'url': 'assets/images/passport_photo.jpg',
      'icon': Icons.photo,
      'color': Colors.orange,
    },
    {
      'id': 'DOC005',
      'name': 'Parent ID Proof',
      'type': 'PDF',
      'size': '1.5 MB',
      'uploadDate': '2024-01-14',
      'status': 'Verified',
      'required': true,
      'url': 'assets/documents/parent_id.pdf',
      'icon': Icons.badge,
      'color': Colors.purple,
    },
    {
      'id': 'DOC006',
      'name': 'Address Proof',
      'type': 'PDF',
      'size': '900 KB',
      'uploadDate': '2024-01-15',
      'status': 'Pending Review',
      'required': true,
      'url': 'assets/documents/address_proof.pdf',
      'icon': Icons.home,
      'color': Colors.teal,
    },
    {
      'id': 'DOC007',
      'name': 'Additional Certificates',
      'type': 'PDF',
      'size': '750 KB',
      'uploadDate': '2024-01-16',
      'status': 'Verified',
      'required': false,
      'url': 'assets/documents/additional_cert.pdf',
      'icon': Icons.emoji_events,
      'color': Colors.amber,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Verified':
        return Colors.green;
      case 'Pending Review':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewDocument(Map<String, dynamic> document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerPage(document: document),
      ),
    );
  }

  void _updateDocumentStatus(Map<String, dynamic> document, String newStatus) {
    setState(() {
      document['status'] = newStatus;
    });

    String message = 'Document ${newStatus.toLowerCase()} successfully';
    Color snackBarColor = newStatus == 'Verified' ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: snackBarColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
    );
  }

  void _showDocumentActions(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getDialogBorderRadius(context)),
          ),
          child: Container(
            padding: AppThemeResponsiveness.getResponsivePadding(context, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Document Actions',
                  style: AppThemeResponsiveness.getDialogTitleStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                Text(
                  document['name'],
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildActionButton(
                  'View Document',
                  Icons.visibility,
                  Colors.blue,
                      () {
                    Navigator.of(context).pop();
                    _viewDocument(document);
                  },
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildActionButton(
                  'Verify Document',
                  Icons.check_circle,
                  Colors.green,
                      () {
                    Navigator.of(context).pop();
                    _updateDocumentStatus(document, 'Verified');
                  },
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                _buildActionButton(
                  'Reject Document',
                  Icons.cancel,
                  Colors.red,
                      () {
                    Navigator.of(context).pop();
                    _updateDocumentStatus(document, 'Rejected');
                  },
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: AppThemeResponsiveness.getButtonTextStyle(context)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          padding: AppThemeResponsiveness.getResponsivePadding(context, 12.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Student Details'),
        backgroundColor: AppThemeColor.blue600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: _selectedTab == 'details'
                    ? _buildStudentDetails()
                    : _buildDocumentsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: AppThemeResponsiveness.getResponsivePadding(context, 20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppThemeResponsiveness.getResponsiveSize(context, 30.0, 35.0, 40.0),
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: AppThemeResponsiveness.getResponsiveSize(context, 30.0, 35.0, 40.0),
              color: AppThemeColor.blue600,
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentData['name'] ?? 'Student Name',
                  style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${widget.studentData['grade'] ?? 'Grade'} • ID: ${widget.studentData['id'] ?? 'N/A'}',
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context)),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                    vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12.0)),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.studentData['status'] ?? 'Status',
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: AppThemeResponsiveness.getResponsiveSize(context, 12.0, 13.0, 14.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('details', 'Student Details', Icons.person_outline),
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: _buildTabButton('documents', 'Documents', Icons.folder_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabId, String title, IconData icon) {
    final isSelected = _selectedTab == tabId;

    return Container(
      height: AppThemeResponsiveness.getResponsiveSize(context, 50.0, 55.0, 60.0),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedTab = tabId;
          });
        },
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : AppThemeColor.blue600,
          size: AppThemeResponsiveness.getIconSize(context),
        ),
        label: Text(
          title,
          style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
            color: isSelected ? Colors.white : AppThemeColor.blue600,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppThemeColor.blue600 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          elevation: isSelected ? 4 : 2,
        ),
      ),
    );
  }

  Widget _buildStudentDetails() {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDetailCard('Student Information', [
              _buildDetailRow('Full Name', widget.studentData['name'] ?? 'N/A'),
              _buildDetailRow('Student ID', widget.studentData['id'] ?? 'N/A'),
              _buildDetailRow('Grade', widget.studentData['grade'] ?? 'N/A'),
              _buildDetailRow('Date of Birth', '15/03/2008'),
              _buildDetailRow('Gender', 'Male'),
              _buildDetailRow('Blood Group', 'B+'),
            ]),

            _buildDetailCard('Parent Information', [
              _buildDetailRow('Parent Name', widget.studentData['parentName'] ?? 'N/A'),
              _buildDetailRow('Phone', widget.studentData['phone'] ?? 'N/A'),
              _buildDetailRow('Email', widget.studentData['email'] ?? 'N/A'),
              _buildDetailRow('Occupation', 'Business'),
              _buildDetailRow('Address', '123 Main Street, City, State - 400001'),
            ]),

            _buildDetailCard('Academic Information', [
              _buildDetailRow('Previous School', 'ABC Public School'),
              _buildDetailRow('Previous Grade', 'Grade 9'),
              _buildDetailRow('Academic Year', '2023-2024'),
              _buildDetailRow('Percentage', '85.5%'),
              _buildDetailRow('Subjects', 'Math, Science, English, Hindi, Social Studies'),
            ]),

            _buildDetailCard('Application Details', [
              _buildDetailRow('Application Date', widget.studentData['submittedDate'] ?? 'N/A'),
              _buildDetailRow('Status', widget.studentData['status'] ?? 'N/A'),
              _buildDetailRow('Priority', widget.studentData['priority'] ?? 'N/A'),
              _buildDetailRow('Interview Date', widget.studentData['interviewDate'] != null
                  ? _formatDateTime(widget.studentData['interviewDate'])
                  : 'Not Scheduled'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
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
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppThemeResponsiveness.getRecentTitleStyle(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppThemeColor.blue600,
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppThemeResponsiveness.getResponsiveSize(context, 120.0, 140.0, 160.0),
            child: Text(
              label,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            ': ',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: _documents.isEmpty
          ? _buildEmptyDocuments()
          : ListView.builder(
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          return _buildDocumentCard(_documents[index]);
        },
      ),
    );
  }

  Widget _buildEmptyDocuments() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: AppThemeResponsiveness.getResponsiveSize(context, 64.0, 72.0, 80.0),
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            'No documents uploaded',
            style: AppThemeResponsiveness.getHeadingTextStyle(context).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
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
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          onTap: () => _showDocumentActions(document),
          child: Padding(
            padding: AppThemeResponsiveness.getCardPadding(context),
            child: Row(
              children: [
                Container(
                  width: AppThemeResponsiveness.getResponsiveSize(context, 50.0, 55.0, 60.0),
                  height: AppThemeResponsiveness.getResponsiveSize(context, 50.0, 55.0, 60.0),
                  decoration: BoxDecoration(
                    color: document['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12.0)),
                  ),
                  child: Icon(
                    document['icon'],
                    color: document['color'],
                    size: AppThemeResponsiveness.getIconSize(context),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              document['name'],
                              style: AppThemeResponsiveness.getRecentTitleStyle(context).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (document['required'])
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Required',
                                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                      Text(
                        '${document['type']} • ${document['size']}',
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          color: Colors.grey.shade600,
                          fontSize: AppThemeResponsiveness.getResponsiveSize(context, 12.0, 13.0, 14.0),
                        ),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                              vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(document['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12.0)),
                            ),
                            child: Text(
                              document['status'],
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                color: _getStatusColor(document['status']),
                                fontWeight: FontWeight.w600,
                                fontSize: AppThemeResponsiveness.getResponsiveSize(context, 11.0, 12.0, 13.0),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Uploaded: ${document['uploadDate']}',
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: Colors.grey.shade500,
                              fontSize: AppThemeResponsiveness.getResponsiveSize(context, 11.0, 12.0, 13.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade400,
                  size: AppThemeResponsiveness.getIconSize(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${time.format(context)}';
  }
}

// Document Viewer Page
class DocumentViewerPage extends StatelessWidget {
  final Map<String, dynamic> document;

  const DocumentViewerPage({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document['name']),
        backgroundColor: AppThemeColor.blue600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Handle download
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Document download started'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Handle share
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Document shared'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: document['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  document['icon'],
                  size: 80,
                  color: document['color'],
                ),
              ),
              SizedBox(height: 20),
              Text(
                document['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '${document['type']} • ${document['size']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Document Preview',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'In a real application, this would show the actual document content using a PDF viewer or image viewer widget.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}