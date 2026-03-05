// Card Design Repository Implementation
// Coordinates between local (Isar) and remote (Firestore) data sources

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mobile_wallet/core/database/isar_schemas.dart' as isar;
import 'package:mobile_wallet/core/services/cloudinary_service.dart';
import 'package:mobile_wallet/core/services/isar_service.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/card_design.dart' as domain;
import '../../domain/entities/card_design_version.dart';
import '../../domain/entities/card_template.dart';
import '../../domain/failures/card_design_failure.dart';
import '../../domain/repositories/card_design_repository.dart';

/// Implementation of CardDesignRepository
/// Uses Isar for local storage and Firestore for cloud sync
class CardDesignRepositoryImpl implements CardDesignRepository {
  final Isar _isar;
  final CloudinaryService _cloudinaryService;
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  CardDesignRepositoryImpl(
    this._isar,
    this._cloudinaryService,
    this._firestore,
  );

  @override
  Future<domain.CardDesign?> getCardDesign(String cardId) async {
    try {
      final cardIsar = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      return cardIsar != null ? _mapFromIsar(cardIsar) : null;
    } catch (e) {
      throw CardDesignFailure.storageError('get', e);
    }
  }

  @override
  Future<domain.CardDesign?> getCardDesignByUser(String userId) async {
    try {
      // Get the first active card for the user
      final cardIsar = await _isar.cardDesignIsars
          .filter()
          .userIdEqualTo(userId)
          .statusEqualTo(isar.CardStatus.active)
          .sortByLastModifiedDesc()
          .findFirst();

      return cardIsar != null ? _mapFromIsar(cardIsar) : null;
    } catch (e) {
      throw CardDesignFailure.storageError('get by user', e);
    }
  }

  @override
  Future<List<domain.CardDesign>> getUserCardDesigns(String userId) async {
    try {
      final cardsIsar = await _isar.cardDesignIsars
          .filter()
          .userIdEqualTo(userId)
          .sortByLastModifiedDesc()
          .findAll();

      return cardsIsar.map(_mapFromIsar).toList();
    } catch (e) {
      throw CardDesignFailure.storageError('get user cards', e);
    }
  }

  @override
  Future<domain.CardDesign> createCardDesign(
    domain.CardDesign cardDesign,
  ) async {
    try {
      final isarCard = _mapToIsar(cardDesign);

      await _isar.writeTxn(() async {
        await _isar.cardDesignIsars.put(isarCard);
      });

      return cardDesign;
    } catch (e) {
      throw CardDesignFailure.storageError('create', e);
    }
  }

