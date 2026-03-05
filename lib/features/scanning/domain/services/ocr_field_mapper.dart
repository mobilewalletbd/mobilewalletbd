// OCR Field Mapper
// Maps raw OCR text to structured contact fields

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_wallet/features/scanning/data/services/ocr_service.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/scanned_card.dart';

/// Service for mapping raw OCR text to structured contact fields
class OcrFieldMapper {
  /// Map OCR result to extracted fields
  List<ExtractedField> mapOcrToFields(OcrResult ocrResult) {
    final fields = <ExtractedField>[];
    final usedLines = <String>{};

    // Process all lines
    final lines = ocrResult.allLines;

    // Extract emails first (most reliable pattern)
    for (final line in lines) {
      final emails = _extractEmails(line.text);
      for (final email in emails) {
        if (!usedLines.contains(email)) {
          fields.add(
            ExtractedField(
              fieldType: ExtractedFieldType.email,
              value: email,
              confidence: 0.95,
              rawText: line.text,
            ),
          );
          usedLines.add(email);
        }
      }
    }

    // Extract phone numbers
    for (final line in lines) {
      final phones = _extractPhones(line.text);
      for (final phone in phones) {
        final normalized = _normalizePhone(phone);
        if (!usedLines.contains(normalized) && normalized.length >= 7) {
          fields.add(
            ExtractedField(
              fieldType: ExtractedFieldType.phone,
              value: _formatPhone(phone),
              confidence: line.confidence * 0.9,
              rawText: line.text,
            ),
          );
          usedLines.add(normalized);
        }
      }
    }

    // Extract websites
    for (final line in lines) {
      final websites = _extractWebsites(line.text);
      for (final website in websites) {
        if (!usedLines.contains(website.toLowerCase())) {
          fields.add(
            ExtractedField(
              fieldType: ExtractedFieldType.website,
              value: _normalizeUrl(website),
              confidence: 0.85,
              rawText: line.text,
            ),
          );
          usedLines.add(website.toLowerCase());
        }
      }
    }

    // Extract name (usually first prominent line that's not email/phone)
    final nameField = _extractName(lines, usedLines);
    if (nameField != null) {
      fields.add(nameField);
      usedLines.add(nameField.value.toLowerCase());
    }

    // Extract job title
    final titleField = _extractJobTitle(lines, usedLines);
    if (titleField != null) {
      fields.add(titleField);
      usedLines.add(titleField.value.toLowerCase());
    }

    // Extract company name
    final companyField = _extractCompany(lines, usedLines);
    if (companyField != null) {
      fields.add(companyField);
      usedLines.add(companyField.value.toLowerCase());
    }

    // Extract addresses
    for (final line in lines) {
      if (_looksLikeAddress(line.text) &&
          !usedLines.contains(line.text.toLowerCase())) {
        fields.add(
          ExtractedField(
            fieldType: ExtractedFieldType.address,
            value: line.text.trim(),
            confidence: line.confidence * 0.7,
            rawText: line.text,
          ),
        );
        usedLines.add(line.text.toLowerCase());
      }
    }

    return fields;
  }

  /// Extract email addresses from text
  List<String> _extractEmails(String text) {
    final emails = <String>[];

    // Standard Email pattern
    final standardEmailRegex = RegExp(
      r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
      caseSensitive: false,
    );
    for (final match in standardEmailRegex.allMatches(text)) {
      emails.add(match.group(0)!);
    }

    // Obfuscated Email pattern (e.g., john at company dot com)
    final obfuscatedEmailRegex = RegExp(
      r'([a-zA-Z0-9._%+-]+)\s*(?:at|@)\s*([a-zA-Z0-9.-]+)\s*(?:dot|\.)\s*([a-zA-Z]{2,})',
      caseSensitive: false,
    );
    for (final match in obfuscatedEmailRegex.allMatches(text)) {
      final emailFromObfuscated =
          '${match.group(1)}@${match.group(2)}.${match.group(3)}';
      if (!emails.contains(emailFromObfuscated)) {
        emails.add(emailFromObfuscated);
      }
    }

    return emails;
  }

