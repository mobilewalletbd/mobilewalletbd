import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_wallet/features/collaboration/presentation/providers/team_provider.dart';
import 'package:uuid/uuid.dart';

/// Available team categories (matches design plan Section 5F)
const List<String> kTeamCategories = [
  'Sales & Marketing',
  'Engineering',
  'Design',
  'Finance',
  'Operations',
  'HR & Recruitment',
  'Customer Support',
  'Leadership',
  'Other',
];

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategory;
  String? _photoUrl;
  File? _pickedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    setState(() {
      _pickedImage = File(picked.path);
      _isUploading = true;
    });

    try {
      final uniqueId = const Uuid().v4();
      final ref = FirebaseStorage.instance.ref('team_logos/$uniqueId.jpg');
      await ref.putFile(_pickedImage!);
      final url = await ref.getDownloadURL();
      setState(() {
        _photoUrl = url;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(teamNotifierProvider.notifier)
        .createTeam(
          _nameController.text.trim(),
          _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          _photoUrl,
          category: _selectedCategory,
          visibility: 'private',
        );

    if (!mounted) return;
    final state = ref.read(teamNotifierProvider);
    state.when(
      data: (_) {
        context.pop();
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team created successfully 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create team: $error')),
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamNotifierProvider);
    final isLoading = state is AsyncLoading || _isUploading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Create Team'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Logo Upload Area ---
              GestureDetector(
                onTap: _isUploading ? null : _pickAndUploadImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        color: Colors.green.shade50,
                      ),
                      child: _pickedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _pickedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : _photoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                _photoUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.green.shade400,
                                  size: 32,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Upload Logo',
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    // Upload overlay spinner
                    if (_isUploading)
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    // Edit badge
                    if (!_isUploading)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --- Team Name ---
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Team Name *',
                  hintText: 'e.g. Sales Team Alpha',
                  prefixIcon: const Icon(Icons.group),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Team name is required'
                    : null,
              ),

              const SizedBox(height: 16),

              // --- Description ---
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'What is this team about?',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.notes),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- Category Dropdown ---
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category (Optional)',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: const Text('Select a category'),
                items: kTeamCategories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),

              const SizedBox(height: 32),

              // --- Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Team',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
