import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:school/customWidgets/admissionCustomWidgets/admissionProcessIndicator.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/customWidgets/admissionCustomWidgets/admissionCustomInput.dart';

class AdmissionDocumentsScreen extends StatefulWidget {
  final int applicationId;

  AdmissionDocumentsScreen({required this.applicationId});

  @override
  _AdmissionDocumentsScreenState createState() =>
      _AdmissionDocumentsScreenState();
}

class _AdmissionDocumentsScreenState extends State<AdmissionDocumentsScreen> {
  // ===== DOCUMENT CONFIGURATION =====
  final List<DocumentConfig> _requiredDocuments = [
    DocumentConfig(
      key: 'photo',
      title: 'Passport Size Photo',
      subtitle: 'Recent photograph of the student',
      icon: Icons.photo_camera,
      allowedTypes: ['jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'signature',
      title: 'Signature',
      subtitle: 'Present signature of the student.',
      icon: Icons.pending_actions,
      allowedTypes: ['jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'birth_certificate',
      title: 'Birth Certificate',
      subtitle: 'Official birth certificate',
      icon: Icons.article,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'aadhaar_card',
      title: 'ID Proof (Aadhar etc.)',
      subtitle: 'Government issued ID proof',
      icon: Icons.badge,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
  ];

  final List<DocumentConfig> _optionalDocuments = [
    DocumentConfig(
      key: 'transfer_certificate',
      title: 'Transfer Certificate',
      subtitle: 'From previous school (if applicable)',
      icon: Icons.school,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'previous_report',
      title: 'Previous Report Card',
      subtitle: 'Last academic year report',
      icon: Icons.assessment,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'caste_certificate',
      title: 'Caste Certificate',
      subtitle: 'If applicable for reservations',
      icon: Icons.description,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'medical_certificate',
      title: 'Medical Certificate',
      subtitle: 'Health certificate from doctor',
      icon: Icons.medical_services,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
  ];

  // ===== STATE MAPS =====
  Map<String, bool> documentStatus = {};
  Map<String, PlatformFile?> selectedFiles = {};
  Map<String, bool> uploadingStatus = {};

  bool _acceptedTerms = false;
  bool _isGlobalUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeDocumentMaps();
  }

  void _initializeDocumentMaps() {
    final allDocuments = [..._requiredDocuments, ..._optionalDocuments];
    for (final doc in allDocuments) {
      documentStatus[doc.key] = false;
      selectedFiles[doc.key] = null;
      uploadingStatus[doc.key] = false;
    }
  }

  // ===== PICK DOCUMENT =====
  Future<void> _pickDocument(String key, List<String> allowedTypes) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedTypes,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFiles[key] = result.files.first;
          documentStatus[key] = true;
        });
        AppSnackBar.show(
          context,
          message: 'Document selected!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error picking document: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  // ===== UPLOAD DOCUMENTS =====
  Future<void> _uploadDocuments() async {
    var url = Uri.parse(
      "http://your-backend-url.com/api/admission/documents/${widget.applicationId}/",
    );

    var request = http.MultipartRequest("POST", url);

    // Add headers if required
    request.headers.addAll({
      "Accept": "application/json",
      // "Authorization": "Bearer YOUR_TOKEN",
    });

    // Add required documents
    for (var doc in _requiredDocuments) {
      if (selectedFiles[doc.key] != null) {
        request.files.add(await _convertToMultipart(doc.key));
      }
    }

    // Add optional documents
    for (var doc in _optionalDocuments) {
      if (selectedFiles[doc.key] != null) {
        request.files.add(await _convertToMultipart(doc.key));
      }
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("📤 Response from backend: $respStr");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Upload failed: $respStr");
    }
  }

  Future<http.MultipartFile> _convertToMultipart(String key) async {
    final file = selectedFiles[key]!;
    return http.MultipartFile.fromPath(key, file.path!, filename: file.name);
  }

  // ===== SUBMIT BUTTON =====
  void _submitApplication() async {
    bool allRequiredUploaded = _requiredDocuments.every(
      (doc) => documentStatus[doc.key] == true,
    );

    if (!allRequiredUploaded) {
      AppSnackBar.show(
        context,
        message: "Please upload all required documents",
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
      return;
    }

    if (!_acceptedTerms) {
      AppSnackBar.show(
        context,
        message: "Please accept Terms & Conditions",
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
      return;
    }

    setState(() => _isGlobalUploading = true);

    try {
      await _uploadDocuments();
      AppSnackBar.show(
        context,
        message: "Documents submitted successfully!",
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      // Navigate to success screen
      Navigator.pushNamed(context, '/admission-success');
    } catch (e) {
      AppSnackBar.show(
        context,
        message: "Failed to submit: $e",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() => _isGlobalUploading = false);
    }
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppThemeResponsiveness.getMaxWidth(context),
              ),
              child: SingleChildScrollView(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Column(
                  children: [
                    ProgressIndicatorBar(currentStep: 4, totalSteps: 4),
                    SizedBox(height: 20),
                    Text(
                      'Document Upload',
                      style: AppThemeResponsiveness.getFontStyle(context),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Upload all necessary documents for admission',
                      style: AppThemeResponsiveness.getSplashSubtitleStyle(
                        context,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Required Documents
                    _buildDocumentSection(
                      'Required Documents',
                      _requiredDocuments,
                      true,
                    ),
                    SizedBox(height: 20),

                    // Optional Documents
                    _buildDocumentSection(
                      'Optional Documents',
                      _optionalDocuments,
                      false,
                    ),
                    SizedBox(height: 20),

                    // Terms & Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (v) => setState(() => _acceptedTerms = v!),
                        ),
                        Flexible(child: Text("I accept Terms & Conditions")),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Submit Button
                    PrimaryButton(
                      title: "Submit Application",
                      onPressed:
                          !_isGlobalUploading ? _submitApplication : null,
                      isLoading: _isGlobalUploading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentSection(
    String title,
    List<DocumentConfig> docs,
    bool required,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...docs.map(
          (doc) => DocumentTile(
            config: doc,
            isRequired: required,
            isUploaded: documentStatus[doc.key] ?? false,
            selectedFile: selectedFiles[doc.key],
            isUploading: false,
            onTap: () => _pickDocument(doc.key, doc.allowedTypes),
            onRemove: () {
              setState(() {
                selectedFiles[doc.key] = null;
                documentStatus[doc.key] = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
