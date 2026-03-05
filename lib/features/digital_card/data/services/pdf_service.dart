// PDF Service
// Generates PDF versions of digital business cards

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/card_design.dart';
import '../../domain/entities/card_template.dart';
import '../../domain/failures/card_design_failure.dart';

/// Service for generating PDF business cards
class PdfService {
  /// Generate a PDF business card
  Future<Uint8List> generateCardPdf({
    required CardDesign cardDesign,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) async {
    try {
      final pdf = pw.Document();
      final themeColor = _hexToPdfColor(cardDesign.themeColor);
      final templateId = cardDesign.frontCardTemplateId ?? 'minimalist-white';
      final template =
          PredefinedTemplates.getById(templateId) ??
          PredefinedTemplates.all.first;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildCardLayout(
              context: context,
              cardDesign: cardDesign,
              template: template,
              themeColor: themeColor,
              name: name,
              phone: phone,
              email: email,
              company: company,
              jobTitle: jobTitle,
              website: website,
              address: address,
              logoBytes: logoBytes,
            );
          },
        ),
      );

      return await pdf.save();
    } catch (e) {
      throw CardDesignFailure.pdfGenerationFailed(e);
    }
  }

  /// Batch export multiple cards as a single PDF file (multi-page)
  Future<void> batchExportPdfs({
    required List<CardDesign> designs,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) async {
    try {
      final pdf = pw.Document();

      for (final design in designs) {
        final themeColor = _hexToPdfColor(design.themeColor);
        final templateId = design.frontCardTemplateId ?? 'minimalist-white';
        final template =
            PredefinedTemplates.getById(templateId) ??
            PredefinedTemplates.all.first;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return _buildCardLayout(
                context: context,
                cardDesign: design,
                template: template,
                themeColor: themeColor,
                name: name,
                phone: phone,
                email: email,
                company: company,
                jobTitle: jobTitle,
                website: website,
                address: address,
                logoBytes: logoBytes,
              );
            },
          ),
        );
      }

      final pdfBytes = await pdf.save();

      final tempDir = await getTemporaryDirectory();
      final fileName = '${_sanitizeFileName(name)}_batch.pdf';
      final filePath = '${tempDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'Business Cards: $name (${designs.length} designs)');
    } catch (e) {
      throw CardDesignFailure.pdfGenerationFailed(e);
    }
  }

  /// Build card layout based on template style
  pw.Widget _buildCardLayout({
    required pw.Context context,
    required CardDesign cardDesign,
    required CardTemplate template,
    required PdfColor themeColor,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) {
    // Filter fields based on card visibility settings
    final visible = cardDesign.visibleFields;
    final displayPhone = (visible['phone'] ?? true) ? phone : null;
    final displayEmail = (visible['email'] ?? true) ? email : null;
    final displayCompany = (visible['companyName'] ?? true) ? company : null;
    final displayJobTitle = (visible['jobTitle'] ?? true) ? jobTitle : null;
    final displayWebsite = (visible['website'] ?? false) ? website : null;
    final displayAddress = (visible['address'] ?? false) ? address : null;

    switch (template.layoutStyle) {
      case LayoutStyle.split:
      case LayoutStyle.asymmetric:
        return _buildModernLayout(
          cardDesign: cardDesign,
          template: template,
          name: name,
          phone: displayPhone,
          email: displayEmail,
          company: displayCompany,
          jobTitle: displayJobTitle,
          website: displayWebsite,
          address: displayAddress,
          logoBytes: logoBytes,
        );
      case LayoutStyle.leftAligned:
      case LayoutStyle.centered:
      default:
        return _buildClassicLayout(
          cardDesign: cardDesign,
          template: template,
          name: name,
          phone: displayPhone,
          email: displayEmail,
          company: displayCompany,
          jobTitle: displayJobTitle,
          website: displayWebsite,
          address: displayAddress,
          logoBytes: logoBytes,
        );
    }
  }

  /// Classic layout - Traditional professional design
  pw.Widget _buildClassicLayout({
    required CardDesign cardDesign,
    required CardTemplate template,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) {
    final bgColor = PdfColor.fromInt(template.backgroundColor.value);
    final primaryColor = PdfColor.fromInt(template.primaryColor.value);
    final textColor = PdfColor.fromInt(template.textColor.value);

    pw.BoxDecoration decoration = pw.BoxDecoration(color: bgColor);

    // Add gradient if available and enabled
    if (cardDesign.enableGradient &&
        template.backgroundGradient != null &&
        template.backgroundGradient!.length > 1) {
      decoration = pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: template.backgroundGradient!
              .map((c) => PdfColor.fromInt(c.value))
              .toList(),
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
      );
    }

    return pw.Container(
      padding: pw.EdgeInsets.all(template.contentPadding),
      decoration: decoration,
      child: pw.Column(
        crossAxisAlignment: template.nameAlignment == TextAlignment.center
            ? pw.CrossAxisAlignment.center
            : pw.CrossAxisAlignment.start,
        children: [
          if (logoBytes != null && template.showLogo)
            pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50),
          pw.SizedBox(height: template.elementSpacing),
          pw.Text(
            name,
            style: pw.TextStyle(
              fontSize: template.nameFontSize,
              color: primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (jobTitle != null && jobTitle.isNotEmpty)
            pw.Text(
              jobTitle,
              style: pw.TextStyle(
                fontSize: template.titleFontSize,
                color: textColor,
              ),
            ),
          if (company != null && company.isNotEmpty)
            pw.Text(
              company,
              style: pw.TextStyle(
                fontSize: template.titleFontSize,
                color: primaryColor,
              ),
            ),
          pw.Divider(color: primaryColor),
          pw.SizedBox(height: template.elementSpacing),

          if (phone != null && phone.isNotEmpty)
            pw.Text(
              '📞 $phone',
              style: pw.TextStyle(
                fontSize: template.bodyFontSize,
                color: textColor,
              ),
            ),
          if (email != null && email.isNotEmpty)
            pw.Text(
              '✉ $email',
              style: pw.TextStyle(
                fontSize: template.bodyFontSize,
                color: textColor,
              ),
            ),
          if (website != null && website.isNotEmpty)
            pw.Text(
              '🌐 $website',
              style: pw.TextStyle(
                fontSize: template.bodyFontSize,
                color: textColor,
              ),
            ),
          if (address != null && address.isNotEmpty)
            pw.Text(
              '📍 $address',
              style: pw.TextStyle(
                fontSize: template.bodyFontSize,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }

  /// Modern layout - Contemporary bold design
  pw.Widget _buildModernLayout({
    required CardDesign cardDesign,
    required CardTemplate template,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) {
    final bgColor = PdfColor.fromInt(template.backgroundColor.value);
    final primaryColor = PdfColor.fromInt(template.primaryColor.value);
    final textColor = PdfColor.fromInt(template.textColor.value);

    pw.BoxDecoration decoration = pw.BoxDecoration(color: bgColor);

    // Add gradient if available and enabled
    if (cardDesign.enableGradient &&
        template.backgroundGradient != null &&
        template.backgroundGradient!.length > 1) {
      decoration = pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: template.backgroundGradient!
              .map((c) => PdfColor.fromInt(c.value))
              .toList(),
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
        ),
      );
    }

    return pw.Container(
      padding: pw.EdgeInsets.all(template.contentPadding),
      decoration: decoration,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (logoBytes != null && template.showLogo) ...[
                  pw.Image(pw.MemoryImage(logoBytes), width: 40, height: 40),
                  pw.SizedBox(height: 12),
                ],
                pw.Text(
                  name,
                  style: pw.TextStyle(
                    fontSize: template.nameFontSize,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                pw.SizedBox(height: 4),
                if (jobTitle != null && jobTitle.isNotEmpty)
                  pw.Text(
                    jobTitle,
                    style: pw.TextStyle(
                      fontSize: template.titleFontSize,
                      color: textColor,
                    ),
                  ),
                if (company != null && company.isNotEmpty)
                  pw.Text(
                    company,
                    style: pw.TextStyle(
                      fontSize: template.titleFontSize,
                      color: primaryColor,
                    ),
                  ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              if (phone != null && phone.isNotEmpty)
                pw.Text(
                  phone,
                  style: pw.TextStyle(
                    fontSize: template.bodyFontSize,
                    color: textColor,
                  ),
                ),
              pw.SizedBox(height: 4),
              if (email != null && email.isNotEmpty)
                pw.Text(
                  email,
                  style: pw.TextStyle(
                    fontSize: template.bodyFontSize,
                    color: textColor,
                  ),
                ),
              pw.SizedBox(height: 4),
              if (website != null && website.isNotEmpty)
                pw.Text(
                  website,
                  style: pw.TextStyle(
                    fontSize: template.bodyFontSize,
                    color: textColor,
                  ),
                ),
              pw.SizedBox(height: 4),
              if (address != null && address.isNotEmpty)
                pw.Text(
                  address,
                  style: pw.TextStyle(
                    fontSize: template.bodyFontSize,
                    color: textColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Generate and share PDF card
  Future<void> generateAndSharePdf({
    required CardDesign cardDesign,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) async {
    try {
      final pdfBytes = await generateCardPdf(
        cardDesign: cardDesign,
        name: name,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        website: website,
        address: address,
        logoBytes: logoBytes,
      );

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final fileName = '${_sanitizeFileName(name)}_card.pdf';
      final filePath = '${tempDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Share the file
      await Share.shareXFiles([XFile(filePath)], text: 'Business Card: $name');
    } catch (e) {
      throw CardDesignFailure.pdfGenerationFailed(e);
    }
  }

  /// Print PDF card
  Future<void> printPdf({
    required CardDesign cardDesign,
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    String? address,
    Uint8List? logoBytes,
  }) async {
    try {
      final pdfBytes = await generateCardPdf(
        cardDesign: cardDesign,
        name: name,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        website: website,
        address: address,
        logoBytes: logoBytes,
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } catch (e) {
      throw CardDesignFailure.pdfGenerationFailed(e);
    }
  }

  /// Convert hex color to PdfColor
  PdfColor _hexToPdfColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    final colorInt = int.parse(buffer.toString(), radix: 16);
    return PdfColor.fromInt(colorInt);
  }

  /// Sanitize file name
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
}

/// Provider for PdfService
final pdfServiceProvider = Provider<PdfService>((ref) {
  return PdfService();
});
