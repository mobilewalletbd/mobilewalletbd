// Template Provider
// Manages card template state and operations using Riverpod

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_wallet/features/digital_card/domain/entities/card_template.dart';
import 'package:mobile_wallet/features/digital_card/domain/repositories/template_repository.dart';
import 'package:mobile_wallet/features/digital_card/data/repositories/template_repository_impl.dart';

part 'template_provider.g.dart';

/// Provider for template repository
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepositoryImpl();
});

/// Provider for all templates
@riverpod
Future<List<CardTemplate>> allTemplates(AllTemplatesRef ref) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getAllTemplates();
}

/// Provider for popular templates
@riverpod
Future<List<CardTemplate>> popularTemplates(
  PopularTemplatesRef ref, {
  int limit = 6,
}) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getPopularTemplates(limit: limit);
}

/// Provider for templates by category
@riverpod
Future<List<CardTemplate>> templatesByCategory(
  TemplatesByCategoryRef ref,
  TemplateCategory category,
) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getTemplatesByCategory(category);
}

/// Provider for business templates
@riverpod
Future<List<CardTemplate>> businessTemplates(BusinessTemplatesRef ref) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getBusinessTemplates();
}

/// Provider for free templates
@riverpod
Future<List<CardTemplate>> freeTemplates(FreeTemplatesRef ref) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getFreeTemplates();
}

/// Provider for premium templates
@riverpod
Future<List<CardTemplate>> premiumTemplates(PremiumTemplatesRef ref) async {
  final repository = ref.watch(templateRepositoryProvider);
  return repository.getPremiumTemplates();
}

/// Provider for template search
@riverpod
Future<List<CardTemplate>> searchTemplates(
  SearchTemplatesRef ref,
  String query,
) async {
  if (query.isEmpty) {
    return [];
  }
  final repository = ref.watch(templateRepositoryProvider);
  return repository.searchTemplates(query);
}

/// Provider for selected template (state management)
@riverpod
class SelectedTemplate extends _$SelectedTemplate {
  @override
  CardTemplate? build() => null;

  void selectTemplate(CardTemplate template) {
    state = template;
  }

  void clearSelection() {
    state = null;
  }
}

/// Provider for selected category filter (state management)
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  TemplateCategory? build() => null;

  void selectCategory(TemplateCategory? category) {
    state = category;
  }

  void clearCategory() {
    state = null;
  }
}

/// Provider for filtered templates based on selected category
@riverpod
Future<List<CardTemplate>> filteredTemplates(FilteredTemplatesRef ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final repository = ref.watch(templateRepositoryProvider);

  if (selectedCategory == null) {
    return repository.getAllTemplates();
  }

  return repository.getTemplatesByCategory(selectedCategory);
}
