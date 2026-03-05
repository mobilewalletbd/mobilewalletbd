// Template Repository Implementation
// Provides access to predefined card templates

import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';
import 'package:mobile_wallet/features/digital_card/domain/repositories/template_repository.dart';

/// Implementation of TemplateRepository using predefined templates
class TemplateRepositoryImpl implements TemplateRepository {
  @override
  Future<List<CardTemplate>> getAllTemplates() async {
    // Simulate network delay for realistic behavior
    await Future.delayed(const Duration(milliseconds: 300));
    return PredefinedTemplates.all;
  }

  @override
  Future<List<CardTemplate>> getTemplatesByCategory(
    TemplateCategory category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PredefinedTemplates.byCategory(category);
  }

  @override
  Future<List<CardTemplate>> getPopularTemplates({int limit = 6}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final popular = PredefinedTemplates.popular;
    return popular.take(limit).toList();
  }

  @override
  Future<CardTemplate?> getTemplateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return PredefinedTemplates.all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<CardTemplate>> searchTemplates(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final lowercaseQuery = query.toLowerCase();
    
    return PredefinedTemplates.all.where((template) {
      return template.name.toLowerCase().contains(lowercaseQuery) ||
          template.description.toLowerCase().contains(lowercaseQuery) ||
          template.categoryDisplayName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<CardTemplate>> getBusinessTemplates() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PredefinedTemplates.all
        .where((t) => t.isBusinessSuitable)
        .toList();
  }

  @override
  Future<List<CardTemplate>> getFreeTemplates() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PredefinedTemplates.all.where((t) => !t.isPremium).toList();
  }

  @override
  Future<List<CardTemplate>> getPremiumTemplates() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PredefinedTemplates.all.where((t) => t.isPremium).toList();
  }
}
