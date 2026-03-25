import 'package:flutter/material.dart';

class EditableField {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String value;
  final int maxLines;

  EditableField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.value,
    this.maxLines = 1,
  });
}

class ReadOnlyField {
  final IconData icon;
  final String label;
  final String value;

  ReadOnlyField({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final bool isEditing;
  final VoidCallback onToggleEditMode;
  final VoidCallback onSaveChanges;
  final List<EditableField> editableFields;
  final List<ReadOnlyField> readOnlyFields;
  final Widget? subjectsSection;
  final Widget? classesSection;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.isEditing,
    required this.onToggleEditMode,
    required this.onSaveChanges,
    this.editableFields = const [],
    this.readOnlyFields = const [],
    this.subjectsSection,
    this.classesSection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              ...editableFields.map((field) => _buildEditableInfoRow(context, field)),
              ...readOnlyFields.map((field) => _buildInfoRow(context, field)),
              if (subjectsSection != null) ...[
                const SizedBox(height: 16),
                subjectsSection!,
              ],
              if (classesSection != null) ...[
                const SizedBox(height: 16),
                classesSection!,
              ],
              if (isEditing) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onToggleEditMode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSaveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        if (!isEditing)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onToggleEditMode,
            tooltip: 'Edit Profile',
          ),
      ],
    );
  }

  Widget _buildEditableInfoRow(BuildContext context, EditableField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(field.icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? TextField(
                  controller: field.controller,
                  maxLines: field.maxLines,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                )
                    : Text(
                  field.value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, ReadOnlyField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(field.icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                Text(
                  field.value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
