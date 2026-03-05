// Template Repository Interface
// Defines contract for accessing and managing card templates

import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';

/// Repository interface for card template operations
abstract class TemplateRepository {
  /// Get all available templates
  Future<List<CardTemplate>> getAllTemplates();

  /// Get templates by category
  Future<List<CardTemplate>> getTemplatesByCategory(
    TemplateCategory category,
  );

  /// Get popular templates (sorted by popularity)
  Future<List<CardTemplate>> getPopularTemplates({int limit = 6});

  /// Get template by ID
  Future<CardTemplate?> getTemplateById(String id);

  /// Search templates by name or description
  Future<List<CardTemplate>> searchTemplates(String query);

  /// Get business-suitable templates only
  Future<List<CardTemplate>> getBusinessTemplates();

  /// Get free (non-premium) templates
  Future<List<CardTemplate>> getFreeTemplates();

  /// Get premium templates
  Future<List<CardTemplate>> getPremiumTemplates();
}
