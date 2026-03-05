// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contactByIdHash() => r'47b95426d4c1f1b56032a016dafc4fd70d32215e';

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

/// Provider for a single contact by ID
///
/// Copied from [contactById].
@ProviderFor(contactById)
const contactByIdProvider = ContactByIdFamily();

/// Provider for a single contact by ID
///
/// Copied from [contactById].
class ContactByIdFamily extends Family<AsyncValue<Contact?>> {
  /// Provider for a single contact by ID
  ///
  /// Copied from [contactById].
  const ContactByIdFamily();

  /// Provider for a single contact by ID
  ///
  /// Copied from [contactById].
  ContactByIdProvider call(
    String contactId,
  ) {
    return ContactByIdProvider(
      contactId,
    );
  }

  @override
  ContactByIdProvider getProviderOverride(
    covariant ContactByIdProvider provider,
  ) {
    return call(
      provider.contactId,
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
  String? get name => r'contactByIdProvider';
}

/// Provider for a single contact by ID
///
/// Copied from [contactById].
class ContactByIdProvider extends AutoDisposeFutureProvider<Contact?> {
  /// Provider for a single contact by ID
  ///
  /// Copied from [contactById].
  ContactByIdProvider(
    String contactId,
  ) : this._internal(
          (ref) => contactById(
            ref as ContactByIdRef,
            contactId,
          ),
          from: contactByIdProvider,
          name: r'contactByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contactByIdHash,
          dependencies: ContactByIdFamily._dependencies,
          allTransitiveDependencies:
              ContactByIdFamily._allTransitiveDependencies,
          contactId: contactId,
        );

  ContactByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactId,
  }) : super.internal();

  final String contactId;

