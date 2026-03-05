// Cloud Vision Service
// Google Cloud Vision API integration for enhanced Bangla OCR

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service for Google Cloud Vision API text detection
/// Specialized for Bangla script recognition
class CloudVisionService {
  final String apiKey;
  static const String _visionEndpoint =
      'https://vision.googleapis.com/v1/images:annotate';

  CloudVisionService({required this.apiKey});

  /// Detect text in image using Cloud Vision API
  /// Returns enhanced text with higher accuracy for Bangla
  Future<CloudVisionResult> detectText(File imageFile) async {
    try {
      // Read image and encode to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Build request payload
      final request = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [
              {'type': 'TEXT_DETECTION', 'maxResults': 50},
            ],
            // Language hints for better Bangla recognition
            'imageContext': {
              'languageHints': ['bn', 'en'], // Bengali + English
            },
          },
        ],
      };

      // Make API call
      final response = await http.post(
        Uri.parse('$_visionEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      if (response.statusCode != 200) {
        throw CloudVisionException(
          'API request failed: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      // Parse response
      final data = jsonDecode(response.body);
      final responses = data['responses'] as List;

      if (responses.isEmpty) {
        return CloudVisionResult(
          fullText: '',
          blocks: [],
          success: false,
          error: 'No text detected',
        );
      }

      final firstResponse = responses[0];

      // Check for errors
      if (firstResponse.containsKey('error')) {
        final error = firstResponse['error'];
        throw CloudVisionException(
          error['message'] ?? 'Unknown error',
          statusCode: error['code'],
        );
      }

      // Extract text annotations
      final textAnnotations = firstResponse['textAnnotations'] as List?;

      if (textAnnotations == null || textAnnotations.isEmpty) {
        return CloudVisionResult(
          fullText: '',
          blocks: [],
          success: false,
          error: 'No text annotations found',
        );
      }

      // First annotation is the full text
      final fullText = textAnnotations[0]['description'] as String;

      // Parse text blocks (skip first as it's the full text)
      final blocks = <CloudVisionBlock>[];
      for (var i = 1; i < textAnnotations.length; i++) {
        final annotation = textAnnotations[i];
        blocks.add(
          CloudVisionBlock(
            text: annotation['description'] as String,
            confidence: _extractConfidence(annotation),
            locale: annotation['locale'] as String?,
          ),
        );
      }

      return CloudVisionResult(
        fullText: fullText,
        blocks: blocks,
        success: true,
      );
    } on CloudVisionException {
      rethrow;
    } catch (e) {
      debugPrint('Cloud Vision error: $e');
      return CloudVisionResult(
        fullText: '',
        blocks: [],
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Extract confidence from annotation
  /// Cloud Vision doesn't always provide confidence, estimate from bounding box
  double _extractConfidence(Map<String, dynamic> annotation) {
    // If confidence is provided, use it
    if (annotation.containsKey('confidence')) {
      return (annotation['confidence'] as num).toDouble();
    }

    // Otherwise, estimate based on bounding poly presence
    final boundingPoly = annotation['boundingPoly'];
    if (boundingPoly != null && boundingPoly['vertices'] != null) {
      return 0.85; // High confidence if bounding box is well-defined
    }

    return 0.7; // Default medium confidence
  }

  /// Check if Cloud Vision should be used for this image
  /// Based on Bangla script detection percentage
  static bool shouldUseCloudVision(String mlKitText) {
    if (mlKitText.isEmpty) return false;

    // Count Bangla characters
    final banglaCount = mlKitText.runes.where((rune) {
      return rune >= 0x0980 && rune <= 0x09FF; // Bangla unicode range
    }).length;

    final totalChars = mlKitText.length;
    if (totalChars == 0) return false;

    final banglaPercentage = banglaCount / totalChars;

    // Use Cloud Vision if >30% Bangla content
    return banglaPercentage > 0.3;
  }
}

/// Result from Cloud Vision API
class CloudVisionResult {
  final String fullText;
  final List<CloudVisionBlock> blocks;
  final bool success;
  final String? error;

  CloudVisionResult({
    required this.fullText,
    required this.blocks,
    required this.success,
    this.error,
  });
}

/// Text block from Cloud Vision
class CloudVisionBlock {
  final String text;
  final double confidence;
  final String? locale;

  CloudVisionBlock({required this.text, required this.confidence, this.locale});
}

/// Cloud Vision API exception
class CloudVisionException implements Exception {
  final String message;
  final int? statusCode;

  CloudVisionException(this.message, {this.statusCode});

  @override
  String toString() => 'CloudVisionException: $message (code: $statusCode)';
}
