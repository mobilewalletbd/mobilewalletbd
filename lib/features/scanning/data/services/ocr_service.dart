// OCR Service using Google ML Kit
// Extracts text from images using on-device text recognition

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Service for extracting text from images using Google ML Kit
class OcrService {
  TextRecognizer? _textRecognizer;

  /// Initialize the text recognizer
  void _ensureInitialized() {
    _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
  }

  /// Extract text from an image file
  ///
  /// Returns the recognized text as a string
  Future<OcrResult> extractText(File imageFile) async {
    _ensureInitialized();

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer!.processImage(inputImage);

      return _processRecognizedText(recognizedText);
    } catch (e) {
      print('Error processing image: $e');
      return OcrResult(
        rawText: '',
        blocks: [],
        success: false,
        error: e.toString(),
      );
    }
  }

  OcrResult _processRecognizedText(RecognizedText visionText) {
    final blocks = <TextBlockResult>[];
    final lines = <String>[];

    for (final block in visionText.blocks) {
      String blockText = block.text;

      // Check if block contains Bangla script
      final hasBangla = detectBanglaScript(blockText);

      // Normalize Bangla numbers to English for phone/numeric extraction
      if (hasBangla) {
        blockText = normalizeBanglaNumbers(blockText);
      }

      final blockLines = <TextLineResult>[];
      for (final line in block.lines) {
        String lineText = line.text;

        // Normalize Bangla numbers in line text
        if (hasBangla) {
          lineText = normalizeBanglaNumbers(lineText);
        }

        blockLines.add(
          TextLineResult(
            text: lineText,
            confidence: _calculateLineConfidence(line),
          ),
        );
        lines.add(lineText);
      }

      blocks.add(
        TextBlockResult(
          text: blockText,
          lines: blockLines,
          confidence: _calculateBlockConfidence(block),
        ),
      );
    }

    final fullText = lines.join('\n');

    return OcrResult(rawText: fullText, blocks: blocks, success: true);
  }

  /// Calculate confidence for a text block
  /// ML Kit doesn't provide direct confidence scores, so we estimate
  double _calculateBlockConfidence(TextBlock block) {
    // Base confidence on number of recognized elements
    // This is a heuristic since ML Kit doesn't expose confidence directly
    double confidence = 0.8; // Base confidence

    // Adjust based on text characteristics
    final text = block.text;

    // More lines usually means better recognition
    if (block.lines.length >= 2) {
      confidence += 0.05;
    }

    // Check for garbled text patterns
    if (_hasGarbledPatterns(text)) {
      confidence -= 0.3;
    }

    // Check for reasonable length
    if (text.length < 2) {
      confidence -= 0.2;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Calculate confidence for a text line
  double _calculateLineConfidence(TextLine line) {
    double confidence = 0.85;

    final text = line.text;

    // Penalize very short text
    if (text.length < 3) {
      confidence -= 0.1;
    }

    // Penalize text with unusual characters
    if (_hasGarbledPatterns(text)) {
      confidence -= 0.25;
    }

    // Boost for recognizable patterns
    if (_isEmail(text) || _isPhoneNumber(text) || _isUrl(text)) {
      confidence += 0.1;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Check for patterns indicating poor OCR
  bool _hasGarbledPatterns(String text) {
    // Check for excessive special characters
    final specialCharRatio =
        text.replaceAll(RegExp(r'[a-zA-Z0-9\s\.,@\-\(\)]'), '').length /
        (text.length + 1);
    if (specialCharRatio > 0.3) return true;

    // Check for unlikely character sequences
    if (RegExp(r'[^a-zA-Z]{5,}').hasMatch(text.replaceAll(RegExp(r'\d'), ''))) {
      return true;
    }

    return false;
  }

  /// Check if text looks like an email
  bool _isEmail(String text) {
    return RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(text.trim());
  }

  /// Check if text looks like a phone number
  bool _isPhoneNumber(String text) {
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  /// Check if text looks like a URL
  bool _isUrl(String text) {
    return text.contains('www.') ||
        text.contains('http') ||
        RegExp(r'^\w+\.\w+\.\w+$').hasMatch(text.trim());
  }

  /// Detect if text contains Bangla script
  /// Returns true if more than 20% of characters are in Bangla unicode range
  bool detectBanglaScript(String text) {
    if (text.isEmpty) return false;

    int banglaCharCount = 0;
    final banglaRange = RegExp(r'[\u0980-\u09FF]');

    for (int i = 0; i < text.length; i++) {
      if (banglaRange.hasMatch(text[i])) {
        banglaCharCount++;
      }
    }

    return (banglaCharCount / text.length) > 0.2;
  }

  /// Normalize Bangla numbers to English (০-৯ to 0-9)
  String normalizeBanglaNumbers(String text) {
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    String result = text;
    for (int i = 0; i < banglaDigits.length; i++) {
      result = result.replaceAll(banglaDigits[i], englishDigits[i]);
    }
    return result;
  }

  /// Dispose of resources
  void dispose() {
    _textRecognizer?.close();
    _textRecognizer = null;
  }
}

/// Result of OCR processing
class OcrResult {
  /// The complete raw text extracted
  final String rawText;

  /// Text blocks with structure preserved
  final List<TextBlockResult> blocks;

  /// Whether OCR was successful
  final bool success;

  /// Error message if failed
  final String? error;

  const OcrResult({
    required this.rawText,
    required this.blocks,
    required this.success,
    this.error,
  });

  /// Get all lines as a flat list
  List<TextLineResult> get allLines =>
      blocks.expand((block) => block.lines).toList();

  /// Get lines sorted by estimated confidence
  List<TextLineResult> get linesByConfidence {
    final lines = allLines;
    lines.sort((a, b) => b.confidence.compareTo(a.confidence));
    return lines;
  }
}

/// Represents a text block from OCR
class TextBlockResult {
  final String text;
  final double confidence;
  final List<TextLineResult> lines;

  const TextBlockResult({
    required this.text,
    required this.confidence,
    required this.lines,
  });
}

/// Represents a text line from OCR
class TextLineResult {
  final String text;
  final double confidence;

  const TextLineResult({required this.text, required this.confidence});
}

/// Provider for OcrService
final ocrServiceProvider = Provider<OcrService>((ref) {
  final service = OcrService();
  ref.onDispose(() => service.dispose());
  return service;
});