  @override
  Override overrideWith(
    FutureOr<Contact?> Function(ContactByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContactByIdProvider._internal(
        (ref) => create(ref as ContactByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactId: contactId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Contact?> createElement() {
    return _ContactByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContactByIdProvider && other.contactId == contactId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ContactByIdRef on AutoDisposeFutureProviderRef<Contact?> {
  /// The parameter `contactId` of this provider.
  String get contactId;
}

class _ContactByIdProviderElement
    extends AutoDisposeFutureProviderElement<Contact?> with ContactByIdRef {
  _ContactByIdProviderElement(super.provider);

  @override
  String get contactId => (origin as ContactByIdProvider).contactId;
}

String _$watchContactHash() => r'df316682e6b4c418c8668fa662533b35e8a5801a';

/// Provider for watching a single contact
///
/// Copied from [watchContact].
@ProviderFor(watchContact)
const watchContactProvider = WatchContactFamily();

/// Provider for watching a single contact
///
/// Copied from [watchContact].
class WatchContactFamily extends Family<AsyncValue<Contact?>> {
  /// Provider for watching a single contact
  ///
  /// Copied from [watchContact].
  const WatchContactFamily();

  /// Provider for watching a single contact
  ///
  /// Copied from [watchContact].
  WatchContactProvider call(
    String contactId,
  ) {
    return WatchContactProvider(
      contactId,
    );
  }

  @override
  WatchContactProvider getProviderOverride(
    covariant WatchContactProvider provider,
  ) {
    return call(
      provider.contactId,
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
  String? get name => r'watchContactProvider';
}

/// Provider for watching a single contact
///
/// Copied from [watchContact].
class WatchContactProvider extends AutoDisposeStreamProvider<Contact?> {
  /// Provider for watching a single contact
  ///
  /// Copied from [watchContact].
  WatchContactProvider(
    String contactId,
  ) : this._internal(
          (ref) => watchContact(
            ref as WatchContactRef,
            contactId,
          ),
          from: watchContactProvider,
          name: r'watchContactProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchContactHash,
          dependencies: WatchContactFamily._dependencies,
          allTransitiveDependencies:
              WatchContactFamily._allTransitiveDependencies,
          contactId: contactId,
        );

  WatchContactProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactId,
  }) : super.internal();

  final String contactId;

  @override
  Override overrideWith(
    Stream<Contact?> Function(WatchContactRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchContactProvider._internal(
        (ref) => create(ref as WatchContactRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactId: contactId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Contact?> createElement() {
    return _WatchContactProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchContactProvider && other.contactId == contactId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchContactRef on AutoDisposeStreamProviderRef<Contact?> {
  /// The parameter `contactId` of this provider.
  String get contactId;
}

class _WatchContactProviderElement
    extends AutoDisposeStreamProviderElement<Contact?> with WatchContactRef {
  _WatchContactProviderElement(super.provider);

  @override
  String get contactId => (origin as WatchContactProvider).contactId;
}

String _$contactsCountHash() => r'b9e8c01e2ed1b5d30531faed67f8436cccb62350';

/// Provider for contacts count
///
/// Copied from [contactsCount].
@ProviderFor(contactsCount)
final contactsCountProvider = AutoDisposeFutureProvider<int>.internal(
  contactsCount,
  name: r'contactsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ContactsCountRef = AutoDisposeFutureProviderRef<int>;
String _$favoriteContactsHash() => r'27c515ec265b62275a82aa4672f8bef0eee1711f';

/// Provider for favorite contacts
///
/// Copied from [favoriteContacts].
@ProviderFor(favoriteContacts)
final favoriteContactsProvider =
    AutoDisposeFutureProvider<List<Contact>>.internal(
  favoriteContacts,
  name: r'favoriteContactsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteContactsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteContactsRef = AutoDisposeFutureProviderRef<List<Contact>>;
String _$contactsByCategoryHash() =>
    r'e59bc60c0eca70783b540cb784bd769f1d8de5ff';

/// Provider for contacts by category
///
/// Copied from [contactsByCategory].
@ProviderFor(contactsByCategory)
const contactsByCategoryProvider = ContactsByCategoryFamily();

/// Provider for contacts by category
///
/// Copied from [contactsByCategory].
class ContactsByCategoryFamily extends Family<AsyncValue<List<Contact>>> {
  /// Provider for contacts by category
  ///
  /// Copied from [contactsByCategory].
  const ContactsByCategoryFamily();

  /// Provider for contacts by category
  ///
  /// Copied from [contactsByCategory].
  ContactsByCategoryProvider call(
    String category,
  ) {
    return ContactsByCategoryProvider(
      category,
    );
  }

  @override
  ContactsByCategoryProvider getProviderOverride(
    covariant ContactsByCategoryProvider provider,
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
  String? get name => r'contactsByCategoryProvider';
}

/// Provider for contacts by category
///
/// Copied from [contactsByCategory].
class ContactsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Contact>> {
  /// Provider for contacts by category
  ///
  /// Copied from [contactsByCategory].
  ContactsByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => contactsByCategory(
            ref as ContactsByCategoryRef,
            category,
          ),
          from: contactsByCategoryProvider,
          name: r'contactsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contactsByCategoryHash,
          dependencies: ContactsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ContactsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  ContactsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<Contact>> Function(ContactsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContactsByCategoryProvider._internal(
        (ref) => create(ref as ContactsByCategoryRef),
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
  AutoDisposeFutureProviderElement<List<Contact>> createElement() {
    return _ContactsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContactsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ContactsByCategoryRef on AutoDisposeFutureProviderRef<List<Contact>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _ContactsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Contact>>
    with ContactsByCategoryRef {
  _ContactsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as ContactsByCategoryProvider).category;
}

String _$searchContactsHash() => r'6e948a801260ef8b0c05c4e85990cb0705ec07b3';

/// Provider for search results
///
/// Copied from [searchContacts].
@ProviderFor(searchContacts)
const searchContactsProvider = SearchContactsFamily();

/// Provider for search results
///
/// Copied from [searchContacts].
class SearchContactsFamily extends Family<AsyncValue<List<Contact>>> {
  /// Provider for search results
  ///
  /// Copied from [searchContacts].
  const SearchContactsFamily();

  /// Provider for search results
  ///
  /// Copied from [searchContacts].
  SearchContactsProvider call(
    String query,
  ) {
    return SearchContactsProvider(
      query,
    );
  }

  @override
  SearchContactsProvider getProviderOverride(
    covariant SearchContactsProvider provider,
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
  String? get name => r'searchContactsProvider';
}

/// Provider for search results
///
/// Copied from [searchContacts].
class SearchContactsProvider extends AutoDisposeFutureProvider<List<Contact>> {
  /// Provider for search results
  ///
  /// Copied from [searchContacts].
  SearchContactsProvider(
    String query,
  ) : this._internal(
          (ref) => searchContacts(
            ref as SearchContactsRef,
            query,
          ),
          from: searchContactsProvider,
          name: r'searchContactsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchContactsHash,
          dependencies: SearchContactsFamily._dependencies,
          allTransitiveDependencies:
              SearchContactsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchContactsProvider._internal(
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
    FutureOr<List<Contact>> Function(SearchContactsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchContactsProvider._internal(
        (ref) => create(ref as SearchContactsRef),
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
  AutoDisposeFutureProviderElement<List<Contact>> createElement() {
    return _SearchContactsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchContactsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchContactsRef on AutoDisposeFutureProviderRef<List<Contact>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchContactsProviderElement
    extends AutoDisposeFutureProviderElement<List<Contact>>
    with SearchContactsRef {
  _SearchContactsProviderElement(super.provider);

  @override
  String get query => (origin as SearchContactsProvider).query;
}

String _$filteredContactsHash() => r'ea3dde9be30a7210350a27357c8fb2c296ee227b';

/// Provider for filtered contacts based on search, category, and advanced filters
///
/// Copied from [filteredContacts].
@ProviderFor(filteredContacts)
final filteredContactsProvider =
    AutoDisposeFutureProvider<List<Contact>>.internal(
  filteredContacts,
  name: r'filteredContactsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredContactsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredContactsRef = AutoDisposeFutureProviderRef<List<Contact>>;
String _$isContactsLoadingHash() => r'0616442be5823e1c7963c21ac89b4aedee44330e';

/// Provider for contacts loading state
///
/// Copied from [isContactsLoading].
@ProviderFor(isContactsLoading)
final isContactsLoadingProvider = AutoDisposeProvider<bool>.internal(
  isContactsLoading,
  name: r'isContactsLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isContactsLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsContactsLoadingRef = AutoDisposeProviderRef<bool>;
String _$contactsErrorHash() => r'7b2c5f4471b2e936e8d55a11ae485184081ad4c9';

/// Provider for contacts error state
///
/// Copied from [contactsError].
@ProviderFor(contactsError)
final contactsErrorProvider = AutoDisposeProvider<Object?>.internal(
  contactsError,
  name: r'contactsErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactsErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ContactsErrorRef = AutoDisposeProviderRef<Object?>;
String _$categoryCountsHash() => r'74ec4200abff45dba52228fea76363d64fe576ba';

/// Provider for category counts
///
/// Copied from [categoryCounts].
@ProviderFor(categoryCounts)
final categoryCountsProvider =
    AutoDisposeFutureProvider<Map<String, int>>.internal(
  categoryCounts,
  name: r'categoryCountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryCountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CategoryCountsRef = AutoDisposeFutureProviderRef<Map<String, int>>;
String _$favoritesCountHash() => r'39bba97443c8459da4fced7f4a768292a17f3eaf';

/// Provider for favorites count
///
/// Copied from [favoritesCount].
@ProviderFor(favoritesCount)
final favoritesCountProvider = AutoDisposeProvider<int>.internal(
  favoritesCount,
  name: r'favoritesCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoritesCountRef = AutoDisposeProviderRef<int>;
String _$contactsNotifierHash() => r'b6407d9fed07e8cb8d2ba5cccbcb2a2cf8f647e5';

/// Main contacts state provider using Riverpod.
///
/// Manages the contact list state and provides methods for
/// all contact CRUD operations. Uses AsyncNotifier pattern
/// for handling loading, success, and error states.
///
/// Copied from [ContactsNotifier].
@ProviderFor(ContactsNotifier)
final contactsNotifierProvider =
    StreamNotifierProvider<ContactsNotifier, List<Contact>>.internal(
  ContactsNotifier.new,
  name: r'contactsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContactsNotifier = StreamNotifier<List<Contact>>;
String _$searchQueryHash() => r'790bd96a8a13bb944767c7bf06a5378cfc78a54d';

/// Provider for the current search query
///
/// Copied from [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$selectedCategoryHash() => r'abb583dc7f51a0e8375d0f9dd62f5d3ce2e1e65f';

/// Provider for the selected category filter
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
