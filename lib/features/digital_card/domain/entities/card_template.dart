// Card Template Entity
// Defines pre-designed business card templates with layouts, colors, and styling

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'card_template.freezed.dart';
part 'card_template.g.dart';

/// Template category for organizing card designs
enum TemplateCategory {
  minimal,
  modern,
  elegant,
  creative,
  professional,
  luxury,
  corporate,
  tech,
}

/// Text alignment options for card elements
enum TextAlignment { left, center, right }

/// Layout style for card design
enum LayoutStyle { centered, leftAligned, rightAligned, split, asymmetric }

/// Background pattern types for cards
enum CardPatternType { none, dots, grid, waves, lines, circles }

/// JSON Converter for Color
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.toARGB32();
}

/// JSON Converter for `List<Color>`
class ColorListConverter implements JsonConverter<List<Color>?, List<int>?> {
  const ColorListConverter();

  @override
  List<Color>? fromJson(List<int>? json) => json?.map((e) => Color(e)).toList();

  @override
  List<int>? toJson(List<Color>? object) =>
      object?.map((e) => e.toARGB32()).toList();
}

/// JSON Converter for FontWeight
class FontWeightConverter implements JsonConverter<FontWeight, int> {
  const FontWeightConverter();

  @override
  FontWeight fromJson(int json) => FontWeight.values[json];

  @override
  int toJson(FontWeight object) => object.index;
}

