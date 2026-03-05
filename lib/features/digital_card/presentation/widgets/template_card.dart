// Template Card Widget
// Displays a single card template with preview

import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/theme/app_colors.dart';
import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';

/// Template card widget for displaying card templates
class TemplateCard extends StatelessWidget {
  final CardTemplate template;
  final VoidCallback? onTap;
  final bool isSelected;

  const TemplateCard({
    super.key,
    required this.template,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightGray,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryGreen.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Template preview
            Expanded(
              flex: 3,
              child: _buildPreview(),
            ),
            // Template info
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  /// Build template preview
  Widget _buildPreview() {
    return Container(
      decoration: BoxDecoration(
        color: template.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern if enabled
          if (template.hasBackgroundPattern) _buildBackgroundPattern(),
          
          // Preview content
          Center(
            child: Padding(
              padding: EdgeInsets.all(template.contentPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: _getAlignment(template.nameAlignment),
                children: [
                  // Name placeholder
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontFamily: template.fontFamily,
                      fontSize: template.nameFontSize * 0.5, // Scaled for preview
                      fontWeight: template.nameFontWeight,
                      color: template.primaryColor,
                    ),
                    textAlign: _getTextAlign(template.nameAlignment),
                  ),
                  SizedBox(height: template.elementSpacing * 0.5),
                  // Title placeholder
                  Text(
                    'Job Title',
                    style: TextStyle(
                      fontFamily: template.fontFamily,
                      fontSize: template.titleFontSize * 0.5,
                      fontWeight: template.titleFontWeight,
                      color: template.secondaryColor,
                    ),
                    textAlign: _getTextAlign(template.titleAlignment),
                  ),
                  SizedBox(height: template.elementSpacing),
                  // Contact info placeholder
                  Text(
                    'contact@email.com',
                    style: TextStyle(
                      fontFamily: template.fontFamily,
                      fontSize: template.bodyFontSize * 0.4,
                      color: template.textColor,
                    ),
                    textAlign: _getTextAlign(template.contactAlignment),
                  ),
                ],
              ),
            ),
          ),
          
          // Premium badge
          if (template.isPremium)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warmGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.star, size: 12, color: AppColors.white),
                    SizedBox(width: 4),
                    Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Selection indicator
          if (isSelected)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build background pattern
  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: CustomPaint(
          painter: PatternPainter(color: template.accentColor),
        ),
      ),
    );
  }

  /// Build template info section
  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  template.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (template.isBusinessSuitable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Business',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            template.categoryDisplayName,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  /// Get CrossAxisAlignment from TextAlignment
  CrossAxisAlignment _getAlignment(TextAlignment alignment) {
    switch (alignment) {
      case TextAlignment.left:
        return CrossAxisAlignment.start;
      case TextAlignment.center:
        return CrossAxisAlignment.center;
      case TextAlignment.right:
        return CrossAxisAlignment.end;
    }
  }

  /// Get TextAlign from TextAlignment
  TextAlign _getTextAlign(TextAlignment alignment) {
    switch (alignment) {
      case TextAlignment.left:
        return TextAlign.left;
      case TextAlignment.center:
        return TextAlign.center;
      case TextAlignment.right:
        return TextAlign.right;
    }
  }
}

/// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw simple diagonal lines pattern
    final spacing = 20.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
