import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';

class TermsAndConditions {
  static final List<Map<String, String>> _termsList = [
    {
      'title': '1. Admission Policy',
      'content': 'Admission to the school is subject to availability of seats and fulfillment of eligibility criteria. The school reserves the right to accept or reject any application without assigning reasons.',
    },
    {
      'title': '2. Document Verification',
      'content': 'All submitted documents must be original and verified. Any false information or forged documents will lead to immediate cancellation of admission.',
    },
    {
      'title': '3. Fee Structure',
      'content': 'Fees once paid are non-refundable except in cases explicitly mentioned in the fee refund policy. Fee structure is subject to annual revision as per school policy.',
    },
    {
      'title': '4. Academic Standards',
      'content': 'Students are expected to maintain the academic and behavioral standards set by the school. Failure to meet these standards may result in disciplinary action.',
    },
    {
      'title': '5. Health & Safety',
      'content': 'Parents must inform the school about any medical conditions, allergies, or special needs of their child. The school will take necessary precautions but parents are primarily responsible for their child\'s health.',
    },
    {
      'title': '6. Code of Conduct',
      'content': 'All students and parents must adhere to the school\'s code of conduct. Any violation may result in suspension or expulsion from the school.',
    },
    {
      'title': '7. Communication',
      'content': 'The school will communicate important information through official channels. Parents are responsible for regularly checking school communications.',
    },
    {
      'title': '8. Withdrawal Policy',
      'content': 'Parents must provide at least 30 days written notice for withdrawal. Transfer certificates will be issued only after clearing all dues.',
    },
    {
      'title': '9. Liability',
      'content': 'The school shall not be liable for any loss, damage, or injury to students except in cases of proven negligence by the school staff.',
    },
    {
      'title': '10. Amendments',
      'content': 'The school reserves the right to modify these terms and conditions at any time. Updated terms will be communicated to all stakeholders.',
    },
  ];

  static void show(BuildContext context, {VoidCallback? onAccept}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeColor.cardBorderRadius),
          ),
          title: Row(
            children: [
              Icon(Icons.article, color: AppThemeColor.blue600, size: 24),
              SizedBox(width: 8),
              Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColor.blue600,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._getTermsSections(),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      'By accepting these terms, you acknowledge that you have read, understood, and agree to be bound by all the above conditions.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: AppThemeColor.blue600, fontSize: 16),
              ),
            ),
            if (onAccept != null)
              ElevatedButton(
                onPressed: () {
                  onAccept();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColor.blue600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeColor.buttonBorderRadius),
                  ),
                ),
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
          ],
        );
      },
    );
  }

  static List<Map<String, String>> getTermsList() => _termsList;

  static List<Widget> _getTermsSections() {
    return _termsList
        .map((term) => _buildTermSection(
      title: term['title']!,
      content: term['content']!,
    ))
        .toList();
  }

  static Widget _buildTermSection({required String title, required String content}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppThemeColor.blue600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