/// Card template entity with complete design specifications
@freezed
class CardTemplate with _$CardTemplate {
  const factory CardTemplate({
    required String id,
    required String name,
    required String description,
    required TemplateCategory category,
    required LayoutStyle layoutStyle,

    // Colors
    @ColorConverter() required Color primaryColor,
    @ColorConverter() required Color secondaryColor,
    @ColorConverter() required Color backgroundColor,
    @ColorConverter() required Color textColor,
    @ColorConverter() required Color accentColor,
    @ColorListConverter() List<Color>? backgroundGradient,

    // Patterns
    @Default(CardPatternType.none) CardPatternType patternType,
    @ColorConverter() @Default(Color(0x1A000000)) Color patternColor,
    @Default(0.05) double patternOpacity,

    // Typography
    required String fontFamily,
    required double nameFontSize,
    required double titleFontSize,
    required double bodyFontSize,
    @FontWeightConverter() required FontWeight nameFontWeight,
    @FontWeightConverter() required FontWeight titleFontWeight,

    // Layout properties
    required TextAlignment nameAlignment,
    required TextAlignment titleAlignment,
    required TextAlignment contactAlignment,
    required bool showLogo,
    required bool showQrCode,
    required bool showSocialIcons,
    @Default(false)
    bool hasBackgroundPattern, // Deprecated in favor of patternType
    // Spacing
    required double contentPadding,
    required double elementSpacing,
    required double borderRadius,

    // Preview
    required String previewImageUrl,
    required bool isPremium,
    required int popularity, // For sorting
    // Timestamps
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CardTemplate;

  factory CardTemplate.fromJson(Map<String, dynamic> json) =>
      _$CardTemplateFromJson(json);
}

/// Extension for CardTemplate utility methods
extension CardTemplateX on CardTemplate {
  /// Check if template is suitable for business use
  bool get isBusinessSuitable =>
      category == TemplateCategory.corporate ||
      category == TemplateCategory.minimal ||
      category == TemplateCategory.elegant;

  /// Get category display name
  String get categoryDisplayName {
    switch (category) {
      case TemplateCategory.minimal:
        return 'Minimal';
      case TemplateCategory.modern:
        return 'Modern';
      case TemplateCategory.elegant:
        return 'Elegant';
      case TemplateCategory.creative:
        return 'Creative';
      case TemplateCategory.professional:
        return 'Professional';
      case TemplateCategory.luxury:
        return 'Luxury';
      case TemplateCategory.corporate:
        return 'Corporate';
      case TemplateCategory.tech:
        return 'Tech';
      case TemplateCategory.modern:
        return 'Modern';
      case TemplateCategory.elegant:
        return 'Elegant';
    }
  }

  /// Get layout style description
  String get layoutDescription {
    switch (layoutStyle) {
      case LayoutStyle.centered:
        return 'Centered content with balanced layout';
      case LayoutStyle.leftAligned:
        return 'Left-aligned professional layout';
      case LayoutStyle.rightAligned:
        return 'Right-aligned modern layout';
      case LayoutStyle.split:
        return 'Split design with visual separation';
      case LayoutStyle.asymmetric:
        return 'Asymmetric creative layout';
    }
  }
}

/// Predefined card templates (15 professional designs)
class PredefinedTemplates {
  /// Get all available templates
  static List<CardTemplate> get all => [
    minimalistWhite,
    corporateBlue,
    elegantBlack,
    creativeGreen,
    modernPurple,
    techOrange,
    professionalGray,
    boldRed,
    freshCyan,
    warmBrown,
    vibrantPink,
    classicNavy,
    softBeige,
    dynamicYellow,
    cleanWhite,
  ];

  /// Get templates by category
  static List<CardTemplate> byCategory(TemplateCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  /// Get a template by its ID
  static CardTemplate? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get popular templates
  static List<CardTemplate> get popular {
    final sorted = List<CardTemplate>.from(all);
    sorted.sort((a, b) => b.popularity.compareTo(a.popularity));
    return sorted.take(6).toList();
  }

  // Template 1: Minimalist White
  static CardTemplate minimalistWhite = CardTemplate(
    id: 'minimalist-white',
    name: 'Minimalist White',
    description: 'A clean, modern design with subtle accents.',
    category: TemplateCategory.modern,
    layoutStyle: LayoutStyle.leftAligned,
    primaryColor: const Color(0xFF2D3436),
    secondaryColor: const Color(0xFF636E72),
    backgroundColor: const Color(0xFFFFFFFF),
    backgroundGradient: const [Color(0xFFFFFFFF), Color(0xFFF1F2F6)],
    textColor: const Color(0xFF2D3436),
    accentColor: const Color(0xFF0984E3),
    patternType: CardPatternType.dots,
    patternColor: const Color(0xFF0984E3),
    patternOpacity: 0.1,
    fontFamily: 'Inter',
    nameFontSize: 24,
    titleFontSize: 14,
    bodyFontSize: 12,
    nameFontWeight: FontWeight.bold,
    titleFontWeight: FontWeight.w500,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 24,
    elementSpacing: 12,
    borderRadius: 16,
    previewImageUrl: 'assets/templates/minimalist_white.png',
    isPremium: false,
    popularity: 100,
    createdAt: DateTime.now(),
  );

  static CardTemplate corporateBlue = CardTemplate(
    id: 'corporate-blue',
    name: 'Corporate Blue',
    description: 'Professional and trustworthy design for business.',
    category: TemplateCategory.professional,
    layoutStyle: LayoutStyle.split,
    primaryColor: const Color(0xFF0984E3),
    secondaryColor: const Color(0xFF74B9FF),
    backgroundColor: const Color(0xFF0984E3),
    backgroundGradient: const [Color(0xFF0984E3), Color(0xFF0652DD)],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFAB1A0),
    patternType: CardPatternType.grid,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.05,
    fontFamily: 'Outfit',
    nameFontSize: 22,
    titleFontSize: 14,
    bodyFontSize: 12,
    nameFontWeight: FontWeight.w800,
    titleFontWeight: FontWeight.w400,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 24,
    elementSpacing: 10,
    borderRadius: 12,
    previewImageUrl: 'assets/templates/corporate_blue.png',
    isPremium: true,
    popularity: 95,
    createdAt: DateTime.now(),
  );

  static CardTemplate elegantBlack = CardTemplate(
    id: 'elegant-black',
    name: 'Elegant Black',
    description: 'Sophisticated dark theme with gold accents.',
    category: TemplateCategory.luxury,
    layoutStyle: LayoutStyle.centered,
    primaryColor: const Color(0xFF2D3436),
    secondaryColor: const Color(0xFFD6A232),
    backgroundColor: const Color(0xFF1E272E),
    backgroundGradient: const [Color(0xFF2D3436), Color(0xFF000000)],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFD6A232),
    patternType: CardPatternType.circles,
    patternColor: const Color(0xFFD6A232),
    patternOpacity: 0.08,
    fontFamily: 'Playfair Display',
    nameFontSize: 28,
    titleFontSize: 16,
    bodyFontSize: 14,
    nameFontWeight: FontWeight.w900,
    titleFontWeight: FontWeight.w300,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 32,
    elementSpacing: 16,
    borderRadius: 8,
    previewImageUrl: 'assets/templates/elegant_black.png',
    isPremium: true,
    popularity: 90,
    createdAt: DateTime.now(),
  );

  // Template 4: Creative Green
  static final creativeGreen = CardTemplate(
    id: 'tmpl_004',
    name: 'Eco Green',
    description: 'Fresh and creative design with nature vibes.',
    category: TemplateCategory.creative,
    layoutStyle: LayoutStyle.asymmetric,
    primaryColor: const Color(0xFF0BBF7D),
    secondaryColor: const Color(0xFF059669),
    backgroundColor: const Color(0xFF065F46),
    backgroundGradient: const [
      Color(0xFF065F46),
      Color(0xFF047857),
      Color(0xFF10B981),
    ],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFA7F3D0),
    patternType: CardPatternType.waves,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.05,
    fontFamily: 'Outfit',
    nameFontSize: 24,
    titleFontSize: 15,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w700,
    titleFontWeight: FontWeight.w500,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 26,
    elementSpacing: 14,
    borderRadius: 20,
    previewImageUrl: 'assets/templates/eco_green.png',
    isPremium: false,
    popularity: 85,
    createdAt: DateTime.now(),
  );

