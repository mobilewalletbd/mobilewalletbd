import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

/// Result of an image upload operation
class UploadResult {
  /// Whether the upload was successful
  final bool success;

  /// The public ID of the uploaded image (if successful)
  final String? publicId;

  /// The secure URL of the uploaded image (if successful)
  final String? secureUrl;

  /// The thumbnail URL (if generated)
  final String? thumbnailUrl;

  /// Error message (if failed)
  final String? errorMessage;

  /// Original file size in bytes
  final int? originalSize;

  /// Compressed file size in bytes
  final int? compressedSize;

  const UploadResult({
    required this.success,
    this.publicId,
    this.secureUrl,
    this.thumbnailUrl,
    this.errorMessage,
    this.originalSize,
    this.compressedSize,
  });

  /// Create a successful result
  factory UploadResult.success({
    required String publicId,
    required String secureUrl,
    String? thumbnailUrl,
    int? originalSize,
    int? compressedSize,
  }) {
    return UploadResult(
      success: true,
      publicId: publicId,
      secureUrl: secureUrl,
      thumbnailUrl: thumbnailUrl,
      originalSize: originalSize,
      compressedSize: compressedSize,
    );
  }

  /// Create a failed result
  factory UploadResult.failure(String errorMessage) {
    return UploadResult(success: false, errorMessage: errorMessage);
  }

  /// Get compression ratio as percentage
  double? get compressionRatio {
    if (originalSize == null || compressedSize == null || originalSize == 0) {
      return null;
    }
    return ((originalSize! - compressedSize!) / originalSize!) * 100;
  }
}

/// Service for interacting with Cloudinary for media storage.
///
/// Features:
/// - Image upload with unsigned uploads (using upload preset)
/// - JPEG compression (85% quality)
/// - Thumbnail generation
/// - Image transformation URL generation
class CloudinaryService {
  late final String _cloudName;
  late final String _uploadPreset;
  final _uuid = const Uuid();

  CloudinaryService() {
    _cloudName = dotenv.get('CLOUDINARY_CLOUD_NAME');
    _uploadPreset = dotenv.get('CLOUDINARY_UPLOAD_PRESET');
  }

