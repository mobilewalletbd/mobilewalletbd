// Card Design Entity
// Domain entity for user's personal digital business card

import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_design.freezed.dart';
part 'card_design.g.dart';

/// Layout styles for digital cards
enum CardDesignLayout { classic, modern, minimal }

/// QR code generation styles
enum QrCodeStyle { static, dynamic, custom }

/// Card status
enum CardStatus { active, draft, archived }

/// Entity representing a user's digital business card design
@freezed
class CardDesign with _$CardDesign {
  const factory CardDesign({
    required String id,
    required String userId,
    @Default('#0BBF7D') String themeColor,
    @Default(CardDesignLayout.classic) CardDesignLayout layoutStyle,
    @Default(true) bool showQrCode,
    String? customLogoUrl,
    @Default({}) Map<String, bool> visibleFields,
    String? frontCardTemplateId,
    String? backCardTemplateId,
    @Default([]) List<Map<String, dynamic>> customFields,
    @Default(QrCodeStyle.static) QrCodeStyle qrCodeStyle,
    @Default(true) bool allowSharing,
    @Default(true) bool enablePattern,
    @Default(true) bool enableGradient,
    @Default([]) List<String> sharedWithTeams,
    required DateTime lastModified,
    @Default(CardStatus.active) CardStatus status,
    required DateTime createdAt,
    @Default(0) int viewCount,
    @Default(0) int scanCount,
    @Default(0) int shareCount,
  }) = _CardDesign;

  factory CardDesign.fromJson(Map<String, dynamic> json) =>
      _$CardDesignFromJson(json);

  /// Create a new card design with default values
  factory CardDesign.create({required String userId, String? id}) {
    final now = DateTime.now();
    return CardDesign(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      lastModified: now,
      createdAt: now,
      visibleFields: const {
        'phone': true,
        'email': true,
        'address': false,
        'website': true,
        'jobTitle': true,
        'companyName': true,
      },
    );
  }
}
