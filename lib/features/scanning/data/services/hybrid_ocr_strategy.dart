import 'dart:io';
import 'package:mobile_wallet/features/scanning/data/services/cloud_vision_service.dart';
import 'package:mobile_wallet/features/scanning/data/services/enhanced_ocr_service.dart';

extension CloudVisionIntegration on EnhancedOcrService {
  /// Process image with hybrid OCR strategy
  /// 1. Try ML Kit first (fast, offline)
  /// 2. If high Bangla content detected (>30%), use Cloud Vision
  /// 3. Merge results for best accuracy
  Future<EnhancedOcrResult> extractWithCloudVision(
    File imageFile,
    CloudVisionService? cloudVision,
  ) async {
    // First pass: ML Kit OCR
    final mlKitResult = await extractTextEnhanced(imageFile);

    // Check if Cloud Vision should be used
    if (cloudVision == null ||
        !CloudVisionService.shouldUseCloudVision(mlKitResult.rawText)) {
      return mlKitResult;
    }

    print(
      '🌐 [Cloud Vision] High Bangla content detected, using Cloud Vision API',
    );

    try {
      // Second pass: Cloud Vision for Bangla
      final cloudResult = await cloudVision.detectText(imageFile);

      if (!cloudResult.success) {
        print('⚠️ [Cloud Vision] API call failed, falling back to ML Kit');
        return mlKitResult;
      }

      // Merge results: use Cloud Vision text but keep ML Kit structure
      print('✅ [Cloud Vision] Successfully enhanced with Cloud Vision');
      return mlKitResult.copyWith(
        rawText: cloudResult.fullText.isNotEmpty
            ? cloudResult.fullText
            : mlKitResult.rawText,
        overallConfidence: 0.9, // Cloud Vision typically has high confidence
        detectedLanguage: 'bn', // Preferred for Bangla content
      );
    } catch (e) {
      print('❌ [Cloud Vision] Error: $e, falling back to ML Kit');
      return mlKitResult;
    }
  }
}

// Extension to add copyWith to EnhancedOcrResult
extension EnhancedOcrResultExt on EnhancedOcrResult {
  EnhancedOcrResult copyWith({
    String? rawText,
    double? overallConfidence,
    String? detectedLanguage,
  }) {
    return EnhancedOcrResult(
      rawText: rawText ?? this.rawText,
      blocks: blocks,
      barcodes: barcodes,
      overallConfidence: overallConfidence ?? this.overallConfidence,
      detectedLanguage: detectedLanguage ?? this.detectedLanguage,
      shouldAutoSave: (overallConfidence ?? this.overallConfidence) >= 0.8,
      success: success,
      error: error,
    );
  }
}
