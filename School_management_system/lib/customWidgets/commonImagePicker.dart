import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerWidget extends StatefulWidget {
  final double size;
  final Function(File?)? onImageChanged;
  final Function(Uint8List?)? onImageBytesChanged; // For web support

  const PhotoPickerWidget({
    super.key,
    this.size = 150,
    this.onImageChanged,
    this.onImageBytesChanged,
  });

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  File? _selectedImage;
  Uint8List? _selectedImageBytes; // For web support
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // Web platform - use bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null;
          });
          widget.onImageBytesChanged?.call(_selectedImageBytes);
        } else {
          // Mobile platform - use File
          setState(() {
            _selectedImage = File(pickedFile.path);
            _selectedImageBytes = null;
          });
          widget.onImageChanged?.call(_selectedImage);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
    widget.onImageChanged?.call(null);
    widget.onImageBytesChanged?.call(null);
  }

  Widget _buildImageWidget() {
    if (kIsWeb && _selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && _selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline_rounded,
                size: 50, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('No Photo',
                style: TextStyle(
                    color: Colors.grey[500], fontSize: 14)),
          ],
        ),
      );
    }
  }

  bool get _hasImage {
    return (kIsWeb && _selectedImageBytes != null) ||
        (!kIsWeb && _selectedImage != null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Display
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImageWidget(),
            ),
          ),
          const SizedBox(height: 16),

          // Camera & Gallery Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Only show camera button on mobile
              if (!kIsWeb) ...[
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded, size: 18),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_rounded, size: 18),
                label: Text(kIsWeb ? 'Choose File' : 'Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          // Remove Photo
          if (_hasImage) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _removeImage,
              icon: Icon(Icons.delete_outline_rounded,
                  size: 18, color: Colors.red[600]),
              label: Text('Remove Photo',
                  style: TextStyle(color: Colors.red[600])),
            ),
          ],
        ],
      ),
    );
  }
}