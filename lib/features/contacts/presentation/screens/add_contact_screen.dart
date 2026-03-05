import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/presentation/providers/contact_provider.dart';
import 'package:mobile_wallet/features/contacts/presentation/widgets/contact_form_widgets.dart';

/// Add Contact Screen (Page 15 in design specs)
/// Manual contact entry form with all required fields
class AddContactScreen extends ConsumerStatefulWidget {
  const AddContactScreen({super.key});

  @override
  ConsumerState<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends ConsumerState<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form data
  String _fullName = '';
  String? _jobTitle;
  String? _companyName;
  List<String> _phoneNumbers = [];
  List<String> _emails = [];
  List<String> _addresses = [];
  List<String> _websiteUrls = [];
  String _category = ContactCategories.uncategorized;
  List<String> _tags = [];
  String? _notes;

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(contactsNotifierProvider.notifier)
          .createContact(
            fullName: _fullName,
            jobTitle: _jobTitle?.isNotEmpty == true ? _jobTitle : null,
            companyName: _companyName?.isNotEmpty == true ? _companyName : null,
            phoneNumbers: _phoneNumbers.where((p) => p.isNotEmpty).toList(),
            emails: _emails.where((e) => e.isNotEmpty).toList(),
            addresses: _addresses.where((a) => a.isNotEmpty).toList(),
            websiteUrls: _websiteUrls.where((w) => w.isNotEmpty).toList(),
            category: _category,
            tags: _tags,
            notes: _notes?.isNotEmpty == true ? _notes : null,
            source: ContactSources.manual,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact saved successfully'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save contact: $e'),
            backgroundColor: AppColors.coralAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Add Contact',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.darkGray),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveContact,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryGreen,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              const FormSectionHeader(
                title: 'Basic Information',
                icon: Icons.person_outline,
              ),

              // Full Name (required)
              LabeledTextField(
                label: 'Full Name',
                value: _fullName,
                onChanged: (value) => setState(() => _fullName = value),
                hintText: 'Enter full name',
                prefixIcon: Icons.person_outline,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Job Title
              LabeledTextField(
                label: 'Job Title',
                value: _jobTitle,
                onChanged: (value) => setState(() => _jobTitle = value),
                hintText: 'Enter job title',
                prefixIcon: Icons.work_outline,
              ),
              const SizedBox(height: 16),

              // Company Name
              LabeledTextField(
                label: 'Company',
                value: _companyName,
                onChanged: (value) => setState(() => _companyName = value),
                hintText: 'Enter company name',
                prefixIcon: Icons.business_outlined,
              ),

              const SizedBox(height: 24),

              // Contact Information Section
              const FormSectionHeader(
                title: 'Contact Information',
                icon: Icons.phone_outlined,
              ),

              // Phone Numbers
              MultiValueField(
                label: 'Phone Numbers',
                values: _phoneNumbers,
                onChanged: (values) => setState(() => _phoneNumbers = values),
                hintText: '+880 1XXX XXXXXX',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),

              // Emails
              MultiValueField(
                label: 'Email Addresses',
                values: _emails,
                onChanged: (values) => setState(() => _emails = values),
                hintText: 'email@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Invalid email format';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Addresses
              MultiValueField(
                label: 'Addresses',
                values: _addresses,
                onChanged: (values) => setState(() => _addresses = values),
                hintText: 'Enter address',
                keyboardType: TextInputType.streetAddress,
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),

              // Website URLs
              MultiValueField(
                label: 'Websites',
                values: _websiteUrls,
                onChanged: (values) => setState(() => _websiteUrls = values),
                hintText: 'https://example.com',
                keyboardType: TextInputType.url,
                prefixIcon: Icons.language_outlined,
              ),

              const SizedBox(height: 24),

              // Organization Section
              const FormSectionHeader(
                title: 'Organization',
                icon: Icons.folder_outlined,
              ),

              // Category
              CategoryDropdown(
                value: _category,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Tags
              TagsInput(
                tags: _tags,
                onChanged: (tags) => setState(() => _tags = tags),
              ),

              const SizedBox(height: 24),

              // Notes Section
              const FormSectionHeader(
                title: 'Notes',
                icon: Icons.note_outlined,
              ),

              // Notes
              LabeledTextField(
                label: 'Notes',
                value: _notes,
                onChanged: (value) => setState(() => _notes = value),
                hintText: 'Add any additional notes...',
                maxLines: 4,
                prefixIcon: Icons.note_outlined,
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
