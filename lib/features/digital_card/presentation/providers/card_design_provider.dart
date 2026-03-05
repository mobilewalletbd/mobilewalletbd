// Card Design Provider
// State management for digital card operations

import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../contacts/domain/entities/contact.dart';
import '../../../settings/presentation/providers/user_profile_provider.dart';
import '../../data/repositories/card_design_repository_impl.dart';
import '../../data/services/card_image_export_service.dart';
import '../../data/services/nfc_service.dart';
import '../../data/services/pdf_service.dart';
import '../../data/services/qr_code_service.dart';
import '../../data/services/vcard_service.dart';
import '../../domain/entities/card_design.dart';
import '../../domain/entities/card_design_version.dart';
import '../../domain/entities/card_template.dart';
import '../../domain/failures/card_design_failure.dart';
import '../../domain/repositories/card_design_repository.dart';

part 'card_design_provider.g.dart';

/// State for CardDesign operations
class CardDesignState {
  final CardDesign? cardDesign;
  final List<CardTemplate> templates;
  final bool isLoading;
  final CardDesignFailure? error;
  final Uint8List? qrCodeImage;
  final bool isGeneratingQr;
  final bool isExportingPdf;
  final bool isExportingVcard;
  final bool isExportingImage;
  final bool isNfcSharing;
  final CardDesignNfcState? nfcState;
  final List<CardDesignVersion> versionHistory;
  final bool isLoadingHistory;

  const CardDesignState({
    this.cardDesign,
    this.templates = const [],
    this.isLoading = false,
    this.error,
    this.qrCodeImage,
    this.isGeneratingQr = false,
    this.isExportingPdf = false,
    this.isExportingVcard = false,
    this.isExportingImage = false,
    this.isNfcSharing = false,
    this.nfcState,
    this.versionHistory = const [],
    this.isLoadingHistory = false,
  });

  CardDesignState copyWith({
    CardDesign? cardDesign,
    List<CardTemplate>? templates,
    bool? isLoading,
    CardDesignFailure? error,
    Uint8List? qrCodeImage,
    bool? isGeneratingQr,
    bool? isExportingPdf,
    bool? isExportingVcard,
    bool? isExportingImage,
    bool? isNfcSharing,
    CardDesignNfcState? nfcState,
    List<CardDesignVersion>? versionHistory,
    bool? isLoadingHistory,
    bool clearError = false,
    bool clearQrCode = false,
  }) {
    return CardDesignState(
      cardDesign: cardDesign ?? this.cardDesign,
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      qrCodeImage: clearQrCode ? null : qrCodeImage ?? this.qrCodeImage,
      isGeneratingQr: isGeneratingQr ?? this.isGeneratingQr,
      isExportingPdf: isExportingPdf ?? this.isExportingPdf,
      isExportingVcard: isExportingVcard ?? this.isExportingVcard,
      isExportingImage: isExportingImage ?? this.isExportingImage,
      isNfcSharing: isNfcSharing ?? this.isNfcSharing,
      nfcState: nfcState ?? this.nfcState,
      versionHistory: versionHistory ?? this.versionHistory,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    );
  }
}

enum CardDesignNfcState { initial, scanning, success, error }

@riverpod
class CardDesignNotifier extends _$CardDesignNotifier {
  late final CardDesignRepository _repository;
  late final QrCodeService _qrService;
  late final PdfService _pdfService;
  late final VCardService _vcardService;
  late final CardImageExportService _imageExportService;
  late final NfcService _nfcService;

  @override
  CardDesignState build() {
    _repository = ref.watch(cardDesignRepositoryProvider);
    _qrService = ref.watch(qrCodeServiceProvider);
    _pdfService = ref.watch(pdfServiceProvider);
    _vcardService = ref.watch(vCardServiceProvider);
    _imageExportService = ref.watch(cardImageExportServiceProvider);
    _nfcService = ref.watch(nfcServiceProvider);

    // Using a microtask to avoid updating state during build
    Future.microtask(() {
      _loadTemplates();
      _loadUserCard();
    });

    return const CardDesignState();
  }

  /// Map template layout style to card design layout
  CardDesignLayout _mapTemplateLayout(LayoutStyle style) {
    switch (style) {
      case LayoutStyle.centered:
        return CardDesignLayout.minimal;
      case LayoutStyle.leftAligned:
        return CardDesignLayout.classic;
      case LayoutStyle.rightAligned:
        return CardDesignLayout.modern;
      case LayoutStyle.split:
        return CardDesignLayout.modern;
      case LayoutStyle.asymmetric:
        return CardDesignLayout.modern;
    }
  }

