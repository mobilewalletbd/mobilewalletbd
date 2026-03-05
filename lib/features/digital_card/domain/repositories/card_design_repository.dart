// Card Design Repository Interface
// Abstract repository for card design operations

import '../entities/card_design.dart';
import '../entities/card_design_version.dart';
import '../entities/card_template.dart';

/// Repository interface for card design operations
abstract class CardDesignRepository {
  /// Get card design by ID
  Future<CardDesign?> getCardDesign(String cardId);

  /// Get card design by user ID (returns the user's primary card)
  Future<CardDesign?> getCardDesignByUser(String userId);

  /// Get all card designs for a user
  Future<List<CardDesign>> getUserCardDesigns(String userId);

  /// Create a new card design
  Future<CardDesign> createCardDesign(CardDesign cardDesign);

  /// Update an existing card design
  Future<CardDesign> updateCardDesign(CardDesign cardDesign);

  /// Delete a card design
  Future<bool> deleteCardDesign(String cardId);

  /// Get available card templates
  List<CardTemplate> getCardTemplates();

  /// Get a specific template by ID
  CardTemplate? getTemplateById(String templateId);

  /// Watch card design for real-time updates
  Stream<CardDesign?> watchCardDesign(String cardId);

  /// Watch user's card design for real-time updates
  Stream<CardDesign?> watchUserCardDesign(String userId);

  /// Sync card design to cloud
  Future<void> syncCardDesign(String cardId);

  /// Upload custom logo for card design
  Future<String> uploadLogo(String userId, String filePath);

  /// Generate shareable link for the card
  Future<String> generateShareableLink(String cardId);

  /// Increment view count
  Future<void> incrementViewCount(String cardId);

  /// Increment scan count
  Future<void> incrementScanCount(String cardId);

  /// Increment share count
  Future<void> incrementShareCount(String cardId);

  /// Get version history for a card
  Future<List<CardDesignVersion>> getVersionHistory(String cardId);

  /// Restore a specific version of a card
  Future<CardDesign> restoreVersion(String cardId, String versionId);

  /// Share card with a team
  Future<void> shareCardWithTeam(String cardId, String teamId);

  /// Unshare card with a team
  Future<void> unshareCardWithTeam(String cardId, String teamId);

  /// Get cards shared with a team
  Future<List<CardDesign>> getCardsSharedWithTeam(String teamId);
}
