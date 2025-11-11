import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../features/profile/data/profile_repository.dart';
import '../l10n/app_localizations.dart';

/// Profile screen displaying and editing user information
/// Features: View profile, edit name/email, upload avatar image
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ProfileRepository _profileRepo = ProfileRepository();
  
  bool _isLoading = true;
  bool _isSaving = false;
  UserProfile? _profile;
  File? _selectedImage;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Load user profile from API
  Future<void> _loadProfile() async {
    try {
      final profile = await _profileRepo.getProfile();
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _avatarUrl = profile.avatar;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  /// Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  /// Show image source selection dialog
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_avatarUrl != null || _selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _selectedImage = null;
                    _avatarUrl = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Convert image file to base64 string
  Future<String?> _imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      return null;
    }
  }

  /// Save profile changes
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Convert selected image to base64 if exists
      String? avatarBase64;
      if (_selectedImage != null) {
        avatarBase64 = await _imageToBase64(_selectedImage!);
      } else if (_avatarUrl == null && _profile?.avatar != null) {
        // If avatar was removed, send empty string
        avatarBase64 = '';
      }

      // Update profile
      final updatedProfile = await _profileRepo.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        avatar: avatarBase64,
      );

      setState(() {
        _profile = updatedProfile;
        _avatarUrl = updatedProfile.avatar;
        _selectedImage = null; // Clear selected image after save
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Tooltip(
              message: 'Save Profile',
              child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveProfile,
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ========== Avatar Section ==========
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_avatarUrl != null && _avatarUrl!.startsWith('data:'))
                                ? MemoryImage(
                                    base64Decode(_avatarUrl!.split(',')[1]),
                                  ) as ImageProvider
                                : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                                    ? NetworkImage(_avatarUrl!)
                                    : null,
                        child: (_selectedImage == null &&
                                (_avatarUrl == null || _avatarUrl!.isEmpty))
                            ? Text(
                                _profile?.name.isNotEmpty == true
                                    ? _profile!.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(fontSize: 48),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Tooltip(
                          message: 'Change Photo',
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.camera_alt, size: 20),
                              color: Colors.white,
                              onPressed: _showImageSourceDialog,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _profile?.name ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _profile?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ========== Profile Information Section ==========
            Text(
              'Profile Information',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? l10n.required : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.required;
                if (!v.contains('@')) return l10n.invalidEmail;
                return null;
              },
            ),
            const SizedBox(height: 24),
            // ========== Account Information Section ==========
            if (_profile != null) ...[
              Text(
                'Account Information',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Member since',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (_profile!.createdAt != null)
                        Text(
                          _formatDate(_profile!.createdAt!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Format ISO date string to readable format
  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoString;
    }
  }
}

