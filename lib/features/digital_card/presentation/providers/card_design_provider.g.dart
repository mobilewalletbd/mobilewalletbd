// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_design_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchUserCardDesignHash() =>
    r'107becaa7f9eb2370d4e623339c7c8d00c9a54c6';

/// Provider to watch user's card design
///
/// Copied from [watchUserCardDesign].
@ProviderFor(watchUserCardDesign)
final watchUserCardDesignProvider =
    AutoDisposeStreamProvider<CardDesign?>.internal(
  watchUserCardDesign,
  name: r'watchUserCardDesignProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchUserCardDesignHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchUserCardDesignRef = AutoDisposeStreamProviderRef<CardDesign?>;
String _$cardsSharedWithTeamHash() =>
    r'd21ec74cb606f0364236b81e46fbfacadd2ec188';

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

/// Provider to watch cards shared with a team
///
/// Copied from [cardsSharedWithTeam].
@ProviderFor(cardsSharedWithTeam)
const cardsSharedWithTeamProvider = CardsSharedWithTeamFamily();

/// Provider to watch cards shared with a team
///
/// Copied from [cardsSharedWithTeam].
class CardsSharedWithTeamFamily extends Family<AsyncValue<List<CardDesign>>> {
  /// Provider to watch cards shared with a team
  ///
  /// Copied from [cardsSharedWithTeam].
  const CardsSharedWithTeamFamily();

  /// Provider to watch cards shared with a team
  ///
  /// Copied from [cardsSharedWithTeam].
  CardsSharedWithTeamProvider call(
    String teamId,
  ) {
    return CardsSharedWithTeamProvider(
      teamId,
    );
  }

  @override
  CardsSharedWithTeamProvider getProviderOverride(
    covariant CardsSharedWithTeamProvider provider,
  ) {
    return call(
      provider.teamId,
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
  String? get name => r'cardsSharedWithTeamProvider';
}

/// Provider to watch cards shared with a team
///
/// Copied from [cardsSharedWithTeam].
class CardsSharedWithTeamProvider
    extends AutoDisposeFutureProvider<List<CardDesign>> {
  /// Provider to watch cards shared with a team
  ///
  /// Copied from [cardsSharedWithTeam].
  CardsSharedWithTeamProvider(
    String teamId,
  ) : this._internal(
          (ref) => cardsSharedWithTeam(
            ref as CardsSharedWithTeamRef,
            teamId,
          ),
          from: cardsSharedWithTeamProvider,
          name: r'cardsSharedWithTeamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cardsSharedWithTeamHash,
          dependencies: CardsSharedWithTeamFamily._dependencies,
          allTransitiveDependencies:
              CardsSharedWithTeamFamily._allTransitiveDependencies,
          teamId: teamId,
        );

  CardsSharedWithTeamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamId,
  }) : super.internal();

  final String teamId;

  @override
  Override overrideWith(
    FutureOr<List<CardDesign>> Function(CardsSharedWithTeamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CardsSharedWithTeamProvider._internal(
        (ref) => create(ref as CardsSharedWithTeamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamId: teamId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CardDesign>> createElement() {
    return _CardsSharedWithTeamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CardsSharedWithTeamProvider && other.teamId == teamId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CardsSharedWithTeamRef on AutoDisposeFutureProviderRef<List<CardDesign>> {
  /// The parameter `teamId` of this provider.
  String get teamId;
}

class _CardsSharedWithTeamProviderElement
    extends AutoDisposeFutureProviderElement<List<CardDesign>>
    with CardsSharedWithTeamRef {
  _CardsSharedWithTeamProviderElement(super.provider);

  @override
  String get teamId => (origin as CardsSharedWithTeamProvider).teamId;
}

String _$cardDesignByIdHash() => r'eb792971b3354e959230a85f6ca9bb0a972a1920';

/// Provider to fetch a single card by ID
///
/// Copied from [cardDesignById].
@ProviderFor(cardDesignById)
const cardDesignByIdProvider = CardDesignByIdFamily();

/// Provider to fetch a single card by ID
///
/// Copied from [cardDesignById].
class CardDesignByIdFamily extends Family<AsyncValue<CardDesign?>> {
  /// Provider to fetch a single card by ID
  ///
  /// Copied from [cardDesignById].
  const CardDesignByIdFamily();

  /// Provider to fetch a single card by ID
  ///
  /// Copied from [cardDesignById].
  CardDesignByIdProvider call(
    String cardId,
  ) {
    return CardDesignByIdProvider(
      cardId,
    );
  }

  @override
  CardDesignByIdProvider getProviderOverride(
    covariant CardDesignByIdProvider provider,
  ) {
    return call(
      provider.cardId,
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
  String? get name => r'cardDesignByIdProvider';
}

/// Provider to fetch a single card by ID
///
/// Copied from [cardDesignById].
class CardDesignByIdProvider extends AutoDisposeFutureProvider<CardDesign?> {
  /// Provider to fetch a single card by ID
  ///
  /// Copied from [cardDesignById].
  CardDesignByIdProvider(
    String cardId,
  ) : this._internal(
          (ref) => cardDesignById(
            ref as CardDesignByIdRef,
            cardId,
          ),
          from: cardDesignByIdProvider,
          name: r'cardDesignByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cardDesignByIdHash,
          dependencies: CardDesignByIdFamily._dependencies,
          allTransitiveDependencies:
              CardDesignByIdFamily._allTransitiveDependencies,
          cardId: cardId,
        );

  CardDesignByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardId,
  }) : super.internal();

  final String cardId;

  @override
  Override overrideWith(
    FutureOr<CardDesign?> Function(CardDesignByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CardDesignByIdProvider._internal(
        (ref) => create(ref as CardDesignByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardId: cardId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CardDesign?> createElement() {
    return _CardDesignByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CardDesignByIdProvider && other.cardId == cardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CardDesignByIdRef on AutoDisposeFutureProviderRef<CardDesign?> {
  /// The parameter `cardId` of this provider.
  String get cardId;
}

class _CardDesignByIdProviderElement
    extends AutoDisposeFutureProviderElement<CardDesign?>
    with CardDesignByIdRef {
  _CardDesignByIdProviderElement(super.provider);

  @override
  String get cardId => (origin as CardDesignByIdProvider).cardId;
}

String _$cardDesignNotifierHash() =>
    r'b1d0d2d1c13dc5ea683686d8072bae0b034e9b57';

/// See also [CardDesignNotifier].
@ProviderFor(CardDesignNotifier)
final cardDesignNotifierProvider =
    AutoDisposeNotifierProvider<CardDesignNotifier, CardDesignState>.internal(
  CardDesignNotifier.new,
  name: r'cardDesignNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cardDesignNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CardDesignNotifier = AutoDisposeNotifier<CardDesignState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
