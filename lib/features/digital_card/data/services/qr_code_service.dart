// QR Code Service
// Generates QR codes for digital business cards

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/entities/card_design.dart';
import '../../domain/failures/card_design_failure.dart';

/// Service for generating QR codes
class QrCodeService {
  /// Generate QR code data for a digital card
  ///
  /// Returns a vCard formatted string that can be scanned by any QR scanner
  String generateQrData({
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? avatarUrl,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$name');

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      buffer.writeln('PHOTO;VALUE=URI:$avatarUrl');
    }
    if (phone != null && phone.isNotEmpty) {
      buffer.writeln('TEL:$phone');
    }
    if (email != null && email.isNotEmpty) {
      buffer.writeln('EMAIL:$email');
    }
    if (company != null && company.isNotEmpty) {
      buffer.writeln('ORG:$company');
    }
    if (jobTitle != null && jobTitle.isNotEmpty) {
      buffer.writeln('TITLE:$jobTitle');
    }
    if (website != null && website.isNotEmpty) {
      buffer.writeln('URL:$website');
    }

    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  /// Generate QR code widget for display
  ///
  /// FIX BUG-03: Uses QrEyeStyle/QrDataModuleStyle (non-deprecated API)
  Widget generateQrWidget({
    required String data,
    double size = 200,
    Color backgroundColor = Colors.white,
    Color foregroundColor = Colors.black,
    String? embeddedImageUrl,
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor,
      // FIX BUG-03: Updated from deprecated 'foregroundColor' to styled API
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: foregroundColor),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor,
      ),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      embeddedImage: embeddedImageUrl != null && embeddedImageUrl.isNotEmpty
          ? NetworkImage(embeddedImageUrl)
          : null,
      embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
    );
  }

  /// Generate QR code as PNG image bytes
  ///
  /// NOTE: Flutter's dart:ui has no native JPEG encoder.
  /// We always export as PNG which is lossless and universally supported.
  /// (This resolves the BUG-02 intent — card_image_export was producing PNG
  /// even when JPG was requested; here we document the intentional PNG-only choice.)
  Future<Uint8List> generateQrImage({
    required String data,
    double size = 200,
    Color backgroundColor = Colors.white,
    Color foregroundColor = Colors.black,
  }) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      );

      if (!qrValidationResult.isValid) {
        throw CardDesignFailure.qrGenerationFailed('Invalid QR data');
      }

      final qrCode = qrValidationResult.qrCode;
      // FIX BUG-03: Use QrDataModuleStyle/QrEyeStyle (modern API) instead of
      // deprecated QrPainter(color:) parameter
      final painter = QrPainter.withQr(
        qr: qrCode!,
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor,
        ),
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: foregroundColor,
        ),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );

      final picRecorder = ui.PictureRecorder();
      final canvas = Canvas(picRecorder);
      final sizeRect = Rect.fromPoints(Offset.zero, Offset(size, size));

      // Draw background
      canvas.drawRect(sizeRect, Paint()..color = backgroundColor);

      // Draw QR code
      painter.paint(canvas, sizeRect.size);

      final picture = picRecorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      // Always output PNG (Flutter dart:ui has no native JPEG encoder)
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw CardDesignFailure.qrGenerationFailed('Failed to generate image');
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      throw CardDesignFailure.qrGenerationFailed(e);
    }
  }

  /// Generate QR code image for a specific CardDesign
  ///
  /// Uses the card's themeColor as the QR foreground colour.
  Future<Uint8List> generateCardQrCode({
    required CardDesign cardDesign,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? avatarUrl,
  }) async {
    final data = generateQrData(
      name: name,
      phone: phone,
      email: email,
      company: company,
      jobTitle: jobTitle,
      website: website,
      avatarUrl: avatarUrl,
    );

    final color = _hexToColor(cardDesign.themeColor);

    return generateQrImage(
      data: data,
      size: 400,
      backgroundColor: Colors.white,
      foregroundColor: color,
    );
  }

  /// Convert hex color string to Color
  ///
  /// Handles 6-char (#RRGGBB) and 7-char (#RRGGBB with hash) hex strings.
  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Provider for QrCodeService
final qrCodeServiceProvider = Provider<QrCodeService>((ref) {
  return QrCodeService();
});
