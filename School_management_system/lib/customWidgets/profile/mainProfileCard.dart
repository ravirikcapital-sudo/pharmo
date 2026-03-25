import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String designation;
  final String department;
  final String? profileImageUrl;
  final PlatformFile? profileImageFile;
  final bool isEditing;
  final TextEditingController? nameController;
  final Function(PlatformFile?)? onImageSelected;

  const ProfileCard({
    super.key,
    required this.name,
    required this.designation,
    required this.department,
    this.profileImageUrl,
    this.profileImageFile,
    this.isEditing = false,
    this.nameController,
    this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      context,
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () => _selectFromGallery(context),
                    ),
                    _buildImageSourceOption(
                      context,
                      icon: Icons.photo_camera,
                      label: 'Camera',
                      onTap: () => _selectFromCamera(context),
                    ),
                    _buildImageSourceOption(
                      context,
                      icon: Icons.folder,
                      label: 'Files',
                      onTap: () => _selectFromFiles(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (profileImageFile != null || (profileImageUrl != null && profileImageUrl!.isNotEmpty))
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onImageSelected?.call(null);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'Remove Picture',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromGallery(BuildContext context) async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      final platformFile = PlatformFile(
        name: image.name,
        size: bytes.length,
        bytes: bytes,
        path: image.path,
      );
      onImageSelected?.call(platformFile);
    }
  }

  Future<void> _selectFromCamera(BuildContext context) async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      final platformFile = PlatformFile(
        name: image.name,
        size: bytes.length,
        bytes: bytes,
        path: image.path,
      );
      onImageSelected?.call(platformFile);
    }
  }

  Future<void> _selectFromFiles(BuildContext context) async {
    Navigator.pop(context);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        onImageSelected?.call(platformFile);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Widget _buildProfileImage() {
    if (profileImageFile != null) {
      if (profileImageFile!.bytes != null) {
        return CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          backgroundImage: MemoryImage(profileImageFile!.bytes!),
        );
      } else if (profileImageFile!.path != null) {
        return CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          backgroundImage: FileImage(File(profileImageFile!.path!)),
        );
      }
    }

    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue.shade100,
        backgroundImage: NetworkImage(profileImageUrl!),
      );
    }

    // Default avatar with initials
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.blue.shade100,
      child: Text(
        name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.blue.shade50],
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  _buildProfileImage(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _pickImage(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade600, Colors.blue.shade400],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              isEditing
                  ? TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
              )
                  : Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                designation,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                department,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
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