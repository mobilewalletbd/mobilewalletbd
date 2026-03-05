// Scanned Card Entity
// Represents the result of scanning a business card

import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanned_card.freezed.dart';
part 'scanned_card.g.dart';

/// Represents a scanned business card with extracted OCR data
@freezed
class ScannedCard with _$ScannedCard {
  const ScannedCard._();

  const factory ScannedCard({
    /// Local file path of the front card image
    String? frontImagePath,

    /// Local file path of the back card image
    String? backImagePath,

    /// Raw OCR text from front image
    String? frontOcrText,

    /// Raw OCR text from back image
    String? backOcrText,

    /// Extracted and mapped fields from OCR
    @Default([]) List<ExtractedField> extractedFields,

    /// Overall confidence score (average of all fields)
    @Default(0.0) double overallConfidence,

    /// Detected language
    String? detectedLanguage,

    /// Timestamp of scan
    DateTime? scannedAt,
  }) = _ScannedCard;

  factory ScannedCard.fromJson(Map<String, dynamic> json) =>
      _$ScannedCardFromJson(json);

  /// Get field by type
  ExtractedField? getField(String fieldType) {
    try {
      return extractedFields.firstWhere((f) => f.fieldType == fieldType);
    } catch (_) {
      return null;
    }
  }

  /// Get extracted name
  String? get name => getField(ExtractedFieldType.name)?.value;

  /// Get extracted job title
  String? get jobTitle => getField(ExtractedFieldType.jobTitle)?.value;

  /// Get extracted company
  String? get company => getField(ExtractedFieldType.company)?.value;

  /// Get extracted phone numbers
  List<String> get phoneNumbers => extractedFields
      .where((f) => f.fieldType == ExtractedFieldType.phone)
      .map((f) => f.value)
      .toList();

  /// Get extracted email addresses
  List<String> get emails => extractedFields
      .where((f) => f.fieldType == ExtractedFieldType.email)
      .map((f) => f.value)
      .toList();

  /// Get extracted addresses
  List<String> get addresses => extractedFields
      .where((f) => f.fieldType == ExtractedFieldType.address)
      .map((f) => f.value)
      .toList();

  /// Get extracted websites
  List<String> get websites => extractedFields
      .where((f) => f.fieldType == ExtractedFieldType.website)
      .map((f) => f.value)
      .toList();

  /// Check if any data was extracted
  bool get hasData => extractedFields.isNotEmpty;

  /// Check if has low confidence fields
  bool get hasLowConfidenceFields =>
      extractedFields.any((f) => f.confidenceLevel == ConfidenceLevel.low);
}

/// Represents a single extracted field from OCR
@freezed
class ExtractedField with _$ExtractedField {
  const ExtractedField._();

  const factory ExtractedField({
    /// Type of field (name, title, company, phone, email, address, website)
    required String fieldType,

    /// Extracted value
    required String value,

    /// Confidence score from 0.0 to 1.0
    @Default(0.0) double confidence,

    /// Original raw text that was matched
    String? rawText,

    /// Whether this field has been manually edited
    @Default(false) bool isEdited,
  }) = _ExtractedField;

  factory ExtractedField.fromJson(Map<String, dynamic> json) =>
      _$ExtractedFieldFromJson(json);

  /// Get confidence level category
  ConfidenceLevel get confidenceLevel {
    if (confidence >= 0.8) return ConfidenceLevel.high;
    if (confidence >= 0.5) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }

  /// Check if field is high confidence
  bool get isHighConfidence => confidence >= 0.8;

  /// Check if field is medium confidence
  bool get isMediumConfidence => confidence >= 0.5 && confidence < 0.8;

  /// Check if field is low confidence
  bool get isLowConfidence => confidence < 0.5;
}

/// Confidence level categories
enum ConfidenceLevel {
  /// High confidence (>= 0.8)
  high,

  /// Medium confidence (0.5 - 0.8)
  medium,

  /// Low confidence (< 0.5)
  low,
}

/// Field type constants
class ExtractedFieldType {
  static const String name = 'name';
  static const String jobTitle = 'job_title';
  static const String company = 'company';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String address = 'address';
  static const String website = 'website';

  static const List<String> all = [
    name,
    jobTitle,
    company,
    phone,
    email,
    address,
    website,
  ];

  /// Get display name for field type
  static String displayName(String type) {
    switch (type) {
      case name:
        return 'Name';
      case jobTitle:
        return 'Job Title';
      case company:
        return 'Company';
      case phone:
        return 'Phone';
      case email:
        return 'Email';
      case address:
        return 'Address';
      case website:
        return 'Website';
      default:
        return type;
    }
  }
}

/// Card side for scanning
enum CardSide { front, back }
