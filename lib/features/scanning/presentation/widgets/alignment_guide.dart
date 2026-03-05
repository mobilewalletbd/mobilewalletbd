// Card Alignment Guide Widget
// Shows the alignment frame with corner markers for business card scanning

import 'package:flutter/material.dart';

import 'package:mobile_wallet/core/theme/app_colors.dart';

/// Alignment guide overlay for business card scanning
/// Shows a frame with corner markers
class CardAlignmentGuide extends StatelessWidget {
  const CardAlignmentGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _AlignmentGuidePainter(), child: Container());
  }
}

class _AlignmentGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw dashed border
    _drawDashedRect(canvas, size, paint);

    // Draw corner markers
    _drawCornerMarkers(canvas, size);
  }

  void _drawDashedRect(Canvas canvas, Size size, Paint paint) {
    const dashWidth = 10.0;
    const dashSpace = 8.0;

    // Top edge
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0, size.width), 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Bottom edge
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset((startX + dashWidth).clamp(0, size.width), size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left edge
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, (startY + dashWidth).clamp(0, size.height)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Right edge
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, (startY + dashWidth).clamp(0, size.height)),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  void _drawCornerMarkers(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const markerSize = 24.0;

    // Top-left corner
    canvas.drawLine(const Offset(0, 0), const Offset(markerSize, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, markerSize), paint);

    // Top-right corner
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - markerSize, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, markerSize),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(0, size.height),
      Offset(markerSize, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - markerSize),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - markerSize, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - markerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Confidence indicator for OCR fields
class ConfidenceIndicator extends StatelessWidget {
  final double confidence;
  final double size;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    if (confidence >= 0.8) {
      color = AppColors.primaryGreen;
      icon = Icons.circle;
    } else if (confidence >= 0.5) {
      color = AppColors.warmGold;
      icon = Icons.contrast;
    } else {
      color = AppColors.coralAccent;
      icon = Icons.circle_outlined;
    }

    return Icon(icon, size: size, color: color);
  }
}

/// Scanning instruction card
class ScanInstructionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const ScanInstructionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