  /// Upload an image file to Cloudinary with WebP compression
  ///
  /// [filePath] - Path to the local image file
  /// [folder] - Cloudinary folder to store the image (e.g., 'card-images', 'profile-photos')
  /// [generateThumbnail] - Whether to generate a thumbnail version
  ///
  /// Returns [UploadResult] with upload details or error information
  Future<UploadResult> uploadImage({
    required String filePath,
    String folder = 'uploads',
    bool generateThumbnail = true,
  }) async {
    try {
      // Read original file
      final file = File(filePath);
      if (!await file.exists()) {
        return UploadResult.failure('File not found: $filePath');
      }

      final originalBytes = await file.readAsBytes();
      final originalSize = originalBytes.length;

      // Compress image to JPEG (85% quality)
      final compressedBytes = await _compressImage(originalBytes);
      final compressedSize = compressedBytes.length;

      // Generate unique public ID
      final publicId = '${_uuid.v4()}_${_getTimestamp()}';

      // Prepare upload URL for unsigned upload
      final uploadUrl =
          'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add required fields for unsigned upload
      request.fields['upload_preset'] = _uploadPreset;
      request.fields['public_id'] = publicId;
      request.fields['folder'] = folder;
      // Let Cloudinary handle format optimization

      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          compressedBytes,
          filename: '$publicId.webp',
        ),
      );

      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);
        final secureUrl = jsonResponse['secure_url'] as String;
        final returnedPublicId = jsonResponse['public_id'] as String;

        // Generate thumbnail URL if requested
        String? thumbnailUrl;
        if (generateThumbnail) {
          thumbnailUrl = _generateThumbnailUrl(returnedPublicId);
        }

        return UploadResult.success(
          publicId: returnedPublicId,
          secureUrl: secureUrl,
          thumbnailUrl: thumbnailUrl,
          originalSize: originalSize,
          compressedSize: compressedSize,
        );
      } else {
        final error = jsonDecode(responseData);
        return UploadResult.failure(
          'Upload failed: ${error['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      return UploadResult.failure('Upload error: $e');
    }
  }

  /// Upload business card images (front and back) with thumbnails
  ///
  /// [frontImagePath] - Path to front card image
  /// [backImagePath] - Path to back card image (optional)
  ///
  /// Returns map with upload results for front and back images
  Future<Map<String, UploadResult>> uploadCardImages({
    required String frontImagePath,
    String? backImagePath,
  }) async {
    final results = <String, UploadResult>{};

    // Upload front image
    results['front'] = await uploadImage(
      filePath: frontImagePath,
      folder: 'card-images',
      generateThumbnail: true,
    );

    // Upload back image if provided
    if (backImagePath != null) {
      results['back'] = await uploadImage(
        filePath: backImagePath,
        folder: 'card-images',
        generateThumbnail: true,
      );
    }

    return results;
  }

  /// Upload profile photo with thumbnail
  ///
  /// [filePath] - Path to profile photo
  /// [userId] - User ID for organizing photos
  Future<UploadResult> uploadProfilePhoto({
    required String filePath,
    required String userId,
  }) async {
    return await uploadImage(
      filePath: filePath,
      folder: 'profile-photos/$userId',
      generateThumbnail: true,
    );
  }

  /// Compress image bytes to JPEG format with 85% quality
  /// Note: Using JPEG instead of WebP for better compatibility
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize if image is too large (max 1920px on longest side)
      img.Image resizedImage = image;
      const maxDimension = 1920;
      if (image.width > maxDimension || image.height > maxDimension) {
        resizedImage = img.copyResize(
          image,
          width: image.width > image.height ? maxDimension : null,
          height: image.height >= image.width ? maxDimension : null,
        );
      }

      // Encode to JPEG with 85% quality for good compression
      final jpegBytes = img.encodeJpg(resizedImage, quality: 85);

      return Uint8List.fromList(jpegBytes);
    } catch (e) {
      // If compression fails, return original bytes
      // This ensures the upload still works even if compression fails
      return bytes;
    }
  }

  /// Generate thumbnail transformation URL
  String _generateThumbnailUrl(String publicId) {
    // Cloudinary transformation for thumbnail
    // w_200: width 200px, h_200: height 200px, c_fill: crop to fill, q_auto: auto quality
    return 'https://res.cloudinary.com/$_cloudName/image/upload/w_200,h_200,c_fill,q_auto/$publicId.webp';
  }

  /// Generate a transformed image URL
  ///
  /// [publicId] - Cloudinary public ID
  /// [width] - Desired width
  /// [height] - Desired height
  /// [crop] - Crop mode (fill, fit, scale, etc.)
  /// [quality] - Quality setting (auto or 1-100)
  String getTransformedUrl({
    required String publicId,
    int? width,
    int? height,
    String crop = 'fill',
    String quality = 'auto',
  }) {
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('c_$crop');
    transformations.add('q_$quality');

    final transformString = transformations.join(',');
    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformString/$publicId.webp';
  }

  /// Delete an image from Cloudinary
  ///
  /// Note: This requires API key/secret (signed request)
  /// For now, we just mark for deletion - actual deletion happens via backend
  Future<bool> deleteImage(String publicId) async {
    // TODO: Implement server-side deletion with API secret
    // For security, image deletion should be done via backend
    // This is a placeholder for future implementation
    return false;
  }

  /// Get timestamp for unique IDs
  String _getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Check if Cloudinary is properly configured
  bool get isConfigured => _cloudName.isNotEmpty && _uploadPreset.isNotEmpty;
}

/// Provider for CloudinaryService
final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

/// Provider to check if Cloudinary is configured
final cloudinaryConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(cloudinaryServiceProvider).isConfigured;
});
