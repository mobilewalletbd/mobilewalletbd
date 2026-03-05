 // Duplicate Detection Service
// Advanced duplicate contact detection with fuzzy matching,
// phone normalization, email domain comparison, and company similarity.

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';
import 'package:mobile_wallet/features/scanning/domain/entities/duplicate_result.dart';

/// Weights for the composite duplicate score.
class _Weights {
  static const double name = 0.35;
  static const double phone = 0.30;
  static const double email = 0.20;
  static const double company = 0.15;
}

/// Service for detecting duplicate contacts using multi-signal matching.
class DuplicateDetectionService {
  /// Minimum composite score to flag as a potential duplicate.
  static const double duplicateThreshold = 0.60;

  /// Find potential duplicates for [newContact] among [existingContacts].
  /// Returns results sorted by score descending (best match first).
  List<DuplicateResult> findDuplicates(
    Contact newContact,
    List<Contact> existingContacts,
  ) {
    final results = <DuplicateResult>[];

    for (final existing in existingContacts) {
      // Skip comparing the same contact by ID
      if (existing.id == newContact.id && newContact.id.isNotEmpty) continue;

      final nameScore = calculateNameSimilarity(
        newContact.fullName,
        existing.fullName,
      );
      final phoneScore = calculatePhoneScore(
        newContact.phoneNumbers,
        existing.phoneNumbers,
      );
      final emailScore = calculateEmailScore(
        newContact.emails,
        existing.emails,
      );
      final companyScore = calculateCompanySimilarity(
        newContact.companyName,
        existing.companyName,
      );

      // Compute weighted composite score
      final overallScore =
          (nameScore * _Weights.name) +
          (phoneScore * _Weights.phone) +
          (emailScore * _Weights.email) +
          (companyScore * _Weights.company);

      if (overallScore >= duplicateThreshold) {
        final matchedFields = <String>[];
        if (nameScore >= 0.70) matchedFields.add('Name');
        if (phoneScore >= 0.70) matchedFields.add('Phone');
        if (emailScore >= 0.70) matchedFields.add('Email');
        if (companyScore >= 0.70) matchedFields.add('Company');

        results.add(
          DuplicateResult(
            matchingContact: existing,
            overallScore: overallScore.clamp(0.0, 1.0),
            nameScore: nameScore,
            phoneScore: phoneScore,
            emailScore: emailScore,
            companyScore: companyScore,
            matchedFields: matchedFields,
          ),
        );
      }
    }

    // Sort by score descending
    results.sort((a, b) => b.overallScore.compareTo(a.overallScore));
    return results;
  }

  // ---------------------------------------------------------------------------
  // Name Matching
  // ---------------------------------------------------------------------------

  /// Calculate name similarity using token-based + Levenshtein approach.
  /// Handles swapped name order ("John Doe" ≈ "Doe John").
  double calculateNameSimilarity(String name1, String name2) {
    if (name1.isEmpty || name2.isEmpty) return 0.0;

    final n1 = name1.toLowerCase().trim();
    final n2 = name2.toLowerCase().trim();

    // Exact match
    if (n1 == n2) return 1.0;

    // Token-based: sort tokens and compare (handles reordering)
    final tokens1 = n1.split(RegExp(r'\s+'))..sort();
    final tokens2 = n2.split(RegExp(r'\s+'))..sort();
    final sortedName1 = tokens1.join(' ');
    final sortedName2 = tokens2.join(' ');

    if (sortedName1 == sortedName2) return 0.98;

    // Levenshtein on sorted tokens
    final sortedSimilarity = _levenshteinSimilarity(sortedName1, sortedName2);

    // Levenshtein on original order
    final directSimilarity = _levenshteinSimilarity(n1, n2);

    // Take the better score
    return max(sortedSimilarity, directSimilarity);
  }

  // ---------------------------------------------------------------------------
  // Phone Matching
  // ---------------------------------------------------------------------------

  /// Calculate phone match score between two lists of phone numbers.
  /// Returns 1.0 if any pair of numbers match after normalization.
  double calculatePhoneScore(List<String> phones1, List<String> phones2) {
    if (phones1.isEmpty || phones2.isEmpty) return 0.0;

    for (final p1 in phones1) {
      final norm1 = normalizePhone(p1);
      if (norm1.length < 7) continue; // Skip very short numbers

      for (final p2 in phones2) {
        final norm2 = normalizePhone(p2);
        if (norm2.length < 7) continue;

        // Exact digits match
        if (norm1 == norm2) return 1.0;

        // Match on last 10 digits (strips country code differences)
        final tail1 = norm1.length >= 10
            ? norm1.substring(norm1.length - 10)
            : norm1;
        final tail2 = norm2.length >= 10
            ? norm2.substring(norm2.length - 10)
            : norm2;
        if (tail1 == tail2) return 0.95;

        // Match on last 7 digits (local number)
        final local1 = norm1.length >= 7
            ? norm1.substring(norm1.length - 7)
            : norm1;
        final local2 = norm2.length >= 7
            ? norm2.substring(norm2.length - 7)
            : norm2;
        if (local1 == local2) return 0.80;
      }
    }

    return 0.0;
  }

