import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/contacts/data/repositories/contact_repository_impl.dart';

class FileImportScreen extends ConsumerStatefulWidget {
  const FileImportScreen({super.key});

  @override
  ConsumerState<FileImportScreen> createState() => _FileImportScreenState();
}

class _FileImportScreenState extends ConsumerState<FileImportScreen> {
  bool _isLoading = false;
  List<Contact> _parsedContacts = [];
  String? _errorText;

  Future<void> _pickAndParseFile() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
      _parsedContacts = [];
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'vcf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final extension = result.files.single.extension?.toLowerCase();

        if (extension == 'csv') {
          await _parseCSV(file);
        } else if (extension == 'vcf') {
          await _parseVCF(file);
        } else {
          setState(() {
            _errorText = 'Unsupported file format.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorText = 'Error reading file: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _parseCSV(File file) async {
    final input = await file.readAsString();
    final fields = const CsvToListConverter().convert(input);

    if (fields.isEmpty || fields.length < 2) {
      setState(() => _errorText = 'CSV file is empty or invalid.');
      return;
    }

    final headers = fields.first
        .map((e) => e.toString().toLowerCase())
        .toList();

    // Find column indexes
    final nameIdx = headers.indexWhere((h) => h.contains('name'));
    final phoneIdx = headers.indexWhere((h) => h.contains('phone'));
    final emailIdx = headers.indexWhere((h) => h.contains('email'));

    if (nameIdx == -1 && phoneIdx == -1) {
      setState(
        () => _errorText = 'Could not find "Name" or "Phone" columns in CSV.',
      );
      return;
    }

    final List<Contact> contacts = [];

    for (int i = 1; i < fields.length; i++) {
      final row = fields[i];
      if (row.isEmpty) continue;

      String fullName = nameIdx != -1 && row.length > nameIdx
          ? row[nameIdx].toString()
          : 'Unknown';
      String phone = phoneIdx != -1 && row.length > phoneIdx
          ? row[phoneIdx].toString()
          : '';
      String email = emailIdx != -1 && row.length > emailIdx
          ? row[emailIdx].toString()
          : '';

      if (fullName.isEmpty && phone.isEmpty) continue;

      contacts.add(
        Contact(
          id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
          ownerId: 'placeholder', // Will be set by repository
          fullName: fullName,
          phoneNumbers: phone.isNotEmpty ? [phone] : [],
          emails: email.isNotEmpty ? [email] : [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    setState(() {
      _parsedContacts = contacts;
    });
  }

  Future<void> _parseVCF(File file) async {
    final lines = await file.readAsLines();
    final List<Contact> contacts = [];

    String? currentName;
    List<String> currentPhones = [];
    List<String> currentEmails = [];

    for (final line in lines) {
      if (line.startsWith('BEGIN:VCARD')) {
        currentName = null;
        currentPhones = [];
        currentEmails = [];
      } else if (line.startsWith('FN:')) {
        currentName = line.substring(3);
      } else if (line.startsWith('TEL')) {
        final parts = line.split(':');
        if (parts.length > 1) {
          currentPhones.add(parts[1]);
        }
      } else if (line.startsWith('EMAIL')) {
        final parts = line.split(':');
        if (parts.length > 1) {
          currentEmails.add(parts[1]);
        }
      } else if (line.startsWith('END:VCARD')) {
        if (currentName != null || currentPhones.isNotEmpty) {
          contacts.add(
            Contact(
              id:
                  DateTime.now().millisecondsSinceEpoch.toString() +
                  contacts.length.toString(),
              ownerId: 'placeholder',
              fullName: currentName ?? 'Unknown',
              phoneNumbers: currentPhones,
              emails: currentEmails,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
      }
    }

    if (contacts.isEmpty) {
      setState(() => _errorText = 'No valid contacts found in vCard.');
      return;
    }

    setState(() {
      _parsedContacts = contacts;
    });
  }

  Future<void> _importContacts() async {
    if (_parsedContacts.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(contactRepositoryProvider);
      // In a real app we would assign the proper ownerId, but the repository handles it inside `createContacts` using `currentUser.id`.
      await repository.createContacts(_parsedContacts);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully imported ${_parsedContacts.length} contacts!',
            ),
          ),
        );
        context.pop(); // Go back
      }
    } catch (e) {
      setState(() => _errorText = 'Failed to save contacts: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import from File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select a .csv or .vcf file to import contacts.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickAndParseFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Choose File'),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 16),
              Text(_errorText!, style: const TextStyle(color: AppColors.error)),
            ],
            if (_isLoading) ...[
              const SizedBox(height: 32),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_parsedContacts.isNotEmpty && !_isLoading) ...[
              const SizedBox(height: 24),
              Text(
                'Found ${_parsedContacts.length} contacts ready to import:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _parsedContacts.length,
                  itemBuilder: (context, index) {
                    final contact = _parsedContacts[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primaryGreen,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(contact.fullName),
                      subtitle: Text(
                        contact.phoneNumbers.isNotEmpty
                            ? contact.phoneNumbers.first
                            : 'No Phone',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _importContacts,
                child: Text('Import All ${_parsedContacts.length} Contacts'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
