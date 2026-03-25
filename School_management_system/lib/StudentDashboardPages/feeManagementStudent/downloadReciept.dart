import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:school/model/dashboard/studentDashboardModel/feeManagementStudentDashboard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';

/// Configuration class for PDF receipt generation
class ReceiptConfig {
  final String schoolName;
  final String contactEmail;
  final String contactPhone;
  final String footerMessage;
  final Color primaryColor;
  final Color secondaryColor;

  const ReceiptConfig({
    this.schoolName = 'Royal Public School',
    this.contactEmail = 'admin@royalpublicschool.com',
    this.contactPhone = '+91-XXXXXXXXXX',
    this.footerMessage = 'Thank you for your payment!',
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.green,
  });
}

/// Student information for the receipt
class StudentInfo {
  final String name;
  final String className;
  final String rollNumber;
  final String? admissionNumber;
  final String? section;

  const StudentInfo({
    required this.name,
    required this.className,
    required this.rollNumber,
    this.admissionNumber,
    this.section,
  });
}

/// Main service class for handling PDF receipt generation and download
class ReceiptPDFService {
  final ReceiptConfig config;

  ReceiptPDFService({this.config = const ReceiptConfig()});

  /// Download receipt with loading state management
  Future<void> downloadReceipt({
    required BuildContext context,
    required FeeRecord record,
    required StudentInfo studentInfo,
    required VoidCallback onLoadingStart,
    required VoidCallback onLoadingEnd,
    required Function(String) onError,
  }) async {
    try {
      onLoadingStart();

      // Show loading snackbar
      _showLoadingSnackbar(context);

      // Generate PDF
      final pdf = await _generatePDF(record, studentInfo);
      final Uint8List pdfBytes = await pdf.save();

      // Save PDF based on platform
      File? file;
      if (Platform.isAndroid || Platform.isIOS) {
        file = await _savePDFToMobile(pdfBytes, record);
      } else {
        // For desktop platforms, let user choose location
        file = await _savePDFToDesktop(context, pdfBytes, record);
      }

      onLoadingEnd();

      if (file != null) {
        // Show success dialog
        _showDownloadSuccessDialog(context, file, record);
      }

    } catch (e) {
      onLoadingEnd();
      onError('Failed to download receipt: ${e.toString()}');
    }
  }

  /// Generate PDF without UI interactions (for background processing)
  Future<Uint8List> generatePDFBytes({
    required FeeRecord record,
    required StudentInfo studentInfo,
  }) async {
    final pdf = await _generatePDF(record, studentInfo);
    return await pdf.save();
  }

  /// Save PDF to device and return file (mobile platforms)
  Future<File> savePDFToDevice({
    required Uint8List pdfBytes,
    required FeeRecord record,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await _savePDFToMobile(pdfBytes, record);
    } else {
      throw UnsupportedError('Use savePDFToDesktop for desktop platforms');
    }
  }

  /// Show loading snackbar
  void _showLoadingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Generating receipt...',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: config.primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Get appropriate directory for mobile platforms
  Future<Directory> _getMobileDirectory() async {
    if (Platform.isAndroid) {
      try {
        // For Android, try to get external storage directory
        Directory? externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Create Downloads subfolder
          final downloadsDir = Directory('${externalDir.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          return downloadsDir;
        }
      } catch (e) {
        print('Error accessing external storage: $e');
      }
    }

    // Fallback to application documents directory
    return await getApplicationDocumentsDirectory();
  }

  /// Save PDF to mobile device
  Future<File> _savePDFToMobile(Uint8List pdfBytes, FeeRecord record) async {
    final directory = await _getMobileDirectory();

    // Create filename with timestamp
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'fee_receipt_${record.receiptNumber}_$timestamp.pdf';
    final String filePath = '${directory.path}/$fileName';

    // Write PDF to file
    final File file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    return file;
  }