  /// Normalize a phone number: strip all non-digit characters,
  /// handle Bangladesh +880/0 prefix variants.
  String normalizePhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Bangladesh: +880XXXXXXXXXX → 880XXXXXXXXXX (already)
    // 01XXXXXXXXX → 88001XXXXXXXXX
    if (digits.startsWith('01') && digits.length == 11) {
      digits = '880$digits';
    }
    // Remove leading zeros and plus
    if (digits.startsWith('0') && !digits.startsWith('01')) {
      digits = digits.substring(1);
    }

    return digits;
  }

  // ---------------------------------------------------------------------------
  // Email Matching
  // ---------------------------------------------------------------------------

  /// Calculate email match score.
  /// Full match → 1.0, domain-only match → 0.5, no match → 0.0
  double calculateEmailScore(List<String> emails1, List<String> emails2) {
    if (emails1.isEmpty || emails2.isEmpty) return 0.0;

    double bestScore = 0.0;

    for (final e1 in emails1) {
      final norm1 = e1.toLowerCase().trim();
      for (final e2 in emails2) {
        final norm2 = e2.toLowerCase().trim();

        // Exact match
        if (norm1 == norm2) return 1.0;

        // Domain match (corporate emails from same domain)
        final domain1 = _extractDomain(norm1);
        final domain2 = _extractDomain(norm2);
        if (domain1 != null &&
            domain2 != null &&
            domain1 == domain2 &&
            !_isFreeEmailDomain(domain1)) {
          bestScore = max(bestScore, 0.50);
        }
      }
    }

    return bestScore;
  }

  /// Extract domain from an email address.
  String? _extractDomain(String email) {
    final atIndex = email.lastIndexOf('@');
    if (atIndex < 0 || atIndex >= email.length - 1) return null;
    return email.substring(atIndex + 1);
  }

  /// Check if a domain is a free/public email provider.
  /// Domain-only matching should NOT fire for gmail, yahoo, etc.
  bool _isFreeEmailDomain(String domain) {
    const freeDomains = {
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'outlook.com',
      'live.com',
      'aol.com',
      'icloud.com',
      'mail.com',
      'protonmail.com',
      'proton.me',
      'ymail.com',
      'zoho.com',
      'gmx.com',
    };
    return freeDomains.contains(domain.toLowerCase());
  }

  // ---------------------------------------------------------------------------
  // Company Matching
  // ---------------------------------------------------------------------------

  /// Calculate company name similarity.
  /// Strips common suffixes before comparing.
  double calculateCompanySimilarity(String? company1, String? company2) {
    if (company1 == null ||
        company2 == null ||
        company1.isEmpty ||
        company2.isEmpty) {
      return 0.0;
    }

    final clean1 = _cleanCompanyName(company1);
    final clean2 = _cleanCompanyName(company2);

    if (clean1.isEmpty || clean2.isEmpty) return 0.0;
    if (clean1 == clean2) return 1.0;

    return _levenshteinSimilarity(clean1, clean2);
  }

  /// Remove common business suffixes and noise words for better comparison.
  String _cleanCompanyName(String name) {
    String cleaned = name.toLowerCase().trim();

    // Remove common suffixes
    const suffixes = [
      'ltd',
      'ltd.',
      'limited',
      'inc',
      'inc.',
      'incorporated',
      'corp',
      'corp.',
      'corporation',
      'llc',
      'llp',
      'pvt',
      'pvt.',
      'private',
      'co',
      'co.',
      'company',
      'group',
      'holdings',
      'plc',
      '(pvt)',
    ];

    for (final suffix in suffixes) {
      cleaned = cleaned.replaceAll(RegExp('\\b$suffix\\b'), '');
    }

    // Remove extra whitespace and punctuation
    cleaned = cleaned.replaceAll(RegExp(r'[^\w\s]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleaned;
  }

  // ---------------------------------------------------------------------------
  // String Similarity Utilities
  // ---------------------------------------------------------------------------

  /// Calculate Levenshtein-based similarity (0.0 - 1.0).
  double _levenshteinSimilarity(String s1, String s2) {
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final distance = levenshteinDistance(s1, s2);
    final maxLen = max(s1.length, s2.length);
    return 1.0 - (distance / maxLen);
  }

  /// Compute Levenshtein edit distance between two strings.
  int levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    // Use two-row optimization for O(min(m,n)) space
    List<int> previousRow = List.generate(s2.length + 1, (i) => i);
    List<int> currentRow = List.filled(s2.length + 1, 0);

    for (int i = 1; i <= s1.length; i++) {
      currentRow[0] = i;
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        currentRow[j] = [
          currentRow[j - 1] + 1, // insertion
          previousRow[j] + 1, // deletion
          previousRow[j - 1] + cost, // substitution
        ].reduce(min);
      }
      // Swap rows
      final temp = previousRow;
      previousRow = currentRow;
      currentRow = temp;
    }

    return previousRow[s2.length];
  }
}

/// Provider for DuplicateDetectionService
final duplicateDetectionServiceProvider = Provider<DuplicateDetectionService>((
  ref,
) {
  return DuplicateDetectionService();
});
