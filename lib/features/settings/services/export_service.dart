import 'dart:io';

import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum ExportFormat { csv, vcf }

class ExportService {
  Future<void> exportContacts(
    List<Contact> contacts,
    ExportFormat format,
  ) async {
    if (contacts.isEmpty) throw Exception('No contacts to export');

    final String content;
    final String extension;
    final String mimeType;

    switch (format) {
      case ExportFormat.csv:
        content = _generateCsv(contacts);
        extension = 'csv';
        mimeType = 'text/csv';
        break;
      case ExportFormat.vcf:
        content = _generateVcf(contacts);
        extension = 'vcf';
        mimeType = 'text/vcard';
        break;
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/contacts_export.$extension');
    await file.writeAsString(content);

    await Share.shareXFiles([
      XFile(file.path, mimeType: mimeType),
    ], text: 'My Contacts Export');
  }

  String _generateCsv(List<Contact> contacts) {
    final headers = [
      'Full Name',
      'Job Title',
      'Company',
      'Phone Numbers',
      'Emails',
      'Category',
      'Notes',
      'Tags',
      'Addresses',
      'Websites',
    ];

    final buffer = StringBuffer();
    // Headers
    buffer.writeln(headers.map(_escape).join(','));

    // Rows
    for (final c in contacts) {
      final row = [
        _escape(c.fullName),
        _escape(c.jobTitle ?? ''),
        _escape(c.companyName ?? ''),
        _escape(c.phoneNumbers.join('; ')),
        _escape(c.emails.join('; ')),
        _escape(c.category),
        _escape(c.notes ?? ''),
        _escape(c.tags.join('; ')),
        _escape(c.addresses.join('; ')),
        _escape(c.websiteUrls.join('; ')),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  String _escape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _generateVcf(List<Contact> contacts) {
    final buffer = StringBuffer();
    for (final c in contacts) {
      buffer.writeln('BEGIN:VCARD');
      buffer.writeln('VERSION:3.0');
      buffer.writeln('FN:${c.fullName}');
      buffer.writeln('N:;${c.fullName};;;');

      if (c.companyName != null) {
        buffer.writeln('ORG:${c.companyName}');
      }
      if (c.jobTitle != null) {
        buffer.writeln('TITLE:${c.jobTitle}');
      }

      for (final phone in c.phoneNumbers) {
        buffer.writeln('TEL;TYPE=CELL:$phone');
      }
      for (final email in c.emails) {
        buffer.writeln('EMAIL;TYPE=INTERNET:$email');
      }
      for (final address in c.addresses) {
        buffer.writeln('ADR;TYPE=HOME:;;$address;;;;');
      }
      for (final url in c.websiteUrls) {
        buffer.writeln('URL:$url');
      }
      if (c.notes != null) {
        buffer.writeln('NOTE:${c.notes}');
      }
      if (c.category != 'uncategorized') {
        buffer.writeln('CATEGORIES:${c.category}');
      }

      buffer.writeln('END:VCARD');
    }
    return buffer.toString();
  }
}