  /// Extract phone numbers from text
  List<String> _extractPhones(String text) {
    final phones = <String>[];

    // Check for fax prefix to ignore or explicitly tag it (for now, exclude from phones if we only want phones, or just keep it)
    // Actually, we capture it as phone but ideally it should be tagged as fax.

    // Bangladesh mobile patterns (Enhanced)
    final bdMobileRegex = RegExp(
      r'(?:\+?88)?\s*0?1[3-9]\d{8}',
      caseSensitive: false,
    );

    // Bangladesh landline patterns
    final bdLandlineRegex = RegExp(
      r'(?:\+?88)?\s*0[2-9]\d{6,8}',
      caseSensitive: false,
    );

    // International phone patterns
    final intlPhoneRegex = RegExp(
      r'\+?\d{1,4}[\s\-\.]?\(?\d{1,4}\)?[\s\-\.]?\d{1,4}[\s\-\.]?\d{1,9}',
    );

    // Fax Detection
    final faxRegex = RegExp(
      r'(?:Fax|F|ফ্যাক্স)\s*[:\-]?\s*([\d\+\-\s]+)',
      caseSensitive: false,
    );

    // First, let's extract matches and filter them
    for (final match in bdMobileRegex.allMatches(text)) {
      if (!_isFaxMatch(text, match.start, faxRegex)) {
        phones.add(match.group(0)!);
      }
    }

    if (phones.isEmpty) {
      for (final match in bdLandlineRegex.allMatches(text)) {
        if (!_isFaxMatch(text, match.start, faxRegex)) {
          phones.add(match.group(0)!);
        }
      }
    }

    if (phones.isEmpty) {
      for (final match in intlPhoneRegex.allMatches(text)) {
        if (!_isFaxMatch(text, match.start, faxRegex)) {
          final phone = match.group(0)!;
          final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
          if (digits.length >= 7 && digits.length <= 15) {
            phones.add(phone);
          }
        }
      }
    }

    return phones.toSet().toList(); // Remove exactly identical duplicates
  }

  /// Helper to check if a phone match is actually part of a fax line
  bool _isFaxMatch(String text, int matchStart, RegExp faxRegex) {
    final lineStart = text.lastIndexOf('\n', matchStart) + 1;
    final lineEnd = text.indexOf('\n', matchStart) == -1
        ? text.length
        : text.indexOf('\n', matchStart);
    final line = text.substring(lineStart, lineEnd);
    return faxRegex.hasMatch(line);
  }

  /// Normalize phone number for comparison
  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Format phone number for display
  String _formatPhone(String phone) {
    String normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (normalized.startsWith('01') && normalized.length == 11) {
      normalized = '+880${normalized.substring(1)}';
    } else if (normalized.startsWith('880') && !normalized.startsWith('+')) {
      normalized = '+$normalized';
    } else if (normalized.startsWith('1') && normalized.length == 10) {
      normalized = '+880$normalized';
    } else if (normalized.startsWith('0') &&
        normalized.length >= 8 &&
        normalized.length <= 10) {
      normalized = '+88$normalized';
    }

    return normalized;
  }

  /// Extract websites from text
  List<String> _extractWebsites(String text) {
    final websites = <String>[];

    // Comprehensive URL extraction
    final urlRegex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(?:\/[\w-]+)*',
      caseSensitive: false,
    );
    for (final match in urlRegex.allMatches(text)) {
      final url = match.group(0)!;
      // Filter out things that are likely emails captured by mistake
      if (!url.contains('@') && !websites.any((w) => w.contains(url))) {
        websites.add(url);
      }
    }

