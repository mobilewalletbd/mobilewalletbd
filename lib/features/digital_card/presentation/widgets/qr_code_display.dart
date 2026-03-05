// QR Code Display Widget
// Displays generated QR code for digital card

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Widget for displaying QR code
class QrCodeDisplay extends StatelessWidget {
  final VoidCallback onGenerate;
  final Uint8List? qrImage;
  final bool isGenerating;

  const QrCodeDisplay({
    super.key,
    required this.onGenerate,
    this.qrImage,
    this.isGenerating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isGenerating)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (qrImage != null)
              _buildQrImage()
            else
              _buildGeneratePrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildQrImage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            qrImage!,
            height: 200,
            width: 200,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Scan to add contact',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildGeneratePrompt() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code,
            size: 64,
            color: AppColors.primaryGreen.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Generate QR Code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a scannable QR code\nfor your digital card',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onGenerate,
            icon: const Icon(Icons.qr_code),
            label: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}
