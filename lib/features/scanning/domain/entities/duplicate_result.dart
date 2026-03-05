// Duplicate Result Entity
// Represents the result of a duplicate contact detection check

import 'package:mobile_wallet/features/contacts/domain/entities/contact.dart';

/// Holds the result of comparing a new contact against an existing one.
/// Contains per-field similarity scores and an overall composite score.
class DuplicateResult {
  /// The existing contact that was matched
  final Contact matchingContact;

  /// Overall composite score (0.0 - 1.0)
  final double overallScore;

  /// Name similarity score (0.0 - 1.0)
  final double nameScore;

  /// Phone number match score (0.0 - 1.0)
  final double phoneScore;

  /// Email match score (0.0 - 1.0)
  final double emailScore;

  /// Company name similarity score (0.0 - 1.0)
  final double companyScore;

  /// Human-readable list of which fields matched
  final List<String> matchedFields;

  const DuplicateResult({
    required this.matchingContact,
    required this.overallScore,
    this.nameScore = 0.0,
    this.phoneScore = 0.0,
    this.emailScore = 0.0,
    this.companyScore = 0.0,
    this.matchedFields = const [],
  });

  /// Whether this is a strong match (≥ 0.80)
  bool get isStrongMatch => overallScore >= 0.80;

  /// Whether this is a moderate match (≥ 0.60)
  bool get isModerateMatch => overallScore >= 0.60;

  /// Human-readable confidence label
  String get confidenceLabel {
    if (overallScore >= 0.90) return 'Very High';
    if (overallScore >= 0.80) return 'High';
    if (overallScore >= 0.60) return 'Moderate';
    if (overallScore >= 0.40) return 'Low';
    return 'Very Low';
  }

  @override
  String toString() =>
      'DuplicateResult(contact: ${matchingContact.fullName}, '
      'score: ${(overallScore * 100).toStringAsFixed(1)}%, '
      'matched: $matchedFields)';
}
