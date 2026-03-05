// vCard Service
// Generates vCard (.vcf) files for contact export

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../contacts/domain/entities/contact.dart';
import '../../domain/entities/card_design.dart';
import '../../domain/failures/card_design_failure.dart';

/// Service for generating and sharing vCard files
class VCardService {
  /// Generate vCard string from contact data
  String generateVCard({
    required String fullName,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    String? avatarUrl,
    List<String>? phones,
    List<String>? emails,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$fullName');
    buffer.writeln('N:${_parseName(fullName)}');

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      buffer.writeln('PHOTO;VALUE=URI:$avatarUrl');
    }

    // Add multiple phones
    if (phones != null && phones.isNotEmpty) {
      for (var i = 0; i < phones.length; i++) {
        final type = i == 0 ? 'CELL' : 'WORK';
        buffer.writeln('TEL;TYPE=$type:${phones[i]}');
      }
    } else if (phone != null && phone.isNotEmpty) {
      buffer.writeln('TEL;TYPE=CELL:$phone');
    }

    // Add multiple emails
    if (emails != null && emails.isNotEmpty) {
      for (var i = 0; i < emails.length; i++) {
        final type = i == 0 ? 'HOME' : 'WORK';
        buffer.writeln('EMAIL;TYPE=$type:${emails[i]}');
      }
    } else if (email != null && email.isNotEmpty) {
      buffer.writeln('EMAIL;TYPE=HOME:$email');
    }

    if (company != null && company.isNotEmpty) {
      buffer.writeln('ORG:$company');
    }

    if (jobTitle != null && jobTitle.isNotEmpty) {
      buffer.writeln('TITLE:$jobTitle');
    }

    if (website != null && website.isNotEmpty) {
      buffer.writeln('URL:$website');
    }

    if (address != null && address.isNotEmpty) {
      buffer.writeln('ADR;TYPE=WORK:;;$address;;;;');
    }

    buffer.writeln('END:VCARD');

    return buffer.toString();
  }

  /// Generate vCard from Contact entity
  String generateVCardFromContact(Contact contact) {
    return generateVCard(
      fullName: contact.fullName,
      phones: contact.phoneNumbers,
      emails: contact.emails,
      company: contact.companyName,
      jobTitle: contact.jobTitle,
      website: contact.websiteUrls.isNotEmpty
          ? contact.websiteUrls.first
          : null,
      address: contact.addresses.isNotEmpty ? contact.addresses.first : null,
    );
  }

  /// Export contact as vCard file and share
  Future<void> exportAndShareVCard({
    required String fullName,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    String? avatarUrl,
    List<String>? phones,
    List<String>? emails,
  }) async {
    try {
      final vCardContent = generateVCard(
        fullName: fullName,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        website: website,
        address: address,
        avatarUrl: avatarUrl,
        phones: phones,
        emails: emails,
      );

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = '${_sanitizeFileName(fullName)}.vcf';
      final filePath = '${tempDir.path}/$fileName';

      // Write vCard to file
      final file = File(filePath);
      await file.writeAsString(vCardContent);

      // Share the file
      await Share.shareXFiles([XFile(filePath)], text: 'Contact: $fullName');
    } catch (e) {
      throw CardDesignFailure.vcardExportFailed(e);
    }
  }

  /// Export contact entity as vCard and share
  Future<void> exportContactAsVCard(Contact contact) async {
    await exportAndShareVCard(
      fullName: contact.fullName,
      phones: contact.phoneNumbers,
      emails: contact.emails,
      company: contact.companyName,
      jobTitle: contact.jobTitle,
      website: contact.websiteUrls.isNotEmpty
          ? contact.websiteUrls.first
          : null,
      address: contact.addresses.isNotEmpty ? contact.addresses.first : null,
    );
  }

  /// Generate vCard respecting CardDesign visibility
  String generateVCardForDesign({
    required CardDesign design,
    required String fullName,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
  }) {
    final visible = design.visibleFields;
    return generateVCard(
      fullName: fullName,
      phone: (visible['phone'] ?? true) ? phone : null,
      email: (visible['email'] ?? true) ? email : null,
      company: (visible['companyName'] ?? true) ? company : null,
      jobTitle: (visible['jobTitle'] ?? true) ? jobTitle : null,
      website: (visible['website'] ?? false) ? website : null,
      address: (visible['address'] ?? false) ? address : null,
    );
  }

  /// Batch export multiple cards as a single vCard file
  Future<void> batchExportVCards({
    required List<CardDesign> designs,
    required String fullName,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
  }) async {
    try {
      final buffer = StringBuffer();
      for (final design in designs) {
        buffer.writeln(
          generateVCardForDesign(
            design: design,
            fullName: fullName,
            phone: phone,
            email: email,
            company: company,
            jobTitle: jobTitle,
            website: website,
            address: address,
          ),
        );
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = '${_sanitizeFileName(fullName)}_batch.vcf';
      final filePath = '${tempDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(buffer.toString());

      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'Contacts: $fullName (${designs.length} cards)');
    } catch (e) {
      throw CardDesignFailure.vcardExportFailed(e);
    }
  }

  /// Parse full name into vCard N field components
  String _parseName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return ';;;;';

    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.last : '';
    final middleNames = parts.length > 2
        ? parts.sublist(1, parts.length - 1).join(' ')
        : '';

    return '$lastName;$firstName;$middleNames;;';
  }

  /// Sanitize file name for safe file system usage
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
}

/// Provider for VCardService
final vCardServiceProvider = Provider<VCardService>((ref) {
  return VCardService();
});
