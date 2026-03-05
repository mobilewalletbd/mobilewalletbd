import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_wallet/core/services/cloudinary_service.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/settings/presentation/providers/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _bioController;

  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileNotifierProvider).valueOrNull;
    _nameController = TextEditingController(text: profile?.fullName);
    _jobTitleController = TextEditingController(text: profile?.jobTitle);
    _companyController = TextEditingController(text: profile?.companyName);
    _bioController = TextEditingController(text: profile?.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String? avatarUrl;
      if (_selectedImage != null) {
        // Upload image first
        final cloudinary = ref.read(cloudinaryServiceProvider);
        final userId = ref.read(userProfileNotifierProvider).valueOrNull?.uid;

        if (userId != null) {
          final result = await cloudinary.uploadProfilePhoto(
            filePath: _selectedImage!.path,
            userId: userId,
          );
          if (result.success) {
            avatarUrl = result.secureUrl;
          }
        }
      }

      await ref
          .read(userProfileNotifierProvider.notifier)
          .updateProfile(
            fullName: _nameController.text.trim(),
            jobTitle: _jobTitleController.text.trim(),
            companyName: _companyController.text.trim(),
            bio: _bioController.text.trim(),
            avatarUrl: avatarUrl,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileNotifierProvider).valueOrNull;
    final isLoading = ref.watch(isProfileLoadingProvider) || _isUploading;

    ImageProvider? imageProvider;
    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(profile.avatarUrl!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _saveProfile,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryGreen.withValues(
                        alpha: 0.1,
                      ),
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primaryGreen,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
