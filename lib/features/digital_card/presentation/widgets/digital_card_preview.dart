// Digital Card Preview Widget
// Displays a preview of the digital business card

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';
import 'package:mobile_wallet/features/settings/domain/entities/user_profile.dart';
import '../../../settings/presentation/providers/user_profile_provider.dart';
import '../../domain/entities/card_design.dart';

/// Widget for previewing digital card designs
class DigitalCardPreview extends ConsumerWidget {
  final CardDesign cardDesign;
  final VoidCallback? onTap;
  final double height;

  const DigitalCardPreview({
    super.key,
    required this.cardDesign,
    this.onTap,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildCardContent(context, userProfile),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, UserProfile? userProfile) {
    // If a template is specified, use the dynamic layout
    if (cardDesign.frontCardTemplateId != null) {
      final template = PredefinedTemplates.getById(
        cardDesign.frontCardTemplateId!,
      );
      if (template != null) {
        return _DynamicCardLayout(
          cardDesign: cardDesign,
          template: template,
          userProfile: userProfile,
        );
      }
    }

    // Fallback to legacy layouts
    switch (cardDesign.layoutStyle) {
      case CardDesignLayout.modern:
        return _ModernCardLayout(
          cardDesign: cardDesign,
          userProfile: userProfile,
        );
      case CardDesignLayout.minimal:
        return _MinimalCardLayout(
          cardDesign: cardDesign,
          userProfile: userProfile,
        );
      case CardDesignLayout.classic:
        return _ClassicCardLayout(
          cardDesign: cardDesign,
          userProfile: userProfile,
        );
    }
  }
}

class _DynamicCardLayout extends StatelessWidget {
  final CardDesign cardDesign;
  final CardTemplate template;
  final UserProfile? userProfile;