  // Template 5: Modern Purple
  static final modernPurple = CardTemplate(
    id: 'tmpl_005',
    name: 'Modern Purple',
    description: 'Contemporary design with vibrant purple gradients.',
    category: TemplateCategory.modern,
    layoutStyle: LayoutStyle.split,
    primaryColor: const Color(0xFF8B5CF6),
    secondaryColor: const Color(0xFF6D28D9),
    backgroundColor: const Color(0xFF4C1D95),
    backgroundGradient: const [Color(0xFF4C1D95), Color(0xFF7C3AED)],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFC4B5FD),
    patternType: CardPatternType.lines,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.08,
    fontFamily: 'Inter',
    nameFontSize: 23,
    titleFontSize: 16,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w700,
    titleFontWeight: FontWeight.w600,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 24,
    elementSpacing: 12,
    borderRadius: 14,
    previewImageUrl: 'assets/templates/modern_purple.png',
    isPremium: true,
    popularity: 88,
    createdAt: DateTime.now(),
  );

  // Template 6: Tech Cyberpunk
  static final techOrange = CardTemplate(
    id: 'tmpl_006',
    name: 'Tech Cyber',
    description: 'Bold tech-focused design with dark aesthetics and grid.',
    category: TemplateCategory.tech,
    layoutStyle: LayoutStyle.leftAligned,
    primaryColor: const Color(0xFF00E5FF),
    secondaryColor: const Color(0xFFFF0055),
    backgroundColor: const Color(0xFF0A0A0A),
    backgroundGradient: const [Color(0xFF000000), Color(0xFF111111)],
    textColor: const Color(0xFF00E5FF),
    accentColor: const Color(0xFFFF0055),
    patternType: CardPatternType.grid,
    patternColor: const Color(0xFF00E5FF),
    patternOpacity: 0.15,
    fontFamily: 'Courier Prime',
    nameFontSize: 24,
    titleFontSize: 15,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w800,
    titleFontWeight: FontWeight.w600,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 20,
    elementSpacing: 10,
    borderRadius: 8,
    previewImageUrl: 'assets/templates/tech_cyber.png',
    isPremium: true,
    popularity: 92,
    createdAt: DateTime.now(),
  );

  // Template 7: Professional Slate
  static final professionalGray = CardTemplate(
    id: 'tmpl_007',
    name: 'Professional Slate',
    description: 'Neutral and highly professional for executives.',
    category: TemplateCategory.professional,
    layoutStyle: LayoutStyle.centered,
    primaryColor: const Color(0xFF475569),
    secondaryColor: const Color(0xFF334155),
    backgroundColor: const Color(0xFF1E293B),
    backgroundGradient: const [Color(0xFF1E293B), Color(0xFF0F172A)],
    textColor: const Color(0xFFF8FAFC),
    accentColor: const Color(0xFF94A3B8),
    patternType: CardPatternType.dots,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.04,
    fontFamily: 'Inter',
    nameFontSize: 22,
    titleFontSize: 16,
    bodyFontSize: 14,
    nameFontWeight: FontWeight.w500,
    titleFontWeight: FontWeight.w400,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 28,
    elementSpacing: 14,
    borderRadius: 12,
    previewImageUrl: 'assets/templates/professional_slate.png',
    isPremium: false,
    popularity: 85,
    createdAt: DateTime.now(),
  );

  // Template 8: Bold Sunset
  static final boldRed = CardTemplate(
    id: 'tmpl_008',
    name: 'Bold Sunset',
    description: 'Vibrant sunset gradient with a confident look.',
    category: TemplateCategory.creative,
    layoutStyle: LayoutStyle.split,
    primaryColor: const Color(0xFFDC2626),
    secondaryColor: const Color(0xFFEA580C),
    backgroundColor: const Color(0xFFB91C1C),
    backgroundGradient: const [
      Color(0xFFB91C1C),
      Color(0xFFF97316),
      Color(0xFFFCD34D),
    ],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFEF3C7),
    patternType: CardPatternType.waves,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.07,
    fontFamily: 'Outfit',
    nameFontSize: 26,
    titleFontSize: 16,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w800,
    titleFontWeight: FontWeight.w600,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 22,
    elementSpacing: 12,
    borderRadius: 16,
    previewImageUrl: 'assets/templates/bold_sunset.png',
    isPremium: true,
    popularity: 89,
    createdAt: DateTime.now(),
  );

  // Template 9: Ocean Breeze
  static final freshCyan = CardTemplate(
    id: 'tmpl_009',
    name: 'Ocean Breeze',
    description: 'Refreshing cool blue to cyan gradients.',
    category: TemplateCategory.modern,
    layoutStyle: LayoutStyle.centered,
    primaryColor: const Color(0xFF06B6D4),
    secondaryColor: const Color(0xFF0891B2),
    backgroundColor: const Color(0xFF083344),
    backgroundGradient: const [Color(0xFF164E63), Color(0xFF06B6D4)],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFF67E8F9),
    patternType: CardPatternType.circles,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.05,
    fontFamily: 'Inter',
    nameFontSize: 24,
    titleFontSize: 15,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w700,
    titleFontWeight: FontWeight.w500,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 24,
    elementSpacing: 12,
    borderRadius: 24,
    previewImageUrl: 'assets/templates/ocean_breeze.png',
    isPremium: false,
    popularity: 84,
    createdAt: DateTime.now(),
  );

  // Template 10: Earthy Warmth
  static final warmBrown = CardTemplate(
    id: 'tmpl_010',
    name: 'Earthy Warmth',
    description: 'Grounded, warm brown and beige composition.',
    category: TemplateCategory.elegant,
    layoutStyle: LayoutStyle.leftAligned,
    primaryColor: const Color(0xFF92400E),
    secondaryColor: const Color(0xFF78350F),
    backgroundColor: const Color(0xFF451A03),
    backgroundGradient: const [Color(0xFF451A03), Color(0xFF78350F)],
    textColor: const Color(0xFFFEFCE8),
    accentColor: const Color(0xFFFCD34D),
    patternType: CardPatternType.lines,
    patternColor: const Color(0xFF000000),
    patternOpacity: 0.15,
    fontFamily: 'Playfair Display',
    nameFontSize: 25,
    titleFontSize: 16,
    bodyFontSize: 14,
    nameFontWeight: FontWeight.w600,
    titleFontWeight: FontWeight.w500,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 26,
    elementSpacing: 14,
    borderRadius: 8,
    previewImageUrl: 'assets/templates/earthy_warmth.png',
    isPremium: true,
    popularity: 76,
    createdAt: DateTime.now(),
  );

  // Template 11: Vibrant Magenta
  static final vibrantPink = CardTemplate(
    id: 'tmpl_011',
    name: 'Vibrant Magenta',
    description: 'Energetic and playful magenta and pink gradients.',
    category: TemplateCategory.creative,
    layoutStyle: LayoutStyle.asymmetric,
    primaryColor: const Color(0xFFE11D48),
    secondaryColor: const Color(0xFFBE123C),
    backgroundColor: const Color(0xFF881337),
    backgroundGradient: const [Color(0xFF881337), Color(0xFFE11D48)],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFDA4AF),
    patternType: CardPatternType.circles,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.1,
    fontFamily: 'Outfit',
    nameFontSize: 26,
    titleFontSize: 15,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w800,
    titleFontWeight: FontWeight.w600,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 24,
    elementSpacing: 12,
    borderRadius: 18,
    previewImageUrl: 'assets/templates/vibrant_magenta.png',
    isPremium: true,
    popularity: 81,
    createdAt: DateTime.now(),
  );

  // Template 12: Executive Navy
  static final classicNavy = CardTemplate(
    id: 'tmpl_012',
    name: 'Executive Navy',
    description: 'Timeless luxury navy blue pattern for executives.',
    category: TemplateCategory.corporate,
    layoutStyle: LayoutStyle.split,
    primaryColor: const Color(0xFF1E3A8A),
    secondaryColor: const Color(0xFF172554),
    backgroundColor: const Color(0xFF172554),
    backgroundGradient: const [Color(0xFF172554), Color(0xFF1D4ED8)],
    textColor: const Color(0xFFEFF6FF),
    accentColor: const Color(0xFF93C5FD),
    patternType: CardPatternType.grid,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.05,
    fontFamily: 'Inter',
    nameFontSize: 24,
    titleFontSize: 16,
    bodyFontSize: 14,
    nameFontWeight: FontWeight.w700,
    titleFontWeight: FontWeight.w400,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 28,
    elementSpacing: 16,
    borderRadius: 10,
    previewImageUrl: 'assets/templates/executive_navy.png',
    isPremium: true,
    popularity: 94,
    createdAt: DateTime.now(),
  );

  // Template 13: Luxury Gold
  static final softBeige = CardTemplate(
    id: 'tmpl_013',
    name: 'Luxury Gold',
    description: 'Pure luxury with golden gradients and dark textures.',
    category: TemplateCategory.luxury,
    layoutStyle: LayoutStyle.centered,
    primaryColor: const Color(0xFFF59E0B),
    secondaryColor: const Color(0xFFD97706),
    backgroundColor: const Color(0xFF111827),
    backgroundGradient: const [Color(0xFF2E2211), Color(0xFF000000)],
    textColor: const Color(0xFFFDE68A),
    accentColor: const Color(0xFFF59E0B),
    patternType: CardPatternType.circles,
    patternColor: const Color(0xFFF59E0B),
    patternOpacity: 0.08,
    fontFamily: 'Playfair Display',
    nameFontSize: 28,
    titleFontSize: 15,
    bodyFontSize: 13,
    nameFontWeight: FontWeight.w600,
    titleFontWeight: FontWeight.w400,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 30,
    elementSpacing: 14,
    borderRadius: 12,
    previewImageUrl: 'assets/templates/luxury_gold.png',
    isPremium: true,
    popularity: 97,
    createdAt: DateTime.now(),
  );

  // Template 14: Dynamic Aura
  static final dynamicYellow = CardTemplate(
    id: 'tmpl_014',
    name: 'Dynamic Aura',
    description: 'Bright and optimistic multi-color aura.',
    category: TemplateCategory.modern,
    layoutStyle: LayoutStyle.asymmetric,
    primaryColor: const Color(0xFF8B5CF6),
    secondaryColor: const Color(0xFFEC4899),
    backgroundColor: const Color(0xFF3B82F6),
    backgroundGradient: const [
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
    ],
    textColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFFFFFF),
    patternType: CardPatternType.waves,
    patternColor: const Color(0xFFFFFFFF),
    patternOpacity: 0.1,
    fontFamily: 'Outfit',
    nameFontSize: 25,
    titleFontSize: 16,
    bodyFontSize: 14,
    nameFontWeight: FontWeight.w800,
    titleFontWeight: FontWeight.w600,
    nameAlignment: TextAlignment.left,
    titleAlignment: TextAlignment.left,
    contactAlignment: TextAlignment.left,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 26,
    elementSpacing: 12,
    borderRadius: 20,
    previewImageUrl: 'assets/templates/dynamic_aura.png',
    isPremium: true,
    popularity: 91,
    createdAt: DateTime.now(),
  );

  // Template 15: Clean Minimalist
  static final cleanWhite = CardTemplate(
    id: 'tmpl_015',
    name: 'Clean Minimalist',
    description: 'Ultra-minimal monochrome design with very subtle lines.',
    category: TemplateCategory.minimal,
    layoutStyle: LayoutStyle.centered,
    primaryColor: const Color(0xFF000000),
    secondaryColor: const Color(0xFF374151),
    backgroundColor: const Color(0xFFFFFFFF),
    backgroundGradient: const [Color(0xFFFFFFFF), Color(0xFFF3F4F6)],
    textColor: const Color(0xFF111827),
    accentColor: const Color(0xFF4B5563),
    patternType: CardPatternType.lines,
    patternColor: const Color(0xFF000000),
    patternOpacity: 0.03,
    fontFamily: 'Inter',
    nameFontSize: 24,
    titleFontSize: 16,
    bodyFontSize: 14,
    nameFontWeight: FontWeight.w500,
    titleFontWeight: FontWeight.w400,
    nameAlignment: TextAlignment.center,
    titleAlignment: TextAlignment.center,
    contactAlignment: TextAlignment.center,
    showLogo: true,
    showQrCode: true,
    showSocialIcons: true,
    contentPadding: 32,
    elementSpacing: 16,
    borderRadius: 16,
    previewImageUrl: 'assets/templates/clean_minimalist.png',
    isPremium: false,
    popularity: 88,
    createdAt: DateTime.now(),
  );
}
