import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/model/admission/admissionDocumentTileModel.dart';

class DocumentTile extends StatelessWidget {
  final DocumentConfig config;
  final bool isRequired;
  final bool isUploaded;
  final bool isUploading;
  final PlatformFile? selectedFile;
  final Function() onTap;
  final Function() onRemove;

  const DocumentTile({
    super.key,
    required this.config,
    required this.isRequired,
    required this.isUploaded,
    required this.selectedFile,
    required this.onTap,
    required this.onRemove,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      elevation: AppThemeResponsiveness.isMobile(context) ? 2 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
              vertical: AppThemeResponsiveness.getMediumSpacing(context),
            ),
            leading: Container(
              padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
              decoration: BoxDecoration(
                color: isUploaded
                    ? Colors.green[100]
                    : (isRequired ? Colors.red[100] : Colors.grey[100]),
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getSmallSpacing(context)),
              ),
              child: Icon(
                config.icon,
                size: AppThemeResponsiveness.getIconSize(context),
                color: isUploaded
                    ? Colors.green[600]
                    : (isRequired ? Colors.red[600] : Colors.grey[600]),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    config.title,
                    style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                if (isRequired)
                  Container(
                    padding: AppThemeResponsiveness.getStatusBadgePadding(context),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    child: Text(
                      'Required',
                      style: TextStyle(
                        fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  child: Text(
                    config.subtitle,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context),
                  ),
                ),
                if (selectedFile != null)
                  Padding(
                    padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    child: Text(
                      'Selected: ${selectedFile!.name}',
                      style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedFile != null && !isUploading)
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red[600],
                      size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                    ),
                    onPressed: onRemove,
                  ),
                Icon(
                  isUploaded
                      ? Icons.check_circle
                      : (isUploading && selectedFile != null)
                      ? Icons.hourglass_empty
                      : Icons.upload_file,
                  size: AppThemeResponsiveness.getIconSize(context),
                  color: isUploaded ? Colors.green[600] : Colors.grey[600],
                ),
              ],
            ),
            onTap: isUploading ? null : onTap,
          ),
          if (selectedFile != null) _buildFileDetails(context, selectedFile!),
        ],
      ),
    );
  }

  Widget _buildFileDetails(BuildContext context, PlatformFile file) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
        vertical: AppThemeResponsiveness.getSmallSpacing(context),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          bottomRight: Radius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(file.extension ?? ''),
            size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            color: Colors.grey[600],
          ),
          SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_formatFileSize(file.size)} • ${file.extension?.toUpperCase()}',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontSize: AppThemeResponsiveness.getCaptionTextStyle(context).fontSize! * 0.9,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.description;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
