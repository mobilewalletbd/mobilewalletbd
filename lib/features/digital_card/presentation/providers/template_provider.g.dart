// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTemplatesHash() => r'56aa8b5e39bf54db338907b62160c87b4c3d5876';

/// Provider for all templates
///
/// Copied from [allTemplates].
@ProviderFor(allTemplates)
final allTemplatesProvider =
    AutoDisposeFutureProvider<List<CardTemplate>>.internal(
  allTemplates,
  name: r'allTemplatesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTemplatesRef = AutoDisposeFutureProviderRef<List<CardTemplate>>;
String _$popularTemplatesHash() => r'828fa1e2683e6055d10adaf6d315227b0ffb6b76';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for popular templates
///
/// Copied from [popularTemplates].
@ProviderFor(popularTemplates)
const popularTemplatesProvider = PopularTemplatesFamily();

/// Provider for popular templates
///
/// Copied from [popularTemplates].
class PopularTemplatesFamily extends Family<AsyncValue<List<CardTemplate>>> {
  /// Provider for popular templates
  ///
  /// Copied from [popularTemplates].
  const PopularTemplatesFamily();

  /// Provider for popular templates
  ///
  /// Copied from [popularTemplates].
  PopularTemplatesProvider call({
    int limit = 6,
  }) {
    return PopularTemplatesProvider(
      limit: limit,
    );
  }

  @override
  PopularTemplatesProvider getProviderOverride(
    covariant PopularTemplatesProvider provider,
  ) {
    return call(
      limit: provider.limit,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'popularTemplatesProvider';
}

/// Provider for popular templates
///
/// Copied from [popularTemplates].
class PopularTemplatesProvider
    extends AutoDisposeFutureProvider<List<CardTemplate>> {
  /// Provider for popular templates
  ///
  /// Copied from [popularTemplates].
  PopularTemplatesProvider({
    int limit = 6,
  }) : this._internal(
          (ref) => popularTemplates(
            ref as PopularTemplatesRef,
            limit: limit,
          ),
          from: popularTemplatesProvider,
          name: r'popularTemplatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$popularTemplatesHash,
          dependencies: PopularTemplatesFamily._dependencies,
          allTransitiveDependencies:
              PopularTemplatesFamily._allTransitiveDependencies,
          limit: limit,
        );

  PopularTemplatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<CardTemplate>> Function(PopularTemplatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PopularTemplatesProvider._internal(
        (ref) => create(ref as PopularTemplatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CardTemplate>> createElement() {
    return _PopularTemplatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PopularTemplatesProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PopularTemplatesRef on AutoDisposeFutureProviderRef<List<CardTemplate>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _PopularTemplatesProviderElement
    extends AutoDisposeFutureProviderElement<List<CardTemplate>>
    with PopularTemplatesRef {
  _PopularTemplatesProviderElement(super.provider);

  @override
  int get limit => (origin as PopularTemplatesProvider).limit;
}

String _$templatesByCategoryHash() =>
    r'ca3647c0723adacb2c0cfb8fa3149c12aeeb9f80';

/// Provider for templates by category
///
/// Copied from [templatesByCategory].
@ProviderFor(templatesByCategory)
const templatesByCategoryProvider = TemplatesByCategoryFamily();

/// Provider for templates by category
///
/// Copied from [templatesByCategory].
class TemplatesByCategoryFamily extends Family<AsyncValue<List<CardTemplate>>> {
  /// Provider for templates by category
  ///
  /// Copied from [templatesByCategory].
  const TemplatesByCategoryFamily();

  /// Provider for templates by category
  ///
  /// Copied from [templatesByCategory].
  TemplatesByCategoryProvider call(
    TemplateCategory category,
  ) {
    return TemplatesByCategoryProvider(
      category,
    );
  }

  @override
  TemplatesByCategoryProvider getProviderOverride(
    covariant TemplatesByCategoryProvider provider,
  ) {
    return call(
      provider.category,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'templatesByCategoryProvider';
}

/// Provider for templates by category
///
/// Copied from [templatesByCategory].
class TemplatesByCategoryProvider
    extends AutoDisposeFutureProvider<List<CardTemplate>> {
  /// Provider for templates by category
  ///
  /// Copied from [templatesByCategory].
  TemplatesByCategoryProvider(
    TemplateCategory category,
  ) : this._internal(
          (ref) => templatesByCategory(
            ref as TemplatesByCategoryRef,
            category,
          ),
          from: templatesByCategoryProvider,
          name: r'templatesByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$templatesByCategoryHash,
          dependencies: TemplatesByCategoryFamily._dependencies,
          allTransitiveDependencies:
              TemplatesByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  TemplatesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final TemplateCategory category;

  @override
  Override overrideWith(
    FutureOr<List<CardTemplate>> Function(TemplatesByCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplatesByCategoryProvider._internal(
        (ref) => create(ref as TemplatesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CardTemplate>> createElement() {
    return _TemplatesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplatesByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TemplatesByCategoryRef
    on AutoDisposeFutureProviderRef<List<CardTemplate>> {
  /// The parameter `category` of this provider.
  TemplateCategory get category;
}

class _TemplatesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<CardTemplate>>
    with TemplatesByCategoryRef {
  _TemplatesByCategoryProviderElement(super.provider);

  @override
  TemplateCategory get category =>
      (origin as TemplatesByCategoryProvider).category;
}

String _$businessTemplatesHash() => r'7674e8dd6d8e06babd10ff300cb31035d48b6675';

/// Provider for business templates
///
/// Copied from [businessTemplates].
@ProviderFor(businessTemplates)
final businessTemplatesProvider =
    AutoDisposeFutureProvider<List<CardTemplate>>.internal(
  businessTemplates,
  name: r'businessTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$businessTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BusinessTemplatesRef = AutoDisposeFutureProviderRef<List<CardTemplate>>;
String _$freeTemplatesHash() => r'de234fedd0e138e624785646e513d70993f62d11';

/// Provider for free templates
///
/// Copied from [freeTemplates].
@ProviderFor(freeTemplates)
final freeTemplatesProvider =
    AutoDisposeFutureProvider<List<CardTemplate>>.internal(
  freeTemplates,
  name: r'freeTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$freeTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FreeTemplatesRef = AutoDisposeFutureProviderRef<List<CardTemplate>>;
String _$premiumTemplatesHash() => r'24b32b4ff96ed9f02886db79a3816444594947d3';

/// Provider for premium templates
///
/// Copied from [premiumTemplates].
@ProviderFor(premiumTemplates)
final premiumTemplatesProvider =
    AutoDisposeFutureProvider<List<CardTemplate>>.internal(
  premiumTemplates,
  name: r'premiumTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$premiumTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PremiumTemplatesRef = AutoDisposeFutureProviderRef<List<CardTemplate>>;
String _$searchTemplatesHash() => r'864d17b3167a593522e6ceabbacc03098b07f3c8';

/// Provider for template search
///
/// Copied from [searchTemplates].
@ProviderFor(searchTemplates)
const searchTemplatesProvider = SearchTemplatesFamily();

/// Provider for template search
///
/// Copied from [searchTemplates].
class SearchTemplatesFamily extends Family<AsyncValue<List<CardTemplate>>> {
  /// Provider for template search
  ///
  /// Copied from [searchTemplates].
  const SearchTemplatesFamily();

  /// Provider for template search
  ///
  /// Copied from [searchTemplates].
  SearchTemplatesProvider call(
    String query,
  ) {
    return SearchTemplatesProvider(
      query,
    );
  }

  @override
  SearchTemplatesProvider getProviderOverride(
    covariant SearchTemplatesProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchTemplatesProvider';
}

/// Provider for template search
///
/// Copied from [searchTemplates].
class SearchTemplatesProvider
    extends AutoDisposeFutureProvider<List<CardTemplate>> {
  /// Provider for template search
  ///
  /// Copied from [searchTemplates].
  SearchTemplatesProvider(
    String query,
  ) : this._internal(
          (ref) => searchTemplates(
            ref as SearchTemplatesRef,
            query,
          ),
          from: searchTemplatesProvider,
          name: r'searchTemplatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchTemplatesHash,
          dependencies: SearchTemplatesFamily._dependencies,
          allTransitiveDependencies:
              SearchTemplatesFamily._allTransitiveDependencies,
          query: query,
        );

  SearchTemplatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<CardTemplate>> Function(SearchTemplatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchTemplatesProvider._internal(
        (ref) => create(ref as SearchTemplatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CardTemplate>> createElement() {
    return _SearchTemplatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchTemplatesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchTemplatesRef on AutoDisposeFutureProviderRef<List<CardTemplate>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchTemplatesProviderElement
    extends AutoDisposeFutureProviderElement<List<CardTemplate>>
    with SearchTemplatesRef {
  _SearchTemplatesProviderElement(super.provider);

  @override
  String get query => (origin as SearchTemplatesProvider).query;
}

String _$filteredTemplatesHash() => r'9b5e6239d23cb7d8bb0bc3f064539456a15444ea';

/// Provider for filtered templates based on selected category
///
/// Copied from [filteredTemplates].
@ProviderFor(filteredTemplates)
final filteredTemplatesProvider =
    AutoDisposeFutureProvider<List<CardTemplate>>.internal(
  filteredTemplates,
  name: r'filteredTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredTemplatesRef = AutoDisposeFutureProviderRef<List<CardTemplate>>;
String _$selectedTemplateHash() => r'b4d4fb3adf4445e716dc7968c6d0cf3673f9eff4';

/// Provider for selected template (state management)
///
/// Copied from [SelectedTemplate].
@ProviderFor(SelectedTemplate)
final selectedTemplateProvider =
    AutoDisposeNotifierProvider<SelectedTemplate, CardTemplate?>.internal(
  SelectedTemplate.new,
  name: r'selectedTemplateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTemplateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTemplate = AutoDisposeNotifier<CardTemplate?>;
String _$selectedCategoryHash() => r'6358532dd8cebb70e8faa64d25e0a64b34073a1e';

/// Provider for selected category filter (state management)
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, TemplateCategory?>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<TemplateCategory?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
