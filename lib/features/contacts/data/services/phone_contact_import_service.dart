// Phone Contact Import Service
// Reads contacts from device and maps to domain Contact entity
// Includes duplicate detection based on phone/email matching

import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// Result of fetching phone contacts
class ImportResult {
  /// Contacts that don't match any existing contact
  final List<Contact> newContacts;

  /// Contacts that match existing contacts (potential duplicates)
  final List<DuplicateMatch> duplicates;

  /// Total count of phone contacts read
  final int totalPhoneContacts;

  const ImportResult({
    required this.newContacts,
    required this.duplicates,
    required this.totalPhoneContacts,
  });

  /// All contacts including duplicates
  List<Contact> get allContacts => [
    ...newContacts,
    ...duplicates.map((d) => d.phoneContact),
  ];

  /// Total count of importable contacts
  int get importableCount => newContacts.length + duplicates.length;
}

/// Represents a match between phone contact and existing contact
class DuplicateMatch {
  /// The contact from the phone
  final Contact phoneContact;

  /// The existing contact it matches
  final Contact existingContact;

  /// Why they matched ('phone' or 'email')
  final String matchReason;

  const DuplicateMatch({
    required this.phoneContact,
    required this.existingContact,
    required this.matchReason,
  });
}

/// Service for importing contacts from device
class PhoneContactImportService {
  final Uuid _uuid = const Uuid();

  /// Fetches contacts from phone and compares with existing contacts
  ///
  /// [ownerId] - The ID of the user who will own the imported contacts
  /// [existingContacts] - Current contacts to check for duplicates
  Future<ImportResult> fetchPhoneContacts({
    required String ownerId,
    required List<Contact> existingContacts,
  }) async {
    // Request permission and get contacts
    if (!await fc.FlutterContacts.requestPermission(readonly: true)) {
      return const ImportResult(
        newContacts: [],
        duplicates: [],
        totalPhoneContacts: 0,
      );
    }

    // Fetch all contacts with full details
    final phoneContacts = await fc.FlutterContacts.getContacts(
      withPhoto: false,
      withThumbnail: false,
      withProperties: true,
    );

    final newContacts = <Contact>[];
    final duplicates = <DuplicateMatch>[];

    // Build lookup sets for faster duplicate detection
    final existingPhones = <String>{};
    final existingEmails = <String>{};
    final phoneToContact = <String, Contact>{};
    final emailToContact = <String, Contact>{};

    for (final contact in existingContacts) {
      for (final phone in contact.phoneNumbers) {
        final normalized = _normalizePhone(phone);
        existingPhones.add(normalized);
        phoneToContact[normalized] = contact;
      }
      for (final email in contact.emails) {
        final normalized = email.toLowerCase().trim();
        existingEmails.add(normalized);
        emailToContact[normalized] = contact;
      }
    }

    // Process each phone contact
    for (final phoneContact in phoneContacts) {
      // Skip contacts without name
      final displayName = phoneContact.displayName.trim();
      if (displayName.isEmpty) continue;

      // Convert to domain entity
      final contact = _mapPhoneContact(phoneContact, ownerId);

      // Check for duplicates
      final duplicateMatch = _findDuplicate(
        contact,
        existingPhones,
        existingEmails,
        phoneToContact,
        emailToContact,
      );

      if (duplicateMatch != null) {
        duplicates.add(duplicateMatch);
      } else {
        newContacts.add(contact);
      }
    }

    return ImportResult(
      newContacts: newContacts,
      duplicates: duplicates,
      totalPhoneContacts: phoneContacts.length,
    );
  }

  /// Maps a phone contact to domain Contact entity
  Contact _mapPhoneContact(fc.Contact phoneContact, String ownerId) {
    // Extract phone numbers
    final phoneNumbers = phoneContact.phones
        .map((p) => p.number.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    // Extract emails
    final emails = phoneContact.emails
        .map((e) => e.address.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Extract addresses
    final addresses = phoneContact.addresses
        .map((a) {
          final parts = <String>[];
          if (a.street.isNotEmpty) parts.add(a.street);
          if (a.city.isNotEmpty) parts.add(a.city);
          if (a.state.isNotEmpty) parts.add(a.state);
          if (a.postalCode.isNotEmpty) parts.add(a.postalCode);
          if (a.country.isNotEmpty) parts.add(a.country);
          return parts.join(', ');
        })
        .where((a) => a.isNotEmpty)
        .toList();

    // Extract websites
    final websites = phoneContact.websites
        .map((w) => w.url.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    // Extract organization info
    String? companyName;
    String? jobTitle;
    if (phoneContact.organizations.isNotEmpty) {
      final org = phoneContact.organizations.first;
      companyName = org.company.isNotEmpty ? org.company : null;
      jobTitle = org.title.isNotEmpty ? org.title : null;
    }

    // Extract notes
    String? notes;
    if (phoneContact.notes.isNotEmpty) {
      notes = phoneContact.notes.first.note;
    }

    // Safely extract names
    String? firstName;
    if (phoneContact.name.first.isNotEmpty) {
      firstName = phoneContact.name.first;
    }

    String? lastName;
    if (phoneContact.name.last.isNotEmpty) {
      lastName = phoneContact.name.last;
    }

    return Contact.create(
      id: _uuid.v4(),
      ownerId: ownerId,
      fullName: phoneContact.displayName.trim(),
      firstName: firstName?.trim().isNotEmpty == true
          ? firstName!.trim()
          : null,
      lastName: lastName?.trim().isNotEmpty == true ? lastName!.trim() : null,
      jobTitle: jobTitle,
      companyName: companyName,
      phoneNumbers: phoneNumbers,
      emails: emails,
      addresses: addresses,
      websiteUrls: websites,
      notes: notes,
      source: ContactSources.import,
      category: ContactCategories.uncategorized,
    );
  }

  /// Finds if a contact is a duplicate of an existing contact
  DuplicateMatch? _findDuplicate(
    Contact contact,
    Set<String> existingPhones,
    Set<String> existingEmails,
    Map<String, Contact> phoneToContact,
    Map<String, Contact> emailToContact,
  ) {
    // Check phone numbers
    for (final phone in contact.phoneNumbers) {
      final normalized = _normalizePhone(phone);
      if (existingPhones.contains(normalized)) {
        return DuplicateMatch(
          phoneContact: contact,
          existingContact: phoneToContact[normalized]!,
          matchReason: 'phone',
        );
      }
    }

    // Check emails
    for (final email in contact.emails) {
      final normalized = email.toLowerCase().trim();
      if (existingEmails.contains(normalized)) {
        return DuplicateMatch(
          phoneContact: contact,
          existingContact: emailToContact[normalized]!,
          matchReason: 'email',
        );
      }
    }

    return null;
  }

  /// Normalizes a phone number for comparison
  /// Removes spaces, dashes, parentheses, and keeps only digits
  String _normalizePhone(String phone) {
    // Remove all non-digit characters except +
    String normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Handle Bangladesh numbers - convert 01x to +88001x
    if (normalized.startsWith('01') && normalized.length == 11) {
      normalized = '+880$normalized';
    }

    // Remove leading + for comparison
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    }

    return normalized;
  }

  /// Checks if contact permission is granted
  Future<bool> hasPermission() async {
    return await fc.FlutterContacts.requestPermission(readonly: true);
  }
}

/// Provider for PhoneContactImportService
final phoneContactImportServiceProvider = Provider<PhoneContactImportService>((
  ref,
) {
  return PhoneContactImportService();
});