    return websites;
  }

  /// Normalize URL
  String _normalizeUrl(String url) {
    url = url.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  /// Extract name from OCR lines
  ExtractedField? _extractName(
    List<TextLineResult> lines,
    Set<String> usedLines,
  ) {
    // Name is usually:
    // - One of the first lines
    // - Contains mostly letters
    // - 2-4 words
    // - Not an email, phone, or company suffix

    for (final line in lines.take(5)) {
      final text = line.text.trim();

      // Skip if already used
      if (usedLines.contains(text.toLowerCase())) continue;

      // Skip if too short or too long
      if (text.length < 3 || text.length > 50) continue;

      // Skip if contains email or phone patterns
      if (_extractEmails(text).isNotEmpty) continue;
      if (_extractPhones(text).isNotEmpty) continue;

      // Skip if looks like company name
      if (_hasCompanySuffix(text)) continue;

      // Check if looks like a name (mostly letters, 1-4 words)
      final words = text.split(RegExp(r'\s+'));
      if (words.isNotEmpty && words.length <= 4) {
        final letterRatio =
            text.replaceAll(RegExp(r'[^a-zA-Z\s\.]'), '').length /
            (text.length + 1);
        if (letterRatio > 0.8) {
          // Capitalize name properly
          final formattedName = words
              .map(
                (w) => w.isNotEmpty
                    ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
                    : '',
              )
              .join(' ');

          return ExtractedField(
            fieldType: ExtractedFieldType.name,
            value: formattedName,
            confidence: line.confidence * 0.85,
            rawText: text,
          );
        }
      }
    }

    return null;
  }

  /// Extract job title from OCR lines
  ExtractedField? _extractJobTitle(
    List<TextLineResult> lines,
    Set<String> usedLines,
  ) {
    // English job title keywords
    final titleKeywords = [
      'manager',
      'director',
      'executive',
      'officer',
      'ceo',
      'cto',
      'cfo',
      'coo',
      'president',
      'vice president',
      'vp',
      'head',
      'lead',
      'senior',
      'junior',
      'associate',
      'engineer',
      'developer',
      'designer',
      'analyst',
      'consultant',
      'specialist',
      'coordinator',
      'supervisor',
      'assistant',
      'administrator',
      'founder',
      'owner',
      'partner',
      'sales',
      'marketing',
      'hr',
      'finance',
      'accounting',
      'legal',
      'operations',
    ];

    // Bangla job title keywords
    final banglaKeywords = [
      'ব্যবস্থাপক', // Manager
      'পরিচালক', // Director
      'নির্বাহী', // Executive
      'প্রকৌশলী', // Engineer
      'প্রতিষ্ঠাতা', // Founder
      'চেয়ারম্যান', // Chairman
      'ব্যবস্থাপনা পরিচালক', // Managing Director
      'প্রধান নির্বাহী', // Chief Executive
      'কর্মকর্তা', // Officer
      'ডাক্তার', // Doctor
      'চিকিৎসক', // Physician
      'অধ্যাপক', // Professor
      'শিক্ষক', // Teacher
      'হিসাবরক্ষক', // Accountant
      'আইনজীবী', // Lawyer
      'সাংবাদিক', // Journalist
      'সম্পাদক', // Editor
      'ম্যানেজার', // Manager (English variant)
      'ডিরেক্টর', // Director (English variant)
    ];

    for (final line in lines) {
      final text = line.text.trim();
      final textLower = text.toLowerCase();

      // Skip if already used
      if (usedLines.contains(textLower)) continue;

      // Check for English title keywords
      for (final keyword in titleKeywords) {
        if (textLower.contains(keyword)) {
          return ExtractedField(
            fieldType: ExtractedFieldType.jobTitle,
            value: _capitalizeTitle(text),
            confidence: line.confidence * 0.8,
            rawText: line.text,
          );
        }
      }

      // Check for Bangla title keywords
      for (final keyword in banglaKeywords) {
        if (text.contains(keyword)) {
          return ExtractedField(
            fieldType: ExtractedFieldType.jobTitle,
            value: text, // Keep Bangla text as-is
            confidence: line.confidence * 0.8,
            rawText: line.text,
          );
        }
      }
    }

    return null;
  }

  /// Capitalize job title
  String _capitalizeTitle(String title) {
    final minorWords = ['of', 'the', 'and', 'in', 'at', 'to', 'for'];
    final words = title.split(RegExp(r'\s+'));
    return words
        .asMap()
        .entries
        .map((entry) {
          final word = entry.value.toLowerCase();
          if (entry.key == 0 || !minorWords.contains(word)) {
            return word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '';
          }
          return word;
        })
        .join(' ');
  }

  /// Extract company name from OCR lines
  ExtractedField? _extractCompany(
    List<TextLineResult> lines,
    Set<String> usedLines,
  ) {
    // Company suffixes
    final companySuffixes = [
      'ltd',
      'limited',
      'inc',
      'incorporated',
      'corp',
      'corporation',
      'llc',
      'llp',
      'pvt',
      'private',
      'co',
      'company',
      'group',
      'holdings',
      'enterprises',
      'solutions',
      'technologies',
      'tech',
      'systems',
      'services',
      'consulting',
      'international',
      'global',
      'bangladesh',
    ];

    for (final line in lines) {
      final text = line.text.trim();
      final textLower = text.toLowerCase();

      // Skip if already used
      if (usedLines.contains(textLower)) continue;

      // Check for company suffixes
      for (final suffix in companySuffixes) {
        if (textLower.contains(suffix)) {
          return ExtractedField(
            fieldType: ExtractedFieldType.company,
            value: _standardizeCompanyName(text),
            confidence: line.confidence * 0.85,
            rawText: text,
          );
        }
      }
    }

    return null;
  }

  /// Check if text has company suffix
  bool _hasCompanySuffix(String text) {
    final suffixes = ['ltd', 'inc', 'corp', 'llc', 'co', 'pvt', 'limited'];
    final textLower = text.toLowerCase();
    return suffixes.any((s) => textLower.contains(s));
  }

  /// Standardize company name
  String _standardizeCompanyName(String name) {
    // Standardize common suffixes
    name = name.replaceAllMapped(
      RegExp(r'\bltd\.?\b', caseSensitive: false),
      (_) => 'Ltd.',
    );
    name = name.replaceAllMapped(
      RegExp(r'\binc\.?\b', caseSensitive: false),
      (_) => 'Inc.',
    );
    name = name.replaceAllMapped(
      RegExp(r'\bllc\.?\b', caseSensitive: false),
      (_) => 'LLC',
    );
    name = name.replaceAllMapped(
      RegExp(r'\bpvt\.?\b', caseSensitive: false),
      (_) => 'Pvt.',
    );
    return name.trim();
  }

  /// Check if text looks like an address
  bool _looksLikeAddress(String text) {
    final textLower = text.toLowerCase();

    // English address indicators
    final addressIndicators = [
      'road',
      'rd',
      'street',
      'st',
      'avenue',
      'ave',
      'floor',
      'flat',
      'house',
      'building',
      'tower',
      'block',
      'sector',
      'area',
      'dhaka',
      'chittagong',
      'sylhet',
      'rajshahi',
      'khulna',
      'bangladesh',
    ];

    // Bangla address keywords
    final banglaAddressKeywords = [
      'বাসা', // House
      'হোল্ডিং', // Holding
      'রোড', // Road
      'সড়ক', // Street
      'লেন', // Lane
      'গ্রাম', // Village
      'ডাকঘর', // Post Office
      'থানা', // Police Station/Thana
      'উপজেলা', // Upazila
      'জেলা', // District
      'ফ্ল্যাট', // Flat
      'লেভেল', // Level
      'ভবন', // Building
      'ঢাকা', // Dhaka
      'চট্টগ্রাম', // Chittagong
      'সিলেট', // Sylhet
    ];

    // Check for postal codes (Bangladesh: 4 digits)
    if (RegExp(r'\b\d{4}\b').hasMatch(text)) {
      return true;
    }

    // Check for English address indicators
    if (addressIndicators.any((ind) => textLower.contains(ind))) {
      return true;
    }

    // Check for Bangla address keywords
    if (banglaAddressKeywords.any((keyword) => text.contains(keyword))) {
      return true;
    }

    return false;
  }
}

/// Provider for OcrFieldMapper
final ocrFieldMapperProvider = Provider<OcrFieldMapper>((ref) {
  return OcrFieldMapper();
});
