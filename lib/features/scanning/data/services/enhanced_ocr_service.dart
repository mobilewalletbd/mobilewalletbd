// Enhanced OCR Service with Advanced Features
// Includes confidence scoring, QR detection, multi-language support
// Cloud Vision integration for enhanced Bangla recognition

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

/// Enhanced OCR Service with advanced features
class EnhancedOcrService {
  TextRecognizer? _textRecognizer;
  BarcodeScanner? _barcodeScanner;

  /// Confidence threshold for auto-save (default 80%)
  double confidenceThreshold = 0.80;

  /// Whether to use Cloud Vision for Bangla text (requires API key)
  bool useCloudVision = false;

  /// Cloud Vision API key
  String? cloudVisionApiKey;

  /// Supported languages for recognition
  final List<TextRecognitionScript> _supportedScripts = [
    TextRecognitionScript.latin,
    TextRecognitionScript.chinese,
    TextRecognitionScript.japanese,
    TextRecognitionScript.korean,
  ];

  /// Initialize recognizers
  void _ensureInitialized() {
    _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    _barcodeScanner ??= BarcodeScanner(formats: [BarcodeFormat.all]);
  }

  /// Extract text with confidence scoring and QR detection
  Future<EnhancedOcrResult> extractTextEnhanced(
    File imageFile, {
    TextRecognitionScript? preferredScript,
    bool detectBarcodes = true,
  }) async {
    _ensureInitialized();

    try {
      final inputImage = InputImage.fromFile(imageFile);

      // Process text recognition
      if (preferredScript != null &&
          _textRecognizer!.script != preferredScript) {
        await _textRecognizer?.close();
        _textRecognizer = TextRecognizer(script: preferredScript);
      }

      final recognizedText = await _textRecognizer!.processImage(inputImage);

      // Process barcode/QR detection if enabled
      List<BarcodeResult>? barcodes;
      if (detectBarcodes) {
        final scannedBarcodes = await _barcodeScanner!.processImage(inputImage);
        barcodes = scannedBarcodes
            .map(
              (barcode) => BarcodeResult(
                type: barcode.type,
                rawValue: barcode.rawValue ?? '',
                displayValue: barcode.displayValue ?? '',
                format: barcode.format,
                contactInfo: _extractContactFromBarcode(barcode),
              ),
            )
            .toList();
      }

      // Calculate overall confidence
      final blocks = recognizedText.blocks.map((block) {
        return EnhancedTextBlock(
          text: block.text,
          confidence: _calculateEnhancedConfidence(block),
          lines: block.lines.map((line) {
            return EnhancedTextLine(
              text: line.text,
              confidence: _calculateLineConfidence(line),
              recognizedType: _detectTextType(line.text),
            );
          }).toList(),
        );
      }).toList();

      final overallConfidence = _calculateOverallConfidence(blocks);
      final detectedLanguage = _detectLanguage(recognizedText.text);

      return EnhancedOcrResult(
        rawText: recognizedText.text,
        blocks: blocks,
        barcodes: barcodes ?? [],
        overallConfidence: overallConfidence,
        detectedLanguage: detectedLanguage,
        shouldAutoSave: overallConfidence >= confidenceThreshold,
        success: true,
      );
    } catch (e) {
      return EnhancedOcrResult(
        rawText: '',
        blocks: [],
        barcodes: [],
        overallConfidence: 0.0,
        detectedLanguage: 'unknown',
        shouldAutoSave: false,
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Extract contact info from QR/barcode (vCard format)
  BarcodeContactInfo? _extractContactFromBarcode(Barcode barcode) {
    if (barcode.type == BarcodeType.contactInfo) {
      final dynamic b = barcode;
      final contact = b.contactInfo;
      if (contact != null) {
        return BarcodeContactInfo(
          name: contact.name?.formattedName ?? '',
          phones: contact.phones.map((p) => (p as dynamic).number).toList(),
          emails: contact.emails.map((e) => (e as dynamic).address).toList(),
          organization: contact.organization ?? '',
          urls: contact.urls,
          addresses: contact.addresses
              .map((a) => (a as dynamic).addressLines.join(', '))
              .toList(),
        );
      }
    } else if (barcode.type == BarcodeType.url) {
      final dynamic b = barcode;
      return BarcodeContactInfo(urls: [b.url?.url ?? '']);
    }
    return null;
  }

  /// Enhanced confidence calculation with handwriting detection
  double _calculateEnhancedConfidence(TextBlock block) {
    double confidence = 0.75; // Base confidence

    final text = block.text;
    final lines = block.lines;

    // Factor 1: Number of lines (more = better structure)
    if (lines.length >= 2) confidence += 0.05;
    if (lines.length >= 4) confidence += 0.05;

    // Factor 2: Text clarity (avoid garbled patterns)
    if (_hasGarbledPatterns(text)) {
      confidence -= 0.30;
    } else {
      confidence += 0.10;
    }

    // Factor 3: Recognizable patterns (email, phone, URL)
    int recognizableCount = 0;
    for (final line in lines) {
      if (_hasRecognizablePattern(line.text)) {
        recognizableCount++;
      }
    }
    confidence += (recognizableCount * 0.05).clamp(0, 0.15);

    // Factor 4: Text length (too short = uncertain)
    if (text.length < 5) {
      confidence -= 0.20;
    } else if (text.length > 20) {
      confidence += 0.05;
    }

    // Factor 5: Handwriting indicators (lowercase variation, irregular spacing)
    if (_looksLikeHandwriting(text)) {
      confidence -= 0.25; // Significant penalty for handwriting
    }

    // Factor 6: Mixed scripts (usually indicates OCR confusion)
    if (_hasMixedScripts(text)) {
      confidence -= 0.15;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Detect if text looks like handwriting
  bool _looksLikeHandwriting(String text) {
    // Handwriting often has:
    // 1. Irregular character spacing
    // 2. Unusual capitalization patterns
    // 3. Ambiguous characters (l/I, O/0, etc.)

    // Check for excessive lowercase in titles/names
    if (text.length > 5) {
      final lowerCount = text.replaceAll(RegExp(r'[^a-z]'), '').length;
      final upperCount = text.replaceAll(RegExp(r'[^A-Z]'), '').length;

      // Unusual lowercase dominance in what should be names/titles
      if (lowerCount > upperCount * 3 && text.contains(RegExp(r'\b[a-z]'))) {
        return true;
      }
    }

    // Check for ambiguous character patterns
    final ambiguousPatterns = ['l1', '0O', 'Il', 'rn', 'vv', 'nn'];
    for (final pattern in ambiguousPatterns) {
      if (text.toLowerCase().contains(pattern.toLowerCase())) {
        return true;
      }
    }

    return false;
  }

  /// Detect if text has mixed scripts (Latin + Chinese, etc.)
  bool _hasMixedScripts(String text) {
    final hasLatin = RegExp(r'[a-zA-Z]').hasMatch(text);
    final hasCJK = RegExp(
      r'[\u4E00-\u9FFF\u3040-\u309F\u30A0-\u30FF]',
    ).hasMatch(text);
    final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    final hasDevanagari = RegExp(r'[\u0900-\u097F]').hasMatch(text);

    int scriptCount = 0;
    if (hasLatin) scriptCount++;
    if (hasCJK) scriptCount++;
    if (hasArabic) scriptCount++;
    if (hasDevanagari) scriptCount++;

    return scriptCount > 1;
  }

  /// Calculate line confidence
  double _calculateLineConfidence(TextLine line) {
    double confidence = 0.80;

    final text = line.text.trim();

    // Very short text = low confidence
    if (text.length < 2) {
      confidence -= 0.25;
    } else if (text.length < 4)
      confidence -= 0.10;

    // Garbled patterns
    if (_hasGarbledPatterns(text)) confidence -= 0.30;

    // Recognizable patterns boost confidence
    if (_hasRecognizablePattern(text)) confidence += 0.15;

    // Handwriting penalty
    if (_looksLikeHandwriting(text)) confidence -= 0.20;

    return confidence.clamp(0.0, 1.0);
  }

  /// Check for recognizable patterns
  bool _hasRecognizablePattern(String text) {
    return _isEmail(text) || _isPhoneNumber(text) || _isUrl(text);
  }

  /// Calculate overall confidence from all blocks
  double _calculateOverallConfidence(List<EnhancedTextBlock> blocks) {
    if (blocks.isEmpty) return 0.0;

    double totalConfidence = 0.0;
    int totalWeight = 0;

    for (final block in blocks) {
      // Weight by text length (longer blocks = more important)
      final weight = (block.text.length / 10).ceil().clamp(1, 5);
      totalConfidence += block.confidence * weight;
      totalWeight += weight;
    }

    return (totalConfidence / totalWeight).clamp(0.0, 1.0);
  }

  /// Detect text type (name, email, phone, etc.)
  TextType _detectTextType(String text) {
    final trimmed = text.trim();

    if (_isEmail(trimmed)) return TextType.email;
    if (_isPhoneNumber(trimmed)) return TextType.phone;
    if (_isUrl(trimmed)) return TextType.url;
    if (_isName(trimmed)) return TextType.name;
    if (_isCompany(trimmed)) return TextType.company;
    if (_isAddress(trimmed)) return TextType.address;

    return TextType.other;
  }

  /// Detect language from text
  String _detectLanguage(String text) {
    if (text.isEmpty) return 'unknown';

    // Check for specific character sets
    if (RegExp(r'[\u0980-\u09FF]').hasMatch(text)) return 'Bengali';
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(text)) return 'Chinese';
    if (RegExp(r'[\u3040-\u309F]').hasMatch(text)) return 'Japanese (Hiragana)';
    if (RegExp(r'[\u30A0-\u30FF]').hasMatch(text)) return 'Japanese (Katakana)';
    if (RegExp(r'[\uAC00-\uD7AF]').hasMatch(text)) return 'Korean';
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) return 'Arabic';
    if (RegExp(r'[\u0900-\u097F]').hasMatch(text)) return 'Hindi/Sanskrit';
    if (RegExp(r'[a-zA-Z]').hasMatch(text)) return 'Latin-based';

    return 'Mixed/Unknown';
  }

  /// Helper methods
  bool _hasGarbledPatterns(String text) {
    final specialCharRatio =
        text.replaceAll(RegExp(r'[a-zA-Z0-9\s\.,@\-\(\)\+]'), '').length /
        (text.length + 1);
    return specialCharRatio > 0.3;
  }

  bool _isEmail(String text) {
    return RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(text.trim());
  }

  bool _isPhoneNumber(String text) {
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  bool _isUrl(String text) {
    return text.contains('www.') ||
        text.contains('http') ||
        RegExp(r'^\w+\.\w{2,}\.\w{2,}$').hasMatch(text.trim());
  }

  bool _isName(String text) {
    // Name heuristics: Capitalized words, 2-4 words, no numbers
    if (RegExp(r'\d').hasMatch(text)) return false;
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.length > 4) return false;
    return words.every((w) => w.isNotEmpty && w[0] == w[0].toUpperCase());
  }

  bool _isCompany(String text) {
    // Company heuristics: Contains Inc, Ltd, Corp, LLC, etc.
    final companyIndicators = [
      'inc',
      'ltd',
      'corp',
      'llc',
      'co',
      'pvt',
      'limited',
    ];
    final lower = text.toLowerCase();
    return companyIndicators.any((indicator) => lower.contains(indicator));
  }

  bool _isAddress(String text) {
    // Address heuristics: Contains street, road, city indicators
    final addressIndicators = [
      'street',
      'road',
      'avenue',
      'st',
      'rd',
      'ave',
      'city',
      'zip',
    ];
    final lower = text.toLowerCase();
    return addressIndicators.any((indicator) => lower.contains(indicator)) ||
        RegExp(r'\d+\s+\w+').hasMatch(text); // Number followed by word
  }

  /// Dispose resources
  void dispose() {
    _textRecognizer?.close();
    _barcodeScanner?.close();
    _textRecognizer = null;
    _barcodeScanner = null;
  }
}

/// Enhanced OCR Result with confidence and QR data
class EnhancedOcrResult {
  final String rawText;
  final List<EnhancedTextBlock> blocks;
  final List<BarcodeResult> barcodes;
  final double overallConfidence;
  final String detectedLanguage;
  final bool shouldAutoSave;
  final bool success;
  final String? error;

  const EnhancedOcrResult({
    required this.rawText,
    required this.blocks,
    required this.barcodes,
    required this.overallConfidence,
    required this.detectedLanguage,
    required this.shouldAutoSave,
    required this.success,
    this.error,
  });

  /// Get high confidence blocks only
  List<EnhancedTextBlock> get highConfidenceBlocks =>
      blocks.where((b) => b.confidence >= 0.75).toList();

  /// Get low confidence blocks (need review)
  List<EnhancedTextBlock> get lowConfidenceBlocks =>
      blocks.where((b) => b.confidence < 0.75).toList();

  /// Has any QR/barcode data
  bool get hasQrData => barcodes.isNotEmpty;

  /// Get contact info from QR if available
  BarcodeContactInfo? get qrContactInfo {
    if (barcodes.isEmpty) return null;
    try {
      return barcodes.firstWhere((b) => b.contactInfo != null).contactInfo;
    } catch (_) {
      return null;
    }
  }
}

/// Enhanced text block with confidence
class EnhancedTextBlock {
  final String text;
  final double confidence;
  final List<EnhancedTextLine> lines;

  const EnhancedTextBlock({
    required this.text,
    required this.confidence,
    required this.lines,
  });

  /// Confidence level description
  String get confidenceLevel {
    if (confidence >= 0.90) return 'Very High';
    if (confidence >= 0.75) return 'High';
    if (confidence >= 0.60) return 'Medium';
    if (confidence >= 0.40) return 'Low';
    return 'Very Low';
  }

  /// Should highlight for review
  bool get needsReview => confidence < 0.75;
}

/// Enhanced text line with type detection
class EnhancedTextLine {
  final String text;
  final double confidence;
  final TextType recognizedType;

  const EnhancedTextLine({
    required this.text,
    required this.confidence,
    required this.recognizedType,
  });
}

/// Text type enumeration
enum TextType { name, email, phone, url, company, address, other }

/// Barcode/QR scan result
class BarcodeResult {
  final BarcodeType type;
  final String rawValue;
  final String displayValue;
  final BarcodeFormat format;
  final BarcodeContactInfo? contactInfo;

  const BarcodeResult({
    required this.type,
    required this.rawValue,
    required this.displayValue,
    required this.format,
    this.contactInfo,
  });

  bool get isContactInfo => type == BarcodeType.contactInfo;
  bool get isUrl => type == BarcodeType.url;
}

/// Contact info from barcode
class BarcodeContactInfo {
  final String name;
  final List<String> phones;
  final List<String> emails;
  final String organization;
  final List<String> urls;
  final List<String> addresses;

  const BarcodeContactInfo({
    this.name = '',
    this.phones = const [],
    this.emails = const [],
    this.organization = '',
    this.urls = const [],
    this.addresses = const [],
  });

  bool get hasData =>
      name.isNotEmpty ||
      phones.isNotEmpty ||
      emails.isNotEmpty ||
      organization.isNotEmpty;
}

/// Provider for Enhanced OCR Service
final enhancedOcrServiceProvider = Provider<EnhancedOcrService>((ref) {
  final service = EnhancedOcrService();
  ref.onDispose(() => service.dispose());
  return service;
});