  /// Load available card templates
  void _loadTemplates() {
    final templates = _repository.getCardTemplates();
    state = state.copyWith(templates: templates);
  }

  /// Load user's card design
  Future<void> _loadUserCard() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final card = await _repository.getCardDesignByUser(user.id);
      state = state.copyWith(cardDesign: card, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Create a new card design
  Future<void> createCardDesign({
    required String userId,
    String? templateId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      var cardDesign = CardDesign.create(userId: userId);

      // Apply template if specified
      if (templateId != null) {
        final template = _repository.getTemplateById(templateId);
        if (template != null) {
          cardDesign = cardDesign.copyWith(
            // FIX BUG-05: strip alpha — toARGB32() gives 8-char ARGB, we only want 6-char RGB
            themeColor:
                '#${(template.primaryColor.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
            layoutStyle: _mapTemplateLayout(template.layoutStyle),
            frontCardTemplateId: template.id,
          );
        }
      }

      final created = await _repository.createCardDesign(cardDesign);
      state = state.copyWith(cardDesign: created, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Update card design
  Future<void> updateCardDesign(CardDesign cardDesign) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updated = await _repository.updateCardDesign(cardDesign);
      state = state.copyWith(cardDesign: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Publish card (set status to active)
  Future<void> publishCard() async {
    if (state.cardDesign == null) return;
    await updateCardDesign(
      state.cardDesign!.copyWith(status: CardStatus.active),
    );
  }

  /// Unpublish card (set status to draft)
  Future<void> unpublishCard() async {
    if (state.cardDesign == null) return;
    await updateCardDesign(
      state.cardDesign!.copyWith(status: CardStatus.draft),
    );
  }

  /// Update card theme color
  Future<void> updateThemeColor(String color) async {
    if (state.cardDesign == null) return;
    await updateCardDesign(state.cardDesign!.copyWith(themeColor: color));
  }

  /// Update card layout style
  Future<void> updateLayoutStyle(CardDesignLayout style) async {
    if (state.cardDesign == null) return;
    await updateCardDesign(state.cardDesign!.copyWith(layoutStyle: style));
  }

  /// Toggle QR code visibility
  Future<void> toggleQrCode(bool show) async {
    if (state.cardDesign == null) return;
    await updateCardDesign(state.cardDesign!.copyWith(showQrCode: show));
  }

  /// Toggle Background Pattern
  Future<void> togglePattern(bool enable) async {
    if (state.cardDesign == null) return;
    await updateCardDesign(state.cardDesign!.copyWith(enablePattern: enable));
  }

  /// Toggle Background Gradient
  Future<void> toggleGradient(bool enable) async {
    if (state.cardDesign == null) return;
    await updateCardDesign(state.cardDesign!.copyWith(enableGradient: enable));
  }

  /// Update visible fields
  Future<void> updateVisibleFields(Map<String, bool> fields) async {
    if (state.cardDesign == null) return;
    await updateCardDesign(state.cardDesign!.copyWith(visibleFields: fields));
  }

  /// Apply template to card
  Future<void> applyTemplate(String templateId) async {
    final template = _repository.getTemplateById(templateId);
    if (template == null || state.cardDesign == null) return;

    await updateCardDesign(
      state.cardDesign!.copyWith(
        // FIX BUG-05: strip alpha — toARGB32() gives 8-char ARGB, we only want 6-char RGB
        themeColor:
            '#${(template.primaryColor.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
        layoutStyle: _mapTemplateLayout(template.layoutStyle),
        frontCardTemplateId: template.id,
      ),
    );
  }

  /// Generate QR code for the card
  Future<void> generateQrCode() async {
    final cardDesign = state.cardDesign;
    if (cardDesign == null) return;

    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    if (userProfile == null) return;

    state = state.copyWith(isGeneratingQr: true, clearError: true);
    try {
      final qrImage = await _qrService.generateCardQrCode(
        cardDesign: cardDesign,
        name: userProfile.fullName,
        phone: userProfile.phoneNumber,
        email: userProfile.email,
        company: userProfile.companyName,
        jobTitle: userProfile.jobTitle,
        avatarUrl: userProfile.avatarUrl,
      );

      state = state.copyWith(qrCodeImage: qrImage, isGeneratingQr: false);
    } catch (e) {
      state = state.copyWith(
        isGeneratingQr: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.qrGenerationFailed(e),
      );
    }
  }

  /// Clear QR code
  void clearQrCode() {
    state = state.copyWith(clearQrCode: true);
  }

  /// Export card as PDF
  Future<void> exportPdf() async {
    final cardDesign = state.cardDesign;
    if (cardDesign == null) return;

    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    if (userProfile == null) return;

    state = state.copyWith(isExportingPdf: true, clearError: true);
    try {
      await _pdfService.generateAndSharePdf(
        cardDesign: cardDesign,
        name: userProfile.fullName,
        phone: null,
        email: null,
        company: userProfile.companyName,
        jobTitle: userProfile.jobTitle,
      );

      state = state.copyWith(isExportingPdf: false);
      await trackShare();
    } catch (e) {
      state = state.copyWith(
        isExportingPdf: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.pdfGenerationFailed(e),
      );
    }
  }

  /// Export card as vCard
  Future<void> exportVCard() async {
    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    if (userProfile == null) return;

    state = state.copyWith(isExportingVcard: true, clearError: true);
    try {
      await _vcardService.exportAndShareVCard(
        fullName: userProfile.fullName,
        phone: userProfile.phoneNumber,
        email: userProfile.email,
        company: userProfile.companyName,
        jobTitle: userProfile.jobTitle,
        avatarUrl: userProfile.avatarUrl,
      );

      state = state.copyWith(isExportingVcard: false);
      await trackShare();
    } catch (e) {
      state = state.copyWith(
        isExportingVcard: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.vcardExportFailed(e),
      );
    }
  }

  /// Export contact as vCard
  Future<void> exportContactAsVCard(Contact contact) async {
    state = state.copyWith(isExportingVcard: true, clearError: true);
    try {
      await _vcardService.exportContactAsVCard(contact);
      state = state.copyWith(isExportingVcard: false);
    } catch (e) {
      state = state.copyWith(
        isExportingVcard: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.vcardExportFailed(e),
      );
    }
  }

  /// Start NFC sharing
  Future<void> startNfcSharing() async {
    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    if (userProfile == null) return;

    state = state.copyWith(isNfcSharing: true, clearError: true);

    try {
      await _nfcService.startSharing(
        name: userProfile.fullName,
        phone: userProfile.phoneNumber,
        email: userProfile.email,
        company: userProfile.companyName,
        jobTitle: userProfile.jobTitle,
      );
    } catch (e) {
      state = state.copyWith(
        isNfcSharing: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Stop NFC sharing
  Future<void> stopNfcSharing() async {
    await _nfcService.stopSession();
    state = state.copyWith(
      isNfcSharing: false,
      nfcState: CardDesignNfcState.initial,
    );
  }

  /// Check if NFC is available
  Future<bool> isNfcAvailable() async {
    return await _nfcService.isNfcAvailable();
  }

  /// Track view count
  Future<void> trackView() async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;
    await _repository.incrementViewCount(cardId);
  }

  /// Track scan count
  Future<void> trackScan() async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;
    await _repository.incrementScanCount(cardId);
  }

  /// Track share count
  Future<void> trackShare() async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;
    await _repository.incrementShareCount(cardId);
  }

  /// Export card as image (PNG/JPG)
  Future<void> exportAsImage({
    required GlobalKey key,
    bool asPng = true,
  }) async {
    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    if (userProfile == null) return;

    state = state.copyWith(isExportingImage: true, clearError: true);
    try {
      await _imageExportService.exportAndShareImage(
        key: key,
        cardName: userProfile.fullName,
        asPng: asPng,
      );
      state = state.copyWith(isExportingImage: false);

      // Track share since exporting as image is a form of sharing
      await trackShare();
    } catch (e) {
      state = state.copyWith(
        isExportingImage: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Batch export multiple cards as vCard
  Future<void> batchExportVCards(List<CardDesign> designs) async {
    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    final currentUser = ref.read(currentUserProvider);

    if (userProfile == null || currentUser == null) return;

    state = state.copyWith(isExportingVcard: true, clearError: true);
    try {
      await _vcardService.batchExportVCards(
        designs: designs,
        fullName: userProfile.fullName,
        phone: currentUser.phoneNumber,
        email: currentUser.email,
        company: userProfile.companyName,
        jobTitle: userProfile.jobTitle,
      );

      state = state.copyWith(isExportingVcard: false);
    } catch (e) {
      state = state.copyWith(
        isExportingVcard: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.vcardExportFailed(e),
      );
    }
  }

  /// Batch export all user cards as vCard
  Future<void> batchExportAllVCards() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    state = state.copyWith(isExportingVcard: true, clearError: true);
    try {
      final designs = await _repository.getUserCardDesigns(currentUser.id);
      if (designs.isEmpty) {
        state = state.copyWith(isExportingVcard: false);
        return;
      }

      final userProfileAsync = ref.read(userProfileNotifierProvider);
      final userProfile = userProfileAsync.valueOrNull;

      if (userProfile != null) {
        await _vcardService.batchExportVCards(
          designs: designs,
          fullName: userProfile.fullName,
          phone: currentUser.phoneNumber,
          email: currentUser.email,
          company: userProfile.companyName,
          jobTitle: userProfile.jobTitle,
        );
      }

      state = state.copyWith(isExportingVcard: false);
    } catch (e) {
      state = state.copyWith(
        isExportingVcard: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.vcardExportFailed(e),
      );
    }
  }

  /// Batch export multiple cards as PDF
  Future<void> batchExportPdfs(List<CardDesign> designs) async {
    final userProfileAsync = ref.read(userProfileNotifierProvider);
    final userProfile = userProfileAsync.valueOrNull;
    final currentUser = ref.read(currentUserProvider);

    if (userProfile == null || currentUser == null) return;

    state = state.copyWith(isExportingPdf: true, clearError: true);
    try {
      await _pdfService.batchExportPdfs(
        designs: designs,
        name: userProfile.fullName,
        phone: currentUser.phoneNumber,
        email: currentUser.email,
        company: userProfile.companyName,
        jobTitle: userProfile.jobTitle,
      );

      state = state.copyWith(isExportingPdf: false);
    } catch (e) {
      state = state.copyWith(
        isExportingPdf: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.pdfGenerationFailed(e),
      );
    }
  }

  /// Batch export all user cards as PDF
  Future<void> batchExportAllPdfs() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    state = state.copyWith(isExportingPdf: true, clearError: true);
    try {
      final designs = await _repository.getUserCardDesigns(currentUser.id);
      if (designs.isEmpty) {
        state = state.copyWith(isExportingPdf: false);
        return;
      }

      final userProfileAsync = ref.read(userProfileNotifierProvider);
      final userProfile = userProfileAsync.valueOrNull;

      if (userProfile != null) {
        await _pdfService.batchExportPdfs(
          designs: designs,
          name: userProfile.fullName,
          phone: currentUser.phoneNumber,
          email: currentUser.email,
          company: userProfile.companyName,
          jobTitle: userProfile.jobTitle,
        );
      }

      state = state.copyWith(isExportingPdf: false);
    } catch (e) {
      state = state.copyWith(
        isExportingPdf: false,
        error: e is CardDesignFailure
            ? e
            : CardDesignFailure.pdfGenerationFailed(e),
      );
    }
  }

  /// Load version history for the current card
  Future<void> loadVersionHistory() async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;

    state = state.copyWith(isLoadingHistory: true, clearError: true);
    try {
      final history = await _repository.getVersionHistory(cardId);
      state = state.copyWith(versionHistory: history, isLoadingHistory: false);
    } catch (e) {
      state = state.copyWith(
        isLoadingHistory: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Restore a specific version of the card
  Future<void> restoreVersion(String versionId) async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Get the historical snapshot
      final restored = await _repository.restoreVersion(cardId, versionId);
      // FIX MISSING-01: actually persist the restored design (was previously
      // only setting state in memory — Restore button was a no-op on restart)
      final saved = await _repository.updateCardDesign(restored);
      state = state.copyWith(cardDesign: saved, isLoading: false);
      // Reload history so the restored version appears as new entry
      await loadVersionHistory();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Share card with a team
  Future<void> shareCardWithTeam(String teamId) async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.shareCardWithTeam(cardId, teamId);
      // Reload card to update state
      final updated = await _repository.getCardDesign(cardId);
      state = state.copyWith(cardDesign: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }

  /// Unshare card with a team
  Future<void> unshareCardWithTeam(String teamId) async {
    final cardId = state.cardDesign?.id;
    if (cardId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.unshareCardWithTeam(cardId, teamId);
      // Reload card to update state
      final updated = await _repository.getCardDesign(cardId);
      state = state.copyWith(cardDesign: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is CardDesignFailure ? e : CardDesignFailure.unknown(e),
      );
    }
  }
}

/// Provider to watch user's card design
@riverpod
Stream<CardDesign?> watchUserCardDesign(WatchUserCardDesignRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final repository = ref.watch(cardDesignRepositoryProvider);
  return repository.watchUserCardDesign(user.id);
}

/// Provider to watch cards shared with a team
@riverpod
Future<List<CardDesign>> cardsSharedWithTeam(
  CardsSharedWithTeamRef ref,
  String teamId,
) {
  final repository = ref.watch(cardDesignRepositoryProvider);
  return repository.getCardsSharedWithTeam(teamId);
}

/// Provider to fetch a single card by ID
@riverpod
Future<CardDesign?> cardDesignById(CardDesignByIdRef ref, String cardId) async {
  final repository = ref.watch(cardDesignRepositoryProvider);
  return await repository.getCardDesign(cardId);
}
