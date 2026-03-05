// Card Image Export Service
// Exports digital card as PNG/JPG image for sharing

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/failures/card_design_failure.dart';

/// Service for exporting digital card as image
class CardImageExportService {
  /// Export card as image (PNG only) and share via system share sheet.
  ///
  /// BUG-02 FIX: Flutter dart:ui has no native JPEG encoder, so we always
  /// produce PNG. The [asPng] argument is kept for API compatibility but
  /// currently both branches produce PNG. JPEG support can be added via
  /// the 'image' package when needed.
  Future<void> exportAndShareImage({
    required GlobalKey key,
    required String cardName,
    bool asPng = true,
  }) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw const CardDesignFailure(
          type: CardDesignFailureType.unknown,
          message: 'Could not find card boundary for export',
        );
      }

      // Capture image at 3× pixel ratio for crisp export
      final image = await boundary.toImage(pixelRatio: 3.0);
      // BUG-02 FIX: Always PNG — dart:ui has no JPEG encoder
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw const CardDesignFailure(
          type: CardDesignFailureType.unknown,
          message: 'Failed to generate image data',
        );
      }

      final bytes = byteData.buffer.asUint8List();

      // Always save as PNG regardless of asPng flag (see BUG-02 fix above)
      final tempDir = await getTemporaryDirectory();
      final fileName = '${_sanitizeFileName(cardName)}.png';
      final filePath = '${tempDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(filePath)], text: 'My Digital Card');
    } catch (e) {
      if (e is CardDesignFailure) rethrow;
      throw CardDesignFailure(
        type: CardDesignFailureType.unknown,
        message: 'Failed to export card image: $e',
      );
    }
  }

  /// Sanitize file name
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
}

/// Provider for CardImageExportService
final cardImageExportServiceProvider = Provider<CardImageExportService>((ref) {
  return CardImageExportService();
});