  @override
  Future<domain.CardDesign> updateCardDesign(
    domain.CardDesign cardDesign,
  ) async {
    try {
      // Check for conflicts
      final existing = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardDesign.id)
          .findFirst();

      if (existing != null) {
        // Logic: if existing.lastModified > cardDesign.lastModified, someone else updated it.
        // For now, we just proceed as "last write wins" locally, but this is where
        // we would throw a ConflictFailure if we wanted to enforce strict concurrency.
      }

      final updatedCard = cardDesign.copyWith(lastModified: DateTime.now());
      final isarCard = _mapToIsar(updatedCard);
      isarCard.needsSync = true;

      await _isar.writeTxn(() async {
        await _isar.cardDesignIsars.put(isarCard);
      });

      // Save version snapshot
      await _saveVersionSnapshot(updatedCard, 'Updated card design');

      return updatedCard;
    } catch (e) {
      throw CardDesignFailure.storageError('update', e);
    }
  }

  Future<void> _saveVersionSnapshot(
    domain.CardDesign card,
    String? message,
  ) async {
    try {
      final version = isar.CardDesignVersionIsar()
        ..versionId = _uuid.v4()
        ..cardId = card.id
        ..userId = card.userId
        ..snapshotData = jsonEncode(card.toJson())
        ..createdAt = DateTime.now()
        ..commitMessage = message
        ..needsSync = true;

      await _isar.writeTxn(() async {
        await _isar.cardDesignVersionIsars.put(version);
      });
    } catch (e) {
      debugPrint('Failed to save design version: $e');
      // Don't fail the update if version saving fails
    }
  }

  @override
  Future<List<CardDesignVersion>> getVersionHistory(String cardId) async {
    try {
      final versions = await _isar.cardDesignVersionIsars
          .filter()
          .cardIdEqualTo(cardId)
          .sortByCreatedAtDesc()
          .findAll();

      return versions
          .map(
            (v) => CardDesignVersion(
              id: v.versionId,
              cardId: v.cardId,
              userId: v.userId,
              snapshotData: jsonDecode(v.snapshotData) as Map<String, dynamic>,
              createdAt: v.createdAt,
              commitMessage: v.commitMessage,
            ),
          )
          .toList();
    } catch (e) {
      throw CardDesignFailure.storageError('get versions', e);
    }
  }

  @override
  Future<domain.CardDesign> restoreVersion(
    String cardId,
    String versionId,
  ) async {
    try {
      final version = await _isar.cardDesignVersionIsars
          .filter()
          .versionIdEqualTo(versionId)
          .findFirst();

      if (version == null) {
        throw CardDesignFailure.storageError(
          'restore',
          Exception('Version not found'),
        );
      }

      final snapshot = jsonDecode(version.snapshotData) as Map<String, dynamic>;
      final design = domain.CardDesign.fromJson(snapshot);

      // Return the design from history
      // Note: We don't automatically save it as current here.
      // The provider/UI should call updateCardDesign with this object.
      return design;
    } catch (e) {
      throw CardDesignFailure.storageError('restore', e);
    }
  }

  @override
  Future<bool> deleteCardDesign(String cardId) async {
    try {
      final card = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (card != null) {
        await _isar.writeTxn(() async {
          await _isar.cardDesignIsars.delete(card.id);
        });
        return true;
      }
      return false;
    } catch (e) {
      throw CardDesignFailure.storageError('delete', e);
    }
  }

  @override
  List<CardTemplate> getCardTemplates() {
    return PredefinedTemplates.all;
  }

  @override
  CardTemplate? getTemplateById(String templateId) {
    return PredefinedTemplates.getById(templateId);
  }

  @override
  Stream<domain.CardDesign?> watchCardDesign(String cardId) {
    return _isar.cardDesignIsars
        .filter()
        .cardIdEqualTo(cardId)
        .watch(fireImmediately: true)
        .map((cards) => cards.isNotEmpty ? _mapFromIsar(cards.first) : null);
  }

  @override
  Stream<domain.CardDesign?> watchUserCardDesign(String userId) {
    return _isar.cardDesignIsars
        .filter()
        .userIdEqualTo(userId)
        .statusEqualTo(isar.CardStatus.active)
        .sortByLastModifiedDesc()
        .watch(fireImmediately: true)
        .map((cards) => cards.isNotEmpty ? _mapFromIsar(cards.first) : null);
  }

  @override
  Future<void> syncCardDesign(String cardId) async {
    // STUB-02 FIX: Implement Firestore sync for dirty card records
    try {
      final localCard = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (localCard == null || !localCard.needsSync) return;

      final domain = _mapFromIsar(localCard);
      final data = domain.toJson();
      data['syncedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection('users')
          .doc(domain.userId)
          .collection('cards')
          .doc(cardId)
          .set(data, SetOptions(merge: true));

      // Mark as synced
      localCard.needsSync = false;
      await _isar.writeTxn(() async {
        await _isar.cardDesignIsars.put(localCard);
      });

      debugPrint('Card $cardId synced to Firestore successfully');
    } catch (e) {
      // Don't throw — sync failure should not break local UX
      debugPrint('Firestore sync failed for card $cardId: $e');
    }
  }

  @override
  Future<String> uploadLogo(String userId, String filePath) async {
    try {
      final result = await _cloudinaryService.uploadProfilePhoto(
        filePath: filePath,
        userId: userId,
      );

      if (result.success && result.secureUrl != null) {
        return result.secureUrl!;
      } else {
        throw CardDesignFailure.logoUploadFailed(
          result.errorMessage ?? 'Unknown error',
        );
      }
    } catch (e) {
      throw CardDesignFailure.logoUploadFailed(e);
    }
  }

  @override
  Future<String> generateShareableLink(String cardId) async {
    // STUB-03: Firebase Dynamic Links are not yet configured.
    // For V1 this throws a user-friendly failure instead of returning
    // a broken URL. When Firebase Dynamic Links are configured:
    //   - Enable in Firebase Console
    //   - Add firebase_dynamic_links: ^5.x to pubspec.yaml
    //   - Build the link with DynamicLinkParameters
    throw const CardDesignFailure(
      type: CardDesignFailureType.syncError,
      message:
          'Shareable link is not available yet. Use QR code or vCard to share.',
    );
  }

  @override
  Future<void> incrementViewCount(String cardId) async {
    try {
      // Optimistic local update
      final localCard = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (localCard != null) {
        localCard.viewCount = localCard.viewCount + 1;
        localCard.needsSync = true;
        await _isar.writeTxn(() async {
          await _isar.cardDesignIsars.put(localCard);
        });
      }

      // Fire-and-forget remote update (requires userId)
      // We'll rely on the sync mechanism for this since we don't have direct access
      // to the owner's ID here without a lookup, and this might be called by a viewer.
      // For personal cards, the local update + sync is sufficient.
      // For public viewing, a dedicated analytics service function would be better,
      // but for V1 we track it on the card document itself.
    } catch (e) {
      // Ignore errors for analytics to not disrupt UX
      debugPrint('Failed to increment view count: $e');
    }
  }

  @override
  Future<void> incrementScanCount(String cardId) async {
    try {
      final localCard = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (localCard != null) {
        localCard.scanCount = localCard.scanCount + 1;
        localCard.needsSync = true;
        await _isar.writeTxn(() async {
          await _isar.cardDesignIsars.put(localCard);
        });
      }
    } catch (e) {
      debugPrint('Failed to increment scan count: $e');
    }
  }

  @override
  Future<void> incrementShareCount(String cardId) async {
    try {
      final localCard = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (localCard != null) {
        localCard.shareCount = localCard.shareCount + 1;
        localCard.needsSync = true;
        await _isar.writeTxn(() async {
          await _isar.cardDesignIsars.put(localCard);
        });
      }
    } catch (e) {
      debugPrint('Failed to increment share count: $e');
    }
  }

  @override
  Future<void> shareCardWithTeam(String cardId, String teamId) async {
    try {
      final card = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (card != null) {
        final currentTeams = List<String>.from(card.sharedWithTeams);
        if (!currentTeams.contains(teamId)) {
          currentTeams.add(teamId);
          card.sharedWithTeams = currentTeams;
          card.needsSync = true;
          await _isar.writeTxn(() async {
            await _isar.cardDesignIsars.put(card);
          });
        }
      }
    } catch (e) {
      throw CardDesignFailure.storageError('share with team', e);
    }
  }

  @override
  Future<void> unshareCardWithTeam(String cardId, String teamId) async {
    try {
      final card = await _isar.cardDesignIsars
          .filter()
          .cardIdEqualTo(cardId)
          .findFirst();

      if (card != null) {
        final currentTeams = List<String>.from(card.sharedWithTeams);
        if (currentTeams.contains(teamId)) {
          currentTeams.remove(teamId);
          card.sharedWithTeams = currentTeams;
          card.needsSync = true;
          await _isar.writeTxn(() async {
            await _isar.cardDesignIsars.put(card);
          });
        }
      }
    } catch (e) {
      throw CardDesignFailure.storageError('unshare with team', e);
    }
  }

  @override
  Future<List<domain.CardDesign>> getCardsSharedWithTeam(String teamId) async {
    try {
      final cardsIsar = await _isar.cardDesignIsars
          .filter()
          .sharedWithTeamsElementEqualTo(teamId)
          .findAll();

      return cardsIsar.map(_mapFromIsar).toList();
    } catch (e) {
      throw CardDesignFailure.storageError('get cards shared with team', e);
    }
  }

  /// Map CardDesignIsar to CardDesign domain entity
  domain.CardDesign _mapFromIsar(isar.CardDesignIsar isarCard) {
    return domain.CardDesign(
      id: isarCard.cardId,
      userId: isarCard.userId,
      themeColor: isarCard.themeColor,
      layoutStyle: _mapIsarLayoutStyle(isarCard.layoutStyle),
      showQrCode: isarCard.showQrCode,
      customLogoUrl: isarCard.customLogoUrl,
      visibleFields: Map<String, bool>.from(
        jsonDecode(isarCard.visibleFields) as Map,
      ),
      frontCardTemplateId: isarCard.frontCardTemplateId,
      backCardTemplateId: isarCard.backCardTemplateId,
      customFields: isarCard.customFields != null
          ? List<Map<String, dynamic>>.from(
              jsonDecode(isarCard.customFields!) as List,
            )
          : [],
      qrCodeStyle: _mapIsarQrCodeStyle(isarCard.qrCodeStyle),
      allowSharing: isarCard.allowSharing,
      lastModified: isarCard.lastModified,
      status: _mapIsarCardStatus(isarCard.status),
      createdAt: isarCard.createdAt,
      viewCount: isarCard.viewCount,
      scanCount: isarCard.scanCount,
      shareCount: isarCard.shareCount,
      sharedWithTeams: isarCard.sharedWithTeams,
    );
  }

  /// Map CardDesign domain entity to CardDesignIsar
  isar.CardDesignIsar _mapToIsar(domain.CardDesign card) {
    return isar.CardDesignIsar()
      ..cardId = card.id
      ..userId = card.userId
      ..themeColor = card.themeColor
      ..layoutStyle = _mapToIsarLayoutStyle(card.layoutStyle)
      ..showQrCode = card.showQrCode
      ..customLogoUrl = card.customLogoUrl
      ..visibleFields = jsonEncode(card.visibleFields)
      ..frontCardTemplateId = card.frontCardTemplateId
      ..backCardTemplateId = card.backCardTemplateId
      ..customFields = card.customFields.isNotEmpty
          ? jsonEncode(card.customFields)
          : null
      ..qrCodeStyle = _mapToIsarQrCodeStyle(card.qrCodeStyle)
      ..allowSharing = card.allowSharing
      ..lastModified = card.lastModified
      ..status = _mapToIsarCardStatus(card.status)
      ..createdAt = card.createdAt
      ..viewCount = card.viewCount
      ..scanCount = card.scanCount
      ..shareCount = card.shareCount
      ..sharedWithTeams = card.sharedWithTeams;
  }

  domain.CardDesignLayout _mapIsarLayoutStyle(isar.CardDesignLayout style) {
    switch (style) {
      case isar.CardDesignLayout.classic:
        return domain.CardDesignLayout.classic;
      case isar.CardDesignLayout.modern:
        return domain.CardDesignLayout.modern;
      case isar.CardDesignLayout.minimal:
        return domain.CardDesignLayout.minimal;
    }
  }

  isar.CardDesignLayout _mapToIsarLayoutStyle(domain.CardDesignLayout style) {
    switch (style) {
      case domain.CardDesignLayout.classic:
        return isar.CardDesignLayout.classic;
      case domain.CardDesignLayout.modern:
        return isar.CardDesignLayout.modern;
      case domain.CardDesignLayout.minimal:
        return isar.CardDesignLayout.minimal;
    }
  }

  domain.QrCodeStyle _mapIsarQrCodeStyle(isar.QrCodeStyle style) {
    switch (style) {
      case isar.QrCodeStyle.static:
        return domain.QrCodeStyle.static;
      case isar.QrCodeStyle.dynamic:
        return domain.QrCodeStyle.dynamic;
      case isar.QrCodeStyle.custom:
        return domain.QrCodeStyle.custom;
    }
  }

  isar.QrCodeStyle _mapToIsarQrCodeStyle(domain.QrCodeStyle style) {
    switch (style) {
      case domain.QrCodeStyle.static:
        return isar.QrCodeStyle.static;
      case domain.QrCodeStyle.dynamic:
        return isar.QrCodeStyle.dynamic;
      case domain.QrCodeStyle.custom:
        return isar.QrCodeStyle.custom;
    }
  }

  domain.CardStatus _mapIsarCardStatus(isar.CardStatus status) {
    switch (status) {
      case isar.CardStatus.active:
        return domain.CardStatus.active;
      case isar.CardStatus.draft:
        return domain.CardStatus.draft;
      case isar.CardStatus.archived:
        return domain.CardStatus.archived;
    }
  }

  isar.CardStatus _mapToIsarCardStatus(domain.CardStatus status) {
    switch (status) {
      case domain.CardStatus.active:
        return isar.CardStatus.active;
      case domain.CardStatus.draft:
        return isar.CardStatus.draft;
      case domain.CardStatus.archived:
        return isar.CardStatus.archived;
    }
  }
}

/// Provider for CardDesignRepository
final cardDesignRepositoryProvider = Provider<CardDesignRepository>((ref) {
  final cloudinaryService = ref.watch(cloudinaryServiceProvider);
  return CardDesignRepositoryImpl(
    IsarService.instance,
    cloudinaryService,
    FirebaseFirestore.instance,
  );
});