  /// Save PDF to desktop (let user choose location)
  Future<File?> _savePDFToDesktop(BuildContext context, Uint8List pdfBytes, FeeRecord record) async {
    try {
      // Generate default filename
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String defaultFileName = 'fee_receipt_${record.receiptNumber}_$timestamp.pdf';

      // Let user choose save location
      String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Receipt PDF',
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (selectedPath != null) {
        // Ensure the file has .pdf extension
        if (!selectedPath.toLowerCase().endsWith('.pdf')) {
          selectedPath += '.pdf';
        }

        final File file = File(selectedPath);
        await file.writeAsBytes(pdfBytes);
        return file;
      }
    } catch (e) {
      print('Error saving PDF to desktop: $e');
      // Fallback to application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'fee_receipt_${record.receiptNumber}_$timestamp.pdf';
      final String filePath = '${directory.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      return file;
    }

    return null;
  }

  /// Generate PDF document
  Future<pw.Document> _generatePDF(FeeRecord record, StudentInfo studentInfo) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              pw.SizedBox(height: 30),

              // Receipt Details Container
              _buildReceiptDetailsContainer(record, studentInfo),
              pw.SizedBox(height: 30),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Build PDF header
  pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _getPdfColor(config.primaryColor.withOpacity(0.1)),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            config.schoolName,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: _getPdfColor(config.primaryColor),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Fee Payment Receipt',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build receipt details container
  pw.Widget _buildReceiptDetailsContainer(FeeRecord record, StudentInfo studentInfo) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Receipt Number and Date
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Receipt No: ${record.receiptNumber}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Date: ${_formatDate(record.paidDate ?? DateTime.now())}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Student Details
          _buildSection('Student Details:', [
            _buildDetailRow('Student Name', studentInfo.name),
            _buildDetailRow('Class', studentInfo.className),
            _buildDetailRow('Roll Number', studentInfo.rollNumber),
            if (studentInfo.admissionNumber != null)
              _buildDetailRow('Admission Number', studentInfo.admissionNumber!),
            if (studentInfo.section != null)
              _buildDetailRow('Section', studentInfo.section!),
          ]),

          pw.SizedBox(height: 20),

          // Payment Details
          _buildSection('Payment Details:', [
            _buildDetailRow('Description', record.description),
            _buildDetailRow('Academic Year', record.academicYear),
            _buildDetailRow('Term', record.term),
            _buildDetailRow('Due Date', _formatDate(record.dueDate)),
            _buildDetailRow('Payment Date',
                record.paidDate != null ? _formatDate(record.paidDate!) : 'N/A'),
          ]),

          pw.SizedBox(height: 20),

          // Amount Section
          _buildAmountSection(record.amount),
        ],
      ),
    );
  }

  /// Build a section with title and details
  pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...children,
      ],
    );
  }

  /// Build detail row
  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Build amount section
  pw.Widget _buildAmountSection(double amount) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: _getPdfColor(config.secondaryColor.withOpacity(0.1)),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Amount Paid:',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            '₹${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: _getPdfColor(config.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Build footer
  pw.Widget _buildFooter() {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            config.footerMessage,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _getPdfColor(config.primaryColor),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'This is a computer-generated receipt. No signature required.',
            style: pw.TextStyle(
              fontSize: 10,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'For queries, contact: ${config.contactEmail} | Phone: ${config.contactPhone}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  /// Show success dialog
  void _showDownloadSuccessDialog(BuildContext context, File file, FeeRecord record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: config.secondaryColor, size: 30),
              SizedBox(width: 10),
              Text(
                'Download Complete',
                style: TextStyle(color: config.secondaryColor),
              ),
            ],
          ),
          content: Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Receipt has been saved successfully!'),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: config.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.folder, color: config.primaryColor),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'File Location:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              file.path,
                              style: TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
            if (Platform.isAndroid || Platform.isIOS)
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Share.shareXFiles([XFile(file.path)], text: 'Fee Receipt');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.secondaryColor,
                ),
                child: Text('Share', style: TextStyle(color: Colors.white)),
              ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final result = await OpenFile.open(file.path);
                if (result.type != ResultType.done) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not open file: ${result.message}'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: config.primaryColor,
              ),
              child: Text('Open', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Convert Flutter Color to PDF Color
  PdfColor _getPdfColor(Color color) {
    return PdfColor(
      color.red / 255,
      color.green / 255,
      color.blue / 255,
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    return date.toString().substring(0, 10);
  }
}