// File: lib/TeacherDashboardPages/salaryManagementTeacher/downloadSalarySlip.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:school/model/dashboard/teacherDashboardModel/salaryModelTeacher.dart';


class SalarySlipPDFService {
  final SalarySlipConfig config;

  SalarySlipPDFService({required this.config});

  Future<void> downloadSalarySlip({
    required BuildContext context,
    required SalaryRecord record,
    required TeacherInfo teacherInfo,
    required VoidCallback onLoadingStart,
    required VoidCallback onLoadingEnd,
    required Function(String) onError,
  }) async {
    try {
      onLoadingStart();

      final pdf = await _generateSalarySlipPDF(record, teacherInfo);

      // For mobile platforms, save to downloads
      if (Platform.isAndroid || Platform.isIOS) {
        await _saveToDownloads(pdf, record, teacherInfo);
      } else {
        // For web and desktop, show print dialog
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
          name: 'salary_slip_${record.month}_${record.year}_${teacherInfo.employeeId}.pdf',
        );
      }

      onLoadingEnd();
    } catch (e) {
      onLoadingEnd();
      onError('Failed to generate salary slip: ${e.toString()}');
    }
  }

  Future<pw.Document> _generateSalarySlipPDF(
      SalaryRecord record,
      TeacherInfo teacherInfo,
      ) async {
    final pdf = pw.Document();

    // Load font if needed
    pw.Font? font;
    try {
      final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
      font = pw.Font.ttf(fontData);
    } catch (e) {
      // Use default font if custom font fails
      font = null;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildEmployeeInfo(teacherInfo),
              pw.SizedBox(height: 20),
              _buildSalaryPeriod(record),
              pw.SizedBox(height: 20),
              _buildSalaryBreakdown(record),
              pw.SizedBox(height: 20),
              _buildSummary(record),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            config.schoolName,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            config.schoolAddress,
            style: pw.TextStyle(fontSize: 12),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Email: ${config.contactEmail} | Phone: ${config.contactPhone}',
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'SALARY SLIP',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEmployeeInfo(TeacherInfo teacherInfo) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'EMPLOYEE INFORMATION',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name:', teacherInfo.name),
                    _buildInfoRow('Employee ID:', teacherInfo.employeeId),
                    _buildInfoRow('Department:', teacherInfo.department),
                    _buildInfoRow('Designation:', teacherInfo.designation),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Join Date:', _formatDate(teacherInfo.joinDate)),
                    _buildInfoRow('Bank Account:', teacherInfo.bankAccount),
                    _buildInfoRow('PAN Number:', teacherInfo.panNumber),
                    if (teacherInfo.phoneNumber != null)
                      _buildInfoRow('Phone:', teacherInfo.phoneNumber!),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSalaryPeriod(SalaryRecord record) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SALARY PERIOD',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                '${record.month} ${record.year}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'WORKING DAYS',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                '${record.workingDays} / ${record.totalWorkingDays}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          if (record.paymentDate != null)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'PAYMENT DATE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  _formatDate(record.paymentDate!),
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
        ],
      ),
    );
  }

  pw.Widget _buildSalaryBreakdown(SalaryRecord record) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            padding: pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue800,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'EARNINGS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.Text(
                  'DEDUCTIONS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          pw.Container(
            padding: pw.EdgeInsets.all(15),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildAmountRow('Basic Salary', record.basicSalary),
                      _buildAmountRow('HRA', record.hra),
                      _buildAmountRow('DA', record.da),
                      _buildAmountRow('TA', record.ta),
                      _buildAmountRow('Medical Allowance', record.medicalAllowance),
                      if (record.overtime > 0)
                        _buildAmountRow('Overtime', record.overtime),
                      pw.Divider(thickness: 1),
                      _buildAmountRow('Gross Salary', record.calculateGrossSalary(), isTotal: true),
                    ],
                  ),
                ),
                pw.Container(
                  width: 1,
                  height: 200,
                  color: PdfColors.grey400,
                  margin: pw.EdgeInsets.symmetric(horizontal: 20),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildAmountRow('PF', record.pf),
                      _buildAmountRow('TDS', record.tds),
                      if (record.otherDeductions > 0)
                        _buildAmountRow('Other Deductions', record.otherDeductions),
                      pw.SizedBox(height: 100), // Spacer
                      pw.Divider(thickness: 1),
                      _buildAmountRow('Total Deductions', record.calculateTotalDeductions(), isTotal: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(SalaryRecord record) {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green, width: 2),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'NET SALARY',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
              pw.Text(
                '₹${record.calculateNetSalary().toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Amount in Words: ${_convertToWords(record.calculateNetSalary())}',
            style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'This is a computer-generated salary slip and does not require a signature.',
            style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Generated on: ${_formatDate(DateTime.now())}',
            style: pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 80,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
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

  pw.Widget _buildAmountRow(String label, double amount, {bool isTotal = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            '₹${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToDownloads(
      pw.Document pdf,
      SalaryRecord record,
      TeacherInfo teacherInfo,
      ) async {
    try {
      final output = await getDownloadsDirectory();
      if (output != null) {
        final file = File(
            '${output.path}/salary_slip_${record.month}_${record.year}_${teacherInfo.employeeId}.pdf'
        );
        await file.writeAsBytes(await pdf.save());
      }
    } catch (e) {
      // Fallback to external storage directory
      try {
        final output = await getExternalStorageDirectory();
        if (output != null) {
          final file = File(
              '${output.path}/salary_slip_${record.month}_${record.year}_${teacherInfo.employeeId}.pdf'
          );
          await file.writeAsBytes(await pdf.save());
        }
      } catch (e) {
        throw Exception('Failed to save salary slip: $e');
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _convertToWords(double amount) {
    // Simple implementation - you can enhance this
    final intAmount = amount.toInt();
    if (intAmount == 0) return 'Zero Rupees Only';

    final ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
      'Seventeen', 'Eighteen', 'Nineteen'
    ];

    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

    if (intAmount < 20) {
      return '${ones[intAmount]} Rupees Only';
    } else if (intAmount < 100) {
      return '${tens[intAmount ~/ 10]} ${ones[intAmount % 10]} Rupees Only'.trim();
    } else if (intAmount < 1000) {
      return '${ones[intAmount ~/ 100]} Hundred ${_convertToWords(intAmount % 100.toDouble()).replaceAll(' Rupees Only', '')} Rupees Only'.trim();
    } else {
      return '${_convertToWords((intAmount ~/ 1000).toDouble()).replaceAll(' Rupees Only', '')} Thousand ${_convertToWords((intAmount % 1000).toDouble()).replaceAll(' Rupees Only', '')} Rupees Only'.trim();
    }
  }
}