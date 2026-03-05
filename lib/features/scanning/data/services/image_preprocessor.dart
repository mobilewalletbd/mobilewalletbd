import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ImagePreprocessor
final imagePreprocessorProvider = Provider<ImagePreprocessor>((ref) {
  return ImagePreprocessor();
});

/// Service for preprocessing images before OCR
/// Includes blur detection, light level estimation, and enhancement
class ImagePreprocessor {
  /// Check if an image is too blurry for OCR
  /// Uses Laplacian variance method
  /// Returns true if blur score is below threshold
  Future<bool> isImageBlurry(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return true;

      // Convert to grayscale for analysis
      final gray = img.grayscale(image);

      // Calculate Laplacian variance
      final variance = _calculateLaplacianVariance(gray);

      // Threshold: < 100 is considered blurry
      // This value can be tuned based on testing
      return variance < 100.0;
    } catch (e) {
      print('Error checking blur: $e');
      return true; // Assume blurry on error
    }
  }

  /// Estimate light level in the image
  /// Returns average pixel brightness (0-255)
  Future<int> estimateLightLevel(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return 0;

      // Convert to grayscale
      final gray = img.grayscale(image);

      // Calculate average pixel value
      int total = 0;
      int count = 0;

      for (int y = 0; y < gray.height; y++) {
        for (int x = 0; x < gray.width; x++) {
          final pixel = gray.getPixel(x, y);
          total += pixel.r.toInt(); // In grayscale, r=g=b
          count++;
        }
      }

      return count > 0 ? (total / count).round() : 0;
    } catch (e) {
      print('Error estimating light level: $e');
      return 0;
    }
  }

  /// Enhance image contrast using CLAHE-like algorithm
  /// (Simplified version for performance)
  Future<File> enhanceContrast(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return imageFile;

      // Apply contrast adjustment
      final enhanced = img.adjustColor(
        image,
        contrast: 1.3, // 30% contrast boost
        brightness: 1.1, // Slight brightness boost
      );

      // Save to temporary file
      final tempDir = imageFile.parent;
      final tempPath =
          '${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      await tempFile.writeAsBytes(img.encodeJpg(enhanced, quality: 90));

      return tempFile;
    } catch (e) {
      print('Error enhancing contrast: $e');
      return imageFile; // Return original on error
    }
  }

  /// Detect and correct image skew
  /// Simplified implementation - full Hough transform would be more complex
  Future<File> deskewImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return imageFile;

      // Detect skew angle (simplified)
      final angle = _estimateSkewAngle(image);

      // Only rotate if skew is significant (> 2 degrees)
      if (angle.abs() < 2.0) {
        return imageFile; // No correction needed
      }

      // Rotate to correct skew
      final corrected = img.copyRotate(image, angle: -angle);

      // Save to temporary file
      final tempDir = imageFile.parent;
      final tempPath =
          '${tempDir.path}/deskewed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      await tempFile.writeAsBytes(img.encodeJpg(corrected, quality: 90));

      return tempFile;
    } catch (e) {
      print('Error deskewing image: $e');
      return imageFile; // Return original on error
    }
  }

  /// Check if image likely has inverted colors (Dark card with light text)
  /// checks if average luminosity is low (< 100)
  Future<bool> isInvertedColor(File imageFile) async {
    final lightLevel = await estimateLightLevel(imageFile);
    return lightLevel < 90; // Threshold for dark background
  }

  /// Create an inverted color version of the image
  Future<File> invertColors(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return imageFile;

      // Invert colors
      img.invert(image);

      // Save to temporary file
      final tempDir = imageFile.parent;
      final tempPath =
          '${tempDir.path}/inverted_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      await tempFile.writeAsBytes(img.encodeJpg(image, quality: 90));

      return tempFile;
    } catch (e) {
      print('Error inverting colors: $e');
      return imageFile;
    }
  }

  /// Calculate Laplacian variance for blur detection
  double _calculateLaplacianVariance(img.Image grayImage) {
    // Simplified Laplacian kernel
    final kernel = [
      [0, 1, 0],
      [1, -4, 1],
      [0, 1, 0],
    ];

    final values = <double>[];

    // Apply kernel to sample of image (for performance)
    final sampleSize = 50; // Sample every 50th pixel
    for (int y = 1; y < grayImage.height - 1; y += sampleSize) {
      for (int x = 1; x < grayImage.width - 1; x += sampleSize) {
        double sum = 0.0;

        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final pixel = grayImage.getPixel(x + kx, y + ky);
            sum += pixel.r.toDouble() * kernel[ky + 1][kx + 1];
          }
        }

        values.add(sum);
      }
    }

    // Calculate variance
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
        values.length;

    return variance;
  }

  /// Estimate skew angle (simplified)
  /// Returns angle in degrees
  double _estimateSkewAngle(img.Image image) {
    // This is a very simplified version
    // A full implementation would use Hough line transform

    // For now, return 0 (no skew detected)
    // TODO: Implement proper Hough transform for production
    return 0.0;
  }

  /// Get image quality score (0-100)
  /// Combines blur, light level, and other factors
  Future<int> getQualityScore(File imageFile) async {
    int score = 100;

    // Check blur
    final isBlurry = await isImageBlurry(imageFile);
    if (isBlurry) score -= 30;

    // Check light level
    final lightLevel = await estimateLightLevel(imageFile);
    if (lightLevel < 50) {
      score -= 20; // Too dark
    } else if (lightLevel > 230) {
      score -= 15; // Too bright/overexposed
    }

    return score.clamp(0, 100);
  }
}