  const _DynamicCardLayout({
    required this.cardDesign,
    required this.template,
    this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = _hexToColor(cardDesign.themeColor);
    final bgColor = template.backgroundColor;
    final primaryTextColor = template.primaryColor;
    final secondaryTextColor = template.secondaryColor;

    return Container(
      decoration: BoxDecoration(
        color:
            (template.backgroundGradient == null || !cardDesign.enableGradient)
            ? bgColor
            : null,
        gradient:
            (template.backgroundGradient != null && cardDesign.enableGradient)
            ? LinearGradient(
                colors: template.backgroundGradient!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background Pattern (Subtle decoration)
          if (template.patternType != CardPatternType.none &&
              cardDesign.enablePattern)
            Positioned.fill(
              child: CustomPaint(
                painter: _PatternPainter(
                  type: template.patternType,
                  color: template.patternColor.withValues(
                    alpha: template.patternOpacity,
                  ),
                ),
              ),
            ),

          // Content
          _buildLayout(
            context,
            themeColor,
            primaryTextColor,
            secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    Color themeColor,
    Color primaryColor,
    Color secondaryColor,
  ) {
    switch (template.layoutStyle) {
      case LayoutStyle.centered:
        return _buildCenteredLayout(
          context,
          themeColor,
          primaryColor,
          secondaryColor,
        );
      case LayoutStyle.leftAligned:
        return _buildSideAlignedLayout(
          context,
          themeColor,
          primaryColor,
          secondaryColor,
          CrossAxisAlignment.start,
        );
      case LayoutStyle.rightAligned:
        return _buildSideAlignedLayout(
          context,
          themeColor,
          primaryColor,
          secondaryColor,
          CrossAxisAlignment.end,
        );
      case LayoutStyle.split:
        return _buildSplitLayout(
          context,
          themeColor,
          primaryColor,
          secondaryColor,
        );
      case LayoutStyle.asymmetric:
        return _buildAsymmetricLayout(
          context,
          themeColor,
          primaryColor,
          secondaryColor,
        );
    }
  }

  Widget _buildCenteredLayout(
    BuildContext context,
    Color themeColor,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Padding(
      padding: EdgeInsets.all(template.contentPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(themeColor),
          SizedBox(height: template.elementSpacing),
          _buildNameAndTitle(primaryColor, secondaryColor, TextAlign.center),
          SizedBox(height: template.elementSpacing * 1.5),
          _buildInfoGrid(secondaryColor, CrossAxisAlignment.center),
        ],
      ),
    );
  }

  Widget _buildSideAlignedLayout(
    BuildContext context,
    Color themeColor,
    Color primaryColor,
    Color secondaryColor,
    CrossAxisAlignment alignment,
  ) {
    return Padding(
      padding: EdgeInsets.all(template.contentPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignment,
        children: [
          _buildAvatar(themeColor),
          SizedBox(height: template.elementSpacing),
          _buildNameAndTitle(
            primaryColor,
            secondaryColor,
            _mapCrossToTextAlign(alignment),
          ),
          SizedBox(height: template.elementSpacing * 1.5),
          _buildInfoGrid(secondaryColor, alignment),
        ],
      ),
    );
  }

  Widget _buildSplitLayout(
    BuildContext context,
    Color themeColor,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Row(
      children: [
        // Left side colored bar/area
        Container(
          width: 80,
          color: themeColor.withValues(alpha: 0.1),
          child: Center(child: _buildAvatar(themeColor, size: 60)),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(template.contentPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameAndTitle(
                  primaryColor,
                  secondaryColor,
                  TextAlign.start,
                ),
                SizedBox(height: template.elementSpacing),
                _buildInfoGrid(secondaryColor, CrossAxisAlignment.start),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAsymmetricLayout(
    BuildContext context,
    Color themeColor,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(template.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAvatar(themeColor, size: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNameAndTitle(
                      primaryColor,
                      secondaryColor,
                      TextAlign.start,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildInfoGrid(
                secondaryColor,
                CrossAxisAlignment.start,
                wrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(Color borderColor, {double size = 70}) {
    final photoUrl = userProfile?.avatarUrl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        image: photoUrl != null && photoUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
            : null,
      ),
      child: photoUrl == null || photoUrl.isEmpty
          ? Icon(
              Icons.person,
              size: size * 0.6,
              color: borderColor.withValues(alpha: 0.5),
            )
          : null,
    );
  }

  Widget _buildNameAndTitle(
    Color primaryColor,
    Color secondaryColor,
    TextAlign textAlign,
  ) {
    final name = userProfile?.fullName ?? 'Your Name';
    final title = userProfile?.jobTitle ?? 'Job Title';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _mapToCrossAxis(textAlign),
      children: [
        Text(
          name,
          textAlign: textAlign,
          style: TextStyle(
            color: primaryColor,
            fontSize: template.nameFontSize,
            fontWeight: template.nameFontWeight,
            fontFamily: template.fontFamily,
          ),
        ),
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            color: secondaryColor,
            fontSize: template.titleFontSize,
            fontWeight: template.titleFontWeight,
            fontFamily: template.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(
    Color color,
    CrossAxisAlignment alignment, {
    bool wrap = false,
  }) {
    final List<Widget> items = [];
    final visible = cardDesign.visibleFields;

    if (visible['phone'] ?? true) {
      items.add(
        _buildInfoItem(
          Icons.phone,
          userProfile?.phoneNumber ?? '+1 234 567 890',
          color,
        ),
      );
    }
    if (visible['email'] ?? true) {
      items.add(
        _buildInfoItem(
          Icons.email,
          userProfile?.email ?? 'hello@example.com',
          color,
        ),
      );
    }
    if (visible['companyName'] ?? true) {
      items.add(
        _buildInfoItem(
          Icons.business,
          userProfile?.companyName ?? 'Company Name',
          color,
        ),
      );
    }

    if (wrap) {
      return Wrap(spacing: 12, runSpacing: 8, children: items);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: items
          .map(
            (e) => Padding(padding: const EdgeInsets.only(bottom: 4), child: e),
          )
          .toList(),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  CrossAxisAlignment _mapToCrossAxis(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.right:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }

  TextAlign _mapCrossToTextAlign(CrossAxisAlignment align) {
    switch (align) {
      case CrossAxisAlignment.center:
        return TextAlign.center;
      case CrossAxisAlignment.end:
        return TextAlign.right;
      default:
        return TextAlign.start;
    }
  }
}

class _PatternPainter extends CustomPainter {
  final CardPatternType type;
  final Color color;

  _PatternPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    switch (type) {
      case CardPatternType.dots:
        paint.style = PaintingStyle.fill;
        for (double i = 10; i < size.width; i += 20) {
          for (double j = 10; j < size.height; j += 20) {
            canvas.drawCircle(Offset(i, j), 1.5, paint);
          }
        }
        break;
      case CardPatternType.grid:
        for (double i = 0; i < size.width; i += 25) {
          canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
        }
        for (double j = 0; j < size.height; j += 25) {
          canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
        }
        break;
      case CardPatternType.waves:
        final path = Path();
        for (double i = 0; i < size.height; i += 40) {
          path.moveTo(0, i);
          for (double x = 0; x < size.width; x += 5) {
            path.lineTo(x, i + 8 * math.sin(x / 20));
          }
        }
        canvas.drawPath(path, paint);
        break;
      case CardPatternType.lines:
        for (double i = -size.height; i < size.width; i += 15) {
          canvas.drawLine(
            Offset(i, 0),
            Offset(i + size.height, size.height),
            paint,
          );
        }
        break;
      case CardPatternType.circles:
        for (double i = 0; i < size.width; i += 60) {
          for (double j = 0; j < size.height; j += 60) {
            canvas.drawCircle(Offset(i, j), 30, paint);
          }
        }
        break;
      case CardPatternType.none:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Classic layout - Traditional professional design
class _ClassicCardLayout extends StatelessWidget {
  final CardDesign cardDesign;
  final UserProfile? userProfile;

  const _ClassicCardLayout({required this.cardDesign, this.userProfile});

  @override
  Widget build(BuildContext context) {
    final themeColor = _hexToColor(cardDesign.themeColor);
    final visibleFields = cardDesign.visibleFields;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo placeholder
          if (cardDesign.customLogoUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cardDesign.customLogoUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderLogo(themeColor),
              ),
            )
          else
            _buildPlaceholderLogo(themeColor),
          const SizedBox(height: 16),

          // Name
          Text(
            userProfile?.fullName ?? 'Your Name',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),

          // Job Title
          if (visibleFields['jobTitle'] != false &&
              userProfile?.jobTitle != null)
            Text(
              userProfile!.jobTitle!,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),

          // Company
          if (visibleFields['companyName'] != false &&
              userProfile?.companyName != null)
            Text(
              userProfile!.companyName!,
              style: TextStyle(
                fontSize: 14,
                color: themeColor.withValues(alpha: 0.8),
              ),
            ),

          const Spacer(),

          // Divider
          Divider(color: themeColor, thickness: 1),

          // Contact Info
          if (visibleFields['phone'] != false)
            _buildInfoRow(Icons.phone, 'Phone', themeColor),
          if (visibleFields['email'] != false)
            _buildInfoRow(Icons.email, 'Email', themeColor),
          if (visibleFields['website'] == true)
            _buildInfoRow(Icons.language, 'Website', themeColor),
        ],
      ),
    );
  }

  Widget _buildPlaceholderLogo(Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.business, color: color),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

/// Modern layout - Contemporary bold design
class _ModernCardLayout extends StatelessWidget {
  final CardDesign cardDesign;
  final UserProfile? userProfile;

  const _ModernCardLayout({required this.cardDesign, this.userProfile});

  @override
  Widget build(BuildContext context) {
    final themeColor = _hexToColor(cardDesign.themeColor);
    final visibleFields = cardDesign.visibleFields;

    return Container(
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userProfile?.fullName ?? 'Your Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (visibleFields['jobTitle'] != false &&
                    userProfile?.jobTitle != null)
                  Text(
                    userProfile!.jobTitle!,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                if (visibleFields['companyName'] != false &&
                    userProfile?.companyName != null)
                  Text(
                    userProfile!.companyName!,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (visibleFields['phone'] != false)
                const Icon(Icons.phone, color: Colors.white70, size: 16),
              if (visibleFields['email'] != false)
                const Icon(Icons.email, color: Colors.white70, size: 16),
              if (visibleFields['website'] == true)
                const Icon(Icons.language, color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

/// Minimal layout - Clean and simple
class _MinimalCardLayout extends StatelessWidget {
  final CardDesign cardDesign;
  final UserProfile? userProfile;

  const _MinimalCardLayout({required this.cardDesign, this.userProfile});

  @override
  Widget build(BuildContext context) {
    final visibleFields = cardDesign.visibleFields;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            userProfile?.fullName ?? 'Your Name',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          if (visibleFields['jobTitle'] != false &&
              userProfile?.jobTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              userProfile!.jobTitle!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
          if (visibleFields['companyName'] != false &&
              userProfile?.companyName != null) ...[
            const SizedBox(height: 4),
            Text(
              userProfile!.companyName!,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          if (visibleFields['phone'] != false ||
              visibleFields['email'] != false)
            Container(height: 1, width: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          if (visibleFields['phone'] != false)
            Text(
              'Phone',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          if (visibleFields['email'] != false)
            Text(
              'Email',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}

/// Convert hex color string to Color
Color _hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
